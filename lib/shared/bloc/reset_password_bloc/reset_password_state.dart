part of 'reset_password_bloc.dart';

@immutable
sealed class ResetPasswordState {}

final class ResetPasswordInitial extends ResetPasswordState {}

class ResetPasswordLoading extends ResetPasswordState {}

class ResetPasswordSuccessState extends ResetPasswordState {
  final ResetPasswordSuccessResponse data;

  ResetPasswordSuccessState(this.data);
}

class ResetPasswordFailureState extends ResetPasswordState {
  final ResetPasswordErrorResponse error;

  ResetPasswordFailureState(this.error);
}