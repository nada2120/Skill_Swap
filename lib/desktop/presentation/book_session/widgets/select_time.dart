import 'package:flutter/material.dart';

import '../../../../shared/core/theme/app_palette.dart';

class SelectTime extends StatefulWidget {
  final Function(String) onSelect;
  final String? initialTime;

  const SelectTime({super.key, required this.onSelect, this.initialTime});

  @override
  State<SelectTime> createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  final List<String> selectTime = [
    "09:00 AM",
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "01:00 PM",
    "02:00 PM",
    "03:00 PM",
    "04:00 PM",
    "05:00 PM",
    "06:00 PM",
    "07:00 PM",
    "08:00 PM",
  ];

  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialTime != null
        ? selectTime.indexOf(widget.initialTime!)
        : 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSelect(selectTime[selectedIndex]);
    });
  }

  @override
  void didUpdateWidget(covariant SelectTime oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTime != null &&
        widget.initialTime != oldWidget.initialTime) {
      setState(() {
        selectedIndex = selectTime.indexOf(widget.initialTime!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 2.4,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      children: List.generate(selectTime.length, (index) {
        final isSelected = selectedIndex == index;

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });
            widget.onSelect(selectTime[index]);
          },
          child: Container(
            decoration: BoxDecoration(
              color:
                  isSelected ? AppPalette.primary : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                selectTime[index],
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected
                      ? Colors.white
                      : (isDark
                          ? AppPalette.darkTextSecondary
                          : AppPalette.lightTextSecondary),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
