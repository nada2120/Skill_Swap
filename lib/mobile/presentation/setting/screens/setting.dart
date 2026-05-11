import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:skill_swap/shared/bloc/change_password_bloc/change_password_bloc.dart';
import 'package:skill_swap/shared/bloc/delete_account_bloc/delete_account_bloc.dart';
import 'package:skill_swap/shared/common_ui/base_screen.dart';

import '../../../../shared/bloc/logout_bloc/logout_bloc.dart';
import '../../../../shared/bloc/track_cubit/skills_cubit.dart';
import '../../../../shared/bloc/update_profile_bloc/update_profile_bloc.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../profile/widgets/profile_tabs.dart';
import '../pages/account_page.dart';
import '../pages/edit_profile_page.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen>
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
        title: "settings".tr,
        child: Column(
          children: [
            ProfileTabs(
              tabController: _tabController,
              tabs: ['edit_profile'.tr, 'preferences'.tr],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  MultiBlocProvider(
                    providers: [
                      // BlocProvider(
                      //     create: (_) =>
                      //         sl<MyProfileCubit>()..fetchMyProfile()),
                      BlocProvider(create: (_) => sl<LogoutBloc>()),
                      BlocProvider(create: (_) => sl<DeleteAccountBloc>()),
                      BlocProvider(create: (_) => sl<ChangePasswordBloc>()),
                      BlocProvider(create: (_) => sl<UpdateProfileBloc>()),
                      BlocProvider(
                          create: (_) => GetIt.instance<SkillsCubit>()),
                    ],
                    child: const EditProfilePage(),
                  ),
                  SettingsPage(),
                ],
              ),
            ),
          ],
        ));
  }
}
