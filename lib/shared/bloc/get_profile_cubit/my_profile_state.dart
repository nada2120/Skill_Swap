part of 'my_profile_cubit.dart';

@immutable
sealed class MyProfileState {}

final class MyProfileInitial extends MyProfileState {}

final class MyProfileLoading extends MyProfileState {}

final class MyProfileLoaded extends MyProfileState {
  final MyProfile profile;

  MyProfileLoaded(this.profile);
}

final class MyProfileError extends MyProfileState {
  final String message;

  MyProfileError(this.message);
}
