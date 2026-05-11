import '../../data/models/login/login_request.dart';

sealed class LoginEvent {}

class LoginSubmit extends LoginEvent {
  final LoginRequest request;
  LoginSubmit(this.request);
}
