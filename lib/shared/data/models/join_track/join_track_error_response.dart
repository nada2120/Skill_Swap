class JoinTrackErrorResponse {
  final String message;

  JoinTrackErrorResponse({
    required this.message,
  });

  factory JoinTrackErrorResponse.fromJson(Map<String, dynamic> json) {
    return JoinTrackErrorResponse(
      message: json['message'] ?? '',
    );
  }
}
