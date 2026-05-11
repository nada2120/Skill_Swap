import 'accepted_bookings_model.dart';

class AcceptedBookingsResponse {
  final String message;
  final List<AcceptedBookingsModel> bookings;

  AcceptedBookingsResponse({
    required this.message,
    required this.bookings,
  });

  factory AcceptedBookingsResponse.fromJson(Map<String, dynamic> json) {
    return AcceptedBookingsResponse(
      message: json['message'] ?? '',
      bookings: (json['bookings'] as List? ?? [])
          .map((e) => AcceptedBookingsModel.fromJson(e))
          .toList(),
    );
  }
}
