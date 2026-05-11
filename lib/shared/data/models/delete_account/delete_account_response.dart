sealed class DeleteAccountResponse {}

class DeleteAccountSuccess extends DeleteAccountResponse {}

class DeleteAccountFailure extends DeleteAccountResponse {
  final String message;

  DeleteAccountFailure(this.message);
}
