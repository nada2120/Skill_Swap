import 'package:json_annotation/json_annotation.dart';

import 'booking_model.dart';

part 'booking_success_response.g.dart';

@JsonSerializable()
class BookingSuccessResponse {
  final String message;

  @JsonKey(name: 'booking')
  final Booking bookSession;

  BookingSuccessResponse({
    required this.message,
    required this.bookSession,
  });

  factory BookingSuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$BookingSuccessResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BookingSuccessResponseToJson(this);
}
