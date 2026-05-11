import '../../data/models/public_chat/get_chat_model.dart';

abstract class PrivateChatsState {}

class PrivateChatsInitial extends PrivateChatsState {}

class PrivateChatsLoading extends PrivateChatsState {}

class PrivateChatsLoaded extends PrivateChatsState {
  final List<GetChatModel> chats;

  PrivateChatsLoaded(this.chats);
}

class PrivateChatsError extends PrivateChatsState {
  final String message;

  PrivateChatsError(this.message);
}
