import '../../data/models/public_chat/chat_response_model.dart';

abstract class PublicChatState {}

class PublicChatInitial extends PublicChatState {}

class PublicChatsLoading extends PublicChatState {}

class PublicChatsLoaded extends PublicChatState {
  final ChatResponseModel chats;

  PublicChatsLoaded(this.chats);
}

class PublicChatsError extends PublicChatState {
  final String message;

  PublicChatsError(this.message);
}
