import 'dart:developer';

import '../../core/services/notification_service.dart';
import '../../domain/repositories/notification_repository.dart';
import '../web_services/notification/notification_api.dart';
import '../web_services/notification/notification_request.dart';
import '../web_services/notification/test_notification_request.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationApi api;

  NotificationRepositoryImpl(this.api);

  @override
  Future<void> saveFcmToken(String token) async {
    await api.saveFcmToken(
      NotificationRequest(fcmToken: token),
    );
  }

  @override
  Future<void> deleteFcmToken() async {
    await api.deleteFcmToken();
  }

  @override
  Future<void> sendNotification({
    required String receiverId,
    required String type,
    Map<String, dynamic> payload = const {},
  }) async {
    try {
      // Locally suppress this type so our own device ignores the bounce-back
      NotificationService.suppressType(type);

      final title = _buildTitle(type, payload);
      final body = _buildBody(type, payload);
      final enrichedPayload = {
        ...payload,
        'type': type,
        'title': title,
        'body': body,
      };

      final request = SendNotificationRequest(
        receiverId: receiverId,
        type: type,
        title: title,
        body: body,
        payload: enrichedPayload,
      );

      log("Notification API request: ${request.toJson()}");

      final response = await api.sendNotification(
        request,
      );
      log("Notification API response: $response");
      log("Notification sent: type=$type, to=$receiverId");
    } catch (e) {
      // Don't crash the main flow if notification fails
      log("Error sending notification: $e");
    }
  }

  String _buildTitle(String type, Map<String, dynamic> payload) {
    switch (type) {
      case 'chat_message':
        return payload['senderName']?.toString() ?? 'New message';
      case 'new_booking':
        return 'New booking request';
      case 'request_accepted':
        return 'Request accepted';
      case 'request_rejected':
        return 'Request rejected';
      case 'booking_cancelled':
        return 'Booking cancelled';
      default:
        return 'SkillSwap';
    }
  }

  String _buildBody(String type, Map<String, dynamic> payload) {
    switch (type) {
      case 'chat_message':
        return payload['messagePreview']?.toString() ??
            'You have a new message';
      case 'new_booking':
        return 'You have a new session request.';
      case 'request_accepted':
        return 'Your session request has been accepted.';
      case 'request_rejected':
        return 'Your session request has been rejected.';
      case 'booking_cancelled':
        return 'A session booking was cancelled.';
      default:
        return payload['body']?.toString() ?? '';
    }
  }
}
