import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/pay_booking/pay_booking_request.dart';
import '../../data/models/pay_booking/pay_booking_response.dart';
import '../../domain/repositories/booking_repository.dart';

part 'pay_booking_event.dart';
part 'pay_booking_state.dart';

class PayBookingBloc extends Bloc<PayBookingEvent, PayBookingState> {
  final BookingRepository repo;

  PayBookingBloc(this.repo) : super(PayBookingInitial()) {
    on<PayBookingRequested>((event, emit) async {
      emit(PayBookingLoading());

      try {
        final request = PayBookingRequest(
            successUrl:
                'skillswap://payment/success?bookingId=${event.bookingId}',
            cancelUrl:
                'skillswap://payment/cancel?bookingId=${event.bookingId}',
            voucherId: event.voucherId);

        final response = await repo.payBooking(event.bookingId, request);

        switch (response) {
          case PayBookingSuccess s:
            emit(PayBookingSuccessState(
              checkoutUrl: s.data.checkoutUrl,
              successUrl: request.successUrl,
              cancelUrl: request.cancelUrl,
            ));
            break;
          case PayBookingFailure f:
            emit(PayBookingFailureState(error: f.error.message));
            break;
        }
      } catch (e) {
        emit(PayBookingFailureState(error: e.toString()));
      }
    });
  }
}
