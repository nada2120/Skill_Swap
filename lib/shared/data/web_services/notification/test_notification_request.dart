class SendNotificationRequest {
  final String type;
  final Map<String, dynamic> payload;
  final String? receiverId;

  SendNotificationRequest({
    required this.type,
    this.payload = const {},
    this.receiverId,
  });

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      "type": type,
      "payload": payload,
    };
    if (receiverId != null) {
      map["receiverId"] = receiverId;
    }
    return map;
  }
}