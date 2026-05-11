import 'package:json_annotation/json_annotation.dart';

part 'booking_validation_error.g.dart';

@JsonSerializable()
class BookingValidationError {
  final String field;
  final String message;

  BookingValidationError({required this.field, required this.message});

  factory BookingValidationError.fromJson(Map<String, dynamic> json) =>
      _$BookingValidationErrorFromJson(json);

  Map<String, dynamic> toJson() => _$BookingValidationErrorToJson(this);
}
