import 'package:json_annotation/json_annotation.dart';

part 'reset_password_validation_error.g.dart';

@JsonSerializable()
class ResetPasswordValidationError {
  final String field;
  final String message;

  ResetPasswordValidationError({required this.field, required this.message});

  factory ResetPasswordValidationError.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordValidationErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordValidationErrorToJson(this);
}
