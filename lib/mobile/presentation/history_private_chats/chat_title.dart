import 'package:flutter/material.dart';

import '../../../shared/core/theme/app_palette.dart';

class ChatTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String image;
  final String time;
  final int unread;
  final VoidCallback onTap;

  const ChatTile({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.image,
    required this.time,
    required this.unread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: AppPalette.primary,
        backgroundImage: image.isNotEmpty ? NetworkImage(image) : null,
        child: image.isEmpty
            ? const Icon(Icons.person, color: Colors.white)
            : null,
      ),
      title: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),

      /// 🔴 هنا التعديل
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _formatTime(time),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 6),
          if (unread > 0)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                unread > 9 ? "9+" : unread.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatTime(String date) {
    if (date.isEmpty) return "";
    final dt = DateTime.tryParse(date);
    if (dt == null) return "";
    return "${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
  }
}
