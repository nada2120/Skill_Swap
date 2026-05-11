import 'dart:io';

import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:skill_swap/shared/bloc/book_session/book_session_bloc.dart';
import 'package:skill_swap/shared/bloc/book_session/book_session_event.dart';
import 'package:skill_swap/shared/data/models/user/skill_model.dart';

import '../../../../shared/bloc/accepted_bookings/accepted_bookings_cubit.dart';
import '../../../../shared/bloc/get_available_dates_bloc/get_available_dates_bloc.dart';
import '../../../../shared/bloc/public_chat/public_chat_messages_cubit.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/data/models/my_profile/review_model.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../../../shared/domain/repositories/chat_repository.dart';
import '../../profile/widgets/review_card.dart';
import '../../prv_chat/private_chat_screen.dart';
import '../../sign/widgets/custom_button.dart';
import '../widgets/profile_mentor_header.dart';
import '../widgets/session_booking_page.dart';

class ProfileMentor extends StatefulWidget {
  final String id;
  final String image;
  final String name;
  final String track;
  final String role;
  final num rate;
  final String bio;
  final num hoursAvailable;
  final num peopleHelped;
  final num hourlyRate;
  final List<ReviewModel> reviews;
  final List<Skill> skills;

  const ProfileMentor(
      {super.key,
      required this.reviews,
      required this.id,
      required this.image,
      required this.name,
      required this.track,
      required this.role,
      required this.rate,
      required this.bio,
      required this.hoursAvailable,
      required this.peopleHelped,
      required this.hourlyRate,
      required this.skills});

  @override
  State<ProfileMentor> createState() => _ProfileMentorState();
}

class _ProfileMentorState extends State<ProfileMentor> {
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

  int calculateSessionPrice({
    required int hourlyRate,
    required int durationInMinutes,
  }) {
    final pricePerMinute = hourlyRate / 60;
    return (pricePerMinute * durationInMinutes).round();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final screenHeight = media.size.height;
    final screenWidth = media.size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget buildAvatar(String? avatarPath) {
      final hasImage = avatarPath != null && avatarPath.isNotEmpty;

      return CircleAvatar(
        radius: screenWidth * 0.12,
        backgroundColor: Theme.of(context).cardColor,
        backgroundImage:
            (hasImage && defaultTargetPlatform != TargetPlatform.windows)
                ? FileImage(File(avatarPath))
                : null,
        child: (!hasImage || defaultTargetPlatform == TargetPlatform.windows)
            ? Icon(
                Icons.person,
                size: screenWidth * 0.12,
                color: Theme.of(context).textTheme.bodyLarge!.color,
              )
            : null,
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                ProfileMentorHeader(
                  id: widget.id,
                  image: widget.image,
                  name: widget.name,
                  track: widget.track,
                  rate: widget.rate,
                ),
              ],
            ),
            Positioned(
              top: screenHeight * 0.16,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(minHeight: screenHeight),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(screenWidth * 0.08),
                    topRight: Radius.circular(screenWidth * 0.08),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Mentor Info (Hours, People Helped, Rate)
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.02),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.08),
                            border: Border.all(
                              color: Theme.of(context).dividerColor,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              mentorInfo(
                                  context: context,
                                  rate: "${widget.hoursAvailable}",
                                  info: "hours_available".tr),
                              mentorInfo(
                                  context: context,
                                  rate: "${widget.peopleHelped}",
                                  info: "people_helped".tr),
                              mentorInfo(
                                  context: context,
                                  rate: widget.role == "Mentor"
                                      ? "${widget.hourlyRate}\$"
                                      : "Free",
                                  info: "hourly_rate".tr),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        /// About
                        Text("about".tr,
                            style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 8),
                        Text(
                          widget.bio == ""
                              ? "I'm ${widget.track ?? 'Mobile Development'}."
                              : widget.bio,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.75,
                            color: isDark
                                ? AppPalette.darkTextSecondary
                                : AppPalette.lightTextSecondary,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        /// Skills
                        Text("skills".tr,
                            style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: widget.skills.map((skill) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.03,
                                vertical: screenHeight * 0.01,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xFFD6D6D6).withOpacity(0.25),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                skill.skillName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: screenHeight * 0.02),

                        /// Reviews
                        Text("reviews".tr,
                            style: Theme.of(context).textTheme.bodyLarge),
                        const SizedBox(height: 8),
                        Column(
                          children: widget.reviews.isNotEmpty
                              ? widget.reviews.map((review) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: ReviewCard(
                                      name: review.reviewer.name,
                                      review: review.review,
                                      rating: review.rating,
                                      image:
                                          review.reviewer.userImage.secureUrl ??
                                              '',
                                      role: review.reviewer.role,
                                      time: review.createdAt,
                                    ),
                                  );
                                }).toList()
                              : [],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(screenWidth * 0.04),
        decoration:
            BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
        child: Row(
          children: [
            Container(
              height: screenHeight * 0.065,
              width: screenHeight * 0.065,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(screenWidth * 0.04),
                border: Border.all(color: AppPalette.primary),
              ),
              child: IconButton(
                icon: Icon(Iconsax.message, color: AppPalette.primary),
                onPressed: () async {
                  try {
                    final chatRepo = sl<ChatRepository>();
                    final chatId =
                        await chatRepo.createOrGetPrivateChat(widget.id);
                    Get.to(
                      () => BlocProvider(
                        create: (_) => sl<PublicChatMessagesCubit>()
                          ..init(chatId, partnerId: widget.id, isPrivate: true),
                        child: PrivateChatScreen(
                          chatId: chatId,
                          partnerName: widget.name,
                          partnerId: widget.id,
                          partnerImage: widget.image,
                        ),
                      ),
                    );
                  } catch (e) {
                    Get.snackbar('Error', 'Failed to open chat: $e');
                  }
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: CustomButton(
                  text: "session_details".tr,
                  onPressed: () async {
                    final bloc = sl<GetAvailableDatesBloc>();

                    bloc.add(FetchAvailableDates(widget.id));

                    final state = await bloc.stream.firstWhere(
                      (state) =>
                          state is GetAvailableDatesSuccess ||
                          state is GetAvailableDatesError,
                    );

                    if (state is GetAvailableDatesSuccess) {
                      if (state.data.availableDates.isEmpty) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text("Oops"),
                            content: Text(
                                "${widget.name} hasn't set any available days for this week yet"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text("OK"),
                              ),
                            ],
                          ),
                        );
                      } else {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => MultiBlocProvider(
                                  providers: [
                                    BlocProvider(
                                      create: (_) => sl<ActiveBookingBloc>()
                                        ..add(
                                            LoadMyBookingWithMentor(widget.id)),
                                    ),
                                    BlocProvider(
                                      create: (_) =>
                                          sl<AcceptedBookingsCubit>(),
                                    ),
                                  ],
                                  child: BookingBottomSheet(
                                    userId: widget.id,
                                    userName: widget.name,
                                    price: widget.hourlyRate,
                                    availableDates: state.data.availableDates,
                                    role: widget.role,
                                  ),
                                ));
                      }
                    } else if (state is GetAvailableDatesError) {
                      Get.snackbar("Error", state.message);
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

Widget mentorInfo(
    {required BuildContext context,
    required String rate,
    required String info}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Column(
    children: [
      Text(
        rate,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : AppPalette.primary,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        info,
        style: TextStyle(
            fontSize: 12, color: isDark ? Colors.white : AppPalette.primary),
      ),
    ],
  );
}
