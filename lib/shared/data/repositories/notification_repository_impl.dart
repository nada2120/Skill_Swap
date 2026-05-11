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

      await api.sendNotification(
        SendNotificationRequest(
          receiverId: receiverId,
          type: type,
          payload: payload,
        ),
      );
      log("Notification sent: type=$type, to=$receiverId");
    } catch (e) {
      // Don't crash the main flow if notification fails
      log("Error sending notification: $e");
    }
  }
}