import 'package:dio/dio.dart';
import 'package:skill_swap/shared/data/models/join_track/tracks_response.dart';
import 'package:skill_swap/shared/data/models/public_chat/get_history_messages.dart';
import 'package:skill_swap/shared/data/models/public_chat/send_message_response.dart';

import '../../domain/repositories/chat_repository.dart';
import '../../helper/local_storage.dart';
import '../models/chat/chat_models.dart';
import '../models/join_track/join_response.dart';
import '../models/join_track/join_track_error_response.dart';
import '../models/join_track/join_track_success_response.dart';
import '../models/public_chat/get_chat_model.dart';
import '../models/public_chat/search_response.dart';
import '../web_services/chat/chat_api_service.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatApiService api;

  ChatRepositoryImpl({required this.api});

  @override
  Future<String> createOrGetPrivateChat(String partnerId) async {
    try {
      final response = await api.createOrGetPrivateChat(partnerId);
      // The response may have the chat ID at various keys
      return response['_id']?.toString() ??
          response['id']?.toString() ??
          response['chatId']?.toString() ??
          (response['chat'] is Map
              ? (response['chat']['_id']?.toString() ??
              response['chat']['id']?.toString() ??
              '')
              : '');
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  @override
  Future<List<PrivateChatModel>> getMyChats() async {
    try {
      final currentUserId = await LocalStorage.getUserId() ?? '';
      final response = await api.getMyChats();
      return response
          .where((item) => item is Map<String, dynamic>)
          .map((item) =>
          PrivateChatModel.fromJson(
              item as Map<String, dynamic>, currentUserId))
          .toList();
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  String _extractError(DioException e) {
    try {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
      if (data is String) return data;
    } catch (_) {}
    return e.message ?? 'Network Error';
  }

  @override
  Future<TracksResponse> getTracks() async {
    try {
      final response = await api.getTracks();
      return TracksResponse.fromJson(response);
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  @override
  Future<JoinTrackResponse> joinTrack(String trackId) async {
    try {
      final response = await api.joinTrack(trackId);

      return JoinTrackSuccess(
        JoinTrackSuccessResponse.fromJson(response),
      );
    } on DioException catch (e) {
      if (e.response?.data != null &&
          e.response!.data is Map<String, dynamic>) {
        final error = JoinTrackErrorResponse.fromJson(e.response!.data);
        return JoinTrackFailure(error);
      }

      return JoinTrackFailure(
        JoinTrackErrorResponse(message: _getServerErrorMessage(e)),
      );
    } catch (e) {
      return JoinTrackFailure(
        JoinTrackErrorResponse(message: e.toString()),
      );
    }
  }

  String _getServerErrorMessage(DioException e) {
    try {
      final data = e.response?.data;
      if (data != null) {
        if (data is Map && data['message'] != null) {
          return data['message'].toString();
        } else if (data is String) {
          return data;
        }
      }
    } catch (_) {}
    return e.message ?? "Network Error";
  }

  @override
  Future<List<GetChatModel>> getPublicChats() async {
    final response = await api.getMyChatsPublic();

    final chats = response.chats.where((chat) => chat.type == "track").toList();

    return chats;
  }

  @override
  Future<List<GetChatModel>> getPrivateChats() async {
    try {
      final currentUserId = await LocalStorage.getUserId() ?? '';

      final response = await api.getMyChatsPublic();

      final chats = response.chats.where((chat) {
        final isPrivate = chat.type == "private";

        final hasOtherUser =
        chat.participants.any((p) => p.id.trim() != currentUserId.trim());

        final hasMessage = chat.lastMessage != null;

        return isPrivate && hasOtherUser && hasMessage;
      }).toList();

      return chats;
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  @override
  Future<int> getUnreadCount(String chatId) async {
    final currentUserId = await LocalStorage.getUserId() ?? '';

    final response = await api.getMessages(chatId, page: 1, limit: 1000);

    final messages = response['messages'] ?? [];

    return (messages as List).where((msg) {
      final senderId = msg['senderId']?['_id'];

      if (senderId == currentUserId) return false;

      // readBy items can be plain strings OR populated Map objects
      final rawReadBy = msg['readBy'] ?? [];
      final readByIds = (rawReadBy as List).map((e) {
        if (e is Map) {
          return (e['_id'] ?? e['id'] ?? e).toString();
        }
        return e.toString();
      }).toList();

      return !readByIds.contains(currentUserId);
    }).length;
  }

  @override
  Future<ChatHistoryResponse> getMessages(String chatId,
      {int page = 1, int limit = 20}) async {
    try {
      final response = await api.getMessages(chatId, page: page, limit: limit);

      final messagesJson =
          response['messages'] ?? response['data'] ?? response['docs'] ?? [];

      final messages = <ChatMessage>[];
      if (messagesJson is List) {
        for (var item in messagesJson) {
          if (item is Map<String, dynamic>) {
            messages.add(ChatMessage.fromJson(item));
          }
        }
      }

      return ChatHistoryResponse(
        message: response['message']?.toString() ?? 'Done',
        userId: response['userId']?.toString() ?? '',
        messages: messages,
        total: response['total'] ?? messages.length,
        page: response['page'] ?? page,
        totalPages: response['totalPages'] ?? 1,
      );
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  @override
  Future<SendMessageResponse> sendMessage(String chatId, String content,
      String type,
      {String? replyTo}) async {
    try {
      final response =
      await api.sendMessage(chatId, content, type, replyTo: replyTo);

      return SendMessageResponse.fromJson(response);
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  @override
  Future<void> markMessagesAsRead(String chatId) async {
    try {
      await api.markMessagesAsRead(chatId);
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  @override
  Future<void> editMessage(String chatId, String messageId,
      String content) async {
    try {
      await api.editMessage(chatId, messageId, content);
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  @override
  Future<void> deleteMessage(String chatId, String messageId) async {
    try {
      await api.deleteMessage(chatId, messageId);
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  @override
  Future<void> leaveChat(String chatId) async {
    try {
      await api.leaveChat(chatId);
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  @override
  Future<List<MessageModel>> searchMessages(String chatId, String query) async {
    try {
      final response = await api.searchMessages(chatId, query);

      final searchResponse = SearchResponse.fromJson(response);

      return searchResponse.results;
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }
}