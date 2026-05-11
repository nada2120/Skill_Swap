import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/desktop/presentation/profile/widgets/profile_tabs.dart';
import 'package:skill_swap/desktop/presentation/sessions/pages/pending_sessions_page.dart';
import 'package:skill_swap/desktop/presentation/sessions/pages/requests_sessions_page.dart';
import 'package:skill_swap/desktop/presentation/sessions/pages/rjected_session_page.dart';
import 'package:skill_swap/desktop/presentation/sessions/pages/upcoming_sessions_page.dart';
import 'package:skill_swap/desktop/presentation/sessions/widgets/session_header.dart';

import '../../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';

class SessionsScreen extends StatefulWidget {
  final int initialTab;

  const SessionsScreen({
    super.key,
    this.initialTab = 0,
  });

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: 4,
      vsync: this,
      initialIndex: widget.initialTab,
    );

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      _fetchByIndex(_tabController.index);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchByIndex(_tabController.index);
    });
  }

  @override
  void didUpdateWidget(covariant SessionsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialTab != widget.initialTab) {
      _tabController.animateTo(widget.initialTab);
      _fetchByIndex(widget.initialTab);
    }
  }

  void _fetchByIndex(int index) {
    final cubit = context.read<GetBookingsCubit>();

    switch (index) {
      case 0:
        cubit.fetchAllBookings("accepted");
        break;
      case 1:
        cubit.fetchAllBookings("pending");
        break;
      case 2:
        cubit.fetchAllBookings("request");
      case 3:
        cubit.fetchAllBookings("rejected");
        break;
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
            SessionsHeader(
              title: "sessions".tr,
              subtitle: "track_upcoming".tr,
            ),
            ProfileTabs(
              tabController: _tabController,
              tabs: ['accepted'.tr, 'pending'.tr, 'request'.tr, 'rejected'],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  UpcomingSessionsPage(),
                  PendingSessionsPage(),
                  RequestsSessionsPage(),
                  RejectedSessionsPage()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
