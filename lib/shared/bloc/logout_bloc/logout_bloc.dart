import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import 'package:skill_swap/shared/helper/local_storage.dart';

import '../../core/services/notification_service.dart';
import '../../data/models/logout/logout_response.dart';
import '../../dependency_injection/injection.dart';
import '../../domain/repositories/auth_repository.dart';
import 'logout_event.dart';
import 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final AuthRepository repository;

  LogoutBloc(this.repository) : super(LogoutInitial()) {
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<LogoutState> emit,
  ) async {
    emit(LogoutLoading());

    final response = await repository.logout();

    if (response is LogoutSuccess) {
      // Clear all tokens and profile
      await LocalStorage.clearAllTokens();
      await LocalStorage.clearUserId();
      await NotificationService.deleteToken();
      sl<MyProfileCubit>().clearProfile();

      emit(LogoutSuccessState(success: response.message));
    } else if (response is LogoutFailure) {
      emit(LogoutFailureState(error: response.message));
    }
  }
}
