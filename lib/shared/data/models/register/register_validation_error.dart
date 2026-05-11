import 'package:json_annotation/json_annotation.dart';

part 'register_validation_error.g.dart';

@JsonSerializable()
class RegisterValidationError {
  final String field;
  final String message;

  RegisterValidationError({required this.field, required this.message});

  factory RegisterValidationError.fromJson(Map<String, dynamic> json) =>
      _$RegisterValidationErrorFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterValidationErrorToJson(this);
}
