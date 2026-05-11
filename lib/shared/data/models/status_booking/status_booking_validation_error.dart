import 'package:json_annotation/json_annotation.dart';

part 'status_booking_validation_error.g.dart';

@JsonSerializable()
class StatusBookingValidationError {
  final String field;
  final String message;

  StatusBookingValidationError({required this.field, required this.message});

  factory StatusBookingValidationError.fromJson(Map<String, dynamic> json) =>
      _$StatusBookingValidationErrorFromJson(json);

  Map<String, dynamic> toJson() => _$StatusBookingValidationErrorToJson(this);
}
