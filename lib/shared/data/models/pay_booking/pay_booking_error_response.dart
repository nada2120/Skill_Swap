import 'package:json_annotation/json_annotation.dart';

part 'pay_booking_error_response.g.dart';

@JsonSerializable()
class PayBookingErrorResponse {
  final String message;

  PayBookingErrorResponse({required this.message});

  factory PayBookingErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$PayBookingErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PayBookingErrorResponseToJson(this);
}