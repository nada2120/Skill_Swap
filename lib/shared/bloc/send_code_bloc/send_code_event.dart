part of 'send_code_bloc.dart';

@immutable
sealed class SendCodeEvent {}
class SendVerificationCode extends SendCodeEvent {
  final SendCodeRequest request;

  SendVerificationCode(this.request);
}

class ResendCode extends SendCodeEvent{
  final String email;
  ResendCode(this.email);
}