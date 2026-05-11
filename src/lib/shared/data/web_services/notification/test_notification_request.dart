class SendNotificationRequest {
  final String type;
  final Map<String, dynamic> payload;
  final String? receiverId;
  final String? title;
  final String? body;

  SendNotificationRequest({
    required this.type,
    this.payload = const {},
    this.receiverId,
    this.title,
    this.body,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      "type": type,
      "payload": payload,
      "data": payload,
    };
    if (receiverId != null) {
      map["receiverId"] = receiverId;
    }
    if (title != null) {
      map["title"] = title;
    }
    if (body != null) {
      map["body"] = body;
    }
    return map;
  }
}
