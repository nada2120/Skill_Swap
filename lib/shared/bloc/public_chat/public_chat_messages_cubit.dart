import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../../../shared/core/network/pusher_service.dart';
import '../../constants/not_type.dart';
import '../../data/models/public_chat/common_sender.dart';
import '../../data/models/public_chat/get_history_messages.dart';
import '../../data/models/public_chat/message_theme.dart';
import '../../data/models/public_chat/reply_message.dart';
import '../../dependency_injection/injection.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../helper/local_storage.dart';
import '../private_chats_bloc/private_chats_bloc.dart';
import '../private_chats_bloc/private_chats_event.dart';
import 'public_chat_messages_state.dart';

class PublicChatMessagesCubit extends Cubit<PublicChatMessagesState> {
  final ChatRepository chatRepository;
  final PusherService pusherService;
  final PrivateChatsBloc privateChatsBloc;
  StreamSubscription? _connectivitySub;
  String? _chatId;
  String? _currentUserId;

  bool _isPrivate = false;
  String? _partnerId;
  int? _participantsCount;

  int _currentPage = 1;
  int _totalPages = 1;
  static const int _pageLimit = 20;

  List<ChatMessage> _messages = [];
  final List<String> _failedMessagesQueue = [];
  bool _isRetrying = false;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  ChatMessage? _replyMessage;
  ChatMessage? _editingMessage;

  StreamSubscription<Map<String, dynamic>>? _messageSubscription;

  final Map<String, String> _senderThemeCache = {};

  PublicChatMessagesCubit(
      {required this.chatRepository,
      required this.pusherService,
      required this.privateChatsBloc})
      : super(PublicChatMessagesInitial());

  String? get chatId => _chatId;

  String? get currentUserId => _currentUserId;

  ChatMessage? get replyMessage => _replyMessage;

  ChatMessage? get editingMessage => _editingMessage;

  Map<String, String> get senderThemeCache => _senderThemeCache;

  bool get hasMore => _hasMore;

  // ================= HELPER =================
  PublicChatMessagesLoaded _buildLoaded({bool isLoadingMore = false}) {
    return PublicChatMessagesLoaded(
      messages: List.from(_messages),
      hasMore: _hasMore,
      isLoadingMore: isLoadingMore,
      replyMessage: _replyMessage,
      editingMessage: _editingMessage,
    );
  }

