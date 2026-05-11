import 'package:json_annotation/json_annotation.dart';


part 'verify_code_error_response.g.dart';

@JsonSerializable()
class VerifyCodeErrorResponse {
  final String message;

  VerifyCodeErrorResponse({required this.message});

  factory VerifyCodeErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$VerifyCodeErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$VerifyCodeErrorResponseToJson(this);
}
