import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SectionHeader extends StatelessWidget {
  final String sectionTitle;
  final VoidCallback? onTop;

  const SectionHeader({
    super.key,
    required this.sectionTitle,
    required this.onTop,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          sectionTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        GestureDetector(
          onTap: onTop,
          child: Row(
            children: [
              Text(
                "view_all".tr,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, size: 14),
            ],
          ),
        ),
      ],
    );
  }
}