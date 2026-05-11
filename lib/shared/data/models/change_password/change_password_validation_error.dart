import 'package:json_annotation/json_annotation.dart';

part 'change_password_validation_error.g.dart';

@JsonSerializable()
class ChangePasswordValidationError {
  final String field;
  final String message;

  ChangePasswordValidationError({required this.field, required this.message});

  factory ChangePasswordValidationError.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordValidationErrorFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordValidationErrorToJson(this);
}
