import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skill_swap/shared/domain/repositories/booking_repository.dart';

import '../../../mobile/presentation/history/models/history_model.dart';
import '../../../mobile/presentation/home/models/next_session.dart';
import '../../../mobile/presentation/notification/models/notification_model.dart';
import '../../../mobile/presentation/sessions/models/session.dart';
import '../../data/models/get_booking/booking.dart';
import '../../helper/local_storage.dart';
import 'get_bookings_state.dart';

class GetBookingsCubit extends Cubit<GetBookingsState> {
  final BookingRepository bookingRepository;

  GetBookingsCubit(this.bookingRepository) : super(GetBookingsInitial());

  Future<List<GetBookingModel>> fetchAcceptedBookingsRaw() async {
    try {
      final response = await bookingRepository.getAllBookings("all");

      print("=== ALL bookings from API ===");
      for (var b in response.bookings) {
        print(
            "date=${b.date} | time=${b.time} | status=${b.status} | instructorId=${b.instructorId.id}");
      }

      return response.bookings;
    } catch (e) {
      print("Error: $e");
      return [];
    }
  }

  Future<void> fetchAllBookings(String status) async {
    emit(GetBookingsLoading());

    try {
      final response = await bookingRepository.getAllBookings(status);
      final currentUserId = await LocalStorage.getUserId();
      final now = DateTime.now();

      final sessions = response.bookings.map((booking) {
        final dateTime = DateTime(
          booking.date.year,
          booking.date.month,
          booking.date.day,
          int.parse(booking.time.split(":")[0]),
          int.parse(booking.time.split(":")[1]),
        );

        final bool isMeSender = booking.studentId.id == currentUserId;
        final bool isIncoming = booking.instructorId.id == currentUserId;
        final otherUser = isMeSender ? booking.instructorId : booking.studentId;

        final String displayStatus = isIncoming && booking.status == "pending"
            ? "requested"
            : booking.status;

        return SessionModel(
          sessionId: booking.id,
          bookingCode: booking.bookingCode,
          userId: otherUser.id,
          studentId: booking.studentId.id,
          userName: otherUser.name,
          userRole: otherUser.role,
          userImage: otherUser.userImage.secureUrl,
          dateTime: dateTime,
          duration: booking.durationMins,
          price: booking.price,
          paymentStatus: booking.paymentStatus,
          status: displayStatus,
          rawStatus: displayStatus,
          timeAgo: booking.createdAt,
          isStudent: isMeSender,
          instructorJoined: booking.instructorJoined,
          studentJoined: booking.studentJoined,
        );
      }).where((session) {
        final endTime = session.dateTime.add(
          Duration(minutes: session.duration.toInt()),
        );

        return now.isBefore(endTime);
      }).toList();

      emit(GetBookingsLoaded(bookings: sessions));
    } catch (e) {
      emit(GetBookingsError(message: e.toString()));
    }
  }

  Future<dynamic> getNotJoinedUserFromAccepted(String bookingCode) async {
    try {
      final response = await bookingRepository.getAllBookings("accepted");

      final booking = response.bookings.firstWhere(
        (b) => b.bookingCode == bookingCode,
        orElse: () => throw Exception("Booking not found"),
      );

      if (booking.studentJoined == false) {
        return booking.studentId;
      }

      if (booking.instructorJoined == false) {
        return booking.instructorId;
      }

      return null;
    } catch (e) {
      print("getNotJoinedUserFromAccepted error: $e");
      return null;
    }
  }

  Future<List<HistoryModel>> getCompletedHistory() async {
    final response = await bookingRepository.getAllBookings("completed");
    final currentUserId = await LocalStorage.getUserId();

    return response.bookings.where((booking) {
      return booking.status == "completed" &&
          booking.studentId.id == currentUserId;
    }).map((booking) {
      final otherUser = booking.instructorId;

      final dateTime = DateTime(
        booking.date.year,
        booking.date.month,
        booking.date.day,
        int.parse(booking.time.split(":")[0]),
        int.parse(booking.time.split(":")[1]),
      );

      return HistoryModel(
        id: booking.id,
        name: otherUser.name,
        role: otherUser.role,
        imageUrl: otherUser.userImage.secureUrl,
        date: "${dateTime.day}/${dateTime.month}/${dateTime.year}",
        time: booking.time,
        duration: "${booking.durationMins} min",
        status: "Finished",
        rating: booking.rate.toDouble(),
        isReviewReceived: false,
        reviewComment: booking.review,
      );
    }).toList();
  }

