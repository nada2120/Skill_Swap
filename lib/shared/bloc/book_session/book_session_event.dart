import '../../data/models/booking/booking_request.dart';
import '../../data/models/update_booking/update_booking_request.dart';

sealed class ActiveBookingEvent {}

class CreateBooking extends ActiveBookingEvent {
  final BookingRequest request;

  CreateBooking(this.request);
}

class UpdateBooking extends ActiveBookingEvent {
  final String id;
  final UpdateBookingRequest request;

  UpdateBooking(this.id, this.request);
}

class CancelBooking extends ActiveBookingEvent {
  final String id;

  CancelBooking(this.id);
}

class LoadBookingDetails extends ActiveBookingEvent {
  final String id;

  LoadBookingDetails(this.id);
}

class LoadMyBookingWithMentor extends ActiveBookingEvent {
  final String mentorId;

  LoadMyBookingWithMentor(this.mentorId);
}