  // ================= INIT =================
  Future<void> init(
    String chatId, {
    bool isPrivate = false,
    String? partnerId,
    int? participantsCount,
  }) async {
    _chatId = chatId;
    _isPrivate = isPrivate;

    _currentUserId = await LocalStorage.getUserId();
    _connectivitySub = Connectivity().onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        retryFailedMessages();
      }
    });
    if (partnerId != null && partnerId != _currentUserId) {
      _partnerId = partnerId;
    } else {
      _partnerId = null;
    }

    _participantsCount = participantsCount;

    _currentPage = 1;
    _totalPages = 1;
    _messages = [];
    _hasMore = true;
    _isLoadingMore = false;
    _replyMessage = null;
    _editingMessage = null;
    _senderThemeCache.clear();

    // Emit initial state to show loader in UI
    emit(PublicChatMessagesInitial());

    // Setup Pusher in background to avoid blocking history loading
    if (_currentUserId != null) {
      _setupPusher(chatId);
    }

    // Load history and mark as read
    await loadMessages();
    await markMessagesAsRead();
  }

  Future<void> _setupPusher(String chatId) async {
    await _messageSubscription?.cancel();

    try {
      await pusherService.init(userId: _currentUserId!);
      await pusherService.whenConnected;
      await pusherService.subscribeToChat(chatId: chatId);

      _messageSubscription = pusherService.messageStream.listen(_onPusherEvent);
    } catch (e) {
      print("❌ Error setting up Pusher: $e");
    }
  }

  // ================= LOAD (أول مرة) =================
  Future<void> loadMessages() async {
    emit(PublicChatMessagesLoading());

    try {
      _currentPage = 1;

      final response = await chatRepository.getMessages(
        _chatId!,
        page: _currentPage,
        limit: _pageLimit,
      );

      _messages = response.messages.toList();
      _totalPages = response.totalPages;
      _hasMore = _currentPage < _totalPages;

      emit(_buildLoaded());
    } catch (e) {
      emit(PublicChatMessagesError(message: e.toString()));
    }
  }

  // ================= LOAD MORE =================
  Future<void> loadMoreMessages() async {
    if (!_hasMore || _isLoadingMore || _chatId == null) return;

    _isLoadingMore = true;
    emit(_buildLoaded(isLoadingMore: true));

    try {
      final nextPage = _currentPage + 1;

      final response = await chatRepository.getMessages(
        _chatId!,
        page: nextPage,
        limit: _pageLimit,
      );

      _currentPage = nextPage;
      _totalPages = response.totalPages;
      _hasMore = _currentPage < _totalPages;

      // الأقدم يتحط فوق
      _messages.insertAll(0, response.messages);

      _isLoadingMore = false;
      emit(_buildLoaded());
    } catch (e) {
      _isLoadingMore = false;
      emit(_buildLoaded());
    }
  }

  // ================= SEND =================
  Future<void> sendMessage(String content) async {
    if (_chatId == null || content.trim().isEmpty) return;

    if (_editingMessage != null) {
      await editMessage(_editingMessage!.id, content.trim());
      return;
    }

    final tempId = 'temp_${DateTime.now().millisecondsSinceEpoch}';

    final optimisticMessage = ChatMessage(
      id: tempId,
      chatId: _chatId!,
      senderId: Sender(
        id: _currentUserId ?? '',
        userImage: UserImage(secureUrl: '', publicId: ''),
        name: '',
        role: '',
      ),
      content: content.trim(),
      messageType: 'text',
      readBy: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: MessageStatus.sending,
      theme: null,
      replyTo: _replyMessage != null
          ? ReplyMessage(
              id: _replyMessage!.id,
              content: _replyMessage!.content,
              type: _replyMessage!.messageType,
              senderName: _replyMessage!.senderId.name ?? 'Unknown',
              createdAt: _replyMessage!.createdAt,
            )
          : null,
      v: 0,
    );

    _messages.add(optimisticMessage);
    emit(_buildLoaded());

    final replyToId = _replyMessage?.id;
    _replyMessage = null;

    _trySendMessage(tempId, optimisticMessage, replyToId);
  }

  // ================= TRY SEND =================
  Future<void> _trySendMessage(
      String tempId, ChatMessage message, String? replyToId) async {
    final index = _messages.indexWhere((m) => m.id == tempId);
    if (index == -1) return;

    bool notificationSent = false;

    try {
      final res = await chatRepository.sendMessage(
        _chatId!,
        message.content,
        'text',
        replyTo: replyToId,
      );

      _messages[index] = message.copyWith(
        id: res.data.id,
        status: MessageStatus.sent,
      );

      emit(_buildLoaded());
      privateChatsBloc.add(GetPrivateChatsEvent());
      final shouldSendNotification = _isPrivate &&
          _partnerId != null &&
          _partnerId!.isNotEmpty &&
          _partnerId != _currentUserId;

      if (!notificationSent && shouldSendNotification) {
        notificationSent = true;

        final senderName = _messages
                .firstWhere(
                  (m) => m.senderId.id == _currentUserId,
                  orElse: () => _messages.first,
                )
                .senderId
                .name ??
            'Someone';

        await sl<NotificationRepository>().sendNotification(
          receiverId: _partnerId!,
          type: NotificationTypes.chatMessage,
          payload: {
            'chatId': _chatId!,
            'senderName': senderName,
            'messagePreview': message.content.length > 100
                ? message.content.substring(0, 100)
                : message.content,
          },
        );
      }
    } catch (e) {
      _messages[index] = message.copyWith(status: MessageStatus.failed);

      if (!_failedMessagesQueue.contains(tempId)) {
        _failedMessagesQueue.add(tempId);
      }
      emit(_buildLoaded());
    }
  }

  Future<void> retryFailedMessages() async {
    if (_isRetrying) return;
    _isRetrying = true;

    try {
      for (final tempId in List.from(_failedMessagesQueue)) {
        final index = _messages.indexWhere((m) => m.id == tempId);

        if (index == -1) {
          _failedMessagesQueue.remove(tempId);
          continue;
        }

        final message = _messages[index];

        if (message.status != MessageStatus.failed) {
          _failedMessagesQueue.remove(tempId);
          continue;
        }

        _messages[index] = message.copyWith(status: MessageStatus.sending);

        emit(_buildLoaded());

        await _trySendMessage(
          tempId,
          message,
          message.replyTo?.id,
        );

        _failedMessagesQueue.remove(tempId);
      }
    } finally {
      _isRetrying = false;
    }
  }

  // ================= RETRY =================
  Future<void> _retryMessage(String tempId, String? replyToId) async {
    final index = _messages.indexWhere((m) => m.id == tempId);
    if (index == -1) return;

    final message = _messages[index];
    _messages[index] = message.copyWith(status: MessageStatus.sending);
    emit(_buildLoaded());

    _trySendMessage(tempId, message, replyToId);
  }

  // ================= REPLY / EDITING STATE =================
  void setReplyMessage(ChatMessage message) {
    _replyMessage = message;
    emit(_buildLoaded());
  }

  void clearReply() {
    _replyMessage = null;
    emit(_buildLoaded());
  }

  void setEditingMessage(ChatMessage message) {
    _editingMessage = message;
    emit(_buildLoaded());
  }

  void clearEditing() {
    _editingMessage = null;
    emit(_buildLoaded());
  }

  // ================= EDIT =================
  Future<void> editMessage(String messageId, String content) async {
    if (_chatId == null) return;

    final index = _messages.indexWhere((m) => m.id == messageId);
    if (index == -1) return;

    final old = _messages[index];
    _messages[index] = old.copyWith(content: content, isEdited: true);
    _editingMessage = null;

    emit(_buildLoaded());

    try {
      await chatRepository.editMessage(_chatId!, messageId, content);
    } catch (e) {
      _messages[index] = old;
      emit(_buildLoaded());
    }
  }

  // ================= DELETE =================
  Future<void> deleteMessage(String messageId) async {
    if (_chatId == null) return;

    final index = _messages.indexWhere((m) => m.id == messageId);
    if (index == -1) return;

    final old = _messages[index];
    _messages.removeAt(index);

    emit(_buildLoaded());

    try {
      await chatRepository.deleteMessage(_chatId!, messageId);
    } catch (e) {
      _messages.insert(index, old);
      emit(_buildLoaded());
    }
  }

  // ================= PUSHER =================
  void _onPusherEvent(Map<String, dynamic> data) {
    if (isClosed) return;

    final eventType = data['_eventType'] ?? 'receive_message';

    switch (eventType) {
      case 'message_edited':
        _handleMessageUpdated(data);
        break;
      case 'message_deleted':
        _handleMessageDeleted(data);
        break;
      case 'messages_read':
        _handleMessagesRead(data);
        break;
      case 'chat_list_update':
        privateChatsBloc.add(ChatListUpdateEvent(data));
        break;
      default:
        _handleNewMessage(data);
    }
  }

  void _handleNewMessage(Map<String, dynamic> data) {
    final messageData = data['message'] is Map<String, dynamic>
        ? data['message'] as Map<String, dynamic>
        : data;

    final themeData = messageData['theme'];
    final MessageTheme? theme =
        themeData != null && themeData is Map<String, dynamic>
            ? MessageTheme.fromJson(themeData)
            : null;

    final messageChatId = messageData['chatId']?.toString() ?? '';
    if (messageChatId != _chatId) return;

    final senderData = messageData['senderData'] ?? {};
    final senderId = messageData['senderId']?.toString() ?? 'unknown';
    final senderName = senderData['userName']?.toString() ?? 'unknown';

    String userImageUrl =
        senderData['userImage']?['secure_url']?.toString() ?? '';

    if (userImageUrl.isEmpty) {
      try {
        final oldMessage =
            _messages.firstWhere((m) => m.senderId.id == senderId);
        userImageUrl = oldMessage.senderId.userImage.secureUrl;
      } catch (_) {}
    }

    if (theme != null && theme.value.isNotEmpty) {
      _senderThemeCache[senderId] = theme.value;
    }

    final newMessage = ChatMessage(
      id: messageData['id']?.toString() ?? DateTime.now().toString(),
      chatId: messageChatId,
      senderId: Sender(
        id: senderId,
        userImage: UserImage(secureUrl: userImageUrl, publicId: ''),
        name: senderName,
        role: '',
      ),
      content: messageData['message'] ?? '',
      messageType: 'text',
      readBy: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: MessageStatus.sent,
      theme: theme,
      v: 0,
    );

    if (senderId == _currentUserId) {
      final tempIndex = _messages.indexWhere(
          (m) => m.id.startsWith('temp_') && m.content == newMessage.content);

      if (tempIndex != -1) {
        _messages[tempIndex] = newMessage.copyWith(status: MessageStatus.sent);
        emit(_buildLoaded());
      } else {
        final exists = _messages.any((m) => m.id == newMessage.id);
        if (!exists) {
          _messages.add(newMessage);
          emit(_buildLoaded());
        }
      }
      return;
    }
    markMessagesAsRead();
  }

  void _handleMessageUpdated(Map<String, dynamic> data) {
    try {
      final messageId =
          data['messageId']?.toString() ?? data['_id']?.toString() ?? '';
      final newContent =
          data['newContent']?.toString() ?? data['content']?.toString() ?? '';
      if (messageId.isEmpty || newContent.isEmpty) return;

      final index = _messages.indexWhere((m) => m.id == messageId);
      if (index == -1) return;

      _messages[index] =
          _messages[index].copyWith(content: newContent, isEdited: true);

      emit(PublicChatMessagesLoaded(
        messages: List.from(_messages),
        hasMore: _hasMore,
        replyMessage: _replyMessage,
        editingMessage: _editingMessage,
      ));
    } catch (e) {
      print('❌ error handling message_edited $e');
    }
  }

  void _handleMessageDeleted(Map<String, dynamic> data) {
    try {
      final messageId =
          data['messageId']?.toString() ?? data['_id']?.toString() ?? '';
      if (messageId.isEmpty) return;

      _messages.removeWhere((m) => m.id == messageId);

      emit(PublicChatMessagesLoaded(
        messages: List.from(_messages),
        hasMore: _hasMore,
        replyMessage: _replyMessage,
        editingMessage: _editingMessage,
      ));
    } catch (e) {
      print('❌ error handling message_deleted $e');
    }
  }

  void _handleMessagesRead(Map<String, dynamic> data) {
    try {
      final dynamic rawReader = data['userId'] ??
          data['readerId'] ??
          (data['readBy'] is String ? data['readBy'] : null);
      final readerId = rawReader?.toString() ?? '';

      if (readerId.isNotEmpty && readerId == _currentUserId) return;

      bool changed = false;

      final useFallback = _isPrivate || readerId.isEmpty;

      if (useFallback) {
        for (int i = 0; i < _messages.length; i++) {
          final msg = _messages[i];
          if (msg.senderId.id != _currentUserId) continue;
          if (!msg.isSeen) {
            _messages[i] = msg.copyWith(isSeen: true);
            changed = true;
          }
        }
      } else {
        final required = ((_participantsCount ?? 2) - 1).clamp(1, 1 << 30);

        for (int i = 0; i < _messages.length; i++) {
          final msg = _messages[i];
          if (msg.senderId.id != _currentUserId) continue;

          final readBy = List<dynamic>.from(msg.readBy);
          final already = readBy.any((e) => e.toString() == readerId);
          if (!already) readBy.add(readerId);

          final uniqueOthers = readBy
              .map((e) => e.toString())
              .where((id) => id != _currentUserId)
              .toSet()
              .length;

          final newSeen = uniqueOthers >= required;

          if (!already || newSeen != msg.isSeen) {
            _messages[i] = msg.copyWith(readBy: readBy, isSeen: newSeen);
            changed = true;
          }
        }
      }

      if (changed) {
        emit(PublicChatMessagesLoaded(
          messages: List.from(_messages),
          hasMore: _hasMore,
          replyMessage: _replyMessage,
          editingMessage: _editingMessage,
        ));
      }
    } catch (e) {
      print('❌ error handling messages_read $e');
    }
  }

  Future<void> markMessagesAsRead() async {
    if (_chatId == null) return;
    await chatRepository.markMessagesAsRead(_chatId!);
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _connectivitySub?.cancel();
    if (_chatId != null && _currentUserId != null) {
      pusherService.unsubscribeFromChat(_chatId!);
    }
    return super.close();
  }
}
