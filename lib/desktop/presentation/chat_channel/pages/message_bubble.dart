import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:skill_swap/mobile/presentation/frames/skill_type.dart';

import '../../../../mobile/presentation/frames/frame_style.dart';
import '../../../../mobile/presentation/frames/frame_styles_map.dart';
import '../../../../mobile/presentation/frames/framed_message_bubble.dart';
import '../../../../shared/common_ui/reply_bubble_preview.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/data/models/public_chat/get_history_messages.dart';
import 'typing_indicator.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;
  final String senderName;
  final String? senderImage;
  final bool showAvatar;
  final bool showName;
  final bool isTyping;
  final VoidCallback? onLongPress;
  final VoidCallback? onTapReply;
  final bool isHighlighted;

  final bool isFirstInGroup;
  final bool isLastInGroup;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
    required this.senderName,
    this.senderImage,
    this.showAvatar = true,
    this.showName = true,
    this.isTyping = false,
    this.onLongPress,
    this.onTapReply,
    this.isHighlighted = false,
    this.isFirstInGroup = true,
    this.isLastInGroup = true,
  });

  String _formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      backgroundColor: AppPalette.primary,
      backgroundImage: (senderImage != null && senderImage!.isNotEmpty)
          ? NetworkImage(senderImage!)
          : null,
      child: (senderImage == null || senderImage!.isEmpty)
          ? Text(
              senderName.isNotEmpty ? senderName[0].toUpperCase() : '?',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          : null,
    );
  }

  Color _lighten(Color color, [double amount = 0.2]) {
    final hsl = HSLColor.fromColor(color);
    final lighter = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );
    return lighter.toColor();
  }

  Color _getBubbleColor(FrameStyle? style) {
    if (style == null) {
      return isMe ? AppPalette.primary : Colors.grey.shade300;
    }

    final baseColor = style.colors.first;
    return isMe ? _lighten(baseColor, 0.1) : _lighten(baseColor, 0.35);
  }

  @override
  Widget build(BuildContext context) {
    final skill = isMe ? SkillType.none : SkillType.none;
    final style = frameStyles[skill];

    final Color bubbleColor = _getBubbleColor(style);
    final textColor = isMe ? Colors.white : Colors.black87;
    final time = _formatTime(message.createdAt);

    final radius = BorderRadius.only(
      topLeft: Radius.circular(isMe ? 14 : (isFirstInGroup ? 14 : 4)),
      topRight: Radius.circular(isMe ? (isFirstInGroup ? 14 : 4) : 14),
      bottomLeft: Radius.circular(isMe ? 14 : (isLastInGroup ? 14 : 4)),
      bottomRight: Radius.circular(isMe ? (isLastInGroup ? 14 : 4) : 14),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          /// Avatar
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: showAvatar ? _buildAvatar() : const SizedBox(width: 40),
            ),

          Flexible(
            child: IntrinsicWidth(
              stepWidth: 0.1,
              child: GestureDetector(
                onLongPress: onLongPress,
                child: FramedMessageBubble(
                  skill: skill,
                  borderRadius: radius,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                    ),
                    decoration: BoxDecoration(
                      color: isHighlighted
                          ? AppPalette.warning.withOpacity(0.4)
                          : bubbleColor,
                      borderRadius: radius,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isMe && showName)
                          Text(
                            senderName.isNotEmpty ? senderName : "User",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                              color: Colors.grey.shade700,
                            ),
                          ),

                        if (!isMe && showName) const SizedBox(height: 3),

                        /// Reply
                        if (message.replyTo != null)
                          ReplyBubblePreview(
                            replyMessage: message.replyTo!,
                            isMe: isMe,
                            onTap: onTapReply ?? () {},
                          ),

                        /// Message / Typing
                        isTyping
                            ? const TypingIndicator()
                            : Text(
                                message.content,
                                style: TextStyle(color: textColor),
                                softWrap: true,
                              ),

                        const SizedBox(height: 3),

                        Align(
                          alignment: Alignment.bottomRight,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (message.isEdited)
                                Text(
                                  'edited  ',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontStyle: FontStyle.italic,
                                    color:
                                        isMe ? Colors.white70 : Colors.black54,
                                  ),
                                ),
                              Text(
                                time,
                                style: TextStyle(
                                  fontSize: 9,
                                  color: isMe ? Colors.white70 : Colors.black54,
                                ),
                              ),

                              /// SEEN ICON
                              if (isMe) ...[
                                const SizedBox(width: 4),
                                if (message.status == MessageStatus.sending)
                                  const Icon(Icons.access_time,
                                      size: 14, color: Colors.white70),
                                if (message.status == MessageStatus.failed)
                                  const Icon(Icons.error,
                                      size: 14, color: Colors.red),
                                if (message.status == MessageStatus.sent)
                                  Icon(
                                    Icons.done_all,
                                    size: 14,
                                    color: message.isSeen
                                        ? Colors.blue
                                        : Colors.white70,
                                  ),
                              ]
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
