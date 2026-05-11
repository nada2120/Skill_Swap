import 'dart:io';

import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart'
    show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:skill_swap/shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import 'package:skill_swap/shared/common_ui/screen_manager/screen_manager.dart';
import 'package:skill_swap/shared/core/localization/app_translation.dart';
import 'package:skill_swap/shared/core/localization/language_controller.dart';
import 'package:skill_swap/shared/core/services/notification_service.dart';
import 'package:skill_swap/shared/core/theme/theme_controller.dart';
import 'package:skill_swap/shared/data/quiz/quiz_controller.dart';
import 'package:skill_swap/shared/dependency_injection/injection.dart';
import 'package:skill_swap/shared/helper/local_storage.dart';

import 'desktop/presentation/common/desktop_screen_manager.dart';
import 'desktop/presentation/sign/screens/sign_in_screen.dart';
import 'firebase_options.dart';
import 'mobile/presentation/forget_password/screens/email_verification_screen.dart';
import 'mobile/presentation/onboarding_screen/screens/onboarding.dart';
import 'mobile/presentation/select_skills/select_track.dart';
import 'mobile/presentation/sign/screens/sign_in_screen.dart';

final GlobalKey<DesktopScreenManagerState> desktopKey =
    GlobalKey<DesktopScreenManagerState>();

@pragma('vm:entry-point')
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final FlutterLocalNotificationsPlugin localNotifications =
      FlutterLocalNotificationsPlugin();

  await localNotifications.initialize(
    settings: const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
  );

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    NotificationService.androidChannelId,
    NotificationService.androidChannelName,
    importance: Importance.max,
  );

  await localNotifications
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  if (message.notification != null) return;

  await localNotifications.show(
    id: DateTime.now().millisecondsSinceEpoch % 2147483647,
    title: message.notification?.title ?? message.data["title"] ?? "SkillSwap",
    // ✅
    body: message.notification?.body ?? message.data["body"] ?? "",
    // ✅
    notificationDetails: const NotificationDetails(
      android: AndroidNotificationDetails(
        NotificationService.androidChannelId,
        NotificationService.androidChannelName,
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ CRITICAL for Flutter Desktop: initializes the native WebRTC engine.
  // Without this, the app crashes silently ~3-5 seconds after the camera stream starts.
  // if (!kIsWeb &&
  //     (defaultTargetPlatform == TargetPlatform.windows ||
  //         defaultTargetPlatform == TargetPlatform.macOS ||
  //         defaultTargetPlatform == TargetPlatform.linux)) {
  //   await WebRTC.initialize();
  // }

  final dir = await getApplicationDocumentsDirectory();
  await Hive.initFlutter(dir.path);
  await Hive.openBox('appBox');

  try {
    Gemini.init(apiKey: QuizController.apiKey);
  } catch (_) {}

  await initDependencies();
  await GetStorage.init();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

  print("🔥🔥🔥 BEFORE INIT");
  await NotificationService.init();
  print("🔥🔥🔥 AFTER INIT");

  final isOnboardingSeen = LocalStorage.isOnboardingSeen();
  final isLogged = LocalStorage.isLoggedIn();
  final track = LocalStorage.getUserTrack();
  final isActive = LocalStorage.getIsActive();
  final email = LocalStorage.getEmail();

  Widget startScreen;

  if (!isOnboardingSeen) {
    startScreen = OnBoardingScreen();
  } else if (!isLogged) {
    startScreen = const SignInScreen();
  } else if (isLogged &&
      (track == null || track.isEmpty) &&
      !Platform.isWindows) {
    startScreen = SelectTrackScreen();
  } else if (isLogged && isActive == null && !Platform.isWindows) {
    startScreen = EmailVerificationScreen(email: email ?? "");
  } else {
    startScreen = LayoutBuilder(
      builder: (context, constraints) {
        if (kIsWeb) return ScreenManager();

        final width = MediaQuery.of(context).size.width;

        if (defaultTargetPlatform == TargetPlatform.windows) {
          return SignInDesktop();
        }
        return ScreenManager();
      },
    );
  }

  Get.put(ThemeController()..loadSavedTheme());

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => MyApp(startScreen: startScreen),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget startScreen;

  const MyApp({super.key, required this.startScreen});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.put(ThemeController());
    final languageController = Get.put(LanguageController());

    return GetBuilder<ThemeController>(
      builder: (controller) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => sl<MyProfileCubit>()..fetchMyProfile(),
            ),
          ],
          child: GetMaterialApp(
            title: 'SkillSwap',
            debugShowCheckedModeBanner: false,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeController.themeMode,
            translations: AppTranslation(),
            locale: languageController.initialLanguage,
            fallbackLocale: const Locale("en", "US"),
            home: startScreen,
          ),
        );
      },
    );
  }
}
