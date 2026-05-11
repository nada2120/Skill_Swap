import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/core/theme/app_palette.dart';
import '../../../shared/data/quiz/quiz_controller.dart';
import 'quiz_screen.dart';

class QuizDetailsScreen extends StatelessWidget {
  final String skillName;
  final bool fromAddSkill;

  QuizDetailsScreen(
      {super.key, required this.skillName, this.fromAddSkill = false});

  final QuizController controller = Get.put(QuizController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).textTheme.bodyLarge!.color,
            size: screenWidth * 0.06,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Quiz Details",
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge!.color,
            fontSize: screenWidth * 0.05,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(screenWidth * 0.05),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).dividerColor),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    skillName,
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  Row(
                    children: [
                      Chip(
                        label: Text(
                          "Beginner",
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        backgroundColor: Colors.grey,
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Chip(
                        label: Text(
                          "15 Q",
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        backgroundColor: Colors.grey,
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Chip(
                        label: Text(
                          "15m",
                          style: TextStyle(
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        backgroundColor: Colors.grey,
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    "Test your knowledge of basics including variables, "
                    "functions and control structures.",
                    style: TextStyle(
                      fontSize: screenWidth * 0.035,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  rowDetails(context, "Questions:", "15", screenWidth),
                  SizedBox(height: screenHeight * 0.01),
                  rowDetails(context, "Time Limit:", "15 minutes", screenWidth),
                  SizedBox(height: screenHeight * 0.01),
                  rowDetails(context, "Passing Score:", "85%", screenWidth),
                  SizedBox(height: screenHeight * 0.01),
                  rowDetails(context, "Difficulty:", "Beginner", screenWidth),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.03),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(screenWidth * 0.05),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Important Notes:",
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Text(
                    "• You cannot pause once started",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "• Questions are randomly selected",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "• You need 80% to pass and get verified",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "• You can retake if you don't pass",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                      fontSize: screenWidth * 0.035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppPalette.primary,
                    padding:
                        EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: controller.loading.value
                      ? null
                      : () async {
                          controller.loading.value = true;
                          await controller.generateQuiz(skillName,
                              isAddSkill: fromAddSkill);
                          controller.loading.value = false;
                          if (controller.questions.isNotEmpty) {
                            Get.to(
                                () => QuizScreen(fromAddSkill: fromAddSkill));
                          } else {
                            Get.snackbar(
                              'Error',
                              'Failed to generate quiz.',
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          }
                        },
                  child: controller.loading.value
                      ? SizedBox(
                          height: screenHeight * 0.03,
                          width: screenHeight * 0.03,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.timer,
                                color: Colors.white, size: screenWidth * 0.05),
                            SizedBox(width: screenWidth * 0.02),
                            Text(
                              "Start Quiz",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.045,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rowDetails(
      BuildContext context, String title, String subTitle, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Theme.of(context).textTheme.bodyMedium!.color,
            )),
        Text(subTitle,
            style: TextStyle(
              fontSize: screenWidth * 0.035,
              color: Theme.of(context).textTheme.bodyMedium!.color,
            )),
      ],
    );
  }
}
