import 'package:flutter/material.dart';

import '../../mobile/presentation/sign/widgets/custom_appbar.dart';

/// Base Stacked Screen
class BaseScreen extends StatelessWidget {
  final String title;
  final Widget child;

  const BaseScreen({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false, // ✅
      backgroundColor: Theme.of(context).scaffoldBackgroundColor, // ✅
      body: Stack(
        children: [
          Column(
            children: [
              CustomAppBar(title: title),
            ],
          ),
          Positioned(
            top: screenHeight * 0.09,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(screenWidth * 0.08),
                  topRight: Radius.circular(screenWidth * 0.08),
                ),
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
