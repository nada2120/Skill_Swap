import 'package:dio/dio.dart';

import '../../models/public_chat/chat_response_model.dart';

/// Plain Dio-based chat API service (no Retrofit code generation needed).
class ChatApiService {
  final Dio _dio;
  static const String _baseUrl = 'https://skill-swaapp.vercel.app';

  ChatApiService(this._dio);

  /// POST /chat/private — Create or get existing private chat
  Future<Map<String, dynamic>> createOrGetPrivateChat(String partnerId) async {
    final response = await _dio.post(
      '$_baseUrl/chat/private',
      data: {'partnerId': partnerId},
    );
    return response.data is Map<String, dynamic>
        ? response.data
        : <String, dynamic>{};
  }

  /// GET /chat/my-chats — Fetch user's private chats
  Future<List<dynamic>> getMyChats() async {
    final response = await _dio.get('$_baseUrl/chat/my-chats');

    if (response.data is List) {
      return response.data;
    }

    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;

      if (data['chats'] is List) return data['chats'];
      if (data['data'] is List) return data['data'];
    }

    return [];
  }

  /// GET /chat/{chatId}/messages?page=X&limit=Y
  Future<Map<String, dynamic>> getMessages(
    String chatId, {
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _dio.get(
      '$_baseUrl/chat/$chatId/messages',
      queryParameters: {'page': page, 'limit': limit},
    );

    return response.data is Map<String, dynamic>
        ? response.data
        : <String, dynamic>{};
  }

  /// POST /chat/{chatId}/message — Send a message
  Future<Map<String, dynamic>> sendMessage(
    String chatId,
    String content,
    String type, {
    String? replyTo,
  }) async {
    final Map<String, dynamic> data = {'content': content, 'type': type};
    if (replyTo != null) {
      data['replyTo'] = replyTo;
    }

    final response = await _dio.post(
      '$_baseUrl/chat/$chatId/message',
      data: data,
    );

    return response.data is Map<String, dynamic>
        ? response.data
        : <String, dynamic>{};
  }

  /// GET /chat/my-chats — Fetch user's public chats
  Future<ChatResponseModel> getMyChatsPublic() async {
    final response = await _dio.get('$_baseUrl/chat/my-chats');

    return ChatResponseModel.fromJson(response.data);
  }

  /// GET /chat/tracks — Get all tracks
  Future<Map<String, dynamic>> getTracks() async {
    final response = await _dio.get('$_baseUrl/chat/tracks');

    return response.data is Map<String, dynamic>
        ? response.data
        : <String, dynamic>{};
  }

  /// POST /chat/track/{trackId}/join — Join a track
  Future<Map<String, dynamic>> joinTrack(String trackId) async {
    final response = await _dio.post(
      '$_baseUrl/chat/track/$trackId/join',
    );

    return response.data is Map<String, dynamic>
        ? response.data
        : <String, dynamic>{};
  }

  /// PATCH /chat/{chatId}/messages/read — Mark all unread messages as read
  Future<Map<String, dynamic>> markMessagesAsRead(String chatId) async {
    final response = await _dio.patch(
      '$_baseUrl/chat/$chatId/messages/read',
    );

    return response.data is Map<String, dynamic>
        ? response.data
        : <String, dynamic>{};
  }

  /// PATCH /chat/{chatId}/message/{messageId} — Edit a message
  Future<Map<String, dynamic>> editMessage(
    String chatId,
    String messageId,
    String content,
  ) async {
    final response = await _dio.patch(
      '$_baseUrl/chat/$chatId/message/$messageId',
      data: {'content': content},
    );

    return response.data is Map<String, dynamic>
        ? response.data
        : <String, dynamic>{};
  }

  /// DELETE /chat/{chatId}/message/{messageId} — Delete a message
  Future<Map<String, dynamic>> deleteMessage(
    String chatId,
    String messageId,
  ) async {
    final response = await _dio.delete(
      '$_baseUrl/chat/$chatId/message/$messageId',
    );

    return response.data is Map<String, dynamic>
        ? response.data
        : <String, dynamic>{};
  }

  /// DELETE /chat/{chatId}/leave — Leave a group chat
  Future<Map<String, dynamic>> leaveChat(String chatId) async {
    final response = await _dio.delete(
      '$_baseUrl/chat/$chatId/leave',
    );

    return response.data is Map<String, dynamic>
        ? response.data
        : <String, dynamic>{};
  }

  /// GET /chat/{chatId}/search?q=hello
  Future<Map<String, dynamic>> searchMessages(
      String chatId, String query) async {
    final response = await _dio.get(
      '$_baseUrl/chat/$chatId/search',
      queryParameters: {'q': query},
    );

    return response.data is Map<String, dynamic>
        ? response.data
        : <String, dynamic>{};
  }
}
