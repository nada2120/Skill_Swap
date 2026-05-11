import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skill_swap/mobile/presentation/game_part/rewards_screen.dart';

import '../../../../shared/core/theme/app_palette.dart';
import '../../../shared/bloc/store_cubit/store_cubit.dart';

class LeaderBoardHeader extends StatelessWidget {
  final String name;
  final int myRank;
  final VoidCallback? onIcon1;
  final VoidCallback? onBack;

  const LeaderBoardHeader({
    super.key,
    required this.name,
    required this.myRank,
    this.onIcon1,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      height: screenHeight * 0.2,
      width: double.infinity,
      color: AppPalette.primary,
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.01),
        child: Row(
          children: [
            /// 🔙 Back
            InkWell(
              borderRadius: BorderRadius.circular(30),
              onTap: onBack ?? () => Navigator.pop(context),
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.02),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                ),
              ),
            ),

            SizedBox(width: screenWidth * 0.03),

            /// 🏆 Title
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            /// 🎁 Rewards Button
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.card_giftcard, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<StoreCubit>(),
                          child: RewardsScreen(myRank: myRank),
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            /// ❓ Help
            circleButton(
              context: context,
              icon: Icons.help_outline_rounded,
              onTap: onIcon1,
              screenWidth: screenWidth,
            ),
          ],
        ),
      ),
    );
  }

  Widget circleButton({
    required BuildContext context,
    required IconData icon,
    VoidCallback? onTap,
    required double screenWidth,
  }) {
    return Material(
      color: Theme.of(context).cardColor,
      shape: const CircleBorder(),
      elevation: 3,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.02),
          child: Icon(icon),
        ),
      ),
    );
  }
}
