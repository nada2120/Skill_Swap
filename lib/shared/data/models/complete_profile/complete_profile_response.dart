sealed class CompleteProfileResponse {}

class CompleteProfileSuccess extends CompleteProfileResponse {
  final String message;

  CompleteProfileSuccess(this.message);
}

class CompleteProfileFailure extends CompleteProfileResponse {
  final String message;

  CompleteProfileFailure(this.message);
}
