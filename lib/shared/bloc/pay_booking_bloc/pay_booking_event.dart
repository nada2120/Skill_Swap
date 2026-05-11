part of 'pay_booking_bloc.dart';

@immutable
sealed class PayBookingEvent {}

class PayBookingRequested extends PayBookingEvent {
  final String bookingId;
  final String? voucherId;

  PayBookingRequested({required this.bookingId, this.voucherId});
}
