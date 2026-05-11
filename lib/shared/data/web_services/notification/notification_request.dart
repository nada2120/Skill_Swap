class NotificationRequest {
  final String fcmToken;

  NotificationRequest({required this.fcmToken});

  Map<String, dynamic> toJson() {
    return {"fcmToken": fcmToken};
  }

  factory NotificationRequest.fromJson(Map<String, dynamic> json) {
    return NotificationRequest(
      fcmToken: json['fcmToken'] ?? '',
    );
  }
}
