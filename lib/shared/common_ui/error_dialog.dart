import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum DialogType { success, error, warning }

void showAppDialog({
  required BuildContext context,
  required String message,
  DialogType type = DialogType.success,
  String? title,
  String buttonText = "Continue",
  bool barrierDismissible = true,
  Duration? autoCloseDuration,
  VoidCallback? onPressed,
}) {
  String defaultTitle;

  switch (type) {
    case DialogType.success:
      defaultTitle = "Success";
      break;
    case DialogType.error:
      defaultTitle = "Error";
      break;
    case DialogType.warning:
      defaultTitle = "Warning";
      break;
  }

  showGeneralDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: "Dialog",
    barrierColor: Colors.black.withOpacity(0.6),
    transitionDuration: const Duration(milliseconds: 400),
    pageBuilder: (_, __, ___) => const SizedBox(),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      if (autoCloseDuration != null) {
        Timer(autoCloseDuration, () {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        });
      }

      final scale = Curves.easeOutBack.transform(animation.value);

      return FadeTransition(
        opacity: animation,
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(color: Colors.transparent),
            ),
            Center(
              child: Transform.scale(
                scale: scale,
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 25,
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// Animation
                          TweenAnimationBuilder(
                            tween: Tween<double>(begin: 0.8, end: 1),
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeOut,
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: Opacity(
                                  opacity: value,
                                  child: child,
                                ),
                              );
                            },
                            child: _buildAnimation(type),
                          ),

                          const SizedBox(height: 20),

                          /// Title
                          Text(
                            title ?? defaultTitle,
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: _getColor(type)),
                          ),

                          const SizedBox(height: 10),

                          /// Message
                          Text(
                            message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 15),
                          ),

                          const SizedBox(height: 25),

                          /// Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                backgroundColor: _getColor(type),
                                elevation: 6,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                if (onPressed != null) onPressed();
                              },
                              child: Text(
                                buttonText,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

/// Animation
Widget _buildAnimation(DialogType type) {
  try {
    switch (type) {
      case DialogType.success:
        return Lottie.asset(
          'assets/animations/success.json',
          height: 120,
          repeat: false,
        );

      case DialogType.error:
        return Lottie.asset(
          'assets/animations/error.json',
          height: 120,
          repeat: false,
        );

      case DialogType.warning:
        return Lottie.asset(
          'assets/animations/warning.json',
          height: 120,
          repeat: false,
        );
    }
  } catch (e) {
    return Icon(
      type == DialogType.success
          ? Icons.check_circle
          : type == DialogType.error
              ? Icons.error
              : Icons.warning,
      size: 80,
      color: _getColor(type),
    );
  }
}

/// Button color
Color _getColor(DialogType type) {
  switch (type) {
    case DialogType.success:
      return Colors.green;
    case DialogType.error:
      return Colors.red;
    case DialogType.warning:
      return Colors.orange;
  }
}
