import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/send_code/send_code_error_response.dart';
import '../../data/models/send_code/send_code_request.dart';
import '../../data/models/send_code/send_code_response.dart';
import '../../data/models/send_code/send_code_success_response.dart';
import '../../domain/repositories/auth_repository.dart';

part 'send_code_event.dart';
part 'send_code_state.dart';


class SendCodeBloc extends Bloc<SendCodeEvent, SendCodeState> {
  AuthRepository repository;
  SendCodeBloc(this.repository) : super(SendCodeInitial()) {
    on<SendVerificationCode>((event, emit) async{
      emit(SendCodeLoading());

      final result = await repository.sendCode(event.request);

      switch(result) {
        case SendCodeSuccess s:
          emit(SendCodeSuccessState(s.data));
          break;
        case SendCodeFailure f:
          emit(SendCodeFailureState(f.error));
          break;
      }

    });

    on<ResendCode>((event, emit) async {
      emit(SendCodeLoading());

      final request = SendCodeRequest(email: event.email);

      final result = await repository.sendCode(request);

      switch(result) {
        case SendCodeSuccess s:
          emit(SendCodeSuccessState(s.data));
          break;
        case SendCodeFailure f:
          emit(SendCodeFailureState(f.error));
          break;
      }
    });
  }
}
