import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/models/change_password/change_password_error_response.dart';
import '../../data/models/change_password/change_password_request.dart';
import '../../data/models/change_password/change_password_response.dart';
import '../../data/models/change_password/change_password_success_response.dart';
import '../../domain/repositories/user_repository.dart';

part 'change_password_event.dart';

part 'change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final UserRepository repository;

  ChangePasswordBloc(this.repository) : super(ChangePasswordInitial()) {
    on<ConfirmSubmit>((event, emit) async {
      emit(ChangePasswordLoading());

      final result = await repository.changePassword(event.request);

      switch (result) {
        case ChangePasswordSuccess s:
          emit(ChangePasswordSuccessState(s.success));
          break;
        case ChangePasswordFailure f:
          emit(ChangePasswordFailureState(f.error));
      }
    });
  }
}
