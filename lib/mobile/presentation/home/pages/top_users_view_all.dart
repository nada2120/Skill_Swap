import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/shared/common_ui/base_screen.dart';

import '../../../../shared/bloc/get_users_cubit/users_cubit.dart';
import '../../../../shared/bloc/get_users_cubit/users_state.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../book_session/screens/profile_mentor.dart';
import '../widgets/top_user_card.dart';

class TopUsersViewAll extends StatefulWidget {
  const TopUsersViewAll({super.key});

  @override
  State<TopUsersViewAll> createState() => _TopUsersViewAllState();
}

class _TopUsersViewAllState extends State<TopUsersViewAll> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final cubit = context.read<UsersCubit>();

    if (!_scrollController.hasClients) return;

    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;

    if (current >= max - 200 && cubit.state is UsersLoaded) {
      final state = cubit.state as UsersLoaded;

      if (!state.isLoadingMore && !state.isLastPage) {
        cubit.fetchNextPage();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    double padding = 16;

    if (screenWidth >= 800) {
      padding = 24;
    }

    return BaseScreen(
      title: "Top Users",
      child: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, state) {
          if (state is UsersLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is UsersError) {
            return Center(child: Text(state.message));
          }

          if (state is UsersLoaded) {
            final users = state.users;

            final showLoader = state.isLoadingMore && !state.isLastPage;

            final itemCount = showLoader ? users.length + 1 : users.length;

            return GridView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(padding),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: itemCount,
              itemBuilder: (context, index) {
                // Loader item
                if (index >= users.length) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: AppPalette.primary,
                    ),
                  );
                }

                final user = users[index];

                return GestureDetector(
                  onTap: () {
                    Get.to(
                      ProfileMentor(
                        id: user.id,
                        name: user.name,
                        track: user.track.name,
                        rate: user.rate,
                        image: user.userImage.secureUrl,
                        bio: user.profile.bio,
                        skills: user.skills,
                        hoursAvailable: user.freeHours,
                        peopleHelped: user.helpTotalHours,
                        hourlyRate: user.hourlyPrice,
                        reviews: user.reviews,
                        role: user.role,
                      ),
                    );
                  },
                  child: TopUserCard(
                    id: user.id,
                    image: user.userImage.secureUrl,
                    name: user.name,
                    track: user.track.name.isEmpty
                        ? "Mobile Development"
                        : user.track.name,
                    hours: user.helpTotalHours,
                  ),
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
