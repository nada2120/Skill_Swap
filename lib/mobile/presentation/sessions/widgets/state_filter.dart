import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatusFilter extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const StatusFilter({
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;

    final statusList = ["accepted".tr, "pending".tr, "request".tr, "rejected"];

    return Wrap(
      spacing: screenWidth * 0.01,
      children: List.generate(statusList.length, (index) {
        final isSelected = selectedIndex == index;

        return GestureDetector(
          onTap: () => onSelect(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.025,
              vertical: screenWidth * 0.012,
            ),
            decoration: BoxDecoration(
              color:
                  isSelected ? Color(0xFFE68C47) : colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? colorScheme.primary
                    : colorScheme.outlineVariant,
              ),
            ),
            child: Text(
              statusList[index],
              style: TextStyle(
                fontSize: screenWidth * 0.035,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      }),
    );
  }
}
