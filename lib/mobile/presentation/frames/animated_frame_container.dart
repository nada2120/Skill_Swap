import 'package:flutter/material.dart';

import 'frame_style.dart';
import 'frame_styles_map.dart';
import 'skill_type.dart';

class AnimatedFrameContainer extends StatelessWidget {
  final Widget child;
  final SkillType skill;
  final BorderRadius borderRadius;

  const AnimatedFrameContainer({
    super.key,
    required this.child,
    required this.skill,
    required this.borderRadius,
  });

  BoxDecoration _buildDecoration(FrameStyle style) {
    return BoxDecoration(
      borderRadius: borderRadius,

      /// 🎯 لون ثابت هادي
      color: style.glowColor.withOpacity(0.06),

      /// ✅ Border ناعم
      border: Border.all(
        color: style.glowColor.withOpacity(0.25),
        width: 1.2,
      ),

      /// ✨ Shadow خفيف
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildBadge(FrameStyle style) {
    final isCircle = style.shapeType == FrameShapeType.circle;

    return Container(
      width: isCircle ? 34 : null,
      height: isCircle ? 34 : null,
      padding: isCircle
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircle ? null : BorderRadius.circular(20),
        border: Border.all(
          color: style.glowColor.withOpacity(0.4),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: style.glowColor.withOpacity(0.25),
            blurRadius: 8,
          ),
        ],
      ),
      child: Center(
        child: style.icon != null
            ? Icon(
                style.icon,
                color: style.glowColor,
                size: 18,
              )
            : Text(
                style.label ?? "",
                style: TextStyle(
                  color: style.glowColor,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (skill == SkillType.none) return child;

    final style = frameStyles[skill]!;

    return Stack(
      children: [
        Container(
          decoration: _buildDecoration(style),
          padding: const EdgeInsets.all(2),
          child: ClipRRect(
            borderRadius: borderRadius,
            child: child,
          ),
        ),

        /// ✨ Badge داخل الكارت
        Positioned(
          bottom: -6,
          right: -6,
          child: _buildBadge(style),
        ),
      ],
    );
  }
}
