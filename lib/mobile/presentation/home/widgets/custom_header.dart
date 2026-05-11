import 'dart:io';

import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';

import '../../../../shared/core/theme/app_palette.dart';

class CustomHeader extends StatelessWidget {
  final String name;
  final String subtitle;
  final String? avatarPath;
  final VoidCallback? onIcon1;
  final VoidCallback? onIcon2;
  final int unreadCount;

  const CustomHeader(
      {super.key,
      required this.name,
      required this.subtitle,
      this.avatarPath,
      this.onIcon1,
      this.onIcon2,
      this.unreadCount = 0});

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
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Avatar
            CircleAvatar(
              radius: screenWidth * 0.075,
              backgroundColor: Theme.of(context).cardColor,
              child: ClipOval(
                child: _buildAvatar(context, screenWidth),
              ),
            ),

            SizedBox(width: screenWidth * 0.02),

            /// Name + Subtitle
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.005),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.03,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Stack(
              children: [
                circleButton(
                  context: context,
                  icon: Icons.chat,
                  onTap: onIcon2,
                  screenWidth: screenWidth,
                ),
                if (unreadCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: screenWidth * 0.025,
                      height: screenWidth * 0.025,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// -------- Avatar Builder --------
  Widget _buildAvatar(BuildContext context, double screenWidth) {
    final radius = screenWidth * 0.075;

    if (avatarPath == null || avatarPath!.isEmpty) {
      return _placeholderIcon(context, radius);
    }

    // Network Image
    if (avatarPath!.startsWith("http")) {
      return Image.network(
        avatarPath!,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholderIcon(context, radius),
      );
    }

    // File Image (Not Windows)
    if (defaultTargetPlatform != TargetPlatform.windows) {
      return Image.file(
        File(avatarPath!),
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholderIcon(context, radius),
      );
    }

    return _placeholderIcon(context, radius);
  }

  /// -------- Placeholder --------
  Widget _placeholderIcon(BuildContext context, double radius) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      color: Theme.of(context).cardColor,
      child: Icon(
        Icons.person,
        size: radius,
        color: Theme.of(context).textTheme.bodyLarge!.color,
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
            size: screenWidth * 0.04,
            color: Theme.of(context).textTheme.bodyLarge!.color,
          ),
        ),
      ),
    );
  }
}
