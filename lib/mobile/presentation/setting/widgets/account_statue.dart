import 'package:flutter/material.dart';

import 'info_field.dart';

class AccountStatusSection extends StatelessWidget {
  const AccountStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    // نجيب حجم الشاشة
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
          SectionTitle("Account Status"),
          StatusRow("Account Type", "Learner"),
          StatusRow("Member Since", "January 2024"),
          StatusRow(
            "Verification Status",
            "Verified",
            valueColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
