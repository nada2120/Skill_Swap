import 'package:flutter/material.dart';

import 'info_field.dart';

class AccountStatusSection extends StatelessWidget {
  const AccountStatusSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecoration(),
      padding: const EdgeInsets.all(16),
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