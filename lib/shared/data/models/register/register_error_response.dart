import 'package:json_annotation/json_annotation.dart';
import 'register_validation_error.dart';

part 'register_error_response.g.dart';

@JsonSerializable()
class RegisterErrorResponse {
  final String message;
  final List<RegisterValidationError>? validationErrors;

  RegisterErrorResponse({required this.message, this.validationErrors});

  factory RegisterErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterErrorResponseToJson(this);
}
