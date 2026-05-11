sealed class LogoutResponse {
  final String message;

  const LogoutResponse(this.message);

  factory LogoutResponse.fromJson(Map<String, dynamic> json) {
    return LogoutData(
      message: json['message'] ?? '',
    );
  }
}

class LogoutData extends LogoutResponse {
  const LogoutData({required String message}) : super(message);
}

class LogoutSuccess extends LogoutResponse {
  const LogoutSuccess({required String success}) : super(success);
}

class LogoutFailure extends LogoutResponse {
  const LogoutFailure({required String error}) : super(error);
}
