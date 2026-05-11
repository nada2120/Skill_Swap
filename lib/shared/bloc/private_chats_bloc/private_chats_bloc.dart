import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:skill_swap/shared/bloc/private_chats_bloc/private_chats_event.dart';
import 'package:skill_swap/shared/bloc/private_chats_bloc/private_chats_state.dart';

import '../../core/network/pusher_service.dart';
import '../../data/models/public_chat/get_chat_model.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../helper/local_storage.dart';

class PrivateChatsBloc extends Bloc<PrivateChatEvent, PrivateChatsState> {
  final ChatRepository repository;
  final PusherService pusherService;

  List<GetChatModel> cache = [];

  final Map<String, int> unreadMap = {};

  /// The chat the user is currently viewing (null = on the list screen).
  String? _activeChatId;

  StreamSubscription<Map<String, dynamic>>? _pusherSubscription;

  /// Track which chat channels we subscribed to, so we can clean up.
  final Set<String> _subscribedChatIds = {};

  /// Call this when the user opens a chat to clear its unread badge immediately.
  void clearUnread(String chatId) {
    _activeChatId = chatId;
    add(ClearUnreadEvent(chatId));
  }

  /// Call this when the user leaves a chat screen.
  void clearActiveChat() {
    _activeChatId = null;
  }

  PrivateChatsBloc(this.repository, this.pusherService)
      : super(PrivateChatsInitial()) {
    on<GetPrivateChatsEvent>(_getPrivateChats);
    on<ClearUnreadEvent>((event, emit) {
      if (unreadMap[event.chatId] != null && unreadMap[event.chatId]! > 0) {
        unreadMap[event.chatId] = 0;
        emit(PrivateChatsLoaded(cache));
      }
    });
    on<ChatListUpdateEvent>((event, emit) {
      _handleChatListUpdate(event.data, emit);
    });
    on<NewMessageReceivedEvent>((event, emit) async {
      await _handleNewMessageReceived(event.data, emit);
    });

    // Listen to Pusher's broadcast stream for real-time updates
    _pusherSubscription = pusherService.messageStream.listen(_onPusherEvent);
  }

  /// Handle incoming Pusher events on all subscribed channels.
  void _onPusherEvent(Map<String, dynamic> data) {
    if (isClosed) return;

    final eventType = data['_eventType'] ?? 'receive_message';

    if (eventType == 'receive_message') {
      add(NewMessageReceivedEvent(data));
    }
  }

  /// Subscribe to Pusher channels for all cached chats so we get real-time
  /// receive_message events even while on the chat list screen.
  Future<void> _subscribeToAllChatChannels() async {
    for (final chat in cache) {
      if (!_subscribedChatIds.contains(chat.id)) {
        await pusherService.subscribeToChat(chatId: chat.id);
        _subscribedChatIds.add(chat.id);
      }
    }
  }

  Future<void> _handleNewMessageReceived(
    Map<String, dynamic> data,
    Emitter<PrivateChatsState> emit,
  ) async {
    final currentUserId = await LocalStorage.getUserId() ?? '';
    final messageData =
        data['message'] is Map<String, dynamic> ? data['message'] : data;

    final chatId = messageData['chatId']?.toString() ?? '';
    final senderId = messageData['senderId']?.toString() ?? '';

    // Ignore own messages
    if (senderId == currentUserId) return;

    // If the user is currently inside this chat, don't increment unread
    if (_activeChatId == chatId) return;

    // Only count for chats that are in our cached list
    final chatExists = cache.any((c) => c.id == chatId);
    if (!chatExists) {
      // It might be a new chat we haven't fetched yet — do a full refresh
      add(GetPrivateChatsEvent());
      return;
    }

    // Increment unread count
    unreadMap[chatId] = (unreadMap[chatId] ?? 0) + 1;

    // Also update the last message preview in the cache
    final messageContent = messageData['message']?.toString() ??
        messageData['content']?.toString();
    if (messageContent != null) {
      final chatIndex = cache.indexWhere((c) => c.id == chatId);
      if (chatIndex != -1) {
        final chat = cache[chatIndex];
        // Update the lastMessage with the new message content
        if (chat.lastMessage != null) {
          cache[chatIndex] = chat.copyWith(
            lastMessage: chat.lastMessage!.copyWith(
              content: messageContent,
              createdAt: DateTime.now().toIso8601String(),
            ),
          );
        }
      }
    }

    emit(PrivateChatsLoaded(cache));
  }

  void _handleChatListUpdate(
      Map<String, dynamic> data, Emitter<PrivateChatsState> emit) {
    final chatId = data['chatId']?.toString();
    final senderId = data['senderId']?.toString();
    final currentUserId = data['currentUserId']?.toString();

    if (chatId == null || senderId == null) return;

    if (senderId == currentUserId) return;

    // If the user is currently inside this chat, don't increment unread
    if (_activeChatId == chatId) return;

    unreadMap[chatId] = (unreadMap[chatId] ?? 0) + 1;

    emit(PrivateChatsLoaded(cache));
  }

  Future<void> _getPrivateChats(
    GetPrivateChatsEvent event,
    Emitter<PrivateChatsState> emit,
  ) async {
    try {
      emit(PrivateChatsLoading());

      final currentUserId = await LocalStorage.getUserId() ?? '';
      final chats = await repository.getPrivateChats();

      cache = chats;

      unreadMap.clear();

      for (final chat in chats) {
        final history = await repository.getMessages(
          chat.id,
          page: 1,
          limit: 100,
        );

        final unreadCount = history.messages.where((msg) {
          final senderId = msg.senderId.id;

          if (senderId == currentUserId) return false;

          // readBy items can be plain strings OR populated Map objects,
          // so we extract the id from each element for a reliable comparison.
          final readByIds = msg.readBy.map((e) {
            if (e is Map) {
              return (e['_id'] ?? e['id'] ?? e).toString();
            }
            return e.toString();
          }).toList();

          return !readByIds.contains(currentUserId);
        }).length;

        unreadMap[chat.id] = unreadCount;
      }

      emit(PrivateChatsLoaded(chats));

      // Subscribe to all chat channels AFTER emitting,
      // so we start receiving real-time events for every chat.
      await _subscribeToAllChatChannels();
    } catch (e) {
      emit(PrivateChatsError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _pusherSubscription?.cancel();
    // Note: we don't unsubscribe from chat channels here because
    // PusherService is a singleton — other cubits may still need them.
    return super.close();
  }
}
