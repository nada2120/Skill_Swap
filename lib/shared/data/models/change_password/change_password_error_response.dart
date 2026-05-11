import 'package:json_annotation/json_annotation.dart';

import 'change_password_validation_error.dart';

part 'change_password_error_response.g.dart';

@JsonSerializable()
class ChangePasswordErrorResponse {
  final String message;
  final List<ChangePasswordValidationError>? validationErrors;

  ChangePasswordErrorResponse({required this.message, this.validationErrors});

  factory ChangePasswordErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordErrorResponseToJson(this);
}
