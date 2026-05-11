import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:skill_swap/shared/data/web_services/notification/test_notification_request.dart';

import 'notification_request.dart';

part 'notification_api.g.dart';

@RestApi(baseUrl: "https://skill-swaapp.vercel.app/")
abstract class NotificationApi {
  factory NotificationApi(Dio dio, {String baseUrl}) = _NotificationApi;

  /// save fcm token
  @POST("user/fcm-token")
  Future<Map<String, dynamic>> saveFcmToken(
    @Body() NotificationRequest body,
  );

  /// delete fcm token
  @DELETE("user/fcm-token")
  Future<void> deleteFcmToken();

  /// send notification to a specific user
  @POST("user/fcm-token/test")
  Future<Map<String, dynamic>> sendNotification(
    @Body() SendNotificationRequest body,
  );
}
