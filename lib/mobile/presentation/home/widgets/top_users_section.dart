import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/shared/bloc/get_users_cubit/users_cubit.dart';

import '../../../../mobile/presentation/home/widgets/top_user_card.dart';
import '../../../../shared/bloc/get_users_cubit/users_state.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../book_session/screens/profile_mentor.dart';

class TopUsersSection extends StatelessWidget {
  const TopUsersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<UsersCubit>()..fetchUsers(reset: true, topUsers: true),
      child: const _TopUsersList(),
    );
  }
}

class _TopUsersList extends StatefulWidget {
  const _TopUsersList({super.key});

  @override
  State<_TopUsersList> createState() => _TopUsersListState();
}

class _TopUsersListState extends State<_TopUsersList> {
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_scrollListener);
  }

  void _scrollListener() {
    final cubit = context.read<UsersCubit>();

    if (!_controller.hasClients) return;

    final max = _controller.position.maxScrollExtent;
    final current = _controller.position.pixels;

    if (current >= max - 150 && cubit.state is UsersLoaded) {
      final state = cubit.state as UsersLoaded;

      if (!state.isLoadingMore && !state.isLastPage) {
        cubit.fetchNextPage();
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_scrollListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height * 0.18,
      child: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, state) {
          if (state is UsersLoading) {
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, __) => const TopUserCard(isLoading: true),
            );
          }

          if (state is UsersLoaded) {
            final showLoader = state.isLoadingMore && !state.isLastPage;

            final itemCount =
                showLoader ? state.users.length + 1 : state.users.length;

            return ListView.separated(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              itemCount: itemCount,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                // loader item
                if (index >= state.users.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppPalette.primary,
                      ),
                    ),
                  );
                }

                final u = state.users[index];

                return InkWell(
                  onTap: () {
                    Get.to(ProfileMentor(
                      id: u.id,
                      name: u.name,
                      track: u.track.name,
                      rate: u.rate,
                      image: u.userImage.secureUrl,
                      bio: u.profile.bio,
                      skills: u.skills,
                      role: u.role,
                      hoursAvailable: u.freeHours,
                      peopleHelped: u.helpTotalHours,
                      hourlyRate: u.hourlyPrice,
                      reviews: u.reviews,
                    ));
                  },
                  child: TopUserCard(
                    id: u.id,
                    image: u.userImage.secureUrl,
                    name: u.name,
                    track: u.track.name.isEmpty
                        ? "Mobile Development"
                        : u.track.name,
                    hours: u.helpTotalHours,
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
