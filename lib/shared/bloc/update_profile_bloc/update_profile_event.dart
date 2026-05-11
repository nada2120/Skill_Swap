part of 'update_profile_bloc.dart';

abstract class UpdateProfileEvent {}

class SubmitUpdateProfile extends UpdateProfileEvent {
  final UpdateProfileRequest request;

  SubmitUpdateProfile(this.request);
}

class SubmitUpdateProfileImage extends UpdateProfileEvent {
  final String imagePath;

  SubmitUpdateProfileImage(this.imagePath);
}
