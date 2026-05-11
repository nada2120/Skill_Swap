part of 'change_password_bloc.dart';

@immutable
sealed class ChangePasswordState {}

final class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordLoading extends ChangePasswordState {}

class ChangePasswordSuccessState extends ChangePasswordState {
  final ChangePasswordSuccessResponse success;

  ChangePasswordSuccessState(this.success);
}

class ChangePasswordFailureState extends ChangePasswordState {
  final ChangePasswordErrorResponse error;

  ChangePasswordFailureState(this.error);
}
