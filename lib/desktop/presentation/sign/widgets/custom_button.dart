import 'package:flutter/material.dart';

import '../../../../shared/core/theme/app_palette.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color colorButton;
  final Color colorText;
  final double widthButton;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.colorButton = AppPalette.primary,
    this.colorText = Colors.white,
    this.widthButton = double.infinity
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widthButton,
      height: 50,
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
          style:  TextStyle(
            color: colorText,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
