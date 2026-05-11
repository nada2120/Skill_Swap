import 'package:json_annotation/json_annotation.dart';

part 'pay_booking_request.g.dart';

@JsonSerializable(includeIfNull: false)
class PayBookingRequest {
  final String successUrl;
  final String cancelUrl;
  final String? voucherId;

  PayBookingRequest(
      {required this.successUrl, required this.cancelUrl, this.voucherId});

  Map<String, dynamic> toJson() => _$PayBookingRequestToJson(this);
}
