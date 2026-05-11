import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shared/domain/repositories/booking_repository.dart';
import 'join_session_event.dart';
import 'join_session_state.dart';

class JoinSessionBloc extends Bloc<JoinSessionEvent, JoinSessionState> {
  final BookingRepository repository;

  JoinSessionBloc(this.repository) : super(JoinSessionInitial()) {
    on<JoinSessionRequested>(_onJoinSessionRequested);
  }

  Future<void> _onJoinSessionRequested(
      JoinSessionRequested event, Emitter<JoinSessionState> emit) async {
    emit(JoinSessionLoading());
    try {
      final response = await repository.joinSession(event.sessionId);
      emit(JoinSessionSuccess(response));
    } catch (e) {
      emit(JoinSessionFailure(e.toString()));
    }
  }
}
