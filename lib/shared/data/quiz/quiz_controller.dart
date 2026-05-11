import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../desktop/presentation/skill_verification/result_screen.dart';
import '../../../mobile/presentation/skill_verification/result_screen.dart';
import '../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';

class QuizQuestion {
  String question;
  List<String> options;
  String correctAnswer;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswer,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      question: json["question"] ?? "",
      options: List<String>.from(json["options"] ?? []),
      correctAnswer: json["answer"] ?? "",
    );
  }
}

class QuizController extends GetxController {
  static const int totalTimeInSeconds = 15 * 60;
  static const apiKey = "AIzaSyB1LiIUeJUv1t7ZEBq9AibLEJiABMCxi3Y";
  final gemini = Gemini.instance;

  var questions = <QuizQuestion>[].obs;
  var index = 0.obs;
  var correct = 0.obs;
  var selectedOption = RxnInt();
  var loading = false.obs;
  var currentSkill = ''.obs;
  var fromAddSkill = false.obs;

  // ── Verification state ──
  var isVerifying = false.obs;
  var isSkillVerified = false.obs;
  var verifiedQuizScore = 0.obs;
  var verifyError = ''.obs;

  Future<void> generateQuiz(String skill, {bool isAddSkill = false}) async {
    loading.value = true;
    currentSkill.value = skill;
    fromAddSkill.value = isAddSkill;

    final prompt = """
Generate exactly 15 multiple-choice questions about $skill.
The questions should gradually increase in difficulty, from easy to very hard.
Return ONLY a valid JSON array like:

[
  {
    "question": "text",
    "options": ["a","b","c","d"],
    "answer": "a"
  }
]

No explanation, no text outside the JSON.
""";

    try {
      final response = await gemini.prompt(parts: [Part.text(prompt)]);
      String text = response?.output ?? "";
      print("🔵 RAW GEMINI RESPONSE:");
      print(text);

      int startIndex = text.indexOf('[');
      if (startIndex == -1) {
        print("❌ No JSON array found");
        questions.clear();
        loading.value = false;
        return;
      }

      int bracketCount = 0;
      int endIndex = startIndex;
      for (int i = startIndex; i < text.length; i++) {
        if (text[i] == '[')
          bracketCount++;
        else if (text[i] == ']') bracketCount--;
        if (bracketCount == 0) {
          endIndex = i + 1;
          break;
        }
      }

      if (bracketCount != 0) {
        print("❌ Incomplete JSON array");
        questions.clear();
        loading.value = false;
        return;
      }

      String jsonString = text.substring(startIndex, endIndex).trim();
      final List data = jsonDecode(jsonString);
      questions.value = data.map((e) => QuizQuestion.fromJson(e)).toList();

      for (var q in questions) {
        while (q.options.length < 4) {
          q.options.add("Option ${q.options.length + 1}");
        }
        if (q.options.length > 4) q.options = q.options.sublist(0, 4);
      }
    } catch (e) {
      print("❌ ERROR: $e");
      questions.clear();
    } finally {
      loading.value = false;
    }
  }

  void nextQuestion() {
    if (selectedOption.value != null) {
      if (questions[index.value]
              .options[selectedOption.value!]
              .trim()
              .toLowerCase() ==
          questions[index.value].correctAnswer.trim().toLowerCase()) {
        correct.value++;
      }
    }

    if (index.value < questions.length - 1) {
      index.value++;
      selectedOption.value = null;
    } else {
      goToResult();
    }
  }

  void previousQuestion() {
    if (index.value > 0) {
      index.value--;
      selectedOption.value = null;
    }
  }

  void resetQuiz() {
    index.value = 0;
    correct.value = 0;
    selectedOption.value = null;
    questions.clear();
    currentSkill.value = '';
    isVerifying.value = false;
    isSkillVerified.value = false;
    verifiedQuizScore.value = 0;
    verifyError.value = '';
  }

  void goToResult() {
    final isDesktop = GetPlatform.isDesktop;

    if (isDesktop) {
      Get.to(
        () => ResultDesktop(),
        arguments: {
          'score': correct.value,
          'total': questions.length,
          'skill': currentSkill.value,
          'fromAddSkill': fromAddSkill.value,
        },
      );
    } else {
      Get.to(
        () => ResultScreen(),
        arguments: {
          'score': correct.value,
          'total': questions.length,
          'skill': currentSkill.value,
          'fromAddSkill': fromAddSkill.value,
        },
      );
    }
  }

  /// Sends the quiz score to the backend for skill verification.
  /// Calculates percentage score, calls POST /user/verify-skill-quiz,
  /// and refreshes the profile cubit on success.
  Future<void> verifySkillQuiz({
    required String skillName,
    required int score,
    required int total,
  }) async {
    isVerifying.value = true;
    verifyError.value = '';

    final int quizScore = total > 0 ? ((score / total) * 100).round() : 0;

    try {
      final dio = GetIt.instance<Dio>();
      final response = await dio.post(
        'https://skill-swaapp.vercel.app/user/verify-skill-quiz',
        data: {
          'skillName': skillName,
          'quizScore': quizScore,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final skill = data['skill'];

        verifiedQuizScore.value = skill['quizScore'] ?? quizScore;
        isSkillVerified.value = skill['isVerified'] ?? (quizScore >= 85);

        print('✅ Skill verification response: $data');

        // Refresh the profile so the SkillsPage updates dynamically
        try {
          final profileCubit = GetIt.instance<MyProfileCubit>();
          profileCubit.refreshProfile();
        } catch (_) {
          print('⚠️ Could not refresh profile cubit');
        }
      } else {
        verifyError.value = 'Unexpected response: ${response.statusCode}';
        // Still set the local score
        verifiedQuizScore.value = quizScore;
        isSkillVerified.value = quizScore >= 85;
      }
    } on DioException catch (e) {
      print('❌ Verify skill API error: $e');
      verifyError.value = e.response?.data?['message']?.toString() ??
          e.message ??
          'Network error';
      // Fallback to local calculation
      verifiedQuizScore.value = quizScore;
      isSkillVerified.value = quizScore >= 85;
    } catch (e) {
      print('❌ Verify skill error: $e');
      verifyError.value = e.toString();
      verifiedQuizScore.value = quizScore;
      isSkillVerified.value = quizScore >= 85;
    } finally {
      isVerifying.value = false;
    }
  }
}
