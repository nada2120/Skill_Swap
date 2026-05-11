import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../../../../shared/bloc/get_bookings_cubit/get_bookings_state.dart';
import '../widgets/session_card.dart';

class RequestsSessionsPage extends StatefulWidget {
  const RequestsSessionsPage({super.key});

  @override
  State<RequestsSessionsPage> createState() => _RequestsSessionsPageState();
}

class _RequestsSessionsPageState extends State<RequestsSessionsPage> {
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
          final requests =
              state.bookings.where((s) => s.rawStatus == "requested").toList();

          if (requests.isEmpty) {
            return const Center(child: Text("No requests"));
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: requests.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (_, index) {
              return SessionCard(
                session: requests[index],
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
