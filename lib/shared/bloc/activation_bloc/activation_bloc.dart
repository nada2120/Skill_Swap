import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/login/login_request.dart';
import '../../data/models/login/login_response.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../helper/local_storage.dart';
import 'activation_event.dart';
import 'activation_state.dart';

class ActivationBloc extends Bloc<ActivationEvent, ActivationState> {
  final AuthRepository repo;

  ActivationBloc(this.repo) : super(ActivationInitial()) {
    on<VerifyActivation>((event, emit) async {
      emit(ActivationLoading());
      try {
        await repo.verifyActivation(event.code, event.email);

        // If password is provided, auto-login to get tokens
        if (event.password != null) {
          print('🔵 [ActivationBloc] Auto-login after activation...');
          final loginResult = await repo.login(
            LoginRequest(email: event.email, password: event.password!),
          );
          switch (loginResult) {
            case LoginSuccess s:
              await LocalStorage.saveToken(s.data.accessToken);
              await LocalStorage.saveRefreshToken(s.data.refreshToken);
              print('🟢 [ActivationBloc] Auto-login successful, tokens saved');
            case LoginFailure f:
              print(
                  '🔴 [ActivationBloc] Auto-login failed: ${f.error.message}');
          }
        }

        emit(ActivationSuccess("Account verified successfully"));
      } catch (e) {
        emit(ActivationFailure(e.toString()));
      }
    });

    on<ResendActivation>((event, emit) async {
      emit(ActivationLoading());
      try {
        await repo.resendActivation(event.email);
        emit(ActivationSuccess("Activation code resent successfully"));
      } catch (e) {
        emit(ActivationFailure(e.toString()));
      }
    });
  }
}
