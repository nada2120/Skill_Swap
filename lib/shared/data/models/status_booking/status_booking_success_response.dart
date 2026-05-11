import 'package:json_annotation/json_annotation.dart';

part 'status_booking_success_response.g.dart';

@JsonSerializable()
class StatusBookingSuccessResponse {
  final String message;

  // @JsonKey(name: 'booking') // ← أهم سطر
  // final Booking bookSession;

  StatusBookingSuccessResponse({
    required this.message,
    //required this.bookSession,
  });

  factory StatusBookingSuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$StatusBookingSuccessResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StatusBookingSuccessResponseToJson(this);
}
