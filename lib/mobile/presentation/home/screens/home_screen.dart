import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/mobile/presentation/game_part/game_section.dart';
import 'package:skill_swap/mobile/presentation/home/widgets/next_session_section.dart';
import 'package:skill_swap/shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import 'package:skill_swap/shared/bloc/get_users_cubit/users_cubit.dart';
import 'package:skill_swap/shared/bloc/private_chats_bloc/private_chats_event.dart';

import '../../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../../../../shared/bloc/private_chats_bloc/private_chats_bloc.dart';
import '../../../../shared/bloc/private_chats_bloc/private_chats_state.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../../../shared/helper/home_controller.dart';
import '../../history_private_chats/private_chats_list.dart';
import '../pages/top_users_view_all.dart';
import '../widgets/custom_header.dart';
import '../widgets/recommended_section.dart';
import '../widgets/section_header.dart';
import '../widgets/top_users_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController controller = Get.put(HomeController());

  final ScrollController _topUsersController = ScrollController();
  final ScrollController _recommendedController = ScrollController();

  @override
  void initState() {
    super.initState();

    context.read<MyProfileCubit>().fetchMyProfile();
    context.read<GetBookingsCubit>().fetchTodayNextSessions();
  }

  @override
  void dispose() {
    _topUsersController.dispose();
    _recommendedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              BlocBuilder<MyProfileCubit, MyProfileState>(
                builder: (context, profileState) {
                  String id = "";
                  String name = "User";
                  String avatarPath = 'assets/images/placeholder.png';

                  if (profileState is MyProfileLoaded) {
                    name = profileState.profile.name ?? name;
                    id = profileState.profile.id ?? id;

                    if (profileState.profile.userImage?.secureUrl?.isNotEmpty ==
                        true) {
                      avatarPath = profileState.profile.userImage!.secureUrl!;
                    }
                  }

                  final unreadCount = context.select<PrivateChatsBloc, int>(
                    (bloc) => bloc.unreadMap.values.fold(0, (a, b) => a + b),
                  );

                  return CustomHeader(
                    name: 'Hi, $name',
                    subtitle: 'keep_learning'.tr,
                    avatarPath: avatarPath,
                    unreadCount: unreadCount,
                    onIcon2: () {
                      final bloc = context.read<PrivateChatsBloc>();
                      Get.to(() => BlocProvider.value(
                            value: bloc..add(GetPrivateChatsEvent()),
                            child: PrivateChatsListScreen(currentUserId: id),
                          ));
                    },
                  );
                },
              ),
            ],
          ),
          Positioned(
            top: screenHeight * 0.15,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: screenHeight * 0.85),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(screenWidth * 0.06),
                  topRight: Radius.circular(screenWidth * 0.06),
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (controller.showGameFirst.value) ...[
                        GameSection(),
                        SizedBox(height: screenHeight * 0.03),
                      ],
                      SectionHeader(
                        sectionTitle: 'top_users'.tr,
                        onTop: () {
                          Get.to(
                            BlocProvider(
                              create: (_) =>
                                  sl<UsersCubit>()..fetchUsers(reset: true),
                              child: TopUsersViewAll(),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      TopUsersSection(),
                      SizedBox(height: screenHeight * 0.03),
                      NextSessionSection(),
                      SizedBox(height: screenHeight * 0.03),
                      // BlocBuilder<MyProfileCubit, MyProfileState>(
                      //   builder: (context, state) {
                      //     String track = '';
                      //
                      //     if (state is MyProfileLoaded) {
                      //       track = state.profile.track.name ?? '';
                      //     }
                      //
                      //     return SectionHeader(
                      //       sectionTitle: 'recommended_for_you'.tr,
                      //       onTop: () {
                      //         Get.to(
                      //           RecommendedViewAll(track: track),
                      //         );
                      //       },
                      //     );
                      //   },
                      // ),
                      // SizedBox(height: screenHeight * 0.01),
                      RecommendedSection(),
                      SizedBox(height: screenHeight * 0.01),
                      // UnrealExperienceCard(),
                      if (!controller.showGameFirst.value) ...[
                        SizedBox(height: screenHeight * 0.03),
                        GameSection(),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
