import '../booking/booking_model.dart';

class BookingDetailsSuccessResponse {
  final String message;
  final Booking booking;

  BookingDetailsSuccessResponse({
    required this.message,
    required this.booking,
  });

  factory BookingDetailsSuccessResponse.fromJson(Map<String, dynamic> json) {
    return BookingDetailsSuccessResponse(
      message: json['message'] ?? '',
      booking: Booking.fromJson(json['booking'] as Map<String, dynamic>),
    );
  }
}
