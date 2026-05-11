import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:skill_swap/mobile/presentation/onboarding_screen/screens/start_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/helper/local_storage.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController controller = PageController();
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.06,
          vertical: screenHeight * 0.03,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(alignment: Alignment.topRight, child: skipIntro(context)),
            Expanded(
              child: PageView(
                controller: controller,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                children: [
                  OnBoardingPage(
                    imagePath:
                        "assets/images/onboarding_images/onboarding_one.json",
                    title: "Learn from Experts",
                    subtitle:
                        "Connect with verified mentors and skilled developers.",
                  ),
                  OnBoardingPage(
                    imagePath:
                        "assets/images/onboarding_images/onboarding_two.json",
                    title: "Free Learning Hours.",
                    subtitle:
                        "Get 4 free learning hours every week to grow your skills.",
                  ),
                  OnBoardingPage(
                    imagePath:
                        "assets/images/onboarding_images/onboarding_three.json",
                    title: "Skill Verification.",
                    subtitle:
                        "Take assessments to verify your skills and become a mentor.",
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.04),
            navagationalBar(screenWidth),
            SizedBox(height: screenHeight * 0.04),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(screenWidth * 0.9, screenHeight * 0.07),
                backgroundColor: AppPalette.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.2),
                ),
              ),
              onPressed: () {
                if (currentPage < 2) {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  LocalStorage.setOnboardingSeen();
                  Get.to(() => StartScreen());
                }
              },
              child: Text(
                currentPage < 2 ? "Next" : "Get Started",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: screenWidth * 0.045,
                  color: const Color(0xFFDCDCDC),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget navagationalBar(double screenWidth) {
    return SmoothPageIndicator(
      controller: controller,
      count: 3,
      effect: ExpandingDotsEffect(
        activeDotColor: AppPalette.primary,
        dotHeight: screenWidth * 0.015,
        dotWidth: screenWidth * 0.015,
        expansionFactor: 3,
        spacing: screenWidth * 0.015,
      ),
    );
  }

  Widget skipIntro(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return TextButton(
      onPressed: () {
        LocalStorage.setOnboardingSeen();
        Get.to(() => StartScreen());
      },
      child: Text(
        "skip",
        style: TextStyle(
          fontSize: screenWidth * 0.045,
          fontWeight: FontWeight.w400,
          color: AppPalette.primary,
        ),
      ),
    );
  }
}

class OnBoardingPage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String subtitle;

  const OnBoardingPage({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Lottie.asset(
          imagePath,
          width: screenWidth * 0.8,
          height: screenHeight * 0.45,
        ),
        SizedBox(height: screenHeight * 0.015),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: screenWidth * 0.06,
            fontWeight: FontWeight.w600,
            color: AppPalette.primary,
          ),
        ),
        SizedBox(height: screenHeight * 0.03),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
