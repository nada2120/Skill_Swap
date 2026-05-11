import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../shared/bloc/store_cubit/store_cubit.dart';
import '../../../../shared/bloc/store_cubit/store_state.dart';
import '../../../../shared/core/theme/app_palette.dart';

class TimerWidget extends StatelessWidget {
  const TimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<StoreCubit, StoreState>(
      builder: (_, state) {
        final d = state.remaining;

        final totalWeek = 7 * 24 * 60 * 60 * 1000;
        final progress =
            (state.remaining.inMilliseconds / totalWeek).clamp(0.0, 1.0);

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).cardColor,
                Theme.of(context).scaffoldBackgroundColor,
              ],
            ),
            border: Border.all(
              color: AppPalette.primary,
              width: 2.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppPalette.primary.withOpacity(0.25),
                blurRadius: 18,
                spreadRadius: 1,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Title Row
              Row(
                children: [
                  Icon(
                    Icons.hourglass_bottom,
                    color: isDark ? Colors.white : AppPalette.primary,
                    size: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Store Refresh",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: isDark ? Colors.white : AppPalette.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              /// 🔹 Progress Bar (rounded clean)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 10,
                  backgroundColor: Colors.black12,
                  valueColor: AlwaysStoppedAnimation(AppPalette.primary),
                ),
              ),

              const SizedBox(height: 14),

              /// 🔹 Time Text (clear & centered)
              Center(
                child: Text(
                  "${d.inDays}d  ${d.inHours % 24}h  ${d.inMinutes % 60}m  ${d.inSeconds % 60}s",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppPalette.primary,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
