import 'package:flutter/material.dart';

import '../../../../shared/core/theme/app_palette.dart';

class CustomAuth extends StatelessWidget {
  final String title;
  final String subTitle;
  final Widget childWidget;
  final String buttonText;
  final VoidCallback? onPressed;
  final String bottomText;
  final String bottomActionText;
  final VoidCallback? onBottomTap;

  const CustomAuth({
    super.key,
    required this.title,
    required this.subTitle,
    required this.childWidget,
    required this.buttonText,
    required this.onPressed,
    required this.bottomText,
    required this.bottomActionText,
    required this.onBottomTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final horizontalPadding = screenWidth * 0.04; // بدل 16
    final containerWidth = screenWidth * 0.9; // بدل 361
    final buttonWidth = screenWidth * 0.9; // بدل 329
    final buttonHeight = screenHeight * 0.065; // بدل 50
    final borderRadius = screenWidth * 0.02; // بدل 16

    final titleFontSize = screenWidth * 0.065; // بدل 24
    final subTitleFontSize = screenWidth * 0.045; // بدل 16
    final buttonFontSize = screenWidth * 0.045; // بدل 16
    final verticalSpacing = screenHeight * 0.02; // بدل 8-32

    final bool isChildSizedBox = childWidget is SizedBox;

    return Center(
      child: Container(
        width: containerWidth,
        padding: EdgeInsets.all(horizontalPadding),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ),
            SizedBox(height: verticalSpacing / 1.5),
            Text(
              subTitle,
              style: TextStyle(
                fontSize: subTitleFontSize,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
            ),
            SizedBox(height: verticalSpacing * 1.5),
            childWidget,
            if (!isChildSizedBox) SizedBox(height: verticalSpacing),
            SizedBox(
              width: buttonWidth,
              height: buttonHeight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppPalette.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius / 2),
                  ),
                ),
                onPressed: onPressed,
                child: Text(
                  buttonText,
                  style:
                      TextStyle(fontSize: buttonFontSize, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: verticalSpacing * 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  bottomText,
                  style: TextStyle(
                    color: const Color(0xff142057),
                    fontSize: screenWidth * 0.04,
                  ),
                ),
                GestureDetector(
                  onTap: onBottomTap,
                  child: Text(
                    bottomActionText,
                    style: TextStyle(
                      color: AppPalette.primary,
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
