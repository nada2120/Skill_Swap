import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/reset_password/reset_password_error_response.dart';
import '../../data/models/reset_password/reset_password_request.dart';
import '../../data/models/reset_password/reset_password_response.dart';
import '../../data/models/reset_password/reset_password_success_response.dart';
import '../../domain/repositories/auth_repository.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  final AuthRepository repository;
  ResetPasswordBloc(this.repository) : super(ResetPasswordInitial()) {
    on<ConfirmSubmit>((event, emit) async{
      emit(ResetPasswordLoading());

      final result = await repository.resetPassword(event.request);

      switch(result){
        case ResetPasswordSuccess s:
          emit(ResetPasswordSuccessState(s.data));
          break;
        case ResetPasswordFailure f:
          emit(ResetPasswordFailureState(f.error));
      }
    });
  }
}
