import 'package:flutter/material.dart';

import '../../../../shared/core/theme/app_palette.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color colorButton;
  final Color colorText;
  final double? widthButton;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.colorButton = AppPalette.primary,
    this.colorText = Colors.white,
    this.widthButton,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      width: widthButton ?? double.infinity,
      height: screenHeight * 0.07,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorButton,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: colorText,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.045, // حجم الخط نسبي للشاشة
          ),
        ),
      ),
    );
  }
}
