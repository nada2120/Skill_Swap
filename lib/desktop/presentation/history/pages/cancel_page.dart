import 'package:flutter/material.dart';
import 'package:skill_swap/mobile/presentation/history/models/history_model.dart';

import '../widgets/history_card.dart';

class CancelSessionsPage extends StatelessWidget {
  const CancelSessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<HistoryModel> cancelledSessions = [
      HistoryModel(
        id: "1",
        name: "Sarah Adams",
        role: "Mobile Developer",
        date: "Oct 1, 2025",
        time: "3:00 PM",
        duration: "60 min",
        status: "Cancelled",
        rating: 0,
        imageUrl: "assets/images/people_images/Sarah Adams.jpg",
      ),
      HistoryModel(
        id: "1",
        name: "Daniel Lee",
        role: "Data Science",
        date: "Sep 28, 2025",
        time: "11:00 AM",
        duration: "30 min",
        status: "Cancelled",
        rating: 0,
        imageUrl: "assets/images/people_images/Daniel Lee.jpg",
      ),
      HistoryModel(
        id: "1",
        name: "Mia Fernandez",
        role: "Web Developer",
        date: "Sep 20, 2025",
        time: "6:00 PM",
        duration: "45 min",
        status: "Cancelled",
        rating: 0,
        imageUrl: "assets/images/people_images/Mia Fernandez.jpg",
      ),
    ];
    return ListView.separated(
      //physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: cancelledSessions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, index) {
        return HistoryCard(data: cancelledSessions[index]);
      },
    );
  }
}
