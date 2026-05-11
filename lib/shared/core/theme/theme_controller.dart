import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();

  ThemeMode themeMode = ThemeMode.system;

  @override
  void onInit() {
    super.onInit();
    loadSavedTheme();
  }

  void changeTheme(ThemeMode mode) {
    themeMode = mode;
    _box.write('theme', mode.name);
    update();
  }

  void loadSavedTheme() {
    final savedTheme = _box.read('theme');

    if (savedTheme != null) {
      themeMode = ThemeMode.values.firstWhere(
        (e) => e.name == savedTheme,
        orElse: () => ThemeMode.system,
      );
    }
  }

  bool isDarkMode(BuildContext context) {
    if (themeMode == ThemeMode.system) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return themeMode == ThemeMode.dark;
  }
}
