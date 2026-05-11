class PrivateChatModel {
  final String id;
  final String partnerId;
  final String partnerName;
  final String? partnerImage;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;

  PrivateChatModel({
    required this.id,
    required this.partnerId,
    required this.partnerName,
    this.partnerImage,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
  });

  factory PrivateChatModel.fromJson(
      Map<String, dynamic> json, String currentUserId) {
    // Determine which participant is the partner
    final participants = json['participants'] as List<dynamic>? ?? [];
    Map<String, dynamic>? partner;
    for (final p in participants) {
      final pMap = p is Map<String, dynamic> ? p : <String, dynamic>{};
      final pId = pMap['_id']?.toString() ?? pMap['id']?.toString() ?? '';
      if (pId != currentUserId) {
        partner = pMap;
        break;
      }
    }

    final lastMsg = json['lastMessage'];
    String? lastMessageText;
    DateTime? lastMessageTime;
    if (lastMsg is Map<String, dynamic>) {
      lastMessageText = lastMsg['content']?.toString();
      final ts =
          lastMsg['createdAt']?.toString() ?? lastMsg['timestamp']?.toString();
      if (ts != null) {
        lastMessageTime = DateTime.tryParse(ts);
      }
    }

    return PrivateChatModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      partnerId:
          partner?['_id']?.toString() ?? partner?['id']?.toString() ?? '',
      partnerName: partner?['name']?.toString() ?? 'Unknown',
      partnerImage: partner?['userImage']?.toString(),
      lastMessage: lastMessageText,
      lastMessageTime: lastMessageTime,
      unreadCount: json['unreadCount'] is int ? json['unreadCount'] : 0,
    );
  }

  PrivateChatModel copyWith({
    String? lastMessage,
    DateTime? lastMessageTime,
    int? unreadCount,
  }) {
    return PrivateChatModel(
      id: id,
      partnerId: partnerId,
      partnerName: partnerName,
      partnerImage: partnerImage,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class ChatMessageModel {
  final String id;
  final String chatId;
  final String senderId;
  final String? senderName;
  final String content;
  final String type;
  final DateTime createdAt;
  final bool isPending; // for optimistic UI

  ChatMessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    this.senderName,
    required this.content,
    this.type = 'text',
    required this.createdAt,
    this.isPending = false,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    String senderId = '';
    String? senderName;

    if (json['sender'] is Map) {
      senderId = json['sender']['_id']?.toString() ??
          json['sender']['id']?.toString() ??
          '';

      senderName = json['sender']['name'];
    } else if (json['sender'] is String) {
      senderId = json['sender'];
    } else if (json['senderId'] != null) {
      senderId = json['senderId'].toString();
    }

    return ChatMessageModel(
      id: json['_id']?.toString() ?? json['id']?.toString() ?? '',
      chatId: json['chat']?.toString() ?? json['chatId']?.toString() ?? '',
      senderId: senderId,
      senderName: senderName,
      content: json['content']?.toString() ?? '',
      type: json['type']?.toString() ?? 'text',
      createdAt: DateTime.tryParse(
            json['createdAt']?.toString() ??
                json['timestamp']?.toString() ??
                '',
          ) ??
          DateTime.now(),
    );
  }

  ChatMessageModel copyWith({bool? isPending, String? id}) {
    return ChatMessageModel(
      id: id ?? this.id,
      chatId: chatId,
      senderId: senderId,
      senderName: senderName,
      content: content,
      type: type,
      createdAt: createdAt,
      isPending: isPending ?? this.isPending,
    );
  }
}
