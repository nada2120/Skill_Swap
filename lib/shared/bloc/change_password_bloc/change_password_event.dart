part of 'change_password_bloc.dart';

@immutable
sealed class ChangePasswordEvent {}

class ConfirmSubmit extends ChangePasswordEvent {
  final ChangePasswordRequest request;

  ConfirmSubmit(this.request);
}
