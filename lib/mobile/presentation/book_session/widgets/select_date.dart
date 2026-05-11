import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../shared/core/theme/app_palette.dart';

class SelectDate extends StatefulWidget {
  final Function(DateTime) onSelect;
  final DateTime? initialDate;

  const SelectDate({super.key, required this.onSelect, this.initialDate});

  @override
  State<SelectDate> createState() => _SelectDateState();
}

class _SelectDateState extends State<SelectDate> {
  late DateTime selectedDay;

  @override
  void initState() {
    super.initState();
    selectedDay = widget.initialDate ?? DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onSelect(selectedDay);
    });
  }

  @override
  void didUpdateWidget(covariant SelectDate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != null &&
        widget.initialDate != oldWidget.initialDate) {
      setState(() {
        selectedDay = widget.initialDate!;
      });
    }
  }

  void onDaySelected(DateTime day, DateTime focusDay) {
    setState(() {
      selectedDay = day;
    });
    widget.onSelect(day);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 288,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(8),
      child: TableCalendar(
        locale: "en_US",
        rowHeight: 32,
        daysOfWeekHeight: 16,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
          leftChevronIcon: Icon(Icons.chevron_left, size: 20),
          rightChevronIcon: Icon(Icons.chevron_right, size: 20),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyMedium!.color,
          ),
          weekendStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodyMedium!.color,
          ),
        ),
        calendarStyle: CalendarStyle(
          isTodayHighlighted: true,
          selectedDecoration: BoxDecoration(
            color: AppPalette.primary,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
          todayDecoration: BoxDecoration(
            color: AppPalette.primary.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          todayTextStyle: TextStyle(
            color: AppPalette.primary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          defaultDecoration: const BoxDecoration(shape: BoxShape.circle),
          weekendDecoration: const BoxDecoration(shape: BoxShape.circle),
          defaultTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          weekendTextStyle: const TextStyle(
            color: Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          outsideTextStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          cellAlignment: Alignment.center,
          tablePadding: const EdgeInsets.only(top: 4),
        ),
        availableGestures: AvailableGestures.all,
        onDaySelected: onDaySelected,
        selectedDayPredicate: (day) => isSameDay(day, selectedDay),
        focusedDay: selectedDay,
        firstDay: DateTime.now(),
        lastDay: DateTime.utc(2030, 3, 14),
      ),
    );
  }
}
