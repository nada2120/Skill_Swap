import 'package:json_annotation/json_annotation.dart';

part 'delete_booking_error_response.g.dart';

@JsonSerializable()
class DeleteBookingErrorResponse {
  final String message;

  DeleteBookingErrorResponse({required this.message});

  factory DeleteBookingErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteBookingErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteBookingErrorResponseToJson(this);
}
