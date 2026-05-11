import 'change_password_error_response.dart';
import 'change_password_success_response.dart';

sealed class ChangePasswordResponse {}

class ChangePasswordSuccess extends ChangePasswordResponse {
  final ChangePasswordSuccessResponse success;

  ChangePasswordSuccess(this.success);
}

class ChangePasswordFailure extends ChangePasswordResponse {
  final ChangePasswordErrorResponse error;

  ChangePasswordFailure(this.error);
}
