import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../../../../shared/bloc/get_bookings_cubit/get_bookings_state.dart';
import '../widgets/session_card.dart';

class RejectedSessionsPage extends StatefulWidget {
  const RejectedSessionsPage({super.key});

  @override
  State<RejectedSessionsPage> createState() => _RejectedSessionsPageState();
}

class _RejectedSessionsPageState extends State<RejectedSessionsPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetBookingsCubit, GetBookingsState>(
      builder: (context, state) {
        if (state is GetBookingsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is GetBookingsError) {
          return Center(child: Text(state.message));
        }

        if (state is GetBookingsLoaded) {
          final rejected =
              state.bookings.where((s) => s.rawStatus == "rejected").toList();

          if (rejected.isEmpty) {
            return const Center(child: Text("No rejected sessions"));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: rejected.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (_, index) {
              return SessionCard(
                session: rejected[index],
                currentStatus: "rejected",
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}
