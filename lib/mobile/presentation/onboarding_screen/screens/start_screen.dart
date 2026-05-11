import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/core/theme/app_palette.dart';
import '../../sign/screens/sign_in_screen.dart';
import '../../sign/screens/sign_up_screen.dart';
import '../../sign/widgets/custom_button.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  Spacer(flex: 2),

                  /// Logo
                  Image.asset(
                    'assets/logo/logoStart.png',
                    width: screenWidth * 0.5,
                    height: screenHeight * 0.2,
                    fit: BoxFit.contain,
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  /// Title
                  Text(
                    'Welcome to \nSkillSwap',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.08, // scalable font
                      fontWeight: FontWeight.bold,
                      color: AppPalette.primary,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.08),

                  /// Subtitle
                  Text(
                    'Learn new skills, teach others, and grow together in our collaborative learning community',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      height: 1.4,
                      color: Theme.of(context).textTheme.bodyLarge!.color,
                    ),
                  ),

                  Spacer(flex: 3),

                  /// Sign Up Button
                  SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.07,
                    child: CustomButton(
                      text: 'Get Start',
                      onPressed: () {
                        Get.to(() => SignUpScreen());
                      },
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),

                  /// Sign In Button
                  SizedBox(
                    width: double.infinity,
                    height: screenHeight * 0.07,
                    child: CustomButton(
                      text: 'I already have an account',
                      colorButton: Colors.white,
                      colorText: AppPalette.primary,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInScreen()),
                        );
                      },
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
