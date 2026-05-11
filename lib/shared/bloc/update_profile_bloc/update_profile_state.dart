part of 'update_profile_bloc.dart';

abstract class UpdateProfileState {}

class UpdateProfileInitial extends UpdateProfileState {}

class UpdateProfileLoading extends UpdateProfileState {}

class UpdateProfileSuccessState extends UpdateProfileState {
  final String success;
  final UpdateUser user;

  UpdateProfileSuccessState(this.success, this.user);
}

class UpdateProfileErrorState extends UpdateProfileState {
  final String error;

  UpdateProfileErrorState(this.error);
}
