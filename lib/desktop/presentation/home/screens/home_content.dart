import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/desktop/presentation/home/pages/top_users_view_all.dart';
import 'package:skill_swap/main.dart';

import '../../../../desktop/presentation/game_part/game_section.dart';
import '../../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../../shared/bloc/get_users_cubit/users_cubit.dart';
import '../../../../shared/bloc/get_users_cubit/users_state.dart';
import '../../../../shared/helper/home_controller.dart';
import '../widgets/next_session_section.dart';
import '../widgets/recommended_section.dart';
import '../widgets/section_header.dart';
import '../widgets/top_users_section.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final ScrollController _topUsersScrollController = ScrollController();
  final ScrollController _recommendedScrollController = ScrollController();

  final HomeController controller = Get.put(HomeController());

  @override
  void initState() {
    super.initState();

    _topUsersScrollController.addListener(_topUsersScrollListener);
    _recommendedScrollController.addListener(_recommendedScrollListener);

    context.read<MyProfileCubit>().fetchMyProfile();
    context.read<GetBookingsCubit>().fetchTodayNextSessions();
  }

  void _topUsersScrollListener() {
    _handleScroll(_topUsersScrollController);
  }

  void _recommendedScrollListener() {
    _handleScroll(_recommendedScrollController);
  }

  void _handleScroll(ScrollController controller) {
    final cubit = context.read<UsersCubit>();

    if (controller.position.pixels >=
            controller.position.maxScrollExtent - 150 &&
        cubit.state is UsersLoaded) {
      final state = cubit.state as UsersLoaded;

      if (!state.isLoadingMore && !state.isLastPage) {
        cubit.fetchNextPage();
      }
    }
  }

  @override
  void dispose() {
    _topUsersScrollController.removeListener(_topUsersScrollListener);
    _topUsersScrollController.dispose();

    _recommendedScrollController.removeListener(_recommendedScrollListener);
    _recommendedScrollController.dispose();

    super.dispose();
  }

  Widget _buildAvatar(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return const Icon(Icons.person, size: 48, color: Colors.white);
    }

    if (imagePath.startsWith("http")) {
      return Image.network(
        imagePath,
        width: 48,
        height: 48,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            const Icon(Icons.person, size: 48, color: Colors.white),
      );
    }

    return const Icon(Icons.person, size: 48, color: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 1200,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// HEADER
                    BlocBuilder<MyProfileCubit, MyProfileState>(
                      builder: (context, state) {
                        String name = "User";
                        String avatarPath = '';

                        if (state is MyProfileLoaded) {
                          name = state.profile.name ?? name;
                          avatarPath = state.profile.userImage?.secureUrl ?? '';
                        }

                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 24),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                  color: Colors.grey.shade800, width: 1),
                            ),
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Colors.white24,
                                child: ClipOval(
                                  child: _buildAvatar(avatarPath),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hi, $name',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 4),
                                  Text('keep_learning'.tr,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    /// GAME
                    if (controller.showGameFirst.value) ...[
                      GameSection(),
                      const SizedBox(height: 40),
                    ],

                    /// TOP USERS
                    SectionHeader(
                      sectionTitle: 'top_users'.tr,
                      onTop: () => desktopKey.currentState?.openSidePage(
                        body: const TopUsersViewAll(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TopUsersSectionDesktop(),

                    const SizedBox(height: 40),

                    const NextSessionSectionDesktop(),

                    const SizedBox(height: 40),

                    RecommendedSectionDesktop(
                      controller: _recommendedScrollController,
                    ),
                    // /// RECOMMENDED
                    // SectionHeader(
                    //   sectionTitle: 'recommended_for_you'.tr,
                    //   onTop: () => desktopKey.currentState?.openSidePage(
                    //     body: const RecommendedViewAll(),
                    //   ),
                    // ),
                    // const SizedBox(height: 16),
                    // RecommendedSectionDesktop(
                    //   controller: _recommendedScrollController,
                    // ),

                    /// GAME
                    if (!controller.showGameFirst.value) ...[
                      const SizedBox(height: 40),
                      GameSection(),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
