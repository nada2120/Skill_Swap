sealed class DeleteAccountState {}

class DeleteAccountInitial extends DeleteAccountState {}

class DeleteAccountLoading extends DeleteAccountState {}

class DeleteAccountSuccessState extends DeleteAccountState {}

class DeleteAccountFailureState extends DeleteAccountState {
  final String message;

  DeleteAccountFailureState(this.message);
}
