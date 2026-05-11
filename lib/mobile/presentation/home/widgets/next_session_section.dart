import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import '../../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../../../../shared/bloc/get_bookings_cubit/get_bookings_state.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../pages/next_session_view_all.dart';
import 'next_session_card.dart';
import 'section_header.dart';

class NextSessionSection extends StatelessWidget {
  const NextSessionSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetBookingsCubit, GetBookingsState>(
      builder: (context, state) {
        if (state is GetTodaySessionsLoading) {
          return const Center(
              child: CircularProgressIndicator(
            color: AppPalette.primary,
          ));
        }

        if (state is GetTodaySessionsLoaded) {
          if (state.sessions.isEmpty) {
            return const SizedBox.shrink();
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(
                sectionTitle: 'your_next_session'.tr,
                onTop: () {
                  Get.to(
                    () => BlocProvider.value(
                      value: context.read<GetBookingsCubit>(),
                      child: const NextSessionViewAll(),
                    ),
                  );
                },
              ),
              //  const SizedBox(height: 10),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
              ),
            ],
          );
        }

        if (state is GetBookingsError) {
          return const SizedBox.shrink();
        }

        return const SizedBox.shrink();
      },
    );
  }
}
