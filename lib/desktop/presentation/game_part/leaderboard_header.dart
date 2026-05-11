import 'package:flutter/material.dart';

import '../../../../shared/core/theme/app_palette.dart';
import '../../../main.dart';

class LeaderBoardHeader extends StatelessWidget {
  final String name;
  final VoidCallback? onIcon1;
  final VoidCallback? onBack;

  const LeaderBoardHeader({
    super.key,
    required this.name,
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
      decoration: const BoxDecoration(
        color: AppPalette.primary,
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.01),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Back Button
            Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: onBack ??
                    () {
                      final didGoBack = desktopKey.currentState?.goBack();
                      if (didGoBack == false) {
                        desktopKey.currentState?.openPage(index: 0);
                      }
                    },
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.02),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: screenWidth * 0.05,
                  ),
                ),
              ),
            ),

            SizedBox(width: screenWidth * 0.03),

            /// Name
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

            /// Notification Button
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

  /// -------- Circle Button --------
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
          child: Icon(
            icon,
            size: screenWidth * 0.07,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
      ),
    );
  }
}
