import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/mobile/presentation/prv_chat/prv_message_bubble.dart';

import '../../../main.dart';

import '../../../mobile/presentation/chat_channel/chat_theme_page.dart';
import '../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../shared/bloc/public_chat/public_chat_messages_cubit.dart';
import '../../../shared/bloc/public_chat/public_chat_messages_state.dart';
import '../../../shared/bloc/store_cubit/purchase_cubit.dart';
import '../../../shared/common_ui/edit_preview_bar.dart';
import '../../../shared/common_ui/reply_preview_bar.dart';
import '../../../shared/common_ui/swipeable_message.dart';
import '../../../shared/core/theme/app_palette.dart';
import '../../../shared/data/models/public_chat/get_history_messages.dart';
import '../../../shared/dependency_injection/injection.dart';

class PrivateChatScreen extends StatefulWidget {
  final String chatId;
  final String partnerName;
  final String partnerId;
  final String? partnerImage;

  const PrivateChatScreen({
    super.key,
    required this.chatId,
    required this.partnerId,
    required this.partnerName,
    this.partnerImage,
  });

  @override
  State<PrivateChatScreen> createState() => _PrivateChatScreenState();
}

class _PrivateChatScreenState extends State<PrivateChatScreen> {
  late PublicChatMessagesCubit _chatCubit;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final Map<String, GlobalKey> _messageKeys = {};
  String? _highlightedMessageId;

  @override
  void initState() {
    super.initState();
    _chatCubit = context.read<PublicChatMessagesCubit>();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          // ✅ reverse: true فـ min مش max
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    context.read<PublicChatMessagesCubit>().sendMessage(text);
    _controller.clear();
    _scrollToBottom();
  }

  void _scrollToMessage(String messageId) {
    final key = _messageKeys[messageId];
    if (key != null && key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 300),
        alignment: 0.5,
      );
      setState(() {
        _highlightedMessageId = messageId;
      });
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() {
            _highlightedMessageId = null;
          });
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Message not available")),
      );
    }
  }

  bool _canEditMessage(ChatMessage message) {
    final difference = DateTime.now().difference(message.createdAt);
    return difference.inMinutes <= 15;
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
                Navigator.pop(context);
                _chatCubit.setReplyMessage(message);
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

  Widget _buildMessageList(List<ChatMessage> messages) {
    final currentUserId = _chatCubit.currentUserId;
    final reversedMessages = messages.reversed.toList();

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      reverse: true,
      itemCount: reversedMessages.length,
      itemBuilder: (context, index) {
        final ChatMessage message = reversedMessages[index];
        final isMe = message.senderId.id == currentUserId;

        if (!_messageKeys.containsKey(message.id)) {
          _messageKeys[message.id] = GlobalKey();
        }

        return SwipeableMessage(
          onSwipeReply: () => _chatCubit.setReplyMessage(message),
          child: Container(
            key: _messageKeys[message.id],
            child: PrvMessageBubble(
              message: message,
              isMe: isMe,
              isHighlighted: _highlightedMessageId == message.id,
              onLongPress: () => _showMessageOptions(context, message),
              onTapReply: message.replyTo != null
                  ? () => _scrollToMessage(message.replyTo!.id)
                  : null,
            ),
          ),
        );
      },
    );
  }

  Widget _messageInput(PublicChatMessagesState state) {
    return Column(
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
          padding: const EdgeInsets.all(12),
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 10),
              IconButton(
                icon: Icon(Icons.send, color: AppPalette.primary),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // ✅ شيلنا الـ scrollToBottom من هنا
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => desktopKey.currentState?.goBack(),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppPalette.primary,
              backgroundImage:
                  widget.partnerImage != null && widget.partnerImage!.isNotEmpty
                      ? NetworkImage(widget.partnerImage!)
                      : null,
              child: widget.partnerImage == null || widget.partnerImage!.isEmpty
                  ? Text(
                      widget.partnerName.isNotEmpty
                          ? widget.partnerName[0]
                          : '?',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 8),
            Text(
              widget.partnerName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppPalette.primary,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'theme') {
                desktopKey.currentState?.openSidePage(
                  body: widget,
                  rightPanel: MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (_) => sl<PurchaseCubit>()..getPurchases(),
                      ),
                      BlocProvider.value(
                        value: context.read<MyProfileCubit>(),
                      ),
                    ],
                    child: const ChatThemePage(),
                  ),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: 'theme',
                child: Text('Chat theme'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child:
                BlocConsumer<PublicChatMessagesCubit, PublicChatMessagesState>(
              listener: (context, state) {
                if (state is PublicChatMessagesLoaded) {
                  _scrollToBottom(); // ✅ هنا بس
                }
              },
              builder: (context, state) {
                if (state is PublicChatMessagesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is PublicChatMessagesLoaded) {
                  if (state.messages.isEmpty) {
                    return Center(
                      child: Text(
                        'No messages yet',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        ),
                      ),
                    );
                  }
                  return _buildMessageList(state.messages);
                }
                if (state is PublicChatMessagesError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Failed to load messages'),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => context
                              .read<PublicChatMessagesCubit>()
                              .loadMessages(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          Material(
            color: Theme.of(context).scaffoldBackgroundColor,
            child:
                BlocBuilder<PublicChatMessagesCubit, PublicChatMessagesState>(
              builder: (context, state) {
                return _messageInput(state);
              },
            ),
          ),
        ],
      ),
    );
  }
}
