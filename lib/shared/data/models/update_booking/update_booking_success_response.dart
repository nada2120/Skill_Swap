import 'package:json_annotation/json_annotation.dart';

import 'booking_model.dart';

part 'update_booking_success_response.g.dart';

@JsonSerializable()
class UpdateBookingSuccessResponse {
  final String message;

  @JsonKey(name: 'booking')
  final Booking bookSession;

  UpdateBookingSuccessResponse({
    required this.message,
    required this.bookSession,
  });

  factory UpdateBookingSuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$UpdateBookingSuccessResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateBookingSuccessResponseToJson(this);
}
