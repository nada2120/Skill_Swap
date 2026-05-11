import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../mobile/presentation/prv_chat/private_chat_screen.dart';
import '../../../shared/bloc/private_chats_bloc/private_chats_bloc.dart';
import '../../../shared/bloc/private_chats_bloc/private_chats_state.dart';
import '../../../shared/bloc/private_chats_bloc/private_chats_event.dart';
import '../../../shared/bloc/public_chat/public_chat_messages_cubit.dart';
import '../../../shared/dependency_injection/injection.dart';
import '../../../shared/domain/repositories/chat_repository.dart';
import 'chat_title.dart';

final RouteObserver<ModalRoute<void>> routeObserver =
RouteObserver<ModalRoute<void>>();

class PrivateChatsListScreen extends StatefulWidget {
  final String currentUserId;

  const PrivateChatsListScreen({
    super.key,
    required this.currentUserId,
  });

  @override
  State<PrivateChatsListScreen> createState() => _PrivateChatsListScreenState();
}

class _PrivateChatsListScreenState extends State<PrivateChatsListScreen>
    with RouteAware {
  late PrivateChatsBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = context.read<PrivateChatsBloc>();

    // أول فتح
    bloc.add(GetPrivateChatsEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // 🔥 أهم نقطة (real-time refresh عند الرجوع)
  @override
  void didPopNext() {
    bloc.clearActiveChat();
    bloc.add(GetPrivateChatsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
      ),
      body: BlocBuilder<PrivateChatsBloc, PrivateChatsState>(
        builder: (context, state) {
          if (state is PrivateChatsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is PrivateChatsError) {
            return Center(child: Text(state.message));
          }

          if (state is PrivateChatsLoaded) {
            final chats = state.chats;

            if (chats.isEmpty) {
              return const Center(child: Text("No chats yet"));
            }

            return ListView.separated(
              itemCount: chats.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final chat = chats[index];

                final otherUser = chat.participants.firstWhere(
                      (p) => p.id != widget.currentUserId,
                  orElse: () => chat.participants.first,
                );

                final unread = bloc.unreadMap[chat.id] ?? 0;

                return ChatTile(
                  name: chat.type == "private" ? otherUser.name : chat.name,
                  lastMessage: chat.lastMessage?.content ?? "",
                  image: otherUser.userImage.secureUrl,
                  time: chat.lastMessage?.createdAt ?? "",
                  unread: unread,
                  onTap: () async {
                    // Clear unread badge immediately when entering the chat
                    bloc.clearUnread(chat.id);

                    try {
                      final chatRepo = sl<ChatRepository>();

                      final chatId =
                      await chatRepo.createOrGetPrivateChat(otherUser.id);

                      Get.to(
                            () =>
                            BlocProvider(
                              create: (_) =>
                              sl<PublicChatMessagesCubit>()
                                ..init(
                                  chatId,
                                  partnerId: otherUser.id,
                                  isPrivate: true,
                                ),
                              child: PrivateChatScreen(
                                chatId: chatId,
                                partnerName: otherUser.name,
                                partnerId: otherUser.id,
                                partnerImage: otherUser.userImage.secureUrl,
                              ),
                            ),
                      );
                    } catch (e) {
                      Get.snackbar('Error', 'Failed to open chat: $e');
                    }
                  },
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}