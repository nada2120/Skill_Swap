import 'package:json_annotation/json_annotation.dart';

part 'booking_details_error_response.g.dart';

@JsonSerializable()
class BookingDetailsErrorResponse {
  final String message;

  BookingDetailsErrorResponse({required this.message});

  factory BookingDetailsErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$BookingDetailsErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BookingDetailsErrorResponseToJson(this);
}
