class ReplyMessage {
  final String id;
  final String content;
  final String type;
  final String senderName;
  final DateTime createdAt;

  ReplyMessage({
    required this.id,
    required this.content,
    required this.type,
    required this.senderName,
    required this.createdAt,
  });

  factory ReplyMessage.fromJson(Map<String, dynamic> json) {
    String name = 'Unknown';
    if (json['senderId'] is Map) {
      name = json['senderId']['name'] ?? 'Unknown';
    }

    return ReplyMessage(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      type: json['type']?.toString() ?? 'text',
      senderName: name,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        '_id': id,
        'content': content,
        'type': type,
        'senderId': {'name': senderName},
        'createdAt': createdAt.toIso8601String(),
      };
}
