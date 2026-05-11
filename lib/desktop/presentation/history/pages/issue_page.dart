import 'package:flutter/material.dart';
import 'package:skill_swap/mobile/presentation/history/models/history_model.dart';

import '../widgets/history_card.dart';

class IssueSessionsPage extends StatelessWidget {
  const IssueSessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<HistoryModel> issueSessions = [
      HistoryModel(
        id: "1",
        name: "Alex Johnson",
        role: "Flutter Developer",
        date: "Oct 2, 2025",
        time: "2:00 PM",
        duration: "60 min",
        status: "Rejected",
        rating: 0,
        errorMessage: "Schedule conflict",
        imageUrl: "assets/images/people_images/Alex Johnson.png",
      ),
      HistoryModel(
        id: "1",
        name: "Kevin Smith",
        role: "AI Basics",
        date: "Sep 30, 2025",
        time: "5:00 PM",
        duration: "60 min",
        status: "Rejected",
        rating: 0,
        errorMessage: "User unavailable",
        imageUrl: "assets/images/people_images/Kevin Smith.jpg",
      ),
      HistoryModel(
        id: "1",
        name: "Emily Carter",
        role: "Business Strategy",
        date: "Sep 22, 2025",
        time: "7:00 PM",
        duration: "45 min",
        status: "Rejected",
        rating: 0,
        errorMessage: "Technical issue",
        imageUrl: "assets/images/people_images/Emily Carter.jpg",
      ),
    ];

    return ListView.separated(
      //  physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: issueSessions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, index) {
        return HistoryCard(data: issueSessions[index]);
      },
    );
  }
}
