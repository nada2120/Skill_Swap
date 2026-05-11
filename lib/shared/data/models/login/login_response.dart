import 'login_error_response.dart';
import 'login_success_response_new.dart';

sealed class LoginResponse {}

class LoginSuccess extends LoginResponse {
  final LoginSuccessResponseNew data;

  LoginSuccess(this.data);
}

class LoginFailure extends LoginResponse {
  final LoginErrorResponse error;

  LoginFailure(this.error);
}
