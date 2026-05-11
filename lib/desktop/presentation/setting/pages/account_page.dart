import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../shared/core/localization/language_controller.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/core/theme/theme_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Notification settings
  bool emailNotifications = true;
  bool pushNotifications = true;
  bool newMessages = true;
  bool sessionReminders = true;

  // Privacy settings
  bool profileVisibility = true;
  bool showOnlineStatus = true;
  bool directMessages = true;

  // App Preferences
  bool darkMode = false;
  bool soundEffects = true;
  String language = 'English';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final sectionPadding = const EdgeInsets.all(8.0);
    final sectionMargin =
    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0);
    final sectionRadius = BorderRadius.circular(12);

    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            //  margin: sectionMargin,
            padding: sectionPadding,
            decoration: BoxDecoration(
              color: Theme
                  .of(context)
                  .cardColor,
              border: Border.all(color: Theme
                  .of(context)
                  .dividerColor),
              borderRadius: sectionRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'app_preferences'.tr,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme
                          .of(context)
                          .textTheme
                          .bodyLarge!
                          .color),
                ),
                const SizedBox(height: 8),
                GetBuilder<ThemeController>(builder: (controller) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.dark_mode_outlined,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'theme'.tr,
                          ),
                        ],
                      ),
                      DropdownButton<ThemeMode>(
                        value: controller.themeMode,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(
                            value: ThemeMode.system,
                            child: Text('System'),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.light,
                            child: Text('Light'),
                          ),
                          DropdownMenuItem(
                            value: ThemeMode.dark,
                            child: Text('Dark'),
                          ),
                        ],
                        onChanged: (mode) {
                          controller.changeTheme(mode!);
                        },
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 8),
                GetBuilder<LanguageController>(
                  builder: (controller) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.language_outlined,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'language'.tr,
                            ),
                          ],
                        ),
                        DropdownButton<String>(
                          value: controller.currentLangCode,
                          underline: const SizedBox(),
                          items: const [
                            DropdownMenuItem(
                                value: 'en', child: Text('English')),
                            DropdownMenuItem(
                                value: 'ar', child: Text('العربية')),
                          ],
                          onChanged: (value) {
                            controller.changeLanguage(value!);
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Custom switch widget for all cases
  Widget customSwitch({
    required String title,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
    String? subtitle,
  }) {
    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: subtitle != null
          ? Text(subtitle, style: const TextStyle(fontSize: 12))
          : null,
      secondary: Icon(icon),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.white,
      activeTrackColor: AppPalette.primary,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
    );
  }
}
