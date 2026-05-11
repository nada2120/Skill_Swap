import 'package:flutter/material.dart';
import 'package:skill_swap/mobile/presentation/frames/skill_type.dart';

class FrameStyle {
  final List<Color> colors;
  final BorderRadius borderRadius;
  final Color glowColor;
  final String? label;
  final IconData? icon;
  final FrameShapeType shapeType;

  const FrameStyle({
    required this.colors,
    required this.borderRadius,
    required this.glowColor,
    this.label,
    this.icon,
    required this.shapeType,
  });
}
