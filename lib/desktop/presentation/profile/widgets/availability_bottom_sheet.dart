import 'package:flutter/material.dart';
import 'package:skill_swap/shared/core/theme/app_palette.dart';

class AvailabilityBottomSheet extends StatefulWidget {
  final List<String> selectedDays;
  final String fromTime;
  final String toTime;
  final String repeatType;
  final bool isEditMode;
  final DateTime startOfWeek;
  final List<String> disabledDays;

  const AvailabilityBottomSheet({
    super.key,
    required this.selectedDays,
    required this.fromTime,
    required this.toTime,
    required this.repeatType,
    required this.isEditMode,
    required this.startOfWeek,
    required this.disabledDays,
  });

  @override
  State<AvailabilityBottomSheet> createState() =>
      _AvailabilityBottomSheetState();
}

class _AvailabilityBottomSheetState extends State<AvailabilityBottomSheet> {
  late List<String> days;
  late String fromTime;
  late String toTime;
  late String repeat;
  late DateTime currentWeekStart;
  bool _hasAutoShifted = false;

  final allDays = ["Sat", "Sun", "Mon", "Tue", "Wed", "Thu", "Fri"];
  final Map<String, int> dayIndex = {
    "Sat": 0,
    "Sun": 1,
    "Mon": 2,
    "Tue": 3,
    "Wed": 4,
    "Thu": 5,
    "Fri": 6,
  };

