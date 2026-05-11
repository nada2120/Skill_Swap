import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/desktop/presentation/profile/screens/profile_screen.dart';

import '../../../main.dart';
import '../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../shared/bloc/update_profile_bloc/update_profile_bloc.dart';
import '../../../shared/core/theme/app_palette.dart';
import '../../../shared/data/models/update_profile/update_profile_request.dart';
import '../../../shared/data/models/update_profile/update_skill.dart';
import '../../../shared/data/quiz/quiz_controller.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/desktop/presentation/profile/screens/profile_screen.dart';

import '../../../main.dart';
import '../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../shared/bloc/update_profile_bloc/update_profile_bloc.dart';
import '../../../shared/core/theme/app_palette.dart';
import '../../../shared/data/models/update_profile/update_profile_request.dart';
import '../../../shared/data/models/update_profile/update_skill.dart';
import '../../../shared/data/quiz/quiz_controller.dart';

class ResultDesktop extends StatefulWidget {
  final bool fromAddSkill;
  final String? skillName;

  const ResultDesktop({
    super.key,
    this.fromAddSkill = false,
    this.skillName,
  });

  @override
  State<ResultDesktop> createState() => _ResultDesktopState();
}

class _ResultDesktopState extends State<ResultDesktop> {
  late final int score;
  late final int total;
  late final String skillName;
  late final QuizController controller;
  late MyProfileCubit profileCubit;

  @override
  void initState() {
    super.initState();

    score = Get.arguments['score'];
    total = Get.arguments['total'];
    skillName = widget.skillName ?? Get.arguments['skill'] ?? '';

    controller = Get.find<QuizController>();
    profileCubit = context.read<MyProfileCubit>();

    controller.isSkillVerified.value = false;
    controller.verifiedQuizScore.value = 0;
    controller.verifyError.value = '';

    if (skillName.isNotEmpty) {
      controller.verifySkillQuiz(
        skillName: skillName,
        score: score,
        total: total,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isMentor = profileCubit.state is MyProfileLoaded &&
        (profileCubit.state as MyProfileLoaded).profile.role == "Mentor";

    final canAdd = profileCubit.canAddSkill(skillName);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 700),
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Obx(() {
              if (controller.isVerifying.value) {
                return _buildLoading();
              }

              final int displayScore = controller.verifiedQuizScore.value;

              final bool verified =
                  controller.isSkillVerified.value && displayScore >= 85;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    /// ICON
                    Icon(
                      verified ? Icons.emoji_events : Icons.adjust,
                      color: verified ? Colors.amber : Colors.orange,
                      size: 80,
                    ),

                    const SizedBox(height: 20),

                    /// TITLE
                    Text(
                      verified ? "Congratulations!" : "Keep Learning!",
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// SCORE %
                    Text(
                      "$displayScore%",
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// DETAILS
                    Text(
                      "You got $score out of $total questions correct",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark
                            ? AppPalette.darkTextPrimary
                            : AppPalette.primary,
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// PROGRESS BAR
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: displayScore / 100,
                        minHeight: 10,
                        backgroundColor: const Color(0XFFF2F5F8),
                        valueColor: const AlwaysStoppedAnimation(
                          AppPalette.primary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// STATUS
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: verified
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            verified ? Icons.check_circle : Icons.cancel,
                            color: verified ? Colors.green : Colors.red,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            verified ? "Skill Verified" : "Skill Not Verified",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: verified ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (widget.fromAddSkill)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          canAdd
                              ? "You can add this skill!"
                              : "You already have this skill or not allowed.",
                          style: TextStyle(
                            color: canAdd ? Colors.green : Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                    if (!verified)
                      const Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "Need 85% to pass. Try again!",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                    const SizedBox(height: 30),

                    /// BUTTON
                    SizedBox(
                      width: 300,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppPalette.primary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (verified &&
                              widget.fromAddSkill &&
                              isMentor &&
                              canAdd) {
                            final request = UpdateProfileRequest(
                              skills: [
                                UpdateSkill(skillName: skillName),
                              ],
                            );

                            context
                                .read<UpdateProfileBloc>()
                                .add(SubmitUpdateProfile(request));

                            profileCubit.refreshProfile();
                          }

                          if (Get.isRegistered<QuizController>()) {
                            Get.delete<QuizController>();
                          }

                          desktopKey.currentState?.openProfile(tab: 1);
                        },
                        child: const Text(
                          "Continue",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          color: AppPalette.primary,
        ),
        SizedBox(height: 20),
        Text(
          "Verifying your skill...",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
