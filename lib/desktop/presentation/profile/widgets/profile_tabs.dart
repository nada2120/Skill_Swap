import 'package:flutter/material.dart';
import 'package:skill_swap/shared/core/theme/app_palette.dart';

class ProfileTabs extends StatelessWidget {
  final TabController tabController;
  final List<String> tabs;

  const ProfileTabs({
    super.key,
    required this.tabController,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        labelColor: AppPalette.primary,
        unselectedLabelColor:
        isDark ? Colors.white70 : Colors.grey.shade600,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 16,
        ),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: AppPalette.primary, width: 3),
          insets: const EdgeInsets.symmetric(horizontal: 16),
        ),
        tabs: tabs.map((title) => Tab(text: title)).toList(),
      ),
    );
  }
}