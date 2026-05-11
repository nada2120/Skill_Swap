import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../../shared/core/theme/app_palette.dart';
import '../../../mobile/presentation/sign/screens/sign_in_screen.dart';
import '../../../shared/bloc/complete_profile_bloc/complete_profile_bloc.dart';
import '../../../shared/bloc/complete_profile_bloc/complete_profile_event.dart';
import '../../../shared/bloc/complete_profile_bloc/complete_profile_state.dart';
import '../../../shared/bloc/track_cubit/skills_cubit.dart';
import '../../../shared/bloc/track_cubit/skills_state.dart';
import '../../../shared/data/models/complete_profile/complete_profile_request.dart';

class SelectSkillsScreen extends StatefulWidget {
  final String trackId;
  final String trackName;

  const SelectSkillsScreen({
    super.key,
    required this.trackId,
    required this.trackName,
  });

  @override
  State<SelectSkillsScreen> createState() => _SelectSkillsScreenState();
}

class _SelectSkillsScreenState extends State<SelectSkillsScreen> {
  List<String> selectedSkills = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetIt.instance<CompleteProfileBloc>(),
        ),
      ],
      child: BlocConsumer<CompleteProfileBloc, CompleteProfileState>(
        listener: (context, state) {
          if (state is CompleteProfileSuccess) {
            Get.offAll(() => SignInScreen());
          } else if (state is CompleteProfileFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is CompleteProfileLoading;

          return Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: size.height * 0.04,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: size.height * 0.02),

                  Text(
                    "Select your skills",
                    style: TextStyle(
                      fontSize: size.width * 0.065,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: size.height * 0.01),

                  Text(
                    "Track: ${widget.trackName}",
                    style: TextStyle(
                      fontSize: size.width * 0.04,
                    ),
                  ),

                  SizedBox(height: size.height * 0.03),

                  /// 🔥 Skills From API
                  Expanded(
                    child: BlocBuilder<SkillsCubit, SkillsState>(
                      builder: (context, skillsState) {
                        if (skillsState is SkillsLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (skillsState is SkillsError) {
                          return Center(
                            child: Text(
                              skillsState.error,
                            ),
                          );
                        }

                        if (skillsState is SkillsLoaded) {
                          final skills = skillsState.response.data;

                          if (skills.isEmpty) {
                            return const Center(
                              child: Text(
                                "No skills available",
                              ),
                            );
                          }

                          return SingleChildScrollView(
                            child: Wrap(
                              spacing: size.width * 0.02,
                              runSpacing: size.height * 0.015,
                              children: skills.map((skill) {
                                final isSelected = selectedSkills.contains(
                                  skill.name,
                                );

                                return GestureDetector(
                                  onTap: isLoading
                                      ? null
                                      : () {
                                          setState(() {
                                            if (isSelected) {
                                              selectedSkills.remove(
                                                skill.name,
                                              );
                                            } else {
                                              selectedSkills.add(
                                                skill.name,
                                              );
                                            }
                                          });
                                        },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: size.width * 0.04,
                                      vertical: size.height * 0.012,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppPalette.primary
                                          : Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(25),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppPalette.primary
                                            : Theme.of(context).dividerColor,
                                      ),
                                    ),
                                    child: Text(
                                      skill.name,
                                      style: TextStyle(
                                        fontSize: size.width * 0.035,
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
                            ),
                          );
                        }

                        return const SizedBox();
                      },
                    ),
                  ),

                  /// 🔥 Continue Button
                  SizedBox(
                    width: double.infinity,
                    height: size.height * 0.065,
                    child: ElevatedButton(
                      onPressed: (isLoading || selectedSkills.isEmpty)
                          ? null
                          : () {
                              final Set<String> uniqueSkills = {};

                              for (var skill in selectedSkills) {
                                final parts = skill.split('&');

                                for (var part in parts) {
                                  final trimmed = part.trim();

                                  if (trimmed.isNotEmpty) {
                                    uniqueSkills.add(
                                      trimmed,
                                    );
                                  }
                                }
                              }

                              final skillItems = uniqueSkills
                                  .map(
                                    (s) => SkillItem(
                                      skillName: s,
                                      experienceLevel: null,
                                    ),
                                  )
                                  .toList();

                              context.read<CompleteProfileBloc>().add(
                                    CompleteProfileSubmitted(
                                      track: widget.trackId,
                                      skills: skillItems,
                                    ),
                                  );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppPalette.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              "Continue",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
