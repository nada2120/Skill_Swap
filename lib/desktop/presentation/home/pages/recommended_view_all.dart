import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../main.dart';
import '../../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_bloc.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_event.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_state.dart';
import '../../../../shared/dependency_injection/injection.dart';

import '../../../../mobile/presentation/home/models/user_rank.dart';
import '../widgets/recommended_card.dart';

class RecommendedViewAll extends StatefulWidget {
  const RecommendedViewAll({super.key});

  @override
  State<RecommendedViewAll> createState() => _RecommendedViewAllState();
}

class _RecommendedViewAllState extends State<RecommendedViewAll> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    final bloc = context.read<UserFilterBloc>();
    final state = bloc.state;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200 &&
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
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .scaffoldBackgroundColor,
      body: BlocBuilder<MyProfileCubit, MyProfileState>(
        builder: (context, profileState) {
          if (profileState is! MyProfileLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final track = profileState.profile.track.name ?? '';

          return BlocProvider(
            create: (_) =>
            UserFilterBloc(
              userRepository: sl(),
              allUsers: [],
            )
              ..add(ApplyFiltersEvent(track: track)),

            child: Column(
              children: [

                /// 🔥 HEADER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 24),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom:
                      BorderSide(color: Colors.grey.shade800, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          final didGoBack =
                          desktopKey.currentState?.goBack();
                          if (didGoBack == false) {
                            desktopKey.currentState?.openPage(index: 0);
                          }
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            "Recommended for You",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                /// 🔥 GRID
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: BlocBuilder<UserFilterBloc, UserFilterState>(
                      builder: (context, state) {
                        final rankedList = rankRecommendedUsers(
                          state.filteredList,
                          state.selectedTrack,
                        );

                        if (state.isLoading && rankedList.isEmpty) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (!state.isLoading && rankedList.isEmpty) {
                          return const Center(
                            child: Text("No recommendations found"),
                          );
                        }

                        return GridView.builder(
                          controller: _scrollController,
                          itemCount: state.isLastPage
                              ? rankedList.length
                              : rankedList.length + 1,
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 24,
                            crossAxisSpacing: 24,
                            childAspectRatio: 0.85,
                          ),
                          itemBuilder: (context, index) {
                            if (index < rankedList.length) {
                              final user = rankedList[index];

                              return RecommendedCard(
                                id: user.id,
                                image: user.userImage.secureUrl,
                                name: user.name,
                                track: user.track.name,
                                rating: user.rate,
                              );
                            } else {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}