import 'package:flutter/material.dart';

import 'animated_frame_container.dart';
import 'skill_type.dart';

class FramedMessageBubble extends StatelessWidget {
  final Widget child;
  final SkillType skill;
  final BorderRadius borderRadius;

  const FramedMessageBubble({
    super.key,
    required this.child,
    required this.skill,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedFrameContainer(
      skill: skill,
      borderRadius: borderRadius,
      child: child,
    );
  }
}
