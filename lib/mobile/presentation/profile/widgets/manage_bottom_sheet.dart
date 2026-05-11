import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../shared/bloc/accepted_bookings/accepted_bookings_cubit.dart';
import '../../../../shared/bloc/delete_available_dates/delete_available_dates_bloc.dart';
import '../../../../shared/common_ui/screen_manager/screen_manager.dart';

class ManageAvailabilityBottomSheet extends StatefulWidget {
  final List availableDates;
  final VoidCallback onAddPressed;
  final String instructorId;

  const ManageAvailabilityBottomSheet({
    super.key,
    required this.availableDates,
    required this.onAddPressed,
    required this.instructorId,
  });

  @override
  State<ManageAvailabilityBottomSheet> createState() =>
      _ManageAvailabilityBottomSheetState();
}

class _ManageAvailabilityBottomSheetState
    extends State<ManageAvailabilityBottomSheet> {
  late List localDates;

  @override
  void initState() {
    super.initState();
    localDates = List.from(widget.availableDates);

    context
        .read<AcceptedBookingsCubit>()
        .getAcceptedBookings(widget.instructorId);
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
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
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return BlocListener<DeleteAvailableDatesBloc, DeleteAvailableDatesState>(
      listener: (context, state) {
        if (state is DeleteAvailableDatesSuccess) {
          Get.snackbar(
            "Success",
            "Deleted successfully",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.black.withOpacity(0.2),
            colorText: Colors.white,
          );
        }

        if (state is DeleteAvailableDatesFailure) {
          Get.snackbar(
            "Error",
            state.message,
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.black.withOpacity(0.2),
            colorText: Colors.white,
          );
        }
      },
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: height * 0.75, // 👈 مهم جدًا
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Manage Days",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                BlocBuilder<AcceptedBookingsCubit, AcceptedBookingsState>(
                  builder: (context, acceptedState) {
                    List acceptedBookings = [];

                    if (acceptedState is AcceptedBookingsLoaded) {
                      acceptedBookings = acceptedState.bookings;
                    }

                    return Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ...localDates.map((item) {
                          final date = DateTime.parse(item.date);

                          final bookingsOnDay =
                              acceptedBookings.where((booking) {
                            final bookingDate =
                                DateTime.parse(booking.date.toString())
                                    .toLocal();
                            return isSameDay(date, bookingDate);
                          }).toList();

                          final hasBookings = bookingsOnDay.isNotEmpty;

                          return Chip(
                            avatar: hasBookings
                                ? const Icon(Icons.lock, size: 16)
                                : null,
                            backgroundColor: hasBookings
                                ? Colors.grey.withOpacity(0.2)
                                : null,
                            label: Text(
                              "${_getDayName(date.weekday)} ${date.day}/${date.month} "
                              "(${_formatTime(item.from)} - ${_formatTime(item.to)})",
                            ),
                            deleteIcon: const Icon(Icons.close, size: 18),
                            onDeleted: () {
                              if (hasBookings) {
                                showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text("Can't Delete Day"),
                                    content: Text(
                                      "This day has ${bookingsOnDay.length} booking(s).",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text("OK"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Get.to(() => ScreenManager(
                                                initialIndex: 3,
                                                initialSessionTab: 0,
                                              ));
                                        },
                                        child: const Text("View Bookings"),
                                      ),
                                    ],
                                  ),
                                );
                                return;
                              }

                              setState(() {
                                localDates.remove(item);
                              });

                              context.read<DeleteAvailableDatesBloc>().add(
                                    DeleteAvailableDates(idOrDate: item.date),
                                  );
                            },
                          );
                        }).toList(),
                        ActionChip(
                          avatar: const Icon(Icons.add),
                          label: const Text("Add Day"),
                          onPressed: widget.onAddPressed,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
