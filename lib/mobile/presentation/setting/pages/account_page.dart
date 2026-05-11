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
  // App Preferences
  bool darkMode = true;
  String language = 'English';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final sectionPadding = EdgeInsets.all(screenWidth * 0.02);
    final sectionMargin = EdgeInsets.symmetric(
        vertical: screenWidth * 0.02, horizontal: screenWidth * 0.04);
    final sectionRadius = BorderRadius.circular(screenWidth * 0.03);
    final textStyleSize = screenWidth * 0.045;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: ListView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        children: [
          Container(
            padding: sectionPadding,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: sectionRadius,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'app_preferences'.tr,
                  style: TextStyle(
                      fontSize: textStyleSize,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.bodyLarge!.color),
                ),
                SizedBox(height: screenWidth * 0.02),
                GetBuilder<ThemeController>(builder: (controller) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.dark_mode_outlined,
                              size: screenWidth * 0.06),
                          SizedBox(width: screenWidth * 0.03),
                          Text('theme'.tr,
                              style: TextStyle(fontSize: screenWidth * 0.045)),
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
                SizedBox(height: screenWidth * 0.02),
                GetBuilder<LanguageController>(
                  builder: (controller) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.language_outlined,
                                size: screenWidth * 0.06),
                            SizedBox(width: screenWidth * 0.03),
                            Text('language'.tr,
                                style:
                                    TextStyle(fontSize: screenWidth * 0.045)),
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
                SizedBox(height: screenWidth * 0.02),
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
    final screenWidth = MediaQuery.of(Get.context!).size.width;

    return SwitchListTile(
      contentPadding: EdgeInsets.symmetric(vertical: screenWidth * 0.005),
      title: Text(title, style: TextStyle(fontSize: screenWidth * 0.04)),
      subtitle: subtitle != null
          ? Text(subtitle, style: TextStyle(fontSize: screenWidth * 0.035))
          : null,
      secondary: Icon(icon, size: screenWidth * 0.065),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.white,
      activeTrackColor: AppPalette.primary,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity(horizontal: -4, vertical: -4),
    );
  }
}
