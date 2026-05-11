import 'package:skill_swap/shared/data/models/reset_password/reset_password_error_response.dart';
import 'package:skill_swap/shared/data/models/reset_password/reset_password_success_response.dart';

sealed class ResetPasswordResponse {}

class ResetPasswordSuccess extends ResetPasswordResponse {
  final ResetPasswordSuccessResponse data;

  ResetPasswordSuccess(this.data);
}

class ResetPasswordFailure extends ResetPasswordResponse {
  final ResetPasswordErrorResponse error;

  ResetPasswordFailure(this.error);
}
