import 'package:json_annotation/json_annotation.dart';

part 'login_validation_error.g.dart';

@JsonSerializable()
class LoginValidationError {
  final String field;
  final String message;

  LoginValidationError({required this.field, required this.message});

  factory LoginValidationError.fromJson(Map<String, dynamic> json) =>
      _$LoginValidationErrorFromJson(json);

  Map<String, dynamic> toJson() => _$LoginValidationErrorToJson(this);
}
