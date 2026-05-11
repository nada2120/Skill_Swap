import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../../../../shared/bloc/get_bookings_cubit/get_bookings_state.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../widgets/session_card.dart';

class UpcomingSessionsPage extends StatelessWidget {
  const UpcomingSessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetBookingsCubit, GetBookingsState>(
      builder: (context, state) {
        if (state is GetBookingsLoading) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppPalette.primary,
            ),
          );
        }

        if (state is GetBookingsError) {
          return Center(child: Text(state.message));
        }

        if (state is GetBookingsLoaded) {
          if (state.bookings.isEmpty) {
            return const Center(child: Text("No upcoming sessions"));
          }

          /// 🔥 check if there are unpaid sessions
          final unpaidSessions = state.bookings.where((session) =>
              session.paymentStatus == "unpaid" &&
              session.price > 0 &&
              session.isStudent);

          final hasUnpaidSessions = unpaidSessions.isNotEmpty;
          final unpaidCount = unpaidSessions.length;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (hasUnpaidSessions)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                        color: Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(20),
                        border:
                            Border.all(color: Theme.of(context).dividerColor)),
                    child: Row(
                      children: [
                        const Icon(Icons.attach_money, color: Colors.white),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Payment Required",
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "You have $unpaidCount session(s) pending payment.\nTo avoid losing your booking, please complete payment no later than 6 hours before the session begins.",
                                style: const TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView.separated(
                    itemCount: state.bookings.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 16),
                    itemBuilder: (_, index) {
                      return SessionCard(
                        session: state.bookings[index],
                        currentStatus: "accepted",
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox();
      },
    );
  }
}
