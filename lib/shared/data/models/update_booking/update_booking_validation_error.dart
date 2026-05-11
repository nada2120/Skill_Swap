import 'package:json_annotation/json_annotation.dart';

part 'update_booking_validation_error.g.dart';

@JsonSerializable()
class UpdateBookingValidationError {
  final String field;
  final String message;

  UpdateBookingValidationError({required this.field, required this.message});

  factory UpdateBookingValidationError.fromJson(Map<String, dynamic> json) =>
      _$UpdateBookingValidationErrorFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateBookingValidationErrorToJson(this);
}
