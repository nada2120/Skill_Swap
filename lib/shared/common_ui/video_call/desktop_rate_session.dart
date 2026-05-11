import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../mobile/presentation/sessions/models/session.dart';
import '../../../shared/bloc/submit_review_bloc/submit_review_bloc.dart';
import '../../../shared/common_ui/error_dialog.dart';
import '../../../shared/common_ui/screen_manager/screen_manager.dart';
import '../../../shared/core/theme/app_palette.dart';
import '../../../shared/data/models/submit_review/submit_review_request.dart';

class DesktopRateSessionScreen extends StatefulWidget {
  final SessionModel session;

  const DesktopRateSessionScreen({super.key, required this.session});

  @override
  State<DesktopRateSessionScreen> createState() =>
      _DesktopRateSessionScreenState();
}

class _DesktopRateSessionScreenState extends State<DesktopRateSessionScreen> {
  int selectedRating = 0;
  final TextEditingController commentController = TextEditingController();

  final Set<String> selectedTags = {};

  Widget _buildUserImage(double cardWidth) {
    final image = widget.session.userImage;

    if (image == null || image.isEmpty) return _buildPlaceholder(cardWidth);

    if (image.startsWith("http") || image.startsWith("https")) {
      return Image.network(
        image,
        width: cardWidth * 0.25,
        height: cardWidth * 0.25,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(cardWidth),
      );
    }

    if (image.startsWith("data:image")) {
      try {
        final base64Str = image.split(',')[1];
        final bytes = base64Decode(base64Str);
        return Image.memory(
          bytes,
          width: cardWidth * 0.25,
          height: cardWidth * 0.25,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildPlaceholder(cardWidth),
        );
      } catch (e) {
        return _buildPlaceholder(cardWidth);
      }
    }

    return _buildPlaceholder(cardWidth);
  }

  String formatTime12h(DateTime dt) {
    final formatter = DateFormat('hh:mm a');
    return formatter.format(dt);
  }

  String getRatingText(int rating) {
    switch (rating) {
      case 1:
        return "Very Bad - Needs serious improvement";
      case 2:
        return "Bad - Not satisfied";
      case 3:
        return "Average - It was okay";
      case 4:
        return "Good - Nice session";
      case 5:
        return "Excellent - Outstanding session!";
      default:
        return "Tap a star to rate";
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.35;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<SubmitReviewBloc, SubmitReviewState>(
      listener: (context, state) {
        if (state is SubmitReviewSuccessState) {
          showAppDialog(
            context: context,
            type: DialogType.success,
            message: "Thank you for your feedback!",
            //autoCloseDuration: const Duration(seconds: 5),
            onPressed: () {
              Get.offAll(() => ScreenManager(
                    initialIndex: 3,
                    initialSessionTab: 0,
                  ));
            },
          );
        } else if (state is SubmitReviewFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error.message)),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        // appBar: AppBar(
        //   backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        //   elevation: 0,
        //   // leading: BackButton(
        //   //   color: isDark ? Colors.white : AppPalette.primary,
        //   // ),
        //   title: Text(
        //     "Rate Your Session",
        //     style: TextStyle(
        //       color: isDark ? Colors.white : AppPalette.primary,
        //     ),
        //   ),
        //
        //   actions: [
        //     TextButton(
        //       onPressed: () {
        //         Get.offAll(() => ScreenManager(
        //               initialIndex: 3,
        //               initialSessionTab: 0,
        //             ));
        //       },
        //       child: Text(
        //         "Skip",
        //         style: TextStyle(
        //           color: isDark ? Colors.white : AppPalette.primary,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //     ),
        //     const SizedBox(width: 8),
        //   ],
        // ),
        body: Center(
          child: Container(
            width: 700,
            height: 750,
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                /// 🔹 Header (بديل AppBar)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Rate Your Session",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppPalette.primary,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Get.offAll(() => ScreenManager(
                                initialIndex: 3,
                                initialSessionTab: 0,
                              ));
                        },
                        child: const Text("Skip"),
                      )
                    ],
                  ),
                ),

                /// 🔹 Body
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ListView(
                      children: [
                        /// Session Info
                        Row(
                          children: [
                            ClipOval(child: _buildUserImage(200)),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.session.userName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                        formatTime12h(widget.session.dateTime)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today, size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                        "${widget.session.dateTime.day}/${widget.session.dateTime.month}/${widget.session.dateTime.year}"),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        /// Rating
                        const Text(
                          "How would you rate this session?",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (index) {
                            return IconButton(
                              onPressed: () {
                                setState(() {
                                  selectedRating = index + 1;
                                });
                              },
                              icon: Icon(
                                Icons.star,
                                size: 40,
                                color: selectedRating > index
                                    ? Colors.amber
                                    : Colors.grey.shade300,
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 8),

                        if (selectedRating != 0)
                          Center(
                            child: Text(
                              getRatingText(selectedRating),
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),

                        const SizedBox(height: 30),

                        /// Comment
                        const Text(
                          "Additional Comments",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),

                        TextField(
                          controller: commentController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            hintText: "Tell us about your experience...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// Submit
                        BlocBuilder<SubmitReviewBloc, SubmitReviewState>(
                          builder: (context, state) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppPalette.primary,
                                padding: const EdgeInsets.all(16),
                              ),
                              onPressed: selectedRating == 0 ||
                                      state is SubmitReviewLoading
                                  ? null
                                  : () {
                                      final request = SubmitReviewRequest(
                                        rate: selectedRating,
                                        review: commentController.text,
                                      );

                                      context.read<SubmitReviewBloc>().add(
                                            ConfirmSubmit(
                                              id: widget.session.sessionId,
                                              request: request,
                                            ),
                                          );
                                    },
                              child: state is SubmitReviewLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white)
                                  : const Text("Submit Feedback"),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget iconText({
    required BuildContext context,
    required IconData icon,
    required String data,
    required double screenWidth,
  }) {
    return Row(
      children: [
        Icon(icon, size: screenWidth * 0.045),
        SizedBox(width: screenWidth * 0.015),
        Flexible(child: Text(data)),
      ],
    );
  }

  Widget _buildPlaceholder(double cardWidth) {
    return Container(
      width: cardWidth * 0.25,
      height: cardWidth * 0.25,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      child: const Icon(Icons.person, color: Colors.white),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: child,
    );
  }
}

class ThankYouScreen extends StatelessWidget {
  const ThankYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 80,
              ),
              SizedBox(height: 16),
              Text(
                "Thank you for your feedback!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                "Your rating and feedback help us maintain quality mentorship on the platform.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
      ),
    );
  }
}
