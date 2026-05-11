import 'package:skill_swap/shared/data/models/join_track/join_response.dart';
import 'package:skill_swap/shared/data/models/join_track/tracks_response.dart';

import '../../data/models/chat/chat_models.dart';
import '../../data/models/public_chat/get_chat_model.dart';
import '../../data/models/public_chat/get_history_messages.dart';
import '../../data/models/public_chat/search_response.dart';
import '../../data/models/public_chat/send_message_response.dart';

abstract class ChatRepository {
  Future<String> createOrGetPrivateChat(String partnerId);

  Future<List<PrivateChatModel>> getMyChats();

  Future<List<GetChatModel>> getPublicChats();

  Future<List<GetChatModel>> getPrivateChats();

  Future<int> getUnreadCount(String chatId);

  Future<ChatHistoryResponse> getMessages(String chatId,
      {int page = 1, int limit = 20});

  Future<SendMessageResponse> sendMessage(String chatId, String content,
      String type,
      {String? replyTo});

  Future<TracksResponse> getTracks();

  Future<JoinTrackResponse> joinTrack(String trackId);

  Future<void> markMessagesAsRead(String chatId);

  Future<void> editMessage(String chatId, String messageId, String content);

  Future<void> deleteMessage(String chatId, String messageId);

  Future<void> leaveChat(String chatId);

  Future<List<MessageModel>> searchMessages(String chatId, String query);
}