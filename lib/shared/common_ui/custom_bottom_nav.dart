import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/theme/app_palette.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    // Adjust sizes based on screen width
    double selectedIconSize = 20;
    double unselectedIconSize = 22;
    double containerPaddingVertical = 4;
    double containerPaddingHorizontal = 12;
    double fontSize = 12;
    double circleSize = 48;

    if (screenWidth >= 1200) {
      // Desktop
      selectedIconSize = 28;
      unselectedIconSize = 30;
      containerPaddingVertical = 12;
      containerPaddingHorizontal = 24;
      fontSize = 16;
      circleSize = 64;
    } else if (screenWidth >= 800) {
      // Tablet
      selectedIconSize = 24;
      unselectedIconSize = 26;
      containerPaddingVertical = 8;
      containerPaddingHorizontal = 16;
      fontSize = 14;
      circleSize = 56;
    }

    final items = <NavItem>[
      NavItem(icon: Icons.home_outlined, label: 'home'.tr),
      NavItem(icon: Icons.chat_bubble_outline, label: 'chat'.tr),
      NavItem(icon: Icons.search, label: 'search'.tr),
      NavItem(icon: Icons.calendar_today_outlined, label: 'session'.tr),
      NavItem(icon: Icons.person_outline, label: 'profile'.tr),
      NavItem(icon: Icons.storefront_outlined, label: 'Store'),
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: containerPaddingVertical,
        horizontal: containerPaddingHorizontal,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppPalette.darkSurface : AppPalette.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isSelected = index == selectedIndex;

            final gradientColors = isDark
                ? [Color(0xFF3B3B70), AppPalette.primary]
                : [Color(0xFF2D8CFF), AppPalette.primary];

            if (isSelected) {
              return GestureDetector(
                onTap: () => onItemSelected(index),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      width: circleSize,
                      height: circleSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          center: const Alignment(-0.4, -0.3),
                          radius: 1.0,
                          colors: gradientColors,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: gradientColors.last.withOpacity(0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        item.icon,
                        color: Colors.white,
                        size: selectedIconSize,
                      ),
                    ),
                    SizedBox(height: fontSize / 3),
                    Text(
                      item.label,
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            }

            final iconColor = isDark
                ? AppPalette.darkTextSecondary.withOpacity(0.7)
                : AppPalette.lightTextSecondary.withOpacity(0.7);

            return GestureDetector(
              onTap: () => onItemSelected(index),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.icon,
                    size: unselectedIconSize,
                    color: iconColor,
                  ),
                  SizedBox(height: fontSize / 3),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: fontSize,
                      color: iconColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;

  NavItem({required this.icon, required this.label});
}
