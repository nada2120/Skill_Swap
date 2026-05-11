import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:skill_swap/desktop/presentation/home/pages/recommended_view_all.dart';
import 'package:skill_swap/desktop/presentation/home/widgets/recommended_card.dart';
import 'package:skill_swap/desktop/presentation/home/widgets/section_header.dart';

import '../../../../main.dart';
import '../../../../mobile/presentation/home/models/user_rank.dart';
import '../../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_bloc.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_event.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_state.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../book_session/screens/profile_mentor.dart';

class RecommendedSectionDesktop extends StatefulWidget {
  final ScrollController controller;

  const RecommendedSectionDesktop({
    super.key,
    required this.controller,
  });

  @override
  State<RecommendedSectionDesktop> createState() =>
      _RecommendedSectionDesktopState();
}

class _RecommendedSectionDesktopState extends State<RecommendedSectionDesktop> {
  void _scrollListener() {
    final bloc = context.read<UserFilterBloc>();
    final state = bloc.state;

    if (widget.controller.position.pixels >=
            widget.controller.position.maxScrollExtent - 150 &&
        !state.isLoadingMore &&
        !state.isLastPage) {
      bloc.add(
        LoadMoreUsersEvent(
          page: bloc.currentPage + 1,
          track: state.selectedTrack,
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_scrollListener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyProfileCubit, MyProfileState>(
      builder: (context, profileState) {
        if (profileState is! MyProfileLoaded) {
          return const SizedBox();
        }

        final track = profileState.profile.track.name ?? '';

        return BlocProvider(
          create: (_) => UserFilterBloc(
            userRepository: sl(),
            allUsers: [],
          )..add(ApplyFiltersEvent(track: track)),
          child: BlocBuilder<UserFilterBloc, UserFilterState>(
            builder: (context, state) {
              final rankedList = rankRecommendedUsers(
                state.filteredList,
                state.selectedTrack,
              );

              if (!state.isLoading && rankedList.isEmpty) {
                return const SizedBox();
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(
                    sectionTitle: 'recommended_for_you'.tr,
                    onTop: () {
                      desktopKey.currentState?.openSidePage(
                        body: const RecommendedViewAll(),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 170,
                    child: GridView.builder(
                      controller: widget.controller,
                      scrollDirection: Axis.horizontal,
                      itemCount: state.isLastPage
                          ? rankedList.length
                          : rankedList.length + 1,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 24,
                        childAspectRatio: 1,
                      ),
                      itemBuilder: (context, index) {
                        if (index < rankedList.length) {
                          final user = rankedList[index];

                          return InkWell(
                            onTap: () {
                              desktopKey.currentState?.openSidePage(
                                body: ProfileMentorDesktop(
                                  id: user.id,
                                  name: user.name,
                                  track: user.track.name,
                                  rate: user.rate,
                                  role: user.role,
                                  image: user.userImage.secureUrl,
                                  bio: user.profile.bio,
                                  skills: user.skills,
                                  hoursAvailable: user.freeHours,
                                  peopleHelped: user.helpTotalHours,
                                  hourlyRate: user.hourlyPrice,
                                  reviews: user.reviews,
                                ),
                              );
                            },
                            child: RecommendedCard(
                              id: user.id,
                              image: user.userImage.secureUrl,
                              name: user.name,
                              track: user.track.name,
                              rating: user.rate,
                            ),
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
