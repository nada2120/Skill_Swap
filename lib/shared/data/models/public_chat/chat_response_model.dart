import 'get_chat_model.dart';

class ChatResponseModel {
  final String message;
  final List<GetChatModel> chats;

  ChatResponseModel({
    required this.message,
    required this.chats,
  });

  factory ChatResponseModel.fromJson(Map<String, dynamic> json) {
    return ChatResponseModel(
      message: json['message'] ?? '',
      chats:
          (json['chats'] as List).map((e) => GetChatModel.fromJson(e)).toList(),
    );
  }
}
