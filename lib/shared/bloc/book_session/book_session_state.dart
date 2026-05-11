import '../../data/models/booking/booking_model.dart';

sealed class ActiveBookingState {}

class BookingIdle extends ActiveBookingState {}

class BookingLoading extends ActiveBookingState {}

class BookingLoaded extends ActiveBookingState {
  final Booking booking;

  BookingLoaded(this.booking);
}

class BookingError extends ActiveBookingState {
  final String message;

  BookingError(this.message);
}

class BookingCreatedSuccess extends ActiveBookingState {
  final Booking booking;

  BookingCreatedSuccess(this.booking);
}

class BookingUpdatedSuccess extends ActiveBookingState {}

class BookingCancelledSuccess extends ActiveBookingState {}
