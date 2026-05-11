abstract class ActivationEvent {}

class VerifyActivation extends ActivationEvent {
  final String code;
  final String email;
  final String? password; // Optional: if provided, auto-login after activation
  VerifyActivation({required this.code, required this.email, this.password});
}

class ResendActivation extends ActivationEvent {
  final String email;

  ResendActivation(this.email);
}
