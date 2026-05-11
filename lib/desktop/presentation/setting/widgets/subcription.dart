import 'package:flutter/material.dart';

import 'info_field.dart';

class SubscriptionSection extends StatelessWidget {
  const SubscriptionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecoration(),
      padding: const EdgeInsets.all(16),
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
              )
            ],
          ),
          const SizedBox(height: 8),
          const StatusRow("Current Plan", "Free"),
          const StatusRow("Hours Available", "2 / 15 Days"),
        ],
      ),
    );
  }
}