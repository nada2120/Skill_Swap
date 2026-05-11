import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/mobile/presentation/search/widgets/price_filter_section.dart';

import '../../../../shared/bloc/track_cubit/track_cubit.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_bloc.dart';
import '../../../../shared/bloc/user_filter_bloc/user_filter_event.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/data/models/track/track_model.dart';

class MentorFilterSheet extends StatefulWidget {
  final double initialMinPrice;
  final double initialMaxPrice;
  final int? initialRate;
  final String? initialRole;
  final String? initialTrack;

  const MentorFilterSheet({
    super.key,
    this.initialMinPrice = 0,
    this.initialMaxPrice = 20,
    this.initialRate,
    this.initialRole,
    this.initialTrack,
  });

  @override
  State<MentorFilterSheet> createState() => _MentorFilterSheetState();
}

class _MentorFilterSheetState extends State<MentorFilterSheet> {
  late double startPrice;
  late double endPrice;

  int? selectedRate;
  String? selectedRole;
  TrackModel? selectedTrack;

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
  }

  void _restoreTrackIfNeeded(List<TrackModel> tracks) {
    if (selectedTrack == null && widget.initialTrack != null) {
      final match = tracks.where((e) => e.name == widget.initialTrack);
      if (match.isNotEmpty) {
        selectedTrack = match.first;
      }
    }
  }

  int get activeFiltersCount {
    int count = 0;

    if (startPrice != 0 || endPrice != 20) count++;
    if (selectedRate != null) count++;
    if (selectedRole != null) count++;
    if (selectedTrack != null) count++;

    return count;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;

    return FractionallySizedBox(
      heightFactor: 0.9,
      child: Container(
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration: BoxDecoration(
          color: Theme
              .of(context)
              .scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(32),
            bottomLeft: Radius.circular(32),
          ),
        ),
        child: SafeArea(
          child: ListView(
            children: [
              Text(
                "filters".tr,
                style: Theme
                    .of(context)
                    .textTheme
                    .titleMedium,
              ),

              SizedBox(height: screenWidth * 0.02),
              const Divider(),
              SizedBox(height: screenWidth * 0.02),

              /// PRICE
              PriceFilterSection(
                min: 0,
                max: 20,
                onChanged: (start, end) {
                  setState(() {
                    startPrice = start;
                    endPrice = end;
                  });
                },
              ),

              SizedBox(height: screenWidth * 0.04),

              /// ROLE
              Text("role".tr, style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium),

              SizedBox(height: screenWidth * 0.02),

              buildChoiceChips<String>(
                context: context,
                items: roles,
                selectedItem: selectedRole,
                onSelected: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
              ),

              SizedBox(height: screenWidth * 0.04),

              /// TRACK
              Text("track".tr, style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium),

              SizedBox(height: screenWidth * 0.02),

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

                    return buildChoiceChips<TrackModel>(
                      context: context,
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

              SizedBox(height: screenWidth * 0.04),

              /// RATING
              Text("rating".tr, style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium),

              SizedBox(height: screenWidth * 0.02),

              buildChoiceChips<int>(
                context: context,
                items: rates,
                selectedItem: selectedRate,
                showIcon: true,
                icon: Icons.star,
                onSelected: (value) {
                  setState(() {
                    selectedRate = value;
                  });
                },
              ),

              SizedBox(height: screenWidth * 0.08),

              /// BUTTONS
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme
                            .of(context)
                            .cardColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
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

                        Navigator.pop(context, activeFiltersCount);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPalette.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Apply",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildChoiceChips<T>({
    required BuildContext context,
    required List<T> items,
    required T? selectedItem,
    required Function(T?) onSelected,
    bool showIcon = false,
    IconData? icon,
    String Function(T)? labelBuilder,
  }) {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    final activeColor = AppPalette.primary;
    final inactiveColor = Theme
        .of(context)
        .cardColor;
    final textActive = Colors.white;
    final textInactive =
    isDark ? AppPalette.darkTextPrimary : AppPalette.lightTextPrimary;

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items.map((item) {
        final label = labelBuilder?.call(item) ?? "$item";
        final selectedLabel = selectedItem != null
            ? (labelBuilder?.call(selectedItem) ?? "$selectedItem")
            : null;
        final selected = label == selectedLabel;

        return ChoiceChip(
          label: showIcon
              ? Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null)
                Icon(icon,
                    size: 18,
                    color: selected ? textActive : textInactive),
              Text("  $label",
                  style: TextStyle(
                      color: selected ? textActive : textInactive)),
            ],
          )
              : Text(label,
              style:
              TextStyle(color: selected ? textActive : textInactive)),
          selected: selected,
          backgroundColor: inactiveColor,
          selectedColor: activeColor,
          checkmarkColor: textActive,
          onSelected: (_) => onSelected(selected ? null : item),
        );
      }).toList(),
    );
  }
}
