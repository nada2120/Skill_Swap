part of 'reset_password_bloc.dart';

@immutable
sealed class ResetPasswordEvent {}

class ConfirmSubmit extends ResetPasswordEvent {
  final ResetPasswordRequest request;

  ConfirmSubmit(this.request);
}