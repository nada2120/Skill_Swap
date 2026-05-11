import 'package:json_annotation/json_annotation.dart';
part 'reset_password_request.g.dart';

@JsonSerializable()
class ResetPasswordRequest {
  final String email;
  final String forgetCode;
  final String password;
  final String confirmPassword;

  ResetPasswordRequest({
    required this.email,
    required this.forgetCode,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => _$ResetPasswordRequestToJson(this);
}
