import 'package:json_annotation/json_annotation.dart';

part 'login_success_response_new.g.dart';

@JsonSerializable()
class LoginSuccessResponseNew {
  final String message;
  final bool flag;

  @JsonKey(name: "access_token")
  final String accessToken;

  @JsonKey(name: "refresh_token")
  final String refreshToken;

  final String id;
  final String role;

  LoginSuccessResponseNew(
      {required this.message,
      required this.flag,
      required this.accessToken,
      required this.refreshToken,
      required this.id,
      required this.role});

  factory LoginSuccessResponseNew.fromJson(Map<String, dynamic> json) =>
      _$LoginSuccessResponseNewFromJson(json);

  Map<String, dynamic> toJson() => _$LoginSuccessResponseNewToJson(this);
}
