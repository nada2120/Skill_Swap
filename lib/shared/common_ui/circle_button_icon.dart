import 'package:flutter/material.dart';

class CircleButtonIcon extends StatefulWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const CircleButtonIcon({super.key, required this.icon, this.onTap});

  @override
  State<CircleButtonIcon> createState() => _CircleButtonIconState();
}

class _CircleButtonIconState extends State<CircleButtonIcon> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // MediaQuery للحصول على حجم الشاشة
    final screenWidth = MediaQuery.of(context).size.width;

    // نحدّد حجم الأيقونة و padding حسب حجم الشاشة
    double iconSize = 16;
    double padding = 8;

    if (screenWidth >= 1200) {
      // Desktop
      iconSize = 24;
      padding = 12;
    } else if (screenWidth >= 800) {
      // Tablet
      iconSize = 20;
      padding = 10;
    }

    return Material(
      color: Theme.of(context).cardColor,
      shape: const CircleBorder(),
      elevation: 1,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: widget.onTap,
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Center(
            child: Icon(
              widget.icon,
              size: iconSize,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
        ),
      ),
    );
  }
}
