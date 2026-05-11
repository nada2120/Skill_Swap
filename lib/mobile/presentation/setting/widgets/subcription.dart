import 'package:flutter/material.dart';

import 'info_field.dart';

class SubscriptionSection extends StatelessWidget {
  const SubscriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final horizontalPadding = screenWidth * 0.04; // 4% من عرض الشاشة
    final verticalPadding = screenHeight * 0.02; // 2% من ارتفاع الشاشة
    final rowSpacing = screenHeight * 0.01; // 1% فاصل ديناميكي

    return Container(
      decoration: boxDecoration(),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SectionTitle("Subscription"),
              OutlinedButton(
                onPressed: () {},
                child: const Text("Upgrade"),
              ),
            ],
          ),
          SizedBox(height: rowSpacing),
          const StatusRow("Current Plan", "Free"),
          const StatusRow("Hours Available", "2 / 15 Days"),
        ],
      ),
    );
  }
}
