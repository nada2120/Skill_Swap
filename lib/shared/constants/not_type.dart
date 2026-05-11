/// Notification type constants that match the backend NOTIFICATION_TYPES
/// and Flutter's NotificationService._navigateByType() handler.
class NotificationTypes {
  NotificationTypes._();

  static const String newBooking = 'new_booking';
  static const String requestAccepted = 'request_accepted';
  static const String requestRejected = 'request_rejected';
  static const String bookingCancelled = 'booking_cancelled';
  static const String chatMessage = 'chat_message';
  static const String sessionReminder = 'session_reminder';
  static const String sessionStarted = 'session_started';
  static const String ratingRequest = 'rating_request';
}
