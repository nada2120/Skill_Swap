import 'package:flutter/material.dart';

import '../../../../shared/core/theme/app_palette.dart';

class ProfileTabs extends StatelessWidget {
  final TabController tabController;
  final List<String> tabs;

  const ProfileTabs({
    Key? key,
    required this.tabController,
    required this.tabs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Color backgroundColor = Color(0xFFF2F5F8);
    const Color indicatorColor = Colors.blue;
    const double borderRadiusValue = 20;
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Theme
              .of(context)
              .cardColor,
          borderRadius: BorderRadius.circular(borderRadiusValue),
          border: Border.all(color: Theme
              .of(context)
              .dividerColor),
        ),
        child: TabBar(
          controller: tabController,
          indicator: BoxDecoration(
            color: AppPalette.primary,
            borderRadius: BorderRadius.circular(borderRadiusValue - 2),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: Colors.transparent,
          labelColor: Colors.white,
          unselectedLabelColor: isDark
              ? AppPalette.darkTextSecondary
              : AppPalette.lightTextSecondary,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 10,
          ),
          unselectedLabelStyle: TextStyle(
            color: isDark
                ? Colors.white
                : (isDark
                ? AppPalette.darkTextSecondary
                : AppPalette.lightTextSecondary),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          tabs: tabs.map((title) => Tab(text: title)).toList(),
        ),
      ),
    );
  }
}
