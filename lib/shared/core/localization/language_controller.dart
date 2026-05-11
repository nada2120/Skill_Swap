import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  final box = GetStorage();

  Locale get initialLanguage {
    String? langCode = box.read('lang');

    if (langCode != null) {
      return langCode == 'ar'
          ? const Locale('ar', 'EG')
          : const Locale('en', 'US');
    }

    Locale deviceLocale = Get.deviceLocale ?? const Locale('en', 'US');

    return deviceLocale.languageCode == 'ar'
        ? const Locale('ar', 'EG')
        : const Locale('en', 'US');
  }

  String get currentLangCode {
    String? langCode = box.read('lang');

    if (langCode != null) return langCode;

    Locale deviceLocale = Get.deviceLocale ?? const Locale('en', 'US');

    return deviceLocale.languageCode == 'ar' ? 'ar' : 'en';
  }

  void changeLanguage(String langCode) {
    Locale locale =
        langCode == 'ar' ? const Locale('ar', 'EG') : const Locale('en', 'US');

    Get.updateLocale(locale);
    box.write('lang', langCode);
    update();
  }
}
