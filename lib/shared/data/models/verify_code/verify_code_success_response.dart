import 'package:json_annotation/json_annotation.dart';

part 'verify_code_success_response.g.dart';

@JsonSerializable()
class VerifyCodeSuccessResponse {
  final String message;

  VerifyCodeSuccessResponse({required this.message});

  factory VerifyCodeSuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyCodeSuccessResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyCodeSuccessResponseToJson(this);
}
