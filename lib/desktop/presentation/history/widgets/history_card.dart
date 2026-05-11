import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/main.dart';

import '../../../../mobile/presentation/history/models/history_model.dart';
import '../../../../shared/bloc/submit_review_bloc/submit_review_bloc.dart';
import '../../../../shared/common_ui/video_call/rateSession.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../details/models/details_model.dart';
import '../../details/screens/session_details.dart';

class HistoryCard extends StatelessWidget {
  final HistoryModel data;

  const HistoryCard({super.key, required this.data});

  Color getStatusColor() {
    switch (data.status) {
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

  bool get isIssue => data.errorMessage != null;

  bool get isCancelled => data.status == "Cancelled";

  bool get isFinished => data.status == "Finished";

  bool get isReviewReceived => data.isReviewReceived == true;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipOval(
                child: Image.asset(
                  data.imageUrl,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data.name,
                        style: Theme.of(context).textTheme.titleMedium),
                    Text(
                      data.role,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (!isReviewReceived)
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: getStatusColor().withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    data.status,
                    style: TextStyle(
                      color: getStatusColor(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(
                Icons.calendar_month,
                size: 20,
                color: Theme.of(context).textTheme.bodyMedium!.color,
              ),
              const SizedBox(width: 8),
              Text(
                data.date,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.access_time,
                  size: 20,
                  color: Theme.of(context).textTheme.bodyMedium!.color),
              const SizedBox(width: 8),
              Text(
                "${data.time} – ${data.duration}",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 16),
          buildBottomSection(context),
        ],
      ),
    );
  }

  Widget buildBottomSection(BuildContext context) {
    // REVIEW RECEIVED
    if (isReviewReceived) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFE7BA2A).withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Their rating:",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 8),
                Row(
                  children: List.generate(
                    5,
                    (i) => Icon(
                      i < data.rating ? Icons.star : Icons.star_border,
                      size: 18,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ],
            ),
            if (data.reviewComment != null &&
                data.reviewComment!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                "“${data.reviewComment}”",
                style: const TextStyle(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      );
    }

    //  ISSUE
    if (isIssue) {
      return Container(
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFF9DADA),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Text(
              "Error: ",
              style: TextStyle(color: Colors.black),
            ),
            Text(
              data.errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
          ],
        ),
      );
    }

    //  CANCELLED
    if (isCancelled) {
      return Container(
        width: double.infinity,
        height: 44,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFD6D6D6)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            "View Details",
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );
    }

    if (isFinished) {
      // لو مفيش تقييم
      if (data.rating == 0) {
        return InkWell(
          onTap: () {
            Get.to(
              () => BlocProvider(
                create: (_) => sl<SubmitReviewBloc>(),
                child: RateSessionScreen(
                    sessionId: data.id,
                    userName: data.name,
                    dateTime: DateTime.parse(data.date)),
              ),
            );
          },
          child: Container(
            height: 44,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD6D6D6)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star_border_outlined, size: 18),
                SizedBox(width: 8),
                Text("Rate Session",
                    style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          ),
        );
      }

      // لو متقيم بالفعل
      return Container(
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFE7BA2A).withOpacity(0.16),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Text("Your rating: ",
                style: Theme.of(context).textTheme.titleMedium),
            Row(
              children: List.generate(
                5,
                (i) => Icon(
                  i < data.rating ? Icons.star : Icons.star_border,
                  size: 18,
                  color: Colors.amber,
                ),
              ),
            ),
          ],
        ),
      );
    }

    //  FINISHED NOT RATED

    return const SizedBox();
  }
}
