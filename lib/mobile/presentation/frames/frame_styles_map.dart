import 'package:flutter/material.dart';

import 'frame_style.dart';
import 'skill_type.dart';

final Map<SkillType, FrameStyle> frameStyles = {
  /// 💙 C++
  SkillType.cpp: FrameStyle(
    colors: [
      Color(0xFF00C6FF),
      Color(0xFF0072FF),
      Color(0xFF8E2DE2),
    ],
    borderRadius: BorderRadius.circular(50),
    glowColor: Colors.blue,
    label: "C++",
    shapeType: FrameShapeType.oval,
  ),

  /// 🟣 PHP
  SkillType.php: FrameStyle(
    colors: [
      Colors.indigo,
      Colors.blueGrey,
    ],
    borderRadius: BorderRadius.circular(30),
    glowColor: Colors.indigo,
    label: "PHP",
    shapeType: FrameShapeType.rounded,
  ),

  /// 🟠 Java
  SkillType.java: FrameStyle(
    colors: [
      Colors.orange,
      Colors.red,
    ],
    borderRadius: BorderRadius.zero,
    glowColor: Colors.orange,
    label: "Java",
    shapeType: FrameShapeType.square,
  ),

  /// 🔴 JS (دائري)
  SkillType.js: FrameStyle(
    colors: [
      Color(0xFF8B0000),
      Color(0xFFB22222),
    ],
    borderRadius: BorderRadius.circular(100),
    glowColor: Color(0xFF8B0000),
    label: "JS",
    shapeType: FrameShapeType.circle,
  ),

  /// 💜 C#
  SkillType.csharp: FrameStyle(
    colors: [
      Colors.purple,
      Colors.deepPurple,
    ],
    borderRadius: BorderRadius.circular(40),
    glowColor: Colors.purple,
    label: "C#",
    shapeType: FrameShapeType.oval,
  ),

  /// 🥇 Top 1
  SkillType.top1: FrameStyle(
    colors: [
      Color(0xFFFFD700),
      Color(0xFFFFC300),
      Color(0xFFFFF3B0),
    ],
    borderRadius: BorderRadius.circular(100),
    glowColor: Color(0xFFFFD700),
    icon: Icons.emoji_events,
    shapeType: FrameShapeType.circle,
  ),

  /// 🥈 Top 2
  SkillType.top2: FrameStyle(
    colors: [
      Color(0xFFC0C0C0),
      Color(0xFFE0E0E0),
      Color(0xFF9E9E9E),
    ],
    borderRadius: BorderRadius.circular(100),
    glowColor: Color(0xFFC0C0C0),
    icon: Icons.workspace_premium,
    shapeType: FrameShapeType.circle,
  ),

  /// 🥉 Top 3
  SkillType.top3: FrameStyle(
    colors: [
      Color(0xFFCD7F32),
      Color(0xFFB87333),
      Color(0xFFE0A96D),
    ],
    borderRadius: BorderRadius.circular(100),
    glowColor: Color(0xFFCD7F32),
    icon: Icons.military_tech,
    shapeType: FrameShapeType.circle,
  ),
};