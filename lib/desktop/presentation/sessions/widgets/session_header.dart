import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/desktop/presentation/history/screens/history_screen.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';

import '../../../../main.dart';
import '../../../../shared/common_ui/circle_button_icon.dart';

class SessionsHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const SessionsHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).textTheme.bodyLarge!.color,
                        )),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(context).textTheme.bodyMedium!.color,
                      ),
                    ),
                  ],
                ),
              ),
              CircleButtonIcon(
                icon: Icons.history,
                onTap: () {
                  desktopKey.currentState?.openSidePage(
                      body: BlocProvider(
                    create: (_) => sl<GetBookingsCubit>(),
                    child: HistoryScreen(),
                  ));
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

Widget selectStatus({
  required BuildContext context,
  required int selectedIndex,
  required Function(int) onSelect,
}) {
  final List<String> statusList = [
    "All",
    "Accepted",
    "Pending",
    "Request",
  ];

  return Wrap(
    spacing: 8,
    runSpacing: 8,
    children: List.generate(statusList.length, (index) {
      final isSelected = selectedIndex == index;

      return GestureDetector(
        onTap: () => onSelect(index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            statusList[index],
            style: TextStyle(
              fontSize: 12,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }),
  );
}
