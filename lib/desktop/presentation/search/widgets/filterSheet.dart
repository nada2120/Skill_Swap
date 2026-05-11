import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

import '../../../../main.dart';
import '../../../../mobile/presentation/search/widgets/price_filter_section.dart';
import '../../../../shared/bloc/track_cubit/track_cubit.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_bloc.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_event.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/data/models/track/track_model.dart';

class MentorFilterPanel extends StatefulWidget {
  final double initialMinPrice;
  final double initialMaxPrice;
  final int? initialRate;
  final String? initialRole;
  final String? initialTrack;

  const MentorFilterPanel({
    super.key,
    this.initialMinPrice = 0,
    this.initialMaxPrice = 20,
    this.initialRate,
    this.initialRole,
    this.initialTrack,
  });

  @override
  State<MentorFilterPanel> createState() => _MentorFilterPanelState();
}

class _MentorFilterPanelState extends State<MentorFilterPanel> {
  late double startPrice;
  late double endPrice;

  int? selectedRate;
  String? selectedRole;
  TrackModel? selectedTrack;

  void _restoreTrackIfNeeded(List<TrackModel> tracks) {
    if (selectedTrack == null && widget.initialTrack != null) {
      final match = tracks.where((e) => e.name == widget.initialTrack);
      if (match.isNotEmpty) {
        selectedTrack = match.first;
      }
    }
  }

  int activeFiltersCount = 0;

  final List<String> roles = ["Mentor", "Normal"];

  final List<int> rates = [1, 2, 3, 4, 5];

  @override
  void initState() {
    super.initState();

    startPrice = widget.initialMinPrice;
    endPrice = widget.initialMaxPrice;

    selectedRate = widget.initialRate;
    selectedRole = widget.initialRole;

    context.read<TracksCubit>().fetchTracks();

    if (startPrice != 0 || endPrice != 20) activeFiltersCount++;
    if (selectedRate != null) activeFiltersCount++;
    if (selectedRole != null) activeFiltersCount++;
    if (selectedTrack != null) activeFiltersCount++;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      decoration: BoxDecoration(
        color: Theme
            .of(context)
            .scaffoldBackgroundColor,
        border: Border(
          left: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              Text(
                "Filters",
                style: Theme
                    .of(context)
                    .textTheme
                    .titleLarge,
              ),

              const SizedBox(height: 20),

              /// PRICE
              PriceFilterSection(
                min: 0,
                max: 20,
                onChanged: (start, end) {
                  setState(() {
                    if (startPrice == 0 &&
                        endPrice == 20 &&
                        (start != 0 || end != 20)) {
                      activeFiltersCount++;
                    }

                    startPrice = start;
                    endPrice = end;
                  });
                },
              ),

              const SizedBox(height: 16),

              Text("role".tr, style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium),
              const SizedBox(height: 8),

              /// ROLE
              buildChips<String>(
                items: roles,
                selectedItem: selectedRole,
                onSelected: (value) {
                  setState(() {
                    if (selectedRole == null && value != null) {
                      activeFiltersCount++;
                    } else if (selectedRole != null && value == null) {
                      activeFiltersCount--;
                    }
                    selectedRole = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              /// Track
              Text("track".tr, style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium),
              const SizedBox(height: 8),

              BlocBuilder<TracksCubit, TracksState>(
                builder: (context, state) {
                  if (state is TracksLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is TracksError) {
                    return Center(child: Text(state.message));
                  }

                  if (state is TracksLoaded) {
                    final tracks = state.tracks;

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (!mounted) return;

                      setState(() {
                        _restoreTrackIfNeeded(tracks);
                      });
                    });

                    return buildChips<TrackModel>(
                      items: tracks,
                      selectedItem: selectedTrack,
                      labelBuilder: (item) => item.name,
                      onSelected: (value) {
                        setState(() {
                          selectedTrack = value;
                        });
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
              const SizedBox(height: 16),

              /// Rating
              Text("rating".tr, style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium),
              const SizedBox(height: 8),

              buildChips<int>(
                items: rates,
                selectedItem: selectedRate,
                showIcon: true,
                icon: Icons.star,
                onSelected: (value) {
                  setState(() {
                    if (selectedRate == null && value != null) {
                      activeFiltersCount++;
                    } else if (selectedRate != null && value == null) {
                      activeFiltersCount--;
                    }
                    selectedRate = value;
                  });
                },
              ),

              const SizedBox(height: 30),

              /// BUTTONS
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        desktopKey.currentState?.goBack();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme
                            .of(context)
                            .cardColor,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text("cancel".tr,
                          style: Theme
                              .of(context)
                              .textTheme
                              .titleMedium),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<UserFilterBloc>().add(
                          ApplyFiltersEvent(
                            minPrice: startPrice,
                            maxPrice: endPrice,
                            minRate: selectedRate?.toDouble(),
                            role: selectedRole,
                            track: selectedTrack?.name,
                          ),
                        );

                        int newCount = 0;
                        if (startPrice != 0 || endPrice != 20) newCount++;
                        if (selectedRate != null) newCount++;
                        if (selectedRole != null) newCount++;
                        if (selectedTrack != null) newCount++;
                        desktopKey.currentState?.goBack();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPalette.primary,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "apply".tr,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildChips<T>({
    required List<T> items,
    required T? selectedItem,
    required Function(T?) onSelected,
    bool showIcon = false,
    IconData? icon,
    String Function(T)? labelBuilder,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        final selected = selectedItem == item;
        final label = labelBuilder?.call(item) ?? "$item";

        return ChoiceChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showIcon && icon != null)
                Icon(
                  icon,
                  size: 16,
                  color: selected ? Colors.white : Colors.black,
                ),
              if (showIcon) const SizedBox(width: 4),
              Text(label),
            ],
          ),
          selected: selected,
          selectedColor: AppPalette.primary,
          onSelected: (_) => onSelected(selected ? null : item),
        );
      }).toList(),
    );
  }
}
