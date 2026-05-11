part of 'verify_code_bloc.dart';

sealed class VerifyCodeEvent {}

class SubmitVerify extends VerifyCodeEvent {
  final String email;
  final String forgetCode;

  SubmitVerify(this.email, this.forgetCode);
}
