abstract class PrivateChatEvent {}

class GetPrivateChatsEvent extends PrivateChatEvent {}

class ChatListUpdateEvent extends PrivateChatEvent {
  final Map<String, dynamic> data;

  ChatListUpdateEvent(this.data);
}

/// Fired when a new message arrives via Pusher in real-time.
class NewMessageReceivedEvent extends PrivateChatEvent {
  final Map<String, dynamic> data;

  NewMessageReceivedEvent(this.data);
}

/// Fired when the user opens a chat to clear its unread badge.
class ClearUnreadEvent extends PrivateChatEvent {
  final String chatId;

  ClearUnreadEvent(this.chatId);
}
