import 'package:json_annotation/json_annotation.dart';

part 'pay_booking_success_response.g.dart';

@JsonSerializable()
class PayBookingSuccessResponse {
  final String message;
  final String checkoutUrl;
  final String? sessionId;

  PayBookingSuccessResponse({
    required this.message,
    required this.checkoutUrl,
    this.sessionId,
  });

  factory PayBookingSuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$PayBookingSuccessResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PayBookingSuccessResponseToJson(this);
}
