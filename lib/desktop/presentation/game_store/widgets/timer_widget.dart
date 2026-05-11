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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).cardColor,
                Theme.of(context).scaffoldBackgroundColor,
              ],
            ),
            border: Border.all(
              color: AppPalette.primary,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: AppPalette.primary.withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.hourglass_bottom,
                      color: isDark ? Colors.white : AppPalette.primary),
                  const SizedBox(width: 8),
                  Text("Store Return",
                      style: TextStyle(
                          color: isDark ? Colors.white : AppPalette.primary)),
                ],
              ),

              const SizedBox(height: 10),

              /// 🔥 FIX هنا
              LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.black12,
                valueColor: AlwaysStoppedAnimation(AppPalette.primary),
              ),

              const SizedBox(height: 10),

              Text(
                "${d.inDays}d ${d.inHours % 24}h ${d.inMinutes % 60}m ${d.inSeconds % 60}s",
              ),
            ],
          ),
        );
      },
    );
  }
}
