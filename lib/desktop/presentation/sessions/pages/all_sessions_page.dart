import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../../../../shared/bloc/get_bookings_cubit/get_bookings_state.dart';
import '../widgets/session_card.dart';

class AllSessionsPage extends StatelessWidget {
  const AllSessionsPage({super.key});

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
          if (state.bookings.isEmpty) {
            return const Center(child: Text("No sessions available"));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.bookings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (_, index) {
              return SessionCard(
                  session: state.bookings[index], currentStatus: "all");
            },
          );
        }

        return const SizedBox();
      },
    );
  }
}
