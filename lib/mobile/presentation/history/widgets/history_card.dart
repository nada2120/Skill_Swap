import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../shared/bloc/submit_review_bloc/submit_review_bloc.dart';
import '../../../../shared/common_ui/video_call/rateSession.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../models/history_model.dart';

class HistoryCard extends StatefulWidget {
  final HistoryModel data;

  const HistoryCard({super.key, required this.data});

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  Color getStatusColor() {
    switch (widget.data.status) {
      case "Finished":
        return Colors.green;
      case "Rejected":
        return Colors.red;
      case "Cancelled":
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  bool get isIssue => widget.data.errorMessage != null;

  bool get isCancelled => widget.data.status == "Cancelled";

  bool get isFinished => widget.data.status == "Finished";

  bool get isReviewReceived => widget.data.isReviewReceived == true;

  Widget _buildPlaceholder(double cardWidth) {
    return Container(
      width: cardWidth,
      height: cardWidth,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
      ),
      child: const Icon(Icons.person, color: Colors.white),
    );
  }

  Widget _buildUserImage(double cardWidth) {
    final image = widget.data.imageUrl;

    if (image == null || image.isEmpty) {
      return _buildPlaceholder(cardWidth);
    }

    if (image.startsWith("http") || image.startsWith("https")) {
      return Image.network(
        image,
        width: cardWidth,
        height: cardWidth,
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
          width: cardWidth,
          height: cardWidth,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildPlaceholder(cardWidth),
        );
      } catch (e) {
        return _buildPlaceholder(cardWidth);
      }
    }

    return _buildPlaceholder(cardWidth);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      margin: EdgeInsets.symmetric(
          vertical: screenHeight * 0.01, horizontal: screenWidth * 0.04),
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(child: _buildUserImage(screenWidth * 0.1)),
              SizedBox(width: screenWidth * 0.02),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.data.name,
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(widget.data.role,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              if (!isReviewReceived)
                Container(
                  padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.005,
                      horizontal: screenWidth * 0.02),
                  decoration: BoxDecoration(
                    color: getStatusColor().withOpacity(0.15),
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  ),
                  child: Text(
                    widget.data.status,
                    style: TextStyle(
                      color: getStatusColor(),
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.035,
                    ),
                  ),
                )
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          Row(
            children: [
              Icon(Icons.calendar_month,
                  size: screenWidth * 0.05,
                  color: Theme.of(context).textTheme.bodyMedium!.color),
              SizedBox(width: screenWidth * 0.02),
              Text(widget.data.date,
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          SizedBox(height: screenHeight * 0.005),
          Row(
            children: [
              Icon(Icons.access_time,
                  size: screenWidth * 0.05,
                  color: Theme.of(context).textTheme.bodyMedium!.color),
              SizedBox(width: screenWidth * 0.02),
              Text("${widget.data.time} – ${widget.data.duration}",
                  style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          buildBottomSection(context, screenWidth, screenHeight),
        ],
      ),
    );
  }

  Widget buildBottomSection(
      BuildContext context, double screenWidth, double screenHeight) {
    double buttonHeight = screenHeight * 0.06;

    // REVIEW RECEIVED
    if (isReviewReceived) {
      return Container(
        padding: EdgeInsets.all(screenWidth * 0.03),
        decoration: BoxDecoration(
          color: const Color(0xFFE7BA2A).withOpacity(0.16),
          borderRadius: BorderRadius.circular(screenWidth * 0.035),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("Their rating:",
                    style: Theme.of(context).textTheme.titleMedium),
                SizedBox(width: screenWidth * 0.02),
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < widget.data.rating ? Icons.star : Icons.star_border,
                      size: screenWidth * 0.045,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ],
            ),
            if (widget.data.reviewComment != null &&
                widget.data.reviewComment!.isNotEmpty) ...[
              SizedBox(height: screenHeight * 0.01),
              Text(
                "“${widget.data.reviewComment}”",
                style: TextStyle(
                  fontSize: screenWidth * 0.033,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      );
    }

    // ISSUE
    if (isIssue) {
      return Container(
        height: buttonHeight,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
        decoration: BoxDecoration(
          color: const Color(0xFFF9DADA),
          borderRadius: BorderRadius.circular(screenWidth * 0.035),
        ),
        child: Row(
          children: [
            Text("Error: ", style: TextStyle(color: Colors.black)),
            Expanded(
              child: Text(
                widget.data.errorMessage!,
                style: TextStyle(color: Colors.red),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    // CANCELLED
    if (isCancelled) {
      return Container(
        width: double.infinity,
        height: buttonHeight,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD6D6D6)),
          borderRadius: BorderRadius.circular(screenWidth * 0.035),
        ),
        child: Center(
          child: Text("View Details",
              style: Theme.of(context).textTheme.titleMedium),
        ),
      );
    }

    // FINISHED
    if (isFinished) {
      // لو مفيش تقييم
      if (widget.data.rating == 0) {
        return InkWell(
          onTap: () {
            Get.to(
              () => BlocProvider(
                create: (_) => sl<SubmitReviewBloc>(),
                child: RateSessionScreen(
                    sessionId: widget.data.id,
                    userName: widget.data.name,
                    dateTime: DateTime.parse(widget.data.date)),
              ),
            );
          },
          child: Container(
            height: buttonHeight,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD6D6D6)),
              borderRadius: BorderRadius.circular(screenWidth * 0.035),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star_border_outlined, size: screenWidth * 0.05),
                SizedBox(width: screenWidth * 0.01),
                Text("Rate Session",
                    style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
        );
      }

      // لو متقيم بالفعل
      return Container(
        height: buttonHeight,
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
        decoration: BoxDecoration(
          color: const Color(0xFFE7BA2A).withOpacity(0.16),
          borderRadius: BorderRadius.circular(screenWidth * 0.035),
        ),
        child: Row(
          children: [
            Text("Your rating: ",
                style: Theme.of(context).textTheme.titleMedium),
            Row(
              children: List.generate(
                5,
                (i) => Icon(
                  i < widget.data.rating ? Icons.star : Icons.star_border,
                  size: screenWidth * 0.045,
                  color: Colors.amber,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox();
  }
}
