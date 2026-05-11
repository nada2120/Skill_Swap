import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:skill_swap/desktop/presentation/select_skills/select_skills.dart';

import '../../../shared/bloc/track_cubit/skills_cubit.dart';
import '../../../shared/bloc/track_cubit/track_cubit.dart';
import '../../../shared/core/theme/app_palette.dart';
import '../../../shared/data/models/track/track_model.dart';
import '../../../shared/data/web_services/skills/skills_api_services.dart';

class SelectTrackScreen extends StatelessWidget {
  const SelectTrackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.instance<TracksCubit>()..fetchTracks(),
      child: const _SelectTrackBody(),
    );
  }
}

class _SelectTrackBody extends StatefulWidget {
  const _SelectTrackBody();

  @override
  State<_SelectTrackBody> createState() => _SelectTrackBodyState();
}

class _SelectTrackBodyState extends State<_SelectTrackBody> {
  TrackModel? selectedTrack;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final isDesktop = size.width > 800;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isDesktop ? 750 : double.infinity,
            ),
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: isDesktop ? 0 : size.width * 0.04,
                vertical: size.height * 0.03,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 40 : size.width * 0.05,
                vertical: isDesktop ? 35 : size.height * 0.04,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(28),
                boxShadow: isDesktop
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 25,
                          offset: const Offset(0, 10),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// TITLE
                  Text(
                    "Select your Track",
                    style: TextStyle(
                      fontSize: isDesktop ? 34 : size.width * 0.065,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: size.height * 0.012),

                  /// DESCRIPTION
                  Text(
                    "Choose the track you already have. "
                    "This will help us connect you with "
                    "the right mentors and users.",
                    style: TextStyle(
                      fontSize: isDesktop ? 16 : size.width * 0.035,
                      height: 1.5,
                    ),
                  ),

                  SizedBox(height: size.height * 0.04),

                  /// TRACKS
                  BlocBuilder<TracksCubit, TracksState>(
                    builder: (context, state) {
                      /// LOADING
                      if (state is TracksLoading) {
                        return SizedBox(
                          height: size.height * 0.4,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      /// ERROR
                      if (state is TracksError) {
                        return SizedBox(
                          height: size.height * 0.4,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  state.message,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    context.read<TracksCubit>().fetchTracks();
                                  },
                                  child: const Text("Retry"),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      /// LOADED
                      if (state is TracksLoaded) {
                        final tracks = state.tracks;

                        if (tracks.isEmpty) {
                          return const Center(
                            child: Text(
                              "No tracks available.",
                            ),
                          );
                        }

                        return Wrap(
                          spacing: 14,
                          runSpacing: 14,
                          children: tracks.map((track) {
                            final isSelected = selectedTrack?.id == track.id;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedTrack = track;
                                });
                              },
                              child: AnimatedContainer(
                                duration: const Duration(
                                  milliseconds: 250,
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: isDesktop ? 24 : 18,
                                  vertical: isDesktop ? 16 : 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppPalette.primary
                                      : Theme.of(context)
                                          .scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppPalette.primary
                                        : Theme.of(context).dividerColor,
                                  ),
                                ),
                                child: Text(
                                  track.name,
                                  style: TextStyle(
                                    fontSize: isDesktop ? 16 : 14,
                                    fontWeight: FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : (isDark
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),

                  SizedBox(height: size.height * 0.05),

                  /// BUTTON
                  Center(
                    child: SizedBox(
                      width: isDesktop ? 260 : size.width * 0.6,
                      height: isDesktop ? 55 : size.height * 0.065,
                      child: ElevatedButton(
                        onPressed: selectedTrack == null
                            ? null
                            : () {
                                Get.to(
                                  () => BlocProvider(
                                    create: (context) => SkillsCubit(
                                      GetIt.instance<SkillsApiService>(),
                                    )..fetchSkills(
                                        selectedTrack!.id,
                                      ),
                                    child: SelectSkillsScreen(
                                      trackId: selectedTrack!.id,
                                      trackName: selectedTrack!.name,
                                    ),
                                  ),
                                );
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppPalette.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Continue",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isDesktop ? 16 : 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
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
