import 'package:json_annotation/json_annotation.dart';

part 'reset_password_success_response.g.dart';

@JsonSerializable()
class ResetPasswordSuccessResponse {
  final String message;

  ResetPasswordSuccessResponse({required this.message});

  factory ResetPasswordSuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordSuccessResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordSuccessResponseToJson(this);
}
