import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../pages/overview_page.dart';
import '../pages/reviews_page.dart';
import '../pages/skills_page.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_tabs.dart';

class ProfileScreen extends StatefulWidget {
  final int initialTab;

  const ProfileScreen({super.key, this.initialTab = 0});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: widget.initialTab);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    return Scaffold(
      body: Stack(
        children: [
          Column(children: [
            // BlocProvider(
            //     create: (_) => sl<MyProfileCubit>()..fetchMyProfile(),
            //     child: const ProfileHeader()),
            const ProfileHeader()
          ]),
          Positioned(
            top: 184,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: screenHeight),
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  ProfileTabs(
                      tabController: _tabController,
                      tabs: ['overview'.tr, 'skills'.tr, 'reviews'.tr]),
                  Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: const [
                          OverviewPage(),
                          SkillsPage(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: ReviewsPage(),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
