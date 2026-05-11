import '../../data/models/register/register_request.dart';

sealed class RegisterEvent {}

class RegisterSubmit extends RegisterEvent {
  final RegisterRequest request;
  RegisterSubmit(this.request);
}
