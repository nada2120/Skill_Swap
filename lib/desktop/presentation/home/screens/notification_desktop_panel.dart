import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../../../../shared/bloc/get_bookings_cubit/get_bookings_state.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../models/notification_model.dart';
import '../widgets/notification_card.dart';

class NotificationDesktopPanel extends StatefulWidget {
  const NotificationDesktopPanel({super.key});

  @override
  State<NotificationDesktopPanel> createState() =>
      _NotificationDesktopPanelState();
}

class _NotificationDesktopPanelState extends State<NotificationDesktopPanel> {
  late GetBookingsCubit cubit;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    cubit = sl<GetBookingsCubit>();
    cubit.fetchAllBookings("all");

    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);

    if (diff.inSeconds < 60) return "${diff.inSeconds}s ago";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
    if (diff.inHours < 24) return "${diff.inHours}h ago";
    return "${diff.inDays}d ago";
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppPalette.darkElevated : AppPalette.lightElevated,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Notifications",
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge!.color,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Divider(height: 20),
          const SizedBox(height: 16),
          Expanded(
            child: BlocBuilder<GetBookingsCubit, GetBookingsState>(
              bloc: cubit,
              builder: (context, state) {
                if (state is GetBookingsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is GetBookingsError) {
                  return Center(child: Text(state.message));
                }

                if (state is GetBookingsLoaded) {
                  final now = DateTime.now();

                  final notifications = state.bookings.map((session) {
                    final dateTime = session.dateTime;

                    Color tagColor;
                    String tag;
                    String title;
                    IconData icon;

                    switch (session.rawStatus) {
                      case "accepted":
                        tag = "Approved";
                        tagColor = Colors.green;
                        icon = Icons.check_circle_outline;
                        if (dateTime.isAfter(now) &&
                            dateTime.difference(now).inMinutes <= 30) {
                          title =
                              "Reminder: Your mentorship session starts in ${dateTime.difference(now).inMinutes} minutes.";
                        } else {
                          title = "Your session has been Approved!";
                        }
                        break;

                      case "rejected":
                        tag = "Rejected";
                        tagColor = Colors.red;
                        icon = Icons.cancel_outlined;
                        title = "Your session request was declined.";
                        break;

                      case "cancelled":
                        tag = "Cancelled";
                        tagColor = Colors.red.shade300;
                        icon = Icons.cancel_outlined;
                        title = "Your session was cancelled.";
                        break;

                      default:
                        tag = "Reminder";
                        tagColor = Colors.grey;
                        icon = Icons.notifications_none_outlined;
                        title = "You have a new session request.";
                    }

                    return NotificationModel(
                      bgColor: tagColor.withOpacity(0.1),
                      borderColor: tagColor,
                      tag: tag,
                      tagColor: tagColor,
                      timeAgo: _formatTimeAgo(dateTime),
                      title: title,
                      mentorName: session.userName,
                      sessionTime:
                          "${dateTime.day}/${dateTime.month} at ${DateFormat('h:mm a').format(dateTime)}",
                      icon: icon,
                      dateTime: dateTime,
                    );
                  }).toList();

                  notifications
                      .sort((a, b) => b.dateTime.compareTo(a.dateTime));

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final item = notifications[index];
                      return NotificationCard(
                        bgColor: item.bgColor,
                        borderColor: item.borderColor,
                        tag: item.tag,
                        tagColor: item.tagColor,
                        timeAgo: item.timeAgo,
                        title: item.title,
                        mentorName: item.mentorName,
                        sessionTime: item.sessionTime,
                        icon: item.icon,
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}
