/// =============================
/// call_state.dart
/// =============================

abstract class CallState {
  const CallState();
}

class CallInitial extends CallState {
  const CallInitial();
}

class CallLoading extends CallState {
  const CallLoading();
}

class CallSuccess extends CallState {
  final String message;

  const CallSuccess(this.message);
}

class CallError extends CallState {
  final String error;

  const CallError(this.error);
}
