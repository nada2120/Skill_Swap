import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../../../../shared/bloc/get_bookings_cubit/get_bookings_state.dart';
import '../widgets/session_card.dart';

class PendingSessionsPage extends StatefulWidget {
  const PendingSessionsPage({super.key});

  @override
  State<PendingSessionsPage> createState() => _PendingSessionsPageState();
}

class _PendingSessionsPageState extends State<PendingSessionsPage> {

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
          final pending =
          state.bookings.where((s) => s.rawStatus == "pending").toList();

          if (pending.isEmpty) {
            return const Center(child: Text("No pending sessions"));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: pending.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (_, index) {
              return SessionCard(
                session: pending[index],
                currentStatus: "pending",
              );
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}
