import 'package:flutter/material.dart';

import 'info_field.dart';

class PersonalInfoSection extends StatelessWidget {
  const PersonalInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // padding ديناميكي
    final horizontalPadding = screenWidth * 0.04; // 4% من عرض الشاشة
    final verticalPadding = screenHeight * 0.02; // 2% من ارتفاع الشاشة

    return Container(
      decoration: boxDecoration(),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SectionTitle("Personal Information"),
          InfoField("Full Name", "Liyan Alex"),
          InfoField("Email", "liyanAlex@gmail.com"),
          InfoField("Bio", "Tell others about yourself"),
          InfoField("Skills", "JavaScript, React"),
        ],
      ),
    );
  }
}
