import 'package:json_annotation/json_annotation.dart';


part 'send_code_error_response.g.dart';

@JsonSerializable()
class SendCodeErrorResponse {
  final String message;

  SendCodeErrorResponse({required this.message});

  factory SendCodeErrorResponse.fromJson(Map<String, dynamic> json) =>
      _$SendCodeErrorResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SendCodeErrorResponseToJson(this);
}
