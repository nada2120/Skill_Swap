// import 'dart:io';
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_gemini/flutter_gemini.dart';
// import 'package:get_storage/get_storage.dart';
//
// import 'package:skill_swap/shared/core/services/notification_service.dart';
// import 'package:skill_swap/shared/data/quiz/quiz_controller.dart';
// import 'package:skill_swap/shared/helper/local_storage.dart';
//
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
//
// import 'package:skill_swap/mobile/presentation/video_call/LiveKeys.dart';
//
// @pragma('vm:entry-point')
// Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
//   if (Platform.isAndroid) {
//     await Firebase.initializeApp();
//   }
// }
//
// class MobileInit {
//   static Future<void> init() async {
//     await Firebase.initializeApp();
//
//     FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);
//
//     await NotificationService.init();
//
//     final userId = await LocalStorage.getUserId();
//     const userName = 'User';
//
//     await ZegoUIKitPrebuiltCallInvitationService().init(
//       appID: LiveKeys.appId,
//       appSign: LiveKeys.appSign,
//       userID: userId ?? '',
//       userName: userName,
//       plugins: [ZegoUIKitSignalingPlugin()],
//     );
//   }
//
//   static void initGemini() {
//     Gemini.init(apiKey: QuizController.apiKey);
//   }
// }