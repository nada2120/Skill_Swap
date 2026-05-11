import 'package:bloc/bloc.dart';

import '../../data/models/update_profile/update_profile_request.dart';
import '../../data/models/update_profile/update_profile_response.dart';
import '../../data/models/update_profile/update_user.dart';
import '../../domain/repositories/user_repository.dart';

part 'update_profile_event.dart';

part 'update_profile_state.dart';

class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  final UserRepository repository;

  UpdateProfileBloc(this.repository) : super(UpdateProfileInitial()) {
    on<SubmitUpdateProfile>((event, emit) async {
      emit(UpdateProfileLoading());

      final response = await repository.updateProfile(event.request);

      if (response is UpdateProfileFailure) {
        emit(UpdateProfileErrorState(response.message));
      } else if (response is UpdateProfileData) {
        emit(UpdateProfileSuccessState(
          response.message,
          response.user,
        ));
      }
    });

    on<SubmitUpdateProfileImage>((event, emit) async {
      emit(UpdateProfileLoading());

      final response = await repository.updateProfileImage(event.imagePath);

      if (response is UpdateProfileFailure) {
        emit(UpdateProfileErrorState(response.message));
      } else if (response is UpdateProfileData) {
        emit(UpdateProfileSuccessState(
          response.message,
          response.user,
        ));
      }
    });
  }
}
