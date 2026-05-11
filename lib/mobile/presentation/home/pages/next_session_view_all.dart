import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/shared/common_ui/base_screen.dart';

import '../../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../../../../shared/bloc/get_bookings_cubit/get_bookings_state.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../widgets/next_session_card.dart';

class NextSessionViewAll extends StatefulWidget {
  const NextSessionViewAll({super.key});

  @override
  State<NextSessionViewAll> createState() => _NextSessionViewAllState();
}

class _NextSessionViewAllState extends State<NextSessionViewAll> {
  int? selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Next Sessions',
      child: BlocBuilder<GetBookingsCubit, GetBookingsState>(
        builder: (context, state) {
          if (state is GetTodaySessionsLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppPalette.primary,
              ),
            );
          }

          if (state is GetTodaySessionsLoaded) {
            if (state.sessions.isEmpty) {
              return const Center(child: Text("No sessions"));
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: state.sessions.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final s = state.sessions[index];

                return NextSessionCard(
                  name: s.name,
                  duration: s.duration,
                  dateTime: s.dateTime,
                  sessionTime: s.sessionTime,
                  isMentor: s.isMentor,
                );
              },
            );
          }

          if (state is GetBookingsError) {
            return const Center(child: Text("Error loading sessions"));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
