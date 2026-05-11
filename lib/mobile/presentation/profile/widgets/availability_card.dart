import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/bloc/accepted_bookings/accepted_bookings_cubit.dart';
import '../../../../shared/bloc/add_available_dates_bloc/add_available_dates_bloc.dart';
import '../../../../shared/bloc/delete_available_dates/delete_available_dates_bloc.dart';
import '../../../../shared/bloc/get_available_dates_bloc/get_available_dates_bloc.dart';
import '../../../../shared/bloc/get_upcoming_sat_bloc/get_upcoming_sat_bloc.dart';
import '../../../../shared/bloc/set_available_dates_bloc/set_available_dates_bloc.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/data/models/booking_availability/available_dates.dart';
import '../../../../shared/data/models/booking_availability/set_available_dates.dart';
import 'availability_bottom_sheet.dart';
import 'manage_bottom_sheet.dart';

class AvailabilityCard extends StatefulWidget {
  final String instructorId;

  const AvailabilityCard({super.key, required this.instructorId});

  @override
  State<AvailabilityCard> createState() => _AvailabilityCardState();
}

class _AvailabilityCardState extends State<AvailabilityCard> {
  List<AvailableDates> availableDates = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<GetAvailableDatesBloc>().add(
            FetchAvailableDates(widget.instructorId),
          );

