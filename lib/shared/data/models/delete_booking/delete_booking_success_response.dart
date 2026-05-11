import 'package:json_annotation/json_annotation.dart';

part 'delete_booking_success_response.g.dart';

@JsonSerializable()
class DeleteBookingSuccessResponse {
  final String message;

  DeleteBookingSuccessResponse({
    required this.message,
  });

  factory DeleteBookingSuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteBookingSuccessResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteBookingSuccessResponseToJson(this);
}
