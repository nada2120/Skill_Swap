import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:modal_side_sheet/modal_side_sheet.dart';
import 'package:skill_swap/desktop/presentation/book_session/screens/profile_mentor.dart';
import 'package:skill_swap/desktop/presentation/search/widgets/filterSheet.dart';
import 'package:skill_swap/desktop/presentation/search/widgets/filter_button.dart';
import 'package:skill_swap/desktop/presentation/search/widgets/mentor_card.dart';
import 'package:skill_swap/desktop/presentation/search/widgets/sort_button.dart';

import '../../../../main.dart';
import '../../../../shared/bloc/track_cubit/track_cubit.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_bloc.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_event.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_state.dart';
import '../../common/desktop_screen_manager.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isSearched = false;
  TextEditingController searchTextController = TextEditingController();
  int activeFiltersCount = 0;
  Timer? _debounce;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  int calculateHourlyRate(int hours, String role) {
    if (role.toLowerCase() != 'mentor') {
      return 0;
    }

    if (hours < 100) return 0;

    if (hours < 120) return 30;

    if (hours < 140) return 35;

    if (hours < 160) return 40;

    if (hours < 180) return 45;

    return 50;
  }

  void _scrollListener() {
    final bloc = context.read<UserFilterBloc>();

    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !bloc.state.isLastPage &&
        !bloc.state.isLoadingMore) {
      bloc.add(LoadMoreUsersEvent(
        page: bloc.currentPage + 1,
        limit: bloc.limit,
        query: searchTextController.text.isNotEmpty
            ? searchTextController.text
            : null,
        minPrice: bloc.state.minPrice?.toDouble(),
        maxPrice: bloc.state.maxPrice?.toDouble(),
        minRate: bloc.state.selectedRate?.toDouble(),
        role: bloc.state.selectedRole,
        track: bloc.state.selectedTrack,
      ));
    }
  }

  @override
  void dispose() {
    searchTextController.dispose();
    _debounce?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  int getCrossAxisCount(double width) {
    if (width > 1400) return 3;
    if (width > 1000) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200), // 👈 الحل هنا
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth > 900 ? 32 : 16,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  /// Title
                  Text(
                    'search'.tr,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),

                  const SizedBox(height: 20),

                  /// Search Row
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 55,
                          child: TextField(
                            controller: searchTextController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              prefixIcon: const Icon(Icons.search),
                              hintText: "search_placeholder".tr,
                            ),
                            onChanged: (value) {
                              if (_debounce?.isActive ?? false) {
                                _debounce!.cancel();
                              }

                              _debounce = Timer(
                                const Duration(milliseconds: 600),
                                () {
                                  context
                                      .read<UserFilterBloc>()
                                      .add(SearchUserEvent(value));

                                  setState(() {
                                    isSearched = value.isNotEmpty;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// Filter Icon
                      Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border:
                              Border.all(color: Theme.of(context).dividerColor),
                        ),
                        child: IconButton(
                            icon: Icon(Icons.tune_outlined,
                                color: isDark ? Colors.white : Colors.black),
                            onPressed: () {
                              final bloc = context.read<UserFilterBloc>();
                              final tracksCubit = context.read<TracksCubit>();

                              final state = bloc.state;

                              desktopKey.currentState?.openSidePage(
                                body: context
                                    .findAncestorStateOfType<
                                        DesktopScreenManagerState>()!
                                    .currentBody!,
                                rightPanel: MultiBlocProvider(
                                  providers: [
                                    BlocProvider.value(
                                      value: bloc,
                                    ),
                                    BlocProvider.value(
                                      value: tracksCubit,
                                    ),
                                  ],
                                  child: MentorFilterPanel(
                                    initialMinPrice: state.minPrice,
                                    initialMaxPrice: state.maxPrice,
                                    initialRate: state.selectedRate,
                                    initialRole: state.selectedRole,
                                    initialTrack: state.selectedTrack,
                                  ),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Sort + Filter Buttons
                  Row(
                    children: [
                      Expanded(
                        child: SortButton(),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: BlocBuilder<UserFilterBloc, UserFilterState>(
                            builder: (context, state) {
                          int count = 0;

                          final isPriceFiltered =
                              state.minPrice != 0 || state.maxPrice != 20;

                          if (isPriceFiltered) count++;
                          if (state.selectedRate != null) count++;
                          if (state.selectedRole != null) count++;
                          if (state.selectedTrack != null) count++;

                          return FilterButton(
                            activeFilters: count,
                            onPressed: () {
                              final bloc = context.read<UserFilterBloc>();
                              final tracksCubit = context.read<TracksCubit>();

                              final state = bloc.state;

                              desktopKey.currentState?.openSidePage(
                                body: context
                                    .findAncestorStateOfType<
                                        DesktopScreenManagerState>()!
                                    .currentBody!,
                                rightPanel: MultiBlocProvider(
                                  providers: [
                                    BlocProvider.value(
                                      value: bloc,
                                    ),
                                    BlocProvider.value(
                                      value: tracksCubit,
                                    ),
                                  ],
                                  child: MentorFilterPanel(
                                    initialMinPrice: state.minPrice,
                                    initialMaxPrice: state.maxPrice,
                                    initialRate: state.selectedRate,
                                    initialRole: state.selectedRole,
                                    initialTrack: state.selectedTrack,
                                  ),
                                ),
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// List
                  Expanded(
                    child: BlocBuilder<UserFilterBloc, UserFilterState>(
                      builder: (context, state) {
                        if (state.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (state.filteredList.isEmpty && !state.isLoading) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.search_off,
                                    size: 80, color: Colors.grey),
                                SizedBox(height: 16),
                                Text("No results found",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                              ],
                            ),
                          );
                        }

                        final showLoader =
                            state.isLoadingMore && !state.isLastPage;
                        return MasonryGridView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: getCrossAxisCount(screenWidth),
                          ),
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          itemCount:
                              state.filteredList.length + (showLoader ? 1 : 0),
                          itemBuilder: (context, index) {
                            if (index < state.filteredList.length) {
                              final user = state.filteredList[index];

                              return InkWell(
                                onTap: () {
                                  desktopKey.currentState?.openSidePage(
                                    body: ProfileMentorDesktop(
                                      id: user.id,
                                      name: user.name,
                                      track: user.track.name,
                                      rate: user.rate,
                                      image: user.userImage.secureUrl,
                                      bio: user.profile.bio,
                                      role: user.role,
                                      skills: user.skills,
                                      hoursAvailable: user.freeHours,
                                      peopleHelped: user.helpTotalHours,
                                      hourlyRate: user.hourlyPrice,
                                      reviews: user.reviews,
                                    ),
                                  );
                                },
                                child: MentorCard(
                                  image: user.userImage.secureUrl,
                                  name: user.name,
                                  role: user.role,
                                  rate: user.rate,
                                  hours: user.helpTotalHours,
                                  price: user.hourlyPrice,
                                  track: user.track.name,
                                  skills: user.skills,
                                  responseTime: "9",
                                ),
                              );
                            } else {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
