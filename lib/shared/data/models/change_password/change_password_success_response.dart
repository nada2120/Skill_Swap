part 'change_password_success_response.g.dart';

class ChangePasswordSuccessResponse {
  final String message;

  ChangePasswordSuccessResponse({required this.message});

  factory ChangePasswordSuccessResponse.fromJson(Map<String, dynamic> json) =>
      _$ChangePasswordSuccessResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordSuccessResponseToJson(this);
}
