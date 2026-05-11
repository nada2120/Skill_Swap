import 'package:json_annotation/json_annotation.dart';

part 'register_success_response.g.dart';

@JsonSerializable()
class RegisterSuccessResponse {
  final String message;
  final bool flag;
  @JsonKey(name: "userId")
  final String id;

  @JsonKey(name: "access_token")
  final String? accessToken;

  @JsonKey(name: "refresh_token")
  final String? refreshToken;

  RegisterSuccessResponse({
    required this.message,
    required this.flag,
    required this.id,
    this.accessToken,
    this.refreshToken,
  });

  factory RegisterSuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterSuccessResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterSuccessResponseToJson(this);
}
