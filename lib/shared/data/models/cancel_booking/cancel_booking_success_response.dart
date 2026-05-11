import 'package:json_annotation/json_annotation.dart';

part 'cancel_booking_success_response.g.dart';

@JsonSerializable()
class CancelBookingSuccessResponse {
  final String message;

  // @JsonKey(name: 'booking')
  // final Booking bookSession;

  CancelBookingSuccessResponse({
    required this.message,
    //required this.bookSession,
  });

  factory CancelBookingSuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$CancelBookingSuccessResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CancelBookingSuccessResponseToJson(this);
}
