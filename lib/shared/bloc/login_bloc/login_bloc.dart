import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/login/login_response.dart';
import '../../dependency_injection/injection.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../helper/local_storage.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository repo;

  LoginBloc(this.repo) : super(LoginInitial()) {
    on<LoginSubmit>((event, emit) async {
      emit(LoginLoading());

      final result = await repo.login(event.request);

      switch (result) {
        case LoginSuccess s:
          await LocalStorage.saveToken(s.data.accessToken);
          await LocalStorage.saveRefreshToken(s.data.refreshToken);
          await LocalStorage.saveUserId(s.data.id);

          final fcmToken = await FirebaseMessaging.instance.getToken();

          if (fcmToken != null) {
            await sl<NotificationRepository>().saveFcmToken(fcmToken);
          }

          emit(LoginSuccessState(s.data));
          break;

        case LoginFailure f:
          emit(LoginFailureState(f.error));
          break;
      }
    });
  }
}
