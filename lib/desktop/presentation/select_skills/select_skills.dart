import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import '../../../shared/bloc/complete_profile_bloc/complete_profile_bloc.dart';
import '../../../shared/bloc/complete_profile_bloc/complete_profile_event.dart';
import '../../../shared/bloc/complete_profile_bloc/complete_profile_state.dart';
import '../../../shared/bloc/track_cubit/skills_cubit.dart';
import '../../../shared/bloc/track_cubit/skills_state.dart';
import '../../../shared/core/theme/app_palette.dart';
import '../../../shared/data/models/complete_profile/complete_profile_request.dart';
import '../sign/screens/sign_in_screen.dart';

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

    final isDesktop = size.width > 800;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetIt.instance<CompleteProfileBloc>(),
        ),
      ],
      child: BlocConsumer<CompleteProfileBloc, CompleteProfileState>(
        listener: (context, state) {
          if (state is CompleteProfileSuccess) {
            Get.offAll(() => SignInDesktop());
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
                                offset: const Offset(
                                  0,
                                  10,
                                ),
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// TITLE
                        Text(
                          "Select your skills",
                          style: TextStyle(
                            fontSize: isDesktop ? 34 : size.width * 0.065,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(
                          height: size.height * 0.012,
                        ),

                        /// TRACK NAME
                        Text(
                          "Track: ${widget.trackName}",
                          style: TextStyle(
                            fontSize: isDesktop ? 17 : size.width * 0.04,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        SizedBox(
                          height: size.height * 0.04,
                        ),

                        /// SKILLS
                        BlocBuilder<SkillsCubit, SkillsState>(
                          builder: (
                            context,
                            skillsState,
                          ) {
                            /// LOADING
                            if (skillsState is SkillsLoading) {
                              return SizedBox(
                                height: size.height * 0.4,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            /// ERROR
                            if (skillsState is SkillsError) {
                              return SizedBox(
                                height: size.height * 0.4,
                                child: Center(
                                  child: Text(
                                    skillsState.error,
                                  ),
                                ),
                              );
                            }

                            /// LOADED
                            if (skillsState is SkillsLoaded) {
                              final skills = skillsState.response.data;

                              if (skills.isEmpty) {
                                return const Center(
                                  child: Text(
                                    "No skills available",
                                  ),
                                );
                              }

                              return Wrap(
                                spacing: 14,
                                runSpacing: 14,
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
                                        borderRadius: BorderRadius.circular(
                                          24,
                                        ),
                                        border: Border.all(
                                          color: isSelected
                                              ? AppPalette.primary
                                              : Theme.of(context).dividerColor,
                                        ),
                                      ),
                                      child: Text(
                                        skill.name,
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

                            return const SizedBox();
                          },
                        ),

                        SizedBox(
                          height: size.height * 0.05,
                        ),

                        /// BUTTON
                        Center(
                          child: SizedBox(
                            width: isDesktop ? 260 : double.infinity,
                            height: isDesktop ? 55 : size.height * 0.065,
                            child: ElevatedButton(
                              onPressed: (isLoading || selectedSkills.isEmpty)
                                  ? null
                                  : () {
                                      final Set<String> uniqueSkills = {};

                                      for (var skill in selectedSkills) {
                                        final parts = skill.split(
                                          '&',
                                        );

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
                                            (
                                              s,
                                            ) =>
                                                SkillItem(
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
                                  borderRadius: BorderRadius.circular(
                                    16,
                                  ),
                                ),
                                elevation: 0,
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
                                  : Text(
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
        },
      ),
    );
  }
}
