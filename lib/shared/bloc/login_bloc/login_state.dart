
import '../../data/models/login/login_error_response.dart';
import '../../data/models/login/login_success_response_new.dart';

sealed class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccessState extends LoginState {
  final LoginSuccessResponseNew data;
  LoginSuccessState(this.data);
}

class LoginFailureState extends LoginState {
  final LoginErrorResponse error;
  LoginFailureState(this.error);
}
