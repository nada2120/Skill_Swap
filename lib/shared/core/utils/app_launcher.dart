import 'dart:io';

import 'package:flutter_device_apps/flutter_device_apps.dart'; // ده الـ import الصح

class AppLauncher {
  static Future<void> openUnrealGame() async {
    if (!Platform.isAndroid) return;

    const packageName = 'com.YourCompany.MyProject2';

    // التحقق إذا مثبت (بدل isAppInstalled)
    final appInfo = await FlutterDeviceApps.getApp(packageName);

    if (appInfo != null) {
      // التطبيق مثبت → افتحه
      await FlutterDeviceApps.openApp(packageName);
    } else {
      print("Game not installed");
      // اختياري: افتحي Play Store لو مش موجود
      // final intent = AndroidIntent(
      //   action: 'action_view',
      //   data: 'market://details?id=$packageName',
      //   flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
      // );
      // await intent.launch();
    }
  }
}