  @override
  void initState() {
    super.initState();

    currentWeekStart = widget.startOfWeek;

    days = [...widget.selectedDays];
    repeat = widget.repeatType;

    if (widget.fromTime.isNotEmpty && widget.toTime.isNotEmpty) {
      fromTime = widget.fromTime;
      toTime = widget.toTime;
    } else {
      final minFrom = DateTime.now().add(const Duration(hours: 12));
      final minTo = minFrom.add(const Duration(hours: 2));

      fromTime = _formatTime(TimeOfDay.fromDateTime(minFrom));
      toTime = _formatTime(TimeOfDay.fromDateTime(minTo));
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoMoveToNextAvailableWeek();
    });
  }

  void _autoMoveToNextAvailableWeek() {
    DateTime tempWeek = currentWeekStart;
    int safety = 0;

    while (_isWeekDisabled(tempWeek) && safety < 10) {
      tempWeek = tempWeek.add(const Duration(days: 7));
      safety++;
    }

    if (tempWeek != currentWeekStart) {
      setState(() {
        currentWeekStart = tempWeek;
      });
    }
  }

  bool _isWeekDisabled(DateTime weekStart) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return allDays.every((day) {
      final index = dayIndex[day]!;
      final date = weekStart.add(Duration(days: index));

      final isPastDay = date.isBefore(today);

      return widget.disabledDays.contains(day) ||
          isPastDay ||
          !isDayAvailable(day, weekStart);
    });
  }

  String _formatTime(TimeOfDay t) {
    final hour = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final minute = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  DateTime get minAllowedDateTime =>
      DateTime.now().add(const Duration(hours: 12));

  bool isDayAvailable(String day, DateTime weekStart) {
    final index = dayIndex[day]!;
    final date = weekStart.add(Duration(days: index));

    final minAllowed = DateTime.now().add(const Duration(hours: 12));
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59);

    return endOfDay.isAfter(minAllowed);
  }

  bool isDayAndTimeValid(String day) {
    final index = dayIndex[day]!;
    final date = currentWeekStart.add(Duration(days: index));

    final fromParsed = _parseTime(fromTime);
    final sessionDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      fromParsed.hour,
      fromParsed.minute,
    );

    final minAllowed = DateTime.now().add(const Duration(hours: 12));
    return sessionDateTime.isAfter(minAllowed);
  }

  int _timeToMinutes(String time) {
    final lower = time.toLowerCase().trim();
    final isPm = lower.contains('pm');

    final clean = lower.replaceAll(RegExp(r'[apm\s]'), '');
    final parts = clean.split(':');

    int hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    if (isPm && hour != 12) hour += 12;
    if (!isPm && hour == 12) hour = 0;

    return hour * 60 + minute;
  }

  int _toMinutes(String timeStr) {
    final lower = timeStr.toLowerCase().trim();
    final hasPeriod = lower.contains('am') || lower.contains('pm');
    if (hasPeriod) {
      final isPm = lower.contains('pm');
      final clean = lower.replaceAll(RegExp(r'[apm\s]'), '');
      final parts = clean.split(':');
      int h = int.parse(parts[0]);
      final m = int.parse(parts[1]);
      if (isPm && h != 12) h += 12;
      if (!isPm && h == 12) h = 0;
      return h * 60 + m;
    } else {
      final parts = lower.split(':');
      return int.parse(parts[0]) * 60 + int.parse(parts[1]);
    }
  }

  bool get isTimeRangeValid {
    final from = _timeToMinutes(fromTime);
    final to = _timeToMinutes(toTime);
    final diff = to - from;
    return diff >= 30 && to > from;
  }

  bool get canSave {
    if (days.isEmpty || !isTimeRangeValid) return false;
    return days.every((day) => isDayAndTimeValid(day));
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 2500),
      ),
    );
  }

  void toggleDay(String day) {
    setState(() {
      if (days.contains(day)) {
        days.remove(day);
      } else {
        if (!isDayAndTimeValid(day)) {
          _showSnackBar(
            "This day is too soon — choose a later time first",
          );
          return;
        }
        days.add(day);
      }
    });
  }

  TimeOfDay _parseTime(String time) {
    final lower = time.toLowerCase();
    final isPm = lower.contains('pm');

    final parts = lower.replaceAll(RegExp(r'[apm\s]'), '').split(':');
    int hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    if (isPm && hour != 12) hour += 12;
    if (!isPm && hour == 12) hour = 0;

    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> pickTime(bool isFrom) async {
    final minAllowed = minAllowedDateTime;
    final initial = isFrom ? _parseTime(fromTime) : _parseTime(toTime);

    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              backgroundColor: Theme.of(context).cardColor,
              dialHandColor: AppPalette.primary,
              entryModeIconColor: AppPalette.primary,
              dialBackgroundColor: AppPalette.primary.withOpacity(0.1),
              hourMinuteTextColor: AppPalette.primary,
              hourMinuteColor: AppPalette.primary.withOpacity(0.1),
              dayPeriodColor: MaterialStateColor.resolveWith((states) {
                return states.contains(MaterialState.selected)
                    ? AppPalette.primary
                    : Colors.grey.shade200;
              }),
              dayPeriodTextColor: MaterialStateColor.resolveWith((states) {
                return states.contains(MaterialState.selected)
                    ? Colors.white
                    : Colors.black;
              }),
            ),
            colorScheme: ColorScheme.light(
              primary: AppPalette.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    final today = DateTime.now();
    final selected = DateTime(
      today.year,
      today.month,
      today.day,
      picked.hour,
      picked.minute,
    );
    if (isFrom && selected.isBefore(minAllowed)) {
      _showSnackBar(
        "Minimum time is ${_formatTime(TimeOfDay.fromDateTime(minAllowed))} (12h from now)",
      );
      return;
    }

    final newTime = _formatTime(picked);
    final newMinutes = _timeToMinutes(newTime);
    final fromMinutes = _timeToMinutes(fromTime);

    setState(() {
      if (isFrom) {
        fromTime = newTime;
        // لو الـ toTime بقى أقل من الـ fromTime، اضبطه تلقائياً
        if (_timeToMinutes(toTime) <= _timeToMinutes(fromTime)) {
          final corrected = selected.add(const Duration(hours: 2));
          toTime = _formatTime(TimeOfDay.fromDateTime(corrected));
        }
        // لو في أيام مختارة مش هتبقى valid مع الوقت الجديد، شيلهم
        days.removeWhere((day) => !isDayAndTimeValid(day));
      } else {
        if (newMinutes <= fromMinutes) {
          _showSnackBar("End time must be after start time");
          return;
        }
        toTime = newTime;
      }
    });

    if (!isTimeRangeValid) {
      _showSnackBar("Invalid time range (minimum 30 minutes)");
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
  }

  String getDateForDay(String day) {
    final index = dayIndex[day]!;
    final date = currentWeekStart.add(Duration(days: index));
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  String _convertTo24(String time) {
    final lower = time.toLowerCase();
    final isPm = lower.contains('pm');

    final parts = lower.replaceAll(RegExp(r'[apm\s]'), '').split(':');
    int hour = int.parse(parts[0]);
    final minute = parts[1];

    if (isPm && hour != 12) hour += 12;
    if (!isPm && hour == 12) hour = 0;

    return "${hour.toString().padLeft(2, '0')}:$minute";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Set Your Availability",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "1. Choose days",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
              Wrap(
                spacing: 8,
                children: allDays.map((day) {
                  final selected = days.contains(day);
                  final now = DateTime.now();
                  final index = dayIndex[day]!;
                  final date = currentWeekStart.add(Duration(days: index));
                  final today = DateTime(now.year, now.month, now.day);
                  final isPastDay = date.isBefore(today);

                  final isDisabled = widget.disabledDays.contains(day) ||
                      !isDayAvailable(day, currentWeekStart) ||
                      isPastDay;

                  return ChoiceChip(
                    label: Text(
                      day,
                      style: TextStyle(
                        color: isDisabled
                            ? Colors.grey
                            : selected
                                ? Colors.white
                                : Colors.grey[300],
                      ),
                    ),
                    selected: selected,
                    onSelected: isDisabled ? null : (_) => toggleDay(day),
                    selectedColor: AppPalette.primary,
                    backgroundColor: isDisabled
                        ? Colors.grey.withOpacity(0.2)
                        : Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isDisabled
                            ? Colors.grey
                            : selected
                                ? AppPalette.primary
                                : Colors.grey[700]!,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Text(
                "2. Time",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
              widget.isEditMode
                  ? Row(
                      children: [
                        Icon(
                          Icons.lock,
                          size: 18,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "$fromTime - $toTime",
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => pickTime(true),
                            child: Text(
                              fromTime,
                              style: TextStyle(color: AppPalette.primary),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => pickTime(false),
                            child: Text(
                              toTime,
                              style: TextStyle(color: AppPalette.primary),
                            ),
                          ),
                        ),
                      ],
                    ),
              if (!widget.isEditMode && !isTimeRangeValid)
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    _toMinutes(toTime) <= _toMinutes(fromTime)
                        ? "End time must be later than start time"
                        : "Time range must be at least 30 minutes",
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontSize: 12,
                    ),
                  ),
                ),
              const SizedBox(height: 20),
              Text(
                "3. Repeat",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium!.color,
                ),
              ),
              widget.isEditMode
                  ? Row(
                      children: [
                        Icon(
                          Icons.lock,
                          size: 18,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          repeat == "weekly" ? "No Repeat" : repeat,
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        RadioListTile(
                          activeColor: AppPalette.primary,
                          value: "weekly",
                          groupValue: repeat,
                          onChanged: (v) => setState(() => repeat = v!),
                          title: Text(
                            "No Repeat",
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                          ),
                        ),
                        RadioListTile(
                          activeColor: AppPalette.primary,
                          value: "monthly",
                          groupValue: repeat,
                          onChanged: (v) => setState(() => repeat = v!),
                          title: Text(
                            "This month",
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 36),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        canSave ? AppPalette.primary : Colors.grey.shade400,
                    padding: const EdgeInsets.all(14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    if (!canSave) {
                      if (days.isEmpty) {
                        _showSnackBar("Please select at least one day");
                      } else if (!isTimeRangeValid) {
                        final from = _timeToMinutes(fromTime);
                        final to = _timeToMinutes(toTime);
                        _showSnackBar(
                          to <= from
                              ? "End time must be after start time"
                              : "Minimum duration is 30 minutes",
                        );
                      } else {
                        _showSnackBar(
                          "Selected day + time must be at least 12 hours from now",
                        );
                      }
                      return;
                    }

                    Navigator.pop(context, {
                      "days": days,
                      "from": fromTime,
                      "to": toTime,
                      "repeat": repeat,
                    });
                  },
                  child: const Text(
                    "Save Availability",
                    style: TextStyle(
                      color: Color(0XFFF2F5F8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
