import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/desktop/presentation/sign/widgets/custom_button.dart';

import '../../../shared/data/quiz/quiz_controller.dart';
import 'quiz_screen.dart';

class QuizDetailsDesktop extends StatelessWidget {
  final String skillName;
  final bool fromAddSkill;

  QuizDetailsDesktop({
    super.key,
    required this.skillName,
    this.fromAddSkill = false,
  });

  final QuizController controller = Get.put(
    QuizController(),
    permanent: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Quiz Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .scaffoldBackgroundColor
                    .withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                  width: 2,
                ),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.black12,
                    offset: Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  Text(
                    skillName,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// CHIPS
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      Chip(label: Text("Beginner")),
                      Chip(label: Text("15 Questions")),
                      Chip(label: Text("15 Minutes")),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// DESCRIPTION
                  const Text(
                    "Test your knowledge of basics including variables, functions and control structures.",
                    style: TextStyle(fontSize: 15),
                  ),

                  const SizedBox(height: 24),

                  /// DETAILS
                  _row("Questions", "15"),
                  _row("Time Limit", "15 minutes"),
                  _row("Passing Score", "85%"),
                  _row("Difficulty", "Beginner"),

                  const SizedBox(height: 24),

                  /// NOTES
                  const Text(
                    "Important Notes:",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _note("You cannot pause once started"),
                  _note("Questions are randomly selected"),
                  _note("You need 80% to pass"),
                  _note("You can retake the quiz if needed"),

                  const SizedBox(height: 28),

                  /// BUTTON
                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        text: controller.loading.value
                            ? "Loading..."
                            : "Start Quiz",
                        onPressed: controller.loading.value
                            ? null
                            : () async {
                                controller.loading.value = true;

                                await controller.generateQuiz(
                                  skillName,
                                  isAddSkill: fromAddSkill,
                                );

                                controller.loading.value = false;

                                if (controller.questions.isNotEmpty) {
                                  Get.to(
                                    () => QuizDesktop(
                                      fromAddSkill: fromAddSkill,
                                    ),
                                  );
                                } else {
                                  Get.snackbar(
                                    "Error",
                                    "Failed to generate quiz",
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                }
                              },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ================= HELPERS =================

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _note(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text("• $text"),
    );
  }
}
