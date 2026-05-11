import 'package:flutter/material.dart';

import 'info_field.dart';

class SettingHeader extends StatelessWidget {
  const SettingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // نجيب أبعاد الشاشة
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // padding ديناميكي
    final horizontalPadding = screenWidth * 0.04; // 4% من عرض الشاشة
    final verticalPadding = screenHeight * 0.02; // 2% من ارتفاع الشاشة

    // مساحة بين العناصر داخل Row
    final rowSpacing = screenWidth * 0.03; // 3% من عرض الشاشة

    return Container(
      decoration: boxDecoration(),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Row(
        children: [
          const CircleAvatar(radius: 30),
          SizedBox(width: rowSpacing),
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.camera_alt),
            label: const Text("Change Photo"),
          ),
        ],
      ),
    );
  }
}
