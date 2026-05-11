import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyProfileCubit, MyProfileState>(
      builder: (context, state) {
        String name = "User";
        String imagePath = '';
        num freeHours = 0;
        num helpHours = 0;
        num rating = 0.0;

        if (state is MyProfileLoaded) {
          final profile = state.profile;

          name = profile.name.isNotEmpty ? profile.name : "User";
          imagePath = profile.userImage.secureUrl ?? '';
          freeHours = profile.freeHours ?? 0;
          helpHours = profile.helpTotalHours ?? 0;

          rating = profile.rate ?? 0.0;
        }

        final hasImage = imagePath.isNotEmpty;

        return Container(
          width: double.infinity,
          color: Theme
              .of(context)
              .scaffoldBackgroundColor,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Theme
                        .of(context)
                        .cardColor,
                    backgroundImage: hasImage ? NetworkImage(imagePath) : null,
                    child: !hasImage
                        ? Icon(
                      Icons.person,
                      size: 28,
                      color: Theme
                          .of(context)
                          .textTheme
                          .bodyLarge
                          ?.color,
                    )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge!
                              .color,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            rating.toStringAsFixed(1),
                            style: TextStyle(
                              color:
                              Theme
                                  .of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.color,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // /// 🔹 الإحصائيات (ساعات)
              // Row(
              //   children: [
              //     _buildStatItem(
              //       context,
              //       title: "Free Hours",
              //       value: freeHours.toString(),
              //     ),
              //     const SizedBox(width: 20),
              //     _buildStatItem(
              //       context,
              //       title: "Help Hours",
              //       value: helpHours.toString(),
              //     ),
              //   ],
              // ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(BuildContext context,
      {required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme
                .of(context)
                .textTheme
                .bodyLarge
                ?.color,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Theme
                .of(context)
                .textTheme
                .bodyMedium
                ?.color,
          ),
        ),
      ],
    );
  }
}
