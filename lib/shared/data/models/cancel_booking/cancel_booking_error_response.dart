import 'package:json_annotation/json_annotation.dart';

part 'cancel_booking_error_response.g.dart';

@JsonSerializable()
class CancelBookingErrorResponse {
  final String message;

  CancelBookingErrorResponse({required this.message});

  factory CancelBookingErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$CancelBookingErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CancelBookingErrorResponseToJson(this);
}
