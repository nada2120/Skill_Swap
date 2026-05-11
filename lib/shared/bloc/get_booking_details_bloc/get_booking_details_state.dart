part of 'get_booking_details_bloc.dart';

@immutable
sealed class GetBookingDetailsState {}

final class GetBookingDetailsInitial extends GetBookingDetailsState {}

final class GetBookingDetailsLoading extends GetBookingDetailsState {}

final class GetBookingDetailsSuccess extends GetBookingDetailsState {
  final BookingDetailsSuccess success;

  GetBookingDetailsSuccess({required this.success});
}

final class GetBookingDetailsError extends GetBookingDetailsState {
  final BookingDetailsFailure error;

  GetBookingDetailsError({required this.error});
}
