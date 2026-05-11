import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/mobile/presentation/history/models/history_model.dart';
import 'package:skill_swap/shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';

import '../widgets/history_card.dart';

class ReviewSessionsPage extends StatefulWidget {
  const ReviewSessionsPage({super.key});

  @override
  State<ReviewSessionsPage> createState() => _ReviewSessionsPageState();
}

class _ReviewSessionsPageState extends State<ReviewSessionsPage> {
  late Future<List<HistoryModel>> future;

  @override
  void initState() {
    super.initState();
    future = context.read<GetBookingsCubit>().getReviewHistory();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<HistoryModel>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No reviews yet"));
        }

        final sessions = snapshot.data!;

        return ListView.separated(
          //physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemCount: sessions.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (_, index) {
            return HistoryCard(data: sessions[index]);
          },
        );
        ;
      },
    );
  }
}
