import 'package:flutter/material.dart';

class SocialButton extends StatelessWidget {
  final String text;

  const SocialButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Expanded(
      child: Container(
        height: screenHeight * 0.06, // ارتفاع نسبي للشاشة
        decoration: BoxDecoration(
          color: const Color(0xFFD6D6D6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis, // لو النص طويل
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
              fontSize: screenWidth * 0.045, // حجم الخط نسبي للشاشة
            ),
          ),
        ),
      ),
    );
  }
}
