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
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        height: 88,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isSelected
              ? const Color(0xFFE6E7FF)
              : Colors.white,
          border: Border.all(
            color: isSelected
                ? AppPalette.primary
                : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppPalette.primary
                    : const Color(0xFFE6E7FF),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : AppPalette.primary,
                size: 18,
              ),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sessionType,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            if (isSelected)
              Container(
                width: 8,
                height: 8,
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