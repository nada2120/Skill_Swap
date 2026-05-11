part of 'send_code_bloc.dart';

@immutable
sealed class SendCodeState {}

final class SendCodeInitial extends SendCodeState {}

final class SendCodeLoading extends SendCodeState {}

final class SendCodeSuccessState extends SendCodeState {
  final  SendCodeSuccessResponse response;
  SendCodeSuccessState(this.response);
}

final class SendCodeFailureState extends SendCodeState {
final SendCodeErrorResponse error;

SendCodeFailureState(this.error);

}