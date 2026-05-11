import 'package:json_annotation/json_annotation.dart';
import 'package:skill_swap/shared/data/models/reset_password/reset_password_validation_error.dart';
part 'reset_password_error_response.g.dart';

@JsonSerializable()
class ResetPasswordErrorResponse {
  final String message;
  final List<ResetPasswordValidationError>? validationErrors;

  ResetPasswordErrorResponse({required this.message, this.validationErrors});

  factory ResetPasswordErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordErrorResponseToJson(this);
}
