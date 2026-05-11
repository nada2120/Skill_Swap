import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:skill_swap/mobile/presentation/sessions/widgets/state_filter.dart';

import '../../../../shared/bloc/get_bookings_cubit/get_bookings_cubit.dart';
import '../../../../shared/common_ui/circle_button_icon.dart';
import '../../../../shared/core/theme/app_palette.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../../history/screens/history_screen.dart';

class SessionsHeader extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;
  final String title;
  final String subtitle;

  const SessionsHeader({
    super.key,
    required this.selectedIndex,
    required this.onSelect,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.24,
      // responsive height
      width: double.infinity,
      color: AppPalette.primary,
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * 0.04),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: screenWidth * 0.04,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.005),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: screenWidth * 0.035,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              CircleButtonIcon(
                icon: Icons.history,
                onTap: () {
                  Get.to(BlocProvider(
                    create: (_) => sl<GetBookingsCubit>(),
                    child: HistoryScreen(),
                  ));
                },
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          StatusFilter(
            selectedIndex: selectedIndex,
            onSelect: onSelect,
          ),
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
    // "All",
    "Accepted",
    "Pending",
    "Request",
  ];
  final screenWidth = MediaQuery.of(context).size.width;

  return Wrap(
    spacing: screenWidth * 0.02,
    runSpacing: screenWidth * 0.02,
    children: List.generate(statusList.length, (index) {
      final isSelected = selectedIndex == index;

      return GestureDetector(
        onTap: () => onSelect(index),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.03,
            vertical: screenWidth * 0.015,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).colorScheme.surface
                : Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(screenWidth * 0.02),
          ),
          child: Text(
            statusList[index],
            style: TextStyle(
              fontSize: screenWidth * 0.035,
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
