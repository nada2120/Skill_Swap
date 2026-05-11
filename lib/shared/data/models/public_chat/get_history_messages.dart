import 'package:skill_swap/shared/data/models/public_chat/message_theme.dart';

import 'common_sender.dart';
import 'reply_message.dart';

class ChatHistoryResponse {
  final String message;
  final String userId;
  final List<ChatMessage> messages;
  final int total;
  final int page;
  final int totalPages;

  ChatHistoryResponse({
    required this.message,
    required this.userId,
    required this.messages,
    required this.total,
    required this.page,
    required this.totalPages,
  });

  factory ChatHistoryResponse.fromJson(Map<String, dynamic> json) =>
      ChatHistoryResponse(
        message: json['message'],
        userId: json['userId'],
        messages: List<ChatMessage>.from(
            json['messages'].map((x) => ChatMessage.fromJson(x))),
        total: json['total'],
        page: json['page'],
        totalPages: json['totalPages'],
      );

  Map<String, dynamic> toJson() =>
      {
        'message': message,
        'userId': userId,
        'messages': List<dynamic>.from(messages.map((x) => x.toJson())),
        'total': total,
        'page': page,
        'totalPages': totalPages,
      };
}

enum MessageStatus { sending, sent, failed }

class ChatMessage {
  final String id;
  final String chatId;
  final Sender senderId;

  final String content;
  final String messageType;
  final List<dynamic> readBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ReplyMessage? replyTo;
  final int v;
  final bool isEdited;
  final bool isSeen;
  final MessageStatus status;
  final String? themeId;
  final MessageTheme? theme;
  final String? timeOnly;

  ChatMessage({required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.messageType,
    required this.readBy,
    required this.createdAt,
    required this.updatedAt,
    this.replyTo,
    this.themeId,
    this.timeOnly,
    required this.v,
    this.isEdited = false,
    this.isSeen = false,
    this.status = MessageStatus.sent,
    this.theme});

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      ChatMessage(
          id: json['_id'],
          chatId: json['chatId'],
          senderId: Sender.fromJson(json['senderId']),
          content: json['content'],
          messageType: json['messageType'],
          readBy: json['readBy'] ?? [],
          themeId: json['themeId'],
          timeOnly: json['timeOnly'],
          createdAt: DateTime.parse(json['createdAt']),
          updatedAt: json['updatedAt'] != null
              ? DateTime.parse(json['updatedAt'])
              : DateTime.now(),
          replyTo: json['replyTo'] != null
              ? ReplyMessage.fromJson(json['replyTo'])
              : null,
          v: json['__v'] ?? 0,
          isEdited: json['isEdited'] ?? false,
          isSeen: json['isSeen'] ?? false,
          theme:
          json['theme'] != null ? MessageTheme.fromJson(json['theme']) : null);

  Map<String, dynamic> toJson() =>
      {
        '_id': id,
        'chatId': chatId,
        'senderId': senderId.toJson(),
        'content': content,
        'messageType': messageType,
        'readBy': readBy,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        if (replyTo != null) 'replyTo': replyTo!.toJson(),
        '__v': v,
        'isEdited': isEdited,
        'isSeen': isSeen,
        'theme': theme,
        'themeId': themeId,
        'timeOnly': timeOnly
      };

  ChatMessage copyWith({String? id,
    String? chatId,
    Sender? senderId,
    String? content,
    String? messageType,
    List<dynamic>? readBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    ReplyMessage? replyTo,
    int? v,
    bool? isEdited,
    bool? isSeen,
    MessageStatus? status,
    MessageTheme? theme}) {
    return ChatMessage(
        id: id ?? this.id,
        chatId: chatId ?? this.chatId,
        senderId: senderId ?? this.senderId,
        content: content ?? this.content,
        messageType: messageType ?? this.messageType,
        readBy: readBy ?? this.readBy,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        replyTo: replyTo ?? this.replyTo,
        v: v ?? this.v,
        isEdited: isEdited ?? this.isEdited,
        isSeen: isSeen ?? this.isSeen,
        status: status ?? this.status,
        theme: theme ?? this.theme);
  }
}