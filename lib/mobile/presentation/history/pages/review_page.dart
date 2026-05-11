import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../models/history_model.dart';
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

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

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03,
            vertical: screenHeight * 0.01,
          ),
          child: ListView.separated(
            itemCount: sessions.length,
            separatorBuilder: (_, __) => SizedBox(height: screenHeight * 0.01),
            itemBuilder: (_, index) {
              return HistoryCard(data: sessions[index]);
            },
          ),
        );
      },
    );
  }
}
