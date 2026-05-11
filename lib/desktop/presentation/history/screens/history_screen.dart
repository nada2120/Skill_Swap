import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
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
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    final didGoBack = desktopKey.currentState?.goBack();
                    if (didGoBack == false) {
                      desktopKey.currentState?.openPage(index: 0);
                    }
                  },
                ),
                SizedBox(
                  width: 16,
                ),
                Text(
                  "history_sessions".tr,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            ProfileTabs(
              tabController: _tabController,
              tabs: ['completed'.tr, 'reviews'.tr],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  CompletedSessionsPage(),
                  //CancelSessionsPage(),
                  //IssueSessionsPage(),
                  ReviewSessionsPage()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
