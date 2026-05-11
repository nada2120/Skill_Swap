import 'package:json_annotation/json_annotation.dart';
import 'login_validation_error.dart';

part 'login_error_response.g.dart';

@JsonSerializable()
class LoginErrorResponse {
  final String message;
  final List<LoginValidationError>? validationErrors;

  LoginErrorResponse({required this.message, this.validationErrors});

  factory LoginErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginErrorResponseToJson(this);
}
