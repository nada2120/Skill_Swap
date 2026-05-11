import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../shared/bloc/submit_review_bloc/submit_review_bloc.dart';
import '../../../shared/common_ui/screen_manager/screen_manager.dart';
import '../../../shared/core/theme/app_palette.dart';
import '../../../shared/data/models/submit_review/submit_review_request.dart';

class RateSessionScreen extends StatefulWidget {
  final String sessionId;
  final String userName;
  final DateTime dateTime;

  const RateSessionScreen(
      {super.key,
      required this.sessionId,
      required this.userName,
      required this.dateTime});

  @override
  State<RateSessionScreen> createState() => _RateSessionScreenState();
}

class _RateSessionScreenState extends State<RateSessionScreen> {
  int selectedRating = 0;
  final TextEditingController commentController = TextEditingController();

  bool isSkipPressed = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<SubmitReviewBloc, SubmitReviewState>(
      listener: (context, state) {
        if (state is SubmitReviewSuccessState) {
          Get.offAll(() => ScreenManager(
                initialIndex: 3,
                initialSessionTab: 0,
              ));
        }

        if (state is SubmitReviewFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          title: Text(
            "Rate Your Session",
            style: TextStyle(
              color: isDark ? Colors.white : AppPalette.primary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                isSkipPressed = true;

                final request = SubmitReviewRequest(
                  rate: 0,
                  review: "Skip",
                );

                context.read<SubmitReviewBloc>().add(
                      ConfirmSubmit(
                        id: widget.sessionId,
                        request: request,
                      ),
                    );
              },
              child: Text(
                "Skip",
                style: TextStyle(
                  color: isDark ? Colors.white : AppPalette.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              // ================= SESSION SUMMARY =================
              _buildCard(
                context,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Session Summary",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildUserImage(screenWidth),
                        const SizedBox(width: 12),
                        Text(
                          widget.userName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    iconText(
                      icon: Icons.access_time,
                      data: formatTime12h(widget.dateTime),
                      screenWidth: screenWidth,
                    ),
                    iconText(
                      icon: Icons.calendar_today_outlined,
                      data:
                          "${widget.dateTime.day}/${widget.dateTime.month}/${widget.dateTime.year}",
                      screenWidth: screenWidth,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ================= RATING =================
              _buildCard(
                context,
                Column(
                  children: [
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
                              isSkipPressed = false;
                            });
                          },
                          icon: Icon(
                            Icons.star,
                            size: 32,
                            color: selectedRating > index
                                ? Colors.amber
                                : Colors.grey.shade300,
                          ),
                        );
                      }),
                    ),
                    if (selectedRating != 0)
                      Text(getRatingText(selectedRating)),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ================= COMMENT =================
              _buildCard(
                context,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Additional Comments (Required)",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: commentController,
                      maxLines: 4,
                      onChanged: (_) => isSkipPressed = false,
                      decoration: const InputDecoration(
                        hintText: "Tell us about your experience...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ================= SUBMIT =================
              BlocBuilder<SubmitReviewBloc, SubmitReviewState>(
                builder: (context, state) {
                  final isLoading = state is SubmitReviewLoading;

                  return ElevatedButton(
                    onPressed: selectedRating == 0 || isLoading
                        ? null
                        : () {
                            isSkipPressed = false;

                            final request = SubmitReviewRequest(
                              rate: selectedRating,
                              review: commentController.text,
                            );

                            context.read<SubmitReviewBloc>().add(
                                  ConfirmSubmit(
                                    id: widget.sessionId,
                                    request: request,
                                  ),
                                );
                          },
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text("Submit Feedback"),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HELPERS =================

  String formatTime12h(DateTime dt) => DateFormat('hh:mm a').format(dt);

  String getRatingText(int rating) {
    switch (rating) {
      case 1:
        return "Very Bad";
      case 2:
        return "Bad";
      case 3:
        return "Average";
      case 4:
        return "Good";
      case 5:
        return "Excellent";
      default:
        return "";
    }
  }

  Widget iconText({
    required IconData icon,
    required String data,
    required double screenWidth,
  }) {
    return Row(
      children: [
        Icon(icon, size: screenWidth * 0.045),
        const SizedBox(width: 6),
        Text(data),
      ],
    );
  }

  Widget _buildUserImage(double size) {
    return Container(
      width: size * 0.12,
      height: size * 0.12,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      child: const Icon(Icons.person, color: Colors.white),
    );
  }

  Widget _buildCard(BuildContext context, Widget child) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 2,
        ),
      ),
      child: child,
    );
  }
}
