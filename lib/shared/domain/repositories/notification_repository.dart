abstract class NotificationRepository {
  Future<void> saveFcmToken(String token);

  Future<void> deleteFcmToken();

  /// Send a push notification to a specific user
  Future<void> sendNotification({
    required String receiverId,
    required String type,
    Map<String, dynamic> payload,
  });
}
