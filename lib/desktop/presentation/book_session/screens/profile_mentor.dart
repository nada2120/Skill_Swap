import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:skill_swap/shared/data/models/user/skill_model.dart';

import '../../../../desktop/presentation/profile/widgets/review_card.dart';
import '../../../../main.dart';
import '../../../../mobile/presentation/prv_chat/private_chat_screen.dart';
import '../../../../shared/bloc/accepted_bookings/accepted_bookings_cubit.dart';
import '../../../../shared/bloc/book_session/book_session_bloc.dart';
import '../../../../shared/bloc/book_session/book_session_event.dart';
import '../../../../shared/bloc/get_available_dates_bloc/get_available_dates_bloc.dart';
import '../../../../shared/bloc/public_chat/public_chat_messages_cubit.dart';
import '../../../../shared/bloc/report_bloc/report_bloc.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/data/models/my_profile/review_model.dart';
import '../../../../shared/data/models/report_user/report_request.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../../../shared/domain/repositories/chat_repository.dart';
import '../../common/desktop_screen_manager.dart';
import '../../sign/widgets/custom_button.dart';
import 'book_session.dart';

class ProfileMentorDesktop extends StatefulWidget {
  final String id;
  final String image;
  final String name;
  final String track;
  final num rate;
  final String role;
  final String bio;
  final num hoursAvailable;
  final num peopleHelped;
  final num hourlyRate;
  final List<Skill> skills;
  final List<ReviewModel> reviews;

  const ProfileMentorDesktop({
    super.key,
    required this.id,
    required this.image,
    required this.name,
    required this.track,
    required this.rate,
    required this.role,
    required this.bio,
    required this.hoursAvailable,
    required this.peopleHelped,
    required this.hourlyRate,
    required this.skills,
    required this.reviews,
  });

  @override
  State<ProfileMentorDesktop> createState() => _ProfileMentorDesktopState();
}

class _ProfileMentorDesktopState extends State<ProfileMentorDesktop> {
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    Widget _buildAvatar(String? imagePath) {
      if (imagePath == null || imagePath.isEmpty) {
        return const Icon(Icons.person, size: 48, color: Colors.white);
      }

      if (imagePath.startsWith("http")) {
        return Image.network(
          imagePath,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              const Icon(Icons.person, size: 48, color: Colors.white),
        );
      }

      return const Icon(Icons.person, size: 48, color: Colors.white);
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header + Report
            BlocProvider(
              create: (_) => sl<ReportBloc>(),
              child: Stack(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        color: Colors.white,
                        onPressed: () {
                          final didGoBack = desktopKey.currentState?.goBack();
                          if (didGoBack == false) {
                            desktopKey.currentState?.openPage(index: 0);
                          }
                        },
                      ),
                      const SizedBox(width: 4),
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white24,
                        child: ClipOval(
                          child: _buildAvatar(widget.image),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.name,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .color,
                                )),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text("${widget.track} Developer • ",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color,
                                    )),
                                Row(
                                  children: [
                                    const Icon(Icons.star,
                                        size: 14, color: Color(0xFFFFCE31)),
                                    const SizedBox(width: 4),
                                    Text("${widget.rate}",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color,
                                        )),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  /// Report Button
                  BlocListener<ReportBloc, ReportState>(
                    listener: (context, state) {
                      if (state is ReportSuccessState) {
                        Get.snackbar('Success', state.success.message);
                      } else if (state is ReportFailureState) {
                        Get.snackbar('Error', state.error.message);
                      }
                    },
                    child: Positioned(
                      top: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.report, color: Colors.red),
                        onPressed: () {
                          final controller = TextEditingController();

                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text("Report ${widget.name}"),
                              content: TextField(
                                controller: controller,
                                maxLines: 4,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Cancel"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    if (controller.text.trim().isEmpty) return;

                                    context.read<ReportBloc>().add(
                                          ConfirmSubmit(
                                            ReportRequest(
                                              reason: controller.text.trim(),
                                              reportedUser: widget.id,
                                            ),
                                          ),
                                        );

                                    Navigator.pop(context);
                                  },
                                  child: const Text("Send"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            /// Stats
            Container(
              padding: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                  )),
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

            const SizedBox(height: 16),

            /// About
            Text("about".tr, style: Theme.of(context).textTheme.bodyLarge),
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

            const SizedBox(height: 16),

            /// Skills
            Text("skills".tr, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.skills.map((skill) {
                return Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6D6D6).withOpacity(0.25),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    skill.skillName,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodyMedium!.color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            /// Reviews
            Text("reviews".tr, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 8),

            if (widget.reviews.isEmpty)
              const Text("No reviews yet")
            else
              Column(
                children: widget.reviews.map((review) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ReviewCard(
                      name: review.reviewer.name,
                      review: review.review,
                      rating: review.rating,
                      image: review.reviewer.userImage.secureUrl ?? '',
                      role: review.reviewer.role,
                      time: review.createdAt,
                    ),
                  );
                }).toList(),
              ),

            const SizedBox(height: 16),

            /// Actions
            Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppPalette.primary),
                  ),
                  child: IconButton(
                    icon: Icon(Iconsax.message, color: AppPalette.primary),
                    onPressed: () async {
                      try {
                        final chatRepo = sl<ChatRepository>();
                        final chatId =
                            await chatRepo.createOrGetPrivateChat(widget.id);

                        desktopKey.currentState?.openSidePage(
                          body: context
                              .findAncestorStateOfType<
                                  DesktopScreenManagerState>()!
                              .currentBody!,
                          rightPanel: BlocProvider(
                            key: ValueKey(chatId),
                            create: (_) => sl<PublicChatMessagesCubit>()
                              ..init(chatId,
                                  partnerId: widget.id, isPrivate: true),
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
                SizedBox(
                  width: 8,
                ),
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
                            desktopKey.currentState?.openSidePage(
                              body: widget,
                              rightPanel: MultiBlocProvider(
                                providers: [
                                  BlocProvider(
                                    create: (_) => sl<ActiveBookingBloc>()
                                      ..add(LoadMyBookingWithMentor(widget.id)),
                                  ),
                                  BlocProvider(
                                    create: (_) => sl<AcceptedBookingsCubit>(),
                                  ),
                                ],
                                child: BookSessionDesktop(
                                  userId: widget.id,
                                  bookingId: null,
                                  userName: widget.name,
                                  price: widget.hourlyRate,
                                  availableDates: state.data.availableDates,
                                  role: widget.role,
                                ),
                              ),
                            );
                          }
                        } else if (state is GetAvailableDatesError) {
                          Get.snackbar("Error", state.message);
                        }
                      }),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget mentorInfo({
  required BuildContext context,
  required String rate,
  required String info,
}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return Column(
    children: [
      Text(
        rate,
        style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppPalette.primary),
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
