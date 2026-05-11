import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../../common_ui/screen_manager/screen_manager.dart';
import '../../dependency_injection/injection.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../helper/local_storage.dart';

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// Tracks notification types that we recently SENT, so we can suppress
  /// them when they bounce back to us via FCM.
  static final Map<String, DateTime> _suppressedTypes = {};
  static const Duration _suppressionWindow = Duration(seconds: 3);

  /// Call this right before sending a notification to suppress that type
  /// from showing up on this device.
  static void suppressType(String type) {
    _suppressedTypes[type] = DateTime.now();
    log('🔕 Suppressing notification type: $type');
  }

  /// Check if a notification type is currently suppressed.
  static bool _isSuppressed(String type) {
    final suppressedAt = _suppressedTypes[type];
    if (suppressedAt == null) return false;

    if (DateTime.now().difference(suppressedAt) > _suppressionWindow) {
      _suppressedTypes.remove(type);
      return false;
    }
    return true;
  }

  /// INIT
  static Future<void> init() async {
    print("🔥 INIT STARTED");

    try {
      await _requestPermission();
      print("✅ Permission done");
    } catch (e) {
      print("❌ Permission error: $e");
    }

    try {
      await _initLocalNotifications();
      print("✅ Local notification init");
    } catch (e) {
      print("❌ Local notification error: $e");
    }

    try {
      await _registerToken();
      print("✅ Token registered");
    } catch (e) {
      print("❌ Token error: $e");
    }

    _listenForeground();
    _listenClick();
    _listenTokenRefresh();

    print("🔥 INIT FINISHED");
  }

  /// REQUEST PERMISSION
  static Future<void> _requestPermission() async {
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    log("Notification Permission: ${settings.authorizationStatus}");
  }

  /// GET TOKEN + SEND TO BACKEND
  static Future<void> _registerToken() async {
    try {
      print("🚀 Getting FCM token...");

      String? token = await FirebaseMessaging.instance.getToken();

      print("🎯 TOKEN = $token");

      if (token == null) {
        print("❌ Token is NULL");
        return;
      }

      print("📡 Sending token to backend...");

      await sl<NotificationRepository>().saveFcmToken(token);

      print("✅ Token sent successfully");
    } catch (e) {
      print("🔥 ERROR in token: $e");
    }
  }

  /// TOKEN REFRESH
  static void _listenTokenRefresh() {
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      print("New FCM TOKEN: $newToken");

      try {
        await sl<NotificationRepository>().saveFcmToken(newToken);
      } catch (e) {
        print("Error updating token");
      }
    });
  }

  /// INIT LOCAL NOTIFICATION
  static Future<void> _initLocalNotifications() async {
    const AndroidInitializationSettings android =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: android);

    await _localNotifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        print("Notification clicked (local)");
      },
    );

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'channel_id',
      'General Notifications',
      importance: Importance.max,
    );
  }

  /// FOREGROUND
  static void _listenForeground() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log("FOREGROUND MESSAGE ARRIVED");
      log("NOTIFICATION: ${message.notification}");
      log("DATA: ${message.data}");

      // 1) Check senderId from data payload
      final senderId =
          message.data['senderId'] ?? message.data['sender_id'] ?? '';
      final currentUserId = LocalStorage.getUserId() ?? '';
      if (senderId.toString().isNotEmpty &&
          currentUserId.isNotEmpty &&
          senderId.toString() == currentUserId) {
        log("Skipping notification — sent by current user (senderId match)");
        return;
      }

      // 2) Check local suppression (for when Backend doesn't forward senderId)
      final notificationType = message.data['type'] ?? '';
      if (notificationType.toString().isNotEmpty &&
          _isSuppressed(notificationType.toString())) {
        log("Skipping notification — type '$notificationType' is locally suppressed");
        return;
      }

      _showLocalNotification(message);
    });
  }

  /// CLICK LISTENER
  static void _listenClick() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("Notification clicked");

      handleNotification(message);
    });
  }

  /// SHOW LOCAL NOTIFICATION
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      "channel_id",
      "General Notifications",
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    final title = message.notification?.title ??
        message.data["title"] ??
        "SkillSwap"; // ✅
    final body = message.notification?.body ?? message.data["body"] ?? ""; // ✅

    await _localNotifications.show(
      id: DateTime.now().millisecondsSinceEpoch % 2147483647,
      title: title,
      body: body,
      notificationDetails: details,
      payload: message.data["type"] ?? "",
    );
  }

  /// HANDLE NOTIFICATION NAVIGATION
  static void handleNotification(RemoteMessage message) {
    String type = message.data["type"] ?? "";

    switch (type) {
      case "chat_message":
        String chatId = message.data["chat_id"] ?? "";
        log("Open Chat: $chatId");
        break;

      case "request_accepted":
        log("Open Requests Screen");
        Get.offAll(() => ScreenManager(
              initialIndex: 3,
              initialSessionTab: 0,
            ));
        break;

      case "request_rejected":
        log("Request Rejected");
        break;

      case "session_reminder":
        log("Open Session Screen");
        break;

      case "session_started":
        log("Open Session Screen");
        break;

      case "rating_request":
        log("Open Session Screen");
        break;

      case "new_booking":
        log("Open Session Screen");
        Get.offAll(() => ScreenManager(
              initialIndex: 3,
              initialSessionTab: 2,
            ));
        break;

      case "booking_cancelled":
        log("Open Session Screen");
        break;

      default:
        log("Unknown notification type");
    }
  }

  /// LOGOUT
  static Future<void> deleteToken() async {
    try {
      await sl<NotificationRepository>().deleteFcmToken();
    } catch (e) {
      log("Error deleting FCM token");
    }
  }
}
