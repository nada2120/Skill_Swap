import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/desktop/presentation/profile/widgets/profile_header.dart';
import 'package:skill_swap/desktop/presentation/profile/widgets/profile_tabs.dart';

import '../../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../pages/overview_page.dart';
import '../pages/reviews_page.dart';
import '../pages/skills_page.dart';

class ProfileScreen extends StatefulWidget {
  final int initialTab;

  const ProfileScreen({
    super.key,
    this.initialTab = 0,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTab,
    );
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialTab != widget.initialTab) {
      _tabController.animateTo(widget.initialTab);
    }
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
            BlocProvider(
              create: (_) => sl<MyProfileCubit>()..fetchMyProfile(),
              child: const ProfileHeader(),
            ),
            ProfileTabs(
              tabController: _tabController,
              tabs: [
                'overview'.tr,
                'skills'.tr,
                'reviews'.tr,
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: const [
                  OverviewPage(),
                  SkillsPage(),
                  ReviewsPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
