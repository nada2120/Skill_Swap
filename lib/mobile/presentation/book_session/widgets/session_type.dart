import 'package:flutter/material.dart';

import '../../../../shared/core/theme/app_palette.dart';

class SessionType extends StatelessWidget {
  final String sessionType;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final IconData icon;

  const SessionType({
    super.key,
    required this.sessionType,
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final containerHeight = screenHeight * 0.11; // ارتفاع نسبي
    final paddingHorizontal = screenWidth * 0.04;
    final borderRadius = screenWidth * 0.03;
    final iconSize = screenWidth * 0.045;

    final sessionTypeFontSize = screenWidth * 0.04;
    final titleFontSize = screenWidth * 0.03;

    return InkWell(
      borderRadius: BorderRadius.circular(borderRadius),
      onTap: onTap,
      child: Container(
        height: containerHeight,
        padding: EdgeInsets.symmetric(horizontal: paddingHorizontal),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: isSelected ? const Color(0xFFE6E7FF) : Colors.white,
          border: Border.all(
            color: isSelected ? AppPalette.primary : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: iconSize * 2.2,
              height: iconSize * 2.2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    isSelected ? AppPalette.primary : const Color(0xFFE6E7FF),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : AppPalette.primary,
                size: iconSize,
              ),
            ),
            SizedBox(width: screenWidth * 0.04),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sessionType,
                    style: TextStyle(
                      fontSize: sessionTypeFontSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: titleFontSize,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                width: iconSize * 0.5,
                height: iconSize * 0.5,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppPalette.primary,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
