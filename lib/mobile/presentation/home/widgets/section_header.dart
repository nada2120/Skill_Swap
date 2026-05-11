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
    final screenWidth = MediaQuery.of(context).size.width;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            sectionTitle,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        GestureDetector(
          onTap: onTop,
          child: Row(
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "view_all".tr,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              SizedBox(width: screenWidth * 0.02), // بدل 8
              Icon(
                Icons.arrow_forward_ios,
                size: screenWidth * 0.04, // بدل 16
                color: Theme.of(context).textTheme.bodyLarge!.color,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
