part of 'pay_booking_bloc.dart';

@immutable
abstract class PayBookingState {}

class PayBookingInitial extends PayBookingState {}

class PayBookingLoading extends PayBookingState {}

class PayBookingSuccessState extends PayBookingState {
  final String checkoutUrl;
  final String successUrl;
  final String cancelUrl;

  PayBookingSuccessState({
    required this.checkoutUrl,
    required this.successUrl,
    required this.cancelUrl,
  });
}

class PayBookingFailureState extends PayBookingState {
  final String error;

  PayBookingFailureState({required this.error});
}
