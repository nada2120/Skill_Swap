import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../constants/not_type.dart';
import '../../data/models/cancel_booking/cancel_booking_response.dart';
import '../../dependency_injection/injection.dart';
import '../../domain/repositories/booking_repository.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../helper/local_storage.dart';

part 'cancel_book_event.dart';
part 'cancel_book_state.dart';

class CancelBookBloc extends Bloc<CancelBookEvent, CancelBookState> {
  final BookingRepository repo;

  CancelBookBloc(this.repo) : super(CancelBookInitial()) {
    on<CancelBookSession>((event, emit) async {
      emit(CancelBookLoading());

      final response = await repo.cancelBookSession(event.id);

      switch (response) {
        case CancelBookingSuccess s:
          emit(CancelBookSuccess(success: s));

          // 🔔 Notify the other party about cancellation
          if (event.recipientId != null) {
            final currentUserId = await LocalStorage.getUserId();
            if (event.recipientId != currentUserId) {
              await sl<NotificationRepository>().sendNotification(
                receiverId: event.recipientId!,
                type: NotificationTypes.bookingCancelled,
                payload: {
                  'bookingId': event.id,
                },
              );
            }
          }
          break;
        case CancelBookingFailure f:
          emit(CancelBookFailure(error: f));
          break;
      }
    });
  }
}