      context.read<GetUpcomingSatBloc>().add(FetchUpcomingSat());
    });
  }

  DateTime getStartOfWeek(DateTime date) {
    int diff = (date.weekday + 1) % 7;
    return date.subtract(Duration(days: diff));
  }

  List<String> generateMonthlyDates({
    required String weekday,
  }) {
    final map = {
      "Sun": DateTime.sunday,
      "Mon": DateTime.monday,
      "Tue": DateTime.tuesday,
      "Wed": DateTime.wednesday,
      "Thu": DateTime.thursday,
      "Fri": DateTime.friday,
      "Sat": DateTime.saturday,
    };

    final targetWeekday = map[weekday]!;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    List<String> result = [];

    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;

    for (int i = 1; i <= daysInMonth; i++) {
      final date = DateTime(now.year, now.month, i);

      if (date.weekday == targetWeekday && !date.isBefore(today)) {
        result.add(
          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        );
      }
    }

    return result;
  }

  void openManageSheet(List availableDates, DateTime startOfWeek) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) => MultiBlocProvider(
        providers: [
          BlocProvider.value(value: context.read<GetAvailableDatesBloc>()),
          BlocProvider.value(value: context.read<DeleteAvailableDatesBloc>()),
          BlocProvider.value(value: context.read<AddAvailableDatesBloc>()),
          BlocProvider.value(value: context.read<AcceptedBookingsCubit>()),
        ],
        child: ManageAvailabilityBottomSheet(
          instructorId: widget.instructorId,
          availableDates: availableDates,
          onAddPressed: () {
            Navigator.pop(bottomSheetContext);
            openBottomSheet(startOfWeek, false, availableDates);
          },
        ),
      ),
    );
  }

  void openBottomSheet(
      DateTime startOfWeek, bool hasData, List availableDates) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: context.read<SetAvailableDatesBloc>(),
          ),
        ],
        child: AvailabilityBottomSheet(
          selectedDays: [],
          fromTime: "02:00 PM",
          toTime: "05:00 PM",
          repeatType: "weekly",
          isEditMode: hasData,
          startOfWeek: startOfWeek,
          disabledDays: availableDates.map((e) {
            final date = DateTime.parse(e.date);
            return _getDayName(date.weekday);
          }).toList(),
        ),
      ),
    );

    if (result != null) {
      final days = result['days'] as List<String>;
      final from = result['from'];
      final to = result['to'];
      final repeat = result['repeat'];

      List<String> allDates = [];

      for (final day in days) {
        if (repeat == "weekly") {
          final date = _getDateFromDay(day, startOfWeek);
          allDates.add(date);
        } else if (repeat == "monthly") {
          final dates = generateMonthlyDates(weekday: day);

          if (dates.isEmpty) {
            if (context.mounted) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("No Available Days"),
                  content: Text(
                    "There are no remaining $day days in this month.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "OK",
                        style: TextStyle(color: AppPalette.primary),
                      ),
                    ),
                  ],
                ),
              );
            }
            return;
          }

          allDates.addAll(dates);
        }
      }

      if (allDates.isNotEmpty) {
        if (context.mounted) {
          context.read<SetAvailableDatesBloc>().add(
                SubmitSetAvailableDates(
                  SetAvailableDates(
                    availableDates: allDates.map((d) {
                      return Dates(
                        date: d,
                        from: _convertTo24(from),
                        to: _convertTo24(to),
                      );
                    }).toList(),
                    rotationType: repeat,
                  ),
                ),
              );
        }
      }
    }
  }

  String _getDateFromDay(String day, DateTime startOfWeek) {
    final map = {
      "Sat": 0,
      "Sun": 1,
      "Mon": 2,
      "Tue": 3,
      "Wed": 4,
      "Thu": 5,
      "Fri": 6,
    };

    final date = startOfWeek.add(Duration(days: map[day]!));

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

  String _getDayName(int weekday) {
    const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    return days[weekday - 1];
  }

  String _formatTime(String time) {
    final parts = time.split(":");
    int hour = int.parse(parts[0]);
    final minute = parts[1];

    final isPm = hour >= 12;
    if (hour > 12) hour -= 12;
    if (hour == 0) hour = 12;

    final period = isPm ? "PM" : "AM";

    return "${hour.toString().padLeft(2, '0')}:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SetAvailableDatesBloc, SetAvailableDatesState>(
          listener: (context, state) {
            if (state is SetAvailableDatesSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Saved successfully")),
              );

              context.read<GetAvailableDatesBloc>().add(
                    FetchAvailableDates(widget.instructorId),
                  );
            }

            if (state is SetAvailableDatesError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
        BlocListener<DeleteAvailableDatesBloc, DeleteAvailableDatesState>(
          listener: (context, state) {
            if (state is DeleteAvailableDatesSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Deleted successfully")),
              );

              context.read<GetAvailableDatesBloc>().add(
                    FetchAvailableDates(widget.instructorId),
                  );
            }

            if (state is DeleteAvailableDatesFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
        ),
      ],
      child: BlocBuilder<GetAvailableDatesBloc, GetAvailableDatesState>(
        builder: (context, state) {
          if (state is GetAvailableDatesSuccess) {
            availableDates = state.data.availableDates;
          }

          final hasData = availableDates.isNotEmpty;

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 6)
              ],
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your Availability",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyLarge!.color,
                  ),
                ),
                const SizedBox(height: 10),
                if (hasData)
                  Column(
                    children: availableDates.map<Widget>((item) {
                      final date = DateTime.parse(item.date);

                      return Row(
                        children: [
                          Text(
                              "${_getDayName(date.weekday)} ${date.day}/${date.month}"),
                          const Spacer(),
                          Text(
                              "${_formatTime(item.from)} - ${_formatTime(item.to)}"),
                        ],
                      );
                    }).toList(),
                  )
                else
                  Text(
                    "Set when you're available for sessions",
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                    ),
                  ),
                const SizedBox(height: 12),
                BlocBuilder<SetAvailableDatesBloc, SetAvailableDatesState>(
                  builder: (context, addState) {
                    final isLoading = addState is SetAvailableDatesLoading;

                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                final start = getStartOfWeek(DateTime.now());

                                if (hasData) {
                                  openManageSheet(availableDates, start);
                                } else {
                                  openBottomSheet(start, false, availableDates);
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppPalette.primary,
                          padding: const EdgeInsets.all(14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    "Saving...",
                                    style: TextStyle(
                                      color: Color(0XFFF2F5F8),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                hasData ? "Manage Days" : "Set Your Schedule",
                                style: const TextStyle(
                                  color: Color(0XFFF2F5F8),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    );
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
