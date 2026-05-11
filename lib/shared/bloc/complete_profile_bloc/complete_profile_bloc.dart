import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/complete_profile/complete_profile_request.dart';
import '../../data/models/complete_profile/complete_profile_response.dart'
    as response;
import '../../domain/repositories/auth_repository.dart';
import '../../helper/local_storage.dart';
import 'complete_profile_event.dart';
import 'complete_profile_state.dart';

class CompleteProfileBloc
    extends Bloc<CompleteProfileEvent, CompleteProfileState> {
  final AuthRepository repo;

  CompleteProfileBloc(this.repo) : super(CompleteProfileInitial()) {
    on<CompleteProfileSubmitted>((event, emit) async {
      emit(CompleteProfileLoading());
      try {
        // Get userId saved from register response
        final userId = await LocalStorage.getUserId();
        if (userId == null || userId.isEmpty) {
          emit(CompleteProfileFailure(
              'User ID not found. Please register again.'));
          return;
        }

        // Validate at least one skill (optional — skills can be empty)

        final request = CompleteProfileRequest(
          userId: userId,
          track: event.track,
          skills: event.skills,
        );

        print('🔵 [completeProfile] Sending: ${request.toJson()}');

        final result = await repo.completeProfile(request);
        switch (result) {
          case response.CompleteProfileSuccess(:final message):
            print('🟢 [completeProfile] Success: $message');
            emit(CompleteProfileSuccess(message));
          case response.CompleteProfileFailure(:final message):
            print('🔴 [completeProfile] Failure: $message');
            emit(CompleteProfileFailure(message));
        }
      } catch (e) {
        print('🔴 [completeProfile] Error: $e');
        emit(CompleteProfileFailure(e.toString()));
      }
    });
  }
}