  Future<List<HistoryModel>> getReviewHistory() async {
    final response = await bookingRepository.getAllBookings("completed");
    final currentUserId = await LocalStorage.getUserId();

    return response.bookings.where((booking) {
      return booking.status == "completed" &&
          booking.instructorId.id == currentUserId &&
          booking.isRated == true;
    }).map((booking) {
      final otherUser = booking.studentId;

      final dateTime = DateTime(
        booking.date.year,
        booking.date.month,
        booking.date.day,
        int.parse(booking.time.split(":")[0]),
        int.parse(booking.time.split(":")[1]),
      );

      return HistoryModel(
        id: booking.id,
        name: otherUser.name,
        role: otherUser.role,
        imageUrl: otherUser.userImage.secureUrl,
        date: "${dateTime.day}/${dateTime.month}/${dateTime.year}",
        time: booking.time,
        duration: "${booking.durationMins} min",
        status: "Finished",
        rating: booking.rate.toDouble(),
        isReviewReceived: true,
        reviewComment: booking.review,
      );
    }).toList();
  }

  Future<List<NotificationModel>> fetchNotifications() async {
    try {
      final response = await bookingRepository.getAllBookings("all");
      final currentUserId = await LocalStorage.getUserId();
      final now = DateTime.now();

      final notifications = response.bookings.map((booking) {
        final dateTime = DateTime(
          booking.date.year,
          booking.date.month,
          booking.date.day,
          int.parse(booking.time.split(":")[0]),
          int.parse(booking.time.split(":")[1]),
        );

        final bool isMeSender = booking.studentId.id == currentUserId;
        final otherUser = isMeSender ? booking.instructorId : booking.studentId;

        String tag;
        Color tagColor;
        String title;
        IconData icon;

        switch (booking.status) {
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
          mentorName: otherUser.name,
          sessionTime:
              "${dateTime.day}/${dateTime.month} at ${DateFormat('h:mm a').format(dateTime)}",
          icon: icon,
          dateTime: dateTime,
        );
      }).toList();

      notifications.sort((a, b) => b.dateTime.compareTo(a.dateTime));

      return notifications;
    } catch (e) {
      print("Error fetching notifications: $e");
      return [];
    }
  }

  Future<void> fetchTodayNextSessions() async {
    emit(GetTodaySessionsLoading());

    try {
      final response = await bookingRepository.getAllBookings("accepted");
      final currentUserId = await LocalStorage.getUserId();
      final now = DateTime.now();

      final sessions = response.bookings.where((booking) {
        final dateTime = DateTime(
          booking.date.year,
          booking.date.month,
          booking.date.day,
          int.parse(booking.time.split(":")[0]),
          int.parse(booking.time.split(":")[1]),
        );

        final isToday = dateTime.year == now.year &&
            dateTime.month == now.month &&
            dateTime.day == now.day;

        final isRelated = booking.studentId.id == currentUserId ||
            booking.instructorId.id == currentUserId;

        final duration = booking.durationMins ?? 0;
        final endTime = dateTime.add(Duration(minutes: duration.toInt()));

        final isNotFinished = now.isBefore(endTime);

        return isToday && isRelated && isNotFinished;
      }).map((booking) {
        final dateTime = DateTime(
          booking.date.year,
          booking.date.month,
          booking.date.day,
          int.parse(booking.time.split(":")[0]),
          int.parse(booking.time.split(":")[1]),
        );

        final isMentor = booking.instructorId.id == currentUserId;
        final otherUser = isMentor ? booking.studentId : booking.instructorId;

        final diff = dateTime.difference(now);

        return NextSession(
          name: otherUser.name,
          sessionTime: dateTime,
          dateTime: "Today, ${DateFormat('h:mm a').format(dateTime)}",
          duration: "${booking.durationMins ?? 1} min",
          isMentor: isMentor,
        );
      }).toList();

      sessions.sort((a, b) => a.sessionTime.compareTo(b.sessionTime));
      emit(GetTodaySessionsLoaded(sessions: sessions));
    } catch (e) {
      emit(GetBookingsError(message: e.toString()));
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inSeconds < 60) return "${diff.inSeconds}s ago";
    if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
    if (diff.inHours < 24) return "${diff.inHours}h ago";
    return "${diff.inDays}d ago";
  }

  void updateBookingStatus(String sessionId, String newStatus) {
    if (state is GetBookingsLoaded) {
      final current = state as GetBookingsLoaded;

      final updated = current.bookings.map((s) {
        if (s.sessionId.toString() == sessionId) {
          return s.copyWith(
            status: newStatus,
            rawStatus: newStatus,
          );
        }
        return s;
      }).toList();

      emit(GetBookingsLoaded(bookings: updated));
    }
  }

  void removeBooking(String sessionId) {
    if (state is GetBookingsLoaded) {
      final current = state as GetBookingsLoaded;

      final updated = current.bookings
          .where((s) => s.sessionId.toString() != sessionId)
          .toList();

      emit(GetBookingsLoaded(bookings: updated));
    }
  }
}
