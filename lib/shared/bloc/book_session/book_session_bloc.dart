import 'package:bloc/bloc.dart';

import '../../constants/not_type.dart';
import '../../data/models/booking/booking_model.dart' as bookingModel;
import '../../data/models/booking/booking_model.dart';
import '../../data/models/booking/booking_response.dart';
import '../../data/models/booking_details/booking_details_response.dart';
import '../../data/models/cancel_booking/cancel_booking_response.dart';
import '../../data/models/get_booking/booking.dart';
import '../../data/models/update_booking/update_booking_response.dart';
import '../../dependency_injection/injection.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../helper/local_storage.dart';
import 'book_session_event.dart';
import 'book_session_state.dart';

class ActiveBookingBloc extends Bloc<ActiveBookingEvent, ActiveBookingState> {
  final BookingRepository repo;

  Booking? _cachedBooking;

  ActiveBookingBloc(this.repo) : super(BookingIdle()) {
    on<LoadBookingDetails>((event, emit) async {
      if (_cachedBooking != null && _cachedBooking!.id == event.id) {
        emit(BookingLoaded(_cachedBooking!));
        return;
      }

      emit(BookingLoading());

      final response = await repo.getBookingDetails(event.id);

      switch (response) {
        case BookingDetailsSuccess d:
          _cachedBooking = d.data.booking;
          emit(BookingLoaded(d.data.booking));

        case BookingDetailsFailure f:
          emit(BookingError(f.error.message));
      }
    });

    /// 🔥 CREATE BOOKING
    on<CreateBooking>((event, emit) async {
      emit(BookingLoading());

      final response = await repo.bookSession(event.request);

      switch (response) {
        case BookingSuccess s:
          _cachedBooking = s.data.bookSession;

          /// ✅ ADD THIS
          emit(BookingCreatedSuccess(s.data.bookSession));

          // 🔔 Notify the INSTRUCTOR about new booking request
          final currentUserIdForBooking = await LocalStorage.getUserId();
          if (event.request.instructorId != currentUserIdForBooking) {
            await sl<NotificationRepository>().sendNotification(
              receiverId: event.request.instructorId,
              type: NotificationTypes.newBooking,
              payload: {
                'bookingId': s.data.bookSession.id ?? '',
              },
            );
          }

          /// UI يكمل طبيعي
          emit(BookingLoaded(s.data.bookSession));

        case BookingFailure f:
          emit(BookingError(f.error.message));
      }
    });

    /// 🔥 UPDATE BOOKING
    on<UpdateBooking>((event, emit) async {
      emit(BookingLoading());

      final updateResponse =
      await repo.updateBookSession(event.id, event.request);

      switch (updateResponse) {
        case UpdateBookingSuccess _:

        /// ✅ ADD THIS
          emit(BookingUpdatedSuccess());

          final detailsResponse = await repo.getBookingDetails(event.id);

          switch (detailsResponse) {
            case BookingDetailsSuccess d:
              _cachedBooking = d.data.booking;
              emit(BookingLoaded(d.data.booking));

            case BookingDetailsFailure f:
              emit(BookingError(f.error.message));
          }
          break;

        case UpdateBookingFailure f:
          emit(BookingError(f.error.message));
      }
    });

    /// 🔥 CANCEL BOOKING
    on<CancelBooking>((event, emit) async {
      emit(BookingLoading());

      final response = await repo.cancelBookSession(event.id);

      switch (response) {
        case CancelBookingSuccess _:

        /// ✅ ADD THIS
          emit(BookingCancelledSuccess());

          // 🔔 Notify the other party about cancellation
          if (_cachedBooking != null) {
            final currentUserId = await LocalStorage.getUserId();
            final recipientId = currentUserId == _cachedBooking!.studentId
                ? _cachedBooking!.instructorId
                : _cachedBooking!.studentId;

            if (recipientId != currentUserId) {
              await sl<NotificationRepository>().sendNotification(
                receiverId: recipientId,
                type: NotificationTypes.bookingCancelled,
                payload: {
                  'bookingId': _cachedBooking!.id,
                },
              );
            }
          }

          _cachedBooking = null;
          emit(BookingIdle());

        case CancelBookingFailure f:
          emit(BookingError(f.error.message));
      }
    });

    on<LoadMyBookingWithMentor>((event, emit) async {
      if (_cachedBooking != null &&
          _cachedBooking!.instructorId == event.mentorId) {
        emit(BookingLoaded(_cachedBooking!));
        return;
      }

      emit(BookingLoading());

      try {
        final response = await repo.getAllBookings("pending");
        final currentUserId = await LocalStorage.getUserId();

        GetBookingModel? myBooking;

        for (final booking in response.bookings) {
          final isStudent = booking.studentId.id == currentUserId;
          final isSameMentor = booking.instructorId.id == event.mentorId;

          if (isStudent && isSameMentor) {
            myBooking = booking;
            break;
          }
        }

        if (myBooking == null) {
          _cachedBooking = null;
          emit(BookingIdle());
          return;
        }

        final bookingObj = bookingModel.Booking(
          id: myBooking.id,
          studentId: myBooking.studentId.id,
          instructorId: myBooking.instructorId.id,
          date: myBooking.date,
          time: myBooking.time,
          duration_mins: myBooking.durationMins,
          price: myBooking.price,
          bookingCode: myBooking.bookingCode,
          status: myBooking.status,
          rate: myBooking.rate,
          createdAt: myBooking.createdAt,
          updatedAt: myBooking.updatedAt,
          v: myBooking.v,
        );

        _cachedBooking = bookingObj;
        emit(BookingLoaded(bookingObj));
      } catch (e) {
        emit(BookingError(e.toString()));
      }
    });
  }
}