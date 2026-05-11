import 'package:flutter/material.dart';
import 'package:skill_swap/shared/data/models/public_chat/get_chat_model.dart';

import '../../../shared/data/models/public_chat/participant_model.dart';

class ChatDetailScreen extends StatelessWidget {
  final GetChatModel chat;
  final String currentUserId;

  const ChatDetailScreen({
    super.key,
    required this.chat,
    required this.currentUserId,
  });

  ParticipantModel getOtherUser() {
    return chat.participants.firstWhere(
      (p) => p.id != currentUserId,
      orElse: () => chat.participants.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final otherUser = getOtherUser();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          chat.type == "private" ? otherUser.email : chat.name,
        ),
      ),
      body: Column(
        children: [
          /// 💬 messages list (dummy دلوقتي)
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                _messageBubble("Hello 👋", false),
                _messageBubble("Hi 😄", true),
                _messageBubble("How are you?", false),
              ],
            ),
          ),

          /// ⬇️ input bar
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.white,
            child: Row(
              children: [
                const Icon(Icons.emoji_emotions_outlined),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Type a message...",
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CircleAvatar(
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () {},
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _messageBubble(String text, bool isMe) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isMe ? Colors.green : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isMe ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }
}
