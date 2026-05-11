part of 'get_booking_details_bloc.dart';

@immutable
sealed class GetBookingDetailsEvent {}

class GetBookingDetailsRequested extends GetBookingDetailsEvent {
  final String id;

  GetBookingDetailsRequested({required this.id});
}
