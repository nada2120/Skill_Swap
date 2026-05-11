part of 'verify_code_bloc.dart';

sealed class VerifyCodeState {}

final class VerifyCodeInitial extends VerifyCodeState {}


final class VerifyCodeLoading extends VerifyCodeState {}

final class VerifyCodeSuccessState extends VerifyCodeState {
  final  VerifyCodeSuccessResponse response;
  VerifyCodeSuccessState(this.response);
}

final class VerifyCodeFailureState extends VerifyCodeState {
  final VerifyCodeErrorResponse error;

  VerifyCodeFailureState(this.error);

}