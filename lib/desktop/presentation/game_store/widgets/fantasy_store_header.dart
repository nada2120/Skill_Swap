// widgets/fantasy_store_header.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/shared/core/theme/app_palette.dart';

import '../../../../main.dart';
import '../../../../shared/bloc/get_profile_cubit/my_profile_cubit.dart';
import '../../../../shared/bloc/store_cubit/purchase_cubit.dart';
import '../../../../shared/dependency_injection/injection.dart';
import '../screens/purchases_page.dart';
import '../widgets/show_store_daiolg.dart';

class FantasyStoreHeader extends StatelessWidget {
  const FantasyStoreHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final coins = context.select<MyProfileCubit, num>(
      (cubit) => cubit.coins,
    );
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
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
              Expanded(
                child: Text(
                  "Skill Swap Store",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppPalette.primary,
                    letterSpacing: 1,
                    shadows: [
                      Shadow(
                        color: isDark
                            ? Colors.white.withOpacity(0.6)
                            : AppPalette.primary.withOpacity(0.6),
                        blurRadius: 8,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  showStoreDialog(
                    context,
                    isFirstTime: false,
                    title: "Skill Swap Store",
                    subtitle: "store",
                  );
                },
                child: Icon(
                  Icons.help_outline_rounded,
                  color: AppPalette.primary,
                  size: 32,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  desktopKey.currentState?.openSidePage(
                      body: BlocProvider(
                          create: (_) => sl<PurchaseCubit>()..getPurchases(),
                          child: const MyPurchasesPage()));
                },
                child: Icon(
                  Icons.shopping_bag_outlined,
                  color: AppPalette.primary,
                  size: 32,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                "assets/images/store_images/coin.png",
                height: 56,
              ),
              const SizedBox(width: 8),
              Text(
                "$coins",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppPalette.primary,
                  shadows: [
                    Shadow(
                      color: isDark
                          ? Colors.white.withOpacity(0.6)
                          : AppPalette.primary.withOpacity(0.6),
                      blurRadius: 12,
                      offset: Offset(3, 3),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
