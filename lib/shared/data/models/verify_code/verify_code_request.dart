import 'package:json_annotation/json_annotation.dart';
part 'verify_code_request.g.dart';

@JsonSerializable()
class VerifyCodeRequest {
  final String email;
  final String forgetCode;


  VerifyCodeRequest({required this.email, required this.forgetCode});

  Map<String, dynamic> toJson() => _$VerifyCodeRequestToJson(this);
}
