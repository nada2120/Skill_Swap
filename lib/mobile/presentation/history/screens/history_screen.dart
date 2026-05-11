import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skill_swap/shared/common_ui/base_screen.dart';

import '../../profile/widgets/profile_tabs.dart';
import '../pages/completed_page.dart';
import '../pages/review_page.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
        title: "history_sessions".tr,
        child: Column(
          children: [
            ProfileTabs(
              tabController: _tabController,
              tabs: ['completed'.tr, /*'cancelled'.tr*/ 'reviews'.tr],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  CompletedSessionsPage(),
                  // CancelSessionsPage(),
                  //IssueSessionsPage(),
                  ReviewSessionsPage()
                ],
              ),
            ),
          ],
        ));
  }
}
