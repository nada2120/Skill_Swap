import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/theme/app_palette.dart';
import 'circle_button_icon.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Adjust sizes based on screen width
    double containerHeight = 100;
    double fontSize = 22;
    double iconSize = 16; // هذا مرتبط بـ CircleButtonIcon

    if (screenWidth >= 1200) {
      // Desktop
      containerHeight = 180;
      fontSize = 32;
      iconSize = 28;
    } else if (screenWidth >= 800) {
      // Tablet
      containerHeight = 150;
      fontSize = 28;
      iconSize = 24;
    }

    return Stack(
      children: [
        Container(
          height: containerHeight,
          decoration: BoxDecoration(color: AppPalette.primary),
        ),
        AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            title,
            style: TextStyle(
              color: const Color(0xFFD6D6D6),
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: CircleButtonIcon(
            icon: Icons.arrow_back_ios,
            onTap: () => Get.back(),
          ),
        ),
      ],
    );
  }
}
