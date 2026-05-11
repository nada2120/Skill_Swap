import 'booking.dart';

class GetBookingsResponse {
  final String message;
  final List<GetBookingModel> bookings;

  GetBookingsResponse({
    required this.message,
    required this.bookings,
  });

  factory GetBookingsResponse.fromJson(Map<String, dynamic> json) {
    return GetBookingsResponse(
      message: json['message'],
      bookings: (json['bookings'] as List)
          .map((e) => GetBookingModel.fromJson(e))
          .toList(),
    );
  }
}
