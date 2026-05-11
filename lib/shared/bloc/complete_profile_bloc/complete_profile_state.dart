abstract class CompleteProfileState {}

class CompleteProfileInitial extends CompleteProfileState {}

class CompleteProfileLoading extends CompleteProfileState {}

class CompleteProfileSuccess extends CompleteProfileState {
  final String message;

  CompleteProfileSuccess(this.message);
}

class CompleteProfileFailure extends CompleteProfileState {
  final String error;

  CompleteProfileFailure(this.error);
}
