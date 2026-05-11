class SearchResponse {
  final String message;
  final String userId;
  final List<MessageModel> results;
  final int count;

  SearchResponse({
    required this.message,
    required this.userId,
    required this.results,
    required this.count,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    return SearchResponse(
      message: json['message'],
      userId: json['userId'],
      count: json['count'],
      results: (json['results'] as List)
          .map((e) => MessageModel.fromJson(e))
          .toList(),
    );
  }
}

class MessageModel {
  final String id;
  final String chatId;
  final SenderModel? senderId;
  final String content;
  final String messageType;
  final List<String> readBy;
  final ReplyToModel? replyTo;
  final String? themeId;
  final String? theme;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.messageType,
    required this.readBy,
    required this.replyTo,
    required this.themeId,
    required this.theme,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['_id'],
      chatId: json['chatId'],
      senderId: json['senderId'] != null
          ? SenderModel.fromJson(json['senderId'])
          : null,
      content: json['content'],
      messageType: json['messageType'],
      readBy: List<String>.from(json['readBy'] ?? []),
      replyTo: json['replyTo'] != null
          ? ReplyToModel.fromJson(json['replyTo'])
          : null,
      themeId: json['themeId'],
      theme: json['theme'],
      userId: json['userId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class SenderModel {
  final String id;
  final String name;
  final String role;
  final UserImage userImage;

  SenderModel({
    required this.id,
    required this.name,
    required this.role,
    required this.userImage,
  });

  factory SenderModel.fromJson(Map<String, dynamic> json) {
    return SenderModel(
      id: json['_id'],
      name: json['name'],
      role: json['role'],
      userImage: UserImage.fromJson(json['userImage']),
    );
  }
}

class UserImage {
  final String secureUrl;
  final String? publicId;

  UserImage({
    required this.secureUrl,
    required this.publicId,
  });

  factory UserImage.fromJson(Map<String, dynamic> json) {
    return UserImage(
      secureUrl: json['secure_url'] ?? '',
      publicId: json['public_id'],
    );
  }
}

class ReplyToModel {
  final String id;
  final String content;
  final String messageType;
  final DateTime createdAt;

  ReplyToModel({
    required this.id,
    required this.content,
    required this.messageType,
    required this.createdAt,
  });

  factory ReplyToModel.fromJson(Map<String, dynamic> json) {
    return ReplyToModel(
      id: json['_id'],
      content: json['content'],
      messageType: json['messageType'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
