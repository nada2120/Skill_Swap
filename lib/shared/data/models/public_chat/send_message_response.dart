import 'package:skill_swap/shared/data/models/public_chat/reply_message.dart';

import 'common_sender.dart';

class SendMessageResponse {
  final String message;
  final ChatData data;

  SendMessageResponse({required this.message, required this.data});

  factory SendMessageResponse.fromJson(Map<String, dynamic> json) {
    return SendMessageResponse(
      message: json['message'],
      data: ChatData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'data': data.toJson(),
      };
}

class ChatData {
  final String chatId;
  final Sender senderId;
  final String content;
  final String messageType;
  final List<dynamic> readBy;
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ReplyMessage? replyTo;
  final int v;

  ChatData({
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.messageType,
    required this.readBy,
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    this.replyTo,
    required this.v,
  });

  factory ChatData.fromJson(Map<String, dynamic> json) => ChatData(
        chatId: json['chatId'],
        senderId: Sender.fromJson(json['senderId']),
        content: json['content'],
        messageType: json['messageType'],
        readBy: json['readBy'] ?? [],
        id: json['_id'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
        replyTo: json['replyTo'] != null
            ? ReplyMessage.fromJson(json['replyTo'])
            : null,
        v: json['__v'],
      );

  Map<String, dynamic> toJson() => {
        'chatId': chatId,
        'senderId': senderId.toJson(),
        'content': content,
        'messageType': messageType,
        'readBy': readBy,
        '_id': id,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        if (replyTo != null) 'replyTo': replyTo!.toJson(),
        '__v': v,
      };
}
