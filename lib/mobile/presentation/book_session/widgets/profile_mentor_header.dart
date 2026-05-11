import 'dart:io';

import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../shared/bloc/report_bloc/report_bloc.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/data/models/report_user/report_request.dart';
import '../../../../shared/dependency_injection/injection.dart';

class ProfileMentorHeader extends StatelessWidget {
  final String id;
  final String image;
  final String name;
  final String track;
  final num rate;
  final VoidCallback? onButtonTap;

  const ProfileMentorHeader({
    super.key,
    required this.id,
    required this.image,
    required this.name,
    required this.track,
    required this.rate,
    this.onButtonTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final cardWidth = screenWidth * 0.55;

    final containerHeight = screenHeight * 0.2;
    final imageSize = screenWidth * 0.12;
    final nameFontSize = screenWidth * 0.05;
    final trackFontSize = screenWidth * 0.045;
    final rateFontSize = screenWidth * 0.04;
    final iconSize = screenWidth * 0.04;

    final hasImage = image.isNotEmpty;

    Widget avatar = CircleAvatar(
      radius: imageSize / 2,
      backgroundColor: Colors.white24,
      backgroundImage:
          (hasImage && defaultTargetPlatform != TargetPlatform.windows)
              ? FileImage(File(image))
              : null,
      child: (!hasImage || defaultTargetPlatform == TargetPlatform.windows)
          ? Icon(Icons.person, size: imageSize * 0.8, color: Colors.white)
          : null,
    );

    return BlocProvider(
      create: (_) => sl<ReportBloc>(),
      child: Builder(
        builder: (parentContext) {
          return Stack(
            children: [
              Container(
                height: containerHeight,
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppPalette.primary,
                ),
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back,
                            size: iconSize, color: Colors.white),
                        onPressed: () {
                          Get.back();
                        },
                      ),
                      SizedBox(width: screenWidth * 0.01),
                      ClipOval(
                        child: (image != null && image!.startsWith("http"))
                            ? Image.network(
                                image!,
                                width: cardWidth * 0.25,
                                height: cardWidth * 0.25,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _buildPlaceholder(cardWidth),
                              )
                            : _buildPlaceholder(cardWidth),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "$name • ",
                                  style: TextStyle(
                                      fontSize: nameFontSize,
                                      color: Colors.white),
                                ),
                                Icon(Icons.star,
                                    size: iconSize,
                                    color: const Color(0xFFFFCE31)),
                                SizedBox(width: screenWidth * 0.01),
                                Text(
                                  rate.toStringAsFixed(2),
                                  style: TextStyle(
                                      fontSize: rateFontSize,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              track,
                              style: TextStyle(
                                  fontSize: trackFontSize,
                                  color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              BlocListener<ReportBloc, ReportState>(
                listener: (context, state) {
                  if (state is ReportSuccessState) {
                    Get.snackbar('Success', state.success.message);
                  } else if (state is ReportFailureState) {
                    Get.snackbar('Error', state.error.message);
                  }
                },
                child: Positioned(
                  top: containerHeight * 0.2,
                  right: screenWidth * 0.04,
                  child: circleButton(
                    context: parentContext,
                    icon: Icons.report_outlined,
                    onTap: () {
                      showReportDialog(parentContext);
                    },
                    screenWidth: screenWidth,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget circleButton({
    required BuildContext context,
    required IconData icon,
    VoidCallback? onTap,
    required double screenWidth,
  }) {
    return Material(
      color: Theme.of(context).cardColor,
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.02),
          child: Icon(
            icon,
            size: screenWidth * 0.04,
            color: Colors.red,
          ),
        ),
      ),
    );
  }

  void showReportDialog(BuildContext parentContext) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: parentContext,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: MediaQuery.of(dialogContext).size.width * 0.90,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(dialogContext).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Why are you reporting $name?",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Write your reason here...",
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                        },
                        child: const Text("Cancel"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (controller.text.trim().isEmpty) return;

                          final request = ReportRequest(
                            reason: controller.text.trim(),
                            reportedUser: id,
                          );

                          parentContext.read<ReportBloc>().add(
                                ConfirmSubmit(request),
                              );

                          Navigator.pop(dialogContext);
                        },
                        child: const Text("Send"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
      child: const Icon(
        Icons.person,
        color: Colors.white,
      ),
    );
  }
}
