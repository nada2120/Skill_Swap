import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/register/register_response.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../helper/local_storage.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthRepository repo;

  RegisterBloc(this.repo) : super(RegisterInitial()) {
    on<RegisterSubmit>((event, emit) async {
      emit(RegisterLoading());

      final result = await repo.register(event.request);

      switch (result) {
        case RegisterSuccess s:
          // Save userId from register response for complete-profile flow
          await LocalStorage.saveUserId(s.data.id);
          if (s.data.accessToken != null) {
            await LocalStorage.saveToken(s.data.accessToken!);
          }
          if (s.data.refreshToken != null) {
            await LocalStorage.saveRefreshToken(s.data.refreshToken!);
          }
          emit(RegisterSuccessState(s.data));
          break;

        case RegisterFailure f:
          emit(RegisterFailureState(f.error));
          break;
      }
    });
  }
}
