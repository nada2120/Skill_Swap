abstract class ActivationState {}

class ActivationInitial extends ActivationState {}

class ActivationLoading extends ActivationState {}

class ActivationSuccess extends ActivationState {
  final String message;

  ActivationSuccess(this.message);
}

class ActivationFailure extends ActivationState {
  final String error;

  ActivationFailure(this.error);
}
