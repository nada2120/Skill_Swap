import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/shared/bloc/get_profile_cubit/my_profile_cubit.dart';

import '../../../shared/bloc/public_chat/message_search_cubit.dart';
import '../../../shared/bloc/public_chat/message_search_state.dart';
import '../../../shared/bloc/public_chat/public_chat_messages_cubit.dart';
import '../../../shared/bloc/public_chat/public_chat_messages_state.dart';
import '../../../shared/bloc/store_cubit/purchase_cubit.dart';
import '../../../shared/common_ui/edit_preview_bar.dart';
import '../../../shared/common_ui/reply_preview_bar.dart';
import '../../../shared/common_ui/swipeable_message.dart';
import '../../../shared/core/theme/app_palette.dart';
import '../../../shared/data/models/public_chat/get_history_messages.dart';
import '../../../shared/dependency_injection/injection.dart';
import 'chat_theme_page.dart';
import 'message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String channelName;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.channelName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late PublicChatMessagesCubit _chatCubit;
  late MessageSearchCubit _searchCubit;

  final TextEditingController _controller = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _isSearching = false;
  String? _highlightedMessageId;
  Timer? _debounce;

  final Map<String, GlobalKey> _messageKeys = {};
  final Map<String, int> _messageIndexMap = {};

  @override
  void initState() {
    super.initState();
    _chatCubit = sl<PublicChatMessagesCubit>();
    _searchCubit = sl<MessageSearchCubit>();
    _chatCubit.init(widget.chatId, isPrivate: false);

    // ✅ scroll listener للـ load more
    _scrollController.addListener(_onScroll);
  }

  // ✅ لما يوصل لأعلى الـ list يحمل صفحة أقدم
  void _onScroll() {
    if (_scrollController.hasClients &&
        _scrollController.position.pixels <= 150) {
      _chatCubit.loadMoreMessages();
    }
  }

  bool _canEditMessage(ChatMessage message) {
    final difference = DateTime.now().difference(message.createdAt);
    return difference.inMinutes <= 15;
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final state = _chatCubit.state;

    if (state is PublicChatMessagesLoaded && state.editingMessage != null) {
      _chatCubit.editMessage(state.editingMessage!.id, text);
      _chatCubit.clearEditing();
    } else {
      _chatCubit.sendMessage(text);
    }

    _controller.clear();
    scrollToBottom();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // ✅ scroll to message باستخدام GlobalKey بدل index * 80
  void _scrollToMessage(String messageId) {
    final key = _messageKeys[messageId];
    if (key == null) return;

    final context = key.currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      alignment: 0.3,
    );

    setState(() => _highlightedMessageId = messageId);

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _highlightedMessageId = null);
    });
  }

  // ✅ حمّل صفحات لحد ما نلاقي الرسالة
  Future<void> _loadUntilMessageFound(String messageId) async {
    while (!_messageIndexMap.containsKey(messageId) && _chatCubit.hasMore) {
      await _chatCubit.loadMoreMessages();
      // استنى الـ state يتحدث والـ ListView يعمل build
      await Future.delayed(const Duration(milliseconds: 400));
    }
  }

  void _showMessageOptions(BuildContext context, ChatMessage message) {
    final isMe = message.senderId.id == _chatCubit.currentUserId;
    final canEdit = _canEditMessage(message);

    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.reply),
              title: const Text('Reply'),
              onTap: () {
                _chatCubit.setReplyMessage(message);
                Navigator.pop(context);
              },
            ),
            if (isMe && canEdit)
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.orange),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  _chatCubit.setEditingMessage(message);
                  _controller.text = message.content;
                  _controller.selection = TextSelection.fromPosition(
                    TextPosition(offset: message.content.length),
                  );
                },
              ),
            if (isMe)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context, message);
                },
              ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, ChatMessage message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Message'),
        content: const Text('Are you sure you want to delete this message?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              _chatCubit.deleteMessage(message.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  bool _isSameSender(ChatMessage a, ChatMessage b) =>
      a.senderId.id == b.senderId.id;

  bool _isFirstInGroup(List<ChatMessage> messages, int index) {
    if (index == 0) return true;
    return !_isSameSender(messages[index], messages[index - 1]);
  }

  bool _isLastInGroup(List<ChatMessage> messages, int index) {
    if (index == messages.length - 1) return true;
    return !_isSameSender(messages[index], messages[index + 1]);
  }

  Widget _buildMessageList(
      List<ChatMessage> messages, String? myActiveTheme, bool isLoadingMore) {
    // ✅ زي PrivateChatScreen بالظبط - بنعكس الـ list الأول
    final reversedMessages = messages.reversed.toList();

    return ListView.builder(
      reverse: true,
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      // ✅ itemCount على reversedMessages
      itemCount: reversedMessages.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        // ✅ أول item هو الـ loading indicator لما بيحمل صفحة أقدم
        if (isLoadingMore && index == 0) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final messageIndex = isLoadingMore ? index - 1 : index;
        // ✅ بنجيب من reversedMessages مش messages
        final message = reversedMessages[messageIndex];

        // ✅ حدّث الـ index map
        _messageIndexMap[message.id] = messageIndex;
        _messageKeys.putIfAbsent(message.id, () => GlobalKey());

        final isMe = message.senderId.id == _chatCubit.currentUserId;
        // ✅ _isFirstInGroup و _isLastInGroup على reversedMessages
        final isFirstInGroup = _isFirstInGroup(reversedMessages, messageIndex);
        final isLastInGroup = _isLastInGroup(reversedMessages, messageIndex);

        return SwipeableMessage(
          onSwipeReply: () => _chatCubit.setReplyMessage(message),
          child: Container(
            key: _messageKeys[message.id],
            child: MessageBubble(
              message: message,
              isMe: isMe,
              senderName: message.senderId.name ?? "User",
              senderImage: message.senderId.userImage.secureUrl,
              showAvatar: true,
              showName: true,
              isHighlighted: _highlightedMessageId == message.id,
              onLongPress: () => _showMessageOptions(context, message),
              onTapReply: message.replyTo != null
                  ? () => _scrollToMessage(message.replyTo!.id)
                  : null,
              senderThemeValue:
                  message.theme?.value ?? (isMe ? myActiveTheme : null),
              isFirstInGroup: isFirstInGroup,
              isLastInGroup: isLastInGroup,
            ),
          ),
        );
      },
    );
  }

  Widget _messageInput(PublicChatMessagesState state) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state is PublicChatMessagesLoaded && state.editingMessage != null)
            EditPreviewBar(
              editingMessage: state.editingMessage!,
              onCancel: () {
                _chatCubit.clearEditing();
                _controller.clear();
              },
            )
          else if (state is PublicChatMessagesLoaded &&
              state.replyMessage != null)
            ReplyPreviewBar(
              replyMessage: state.replyMessage!,
              onCancel: () => _chatCubit.clearReply(),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Message...",
                      fillColor: Theme.of(context).cardColor,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).dividerColor),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).dividerColor),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.send, color: AppPalette.primary),
                  onPressed: _sendMessage,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _scrollController.removeListener(_onScroll);
    _chatCubit.close();
    _searchCubit.close();
    _controller.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _chatCubit),
        BlocProvider.value(value: _searchCubit),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (_isSearching) {
                setState(() {
                  _isSearching = false;
                  _searchController.clear();
                  _searchCubit.clearSearch();
                });
              } else {
                Get.back();
              }
            },
          ),
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    hintText: "Search messages...",
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    if (_debounce?.isActive ?? false) _debounce!.cancel();
                    _debounce = Timer(const Duration(milliseconds: 400), () {
                      _searchCubit.searchMessages(widget.chatId, value);
                    });
                  },
                )
              : Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppPalette.primary,
                      child: Text(
                        widget.channelName[0],
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.channelName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppPalette.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
          actions: [
            if (!_isSearching)
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => setState(() => _isSearching = true),
              ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value == 'theme') {
                  Get.to(MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (_) => sl<PurchaseCubit>()..getPurchases(),
                      ),
                      BlocProvider.value(
                        value: context.read<MyProfileCubit>(),
                      ),
                    ],
                    child: const ChatThemePage(),
                  ));
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'theme', child: Text('Chat theme')),
              ],
            ),
          ],
        ),
        body: Stack(
          children: [
            BlocBuilder<PublicChatMessagesCubit, PublicChatMessagesState>(
              builder: (context, chatState) {
                if (chatState is PublicChatMessagesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = chatState is PublicChatMessagesLoaded
                    ? chatState.messages
                    : <ChatMessage>[];

                final isLoadingMore = chatState is PublicChatMessagesLoaded &&
                    chatState.isLoadingMore;

                return Column(
                  children: [
                    Expanded(
                      child: BlocBuilder<MyProfileCubit, MyProfileState>(
                        builder: (context, profileState) {
                          final myActiveTheme = profileState is MyProfileLoaded
                              ? profileState.profile.activeTheme?.value
                              : null;

                          return _buildMessageList(
                              messages, myActiveTheme, isLoadingMore);
                        },
                      ),
                    ),
                    _messageInput(chatState),
                  ],
                );
              },
            ),
            if (_isSearching)
              Positioned.fill(
                child: BlocBuilder<MessageSearchCubit, MessageSearchState>(
                  builder: (context, searchState) {
                    if (searchState is MessageSearchLoading) {
                      return Container(
                        color: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.9),
                        alignment: Alignment.topCenter,
                        padding: const EdgeInsets.all(8.0),
                        child: const CircularProgressIndicator(),
                      );
                    }
                    if (searchState is MessageSearchLoaded) {
                      if (searchState.results.isEmpty) {
                        return Container(
                          color: Theme.of(context)
                              .scaffoldBackgroundColor
                              .withOpacity(0.9),
                          alignment: Alignment.topCenter,
                          padding: const EdgeInsets.all(16.0),
                          child: const Text("No messages found"),
                        );
                      }
                      return Container(
                        color: Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.95),
                        child: ListView.separated(
                          itemCount: searchState.results.length,
                          separatorBuilder: (_, __) => const Divider(),
                          itemBuilder: (context, index) {
                            final msg = searchState.results[index];
                            final sender = msg.senderId;
                            final name = sender?.name ?? "Unknown";
                            final imageUrl = sender?.userImage.secureUrl ?? "";
                            final initial = name.isNotEmpty ? name[0] : "?";

                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: imageUrl.isNotEmpty
                                    ? NetworkImage(imageUrl)
                                    : null,
                                child: imageUrl.isEmpty ? Text(initial) : null,
                              ),
                              title: Text(
                                name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                msg.content,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Text(
                                "${msg.createdAt.hour}:${msg.createdAt.minute.toString().padLeft(2, '0')}",
                                style: const TextStyle(
                                    fontSize: 12, color: Colors.grey),
                              ),
                              onTap: () async {
                                setState(() => _isSearching = false);
                                await _loadUntilMessageFound(msg.id);
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  _scrollToMessage(msg.id);
                                });
                              },
                            );
                          },
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
