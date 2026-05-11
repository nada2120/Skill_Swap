import 'package:equatable/equatable.dart';

import '../../data/models/public_chat/get_history_messages.dart';

abstract class PublicChatMessagesState extends Equatable {
  const PublicChatMessagesState();

  @override
  List<Object?> get props => [];
}

class PublicChatMessagesInitial extends PublicChatMessagesState {}

class PublicChatMessagesLoading extends PublicChatMessagesState {}

class PublicChatMessagesLoaded extends PublicChatMessagesState {
  final List<ChatMessage> messages;
  final bool hasMore;
  final bool isLoadingMore;
  final ChatMessage? replyMessage;
  final ChatMessage? editingMessage;

  const PublicChatMessagesLoaded({
    required this.messages,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.replyMessage,
    this.editingMessage,
  });

  @override
  List<Object?> get props =>
      [messages, hasMore, isLoadingMore, replyMessage, editingMessage];

  PublicChatMessagesLoaded copyWith({
    List<ChatMessage>? messages,
    bool? hasMore,
    bool? isLoadingMore,
    ChatMessage? replyMessage,
    bool clearReply = false,
    ChatMessage? editingMessage,
    bool clearEditing = false,
  }) {
    return PublicChatMessagesLoaded(
      messages: messages ?? List.from(this.messages),
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      replyMessage: clearReply ? null : (replyMessage ?? this.replyMessage),
      editingMessage:
          clearEditing ? null : (editingMessage ?? this.editingMessage),
    );
  }
}

class PublicChatMessagesError extends PublicChatMessagesState {
  final String message;

  const PublicChatMessagesError({required this.message});

  @override
  List<Object?> get props => [message];
}
