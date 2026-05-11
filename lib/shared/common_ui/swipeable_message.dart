import 'package:flutter/material.dart';

import '../core/theme/app_palette.dart';

class SwipeableMessage extends StatelessWidget {
  final Widget child;
  final VoidCallback onSwipeReply;

  const SwipeableMessage({
    super.key,
    required this.child,
    required this.onSwipeReply,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      confirmDismiss: (direction) async {
        onSwipeReply();
        // Return false so the widget is not actually dismissed (removed from list)
        return false;
      },
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Icon(Icons.reply, color: AppPalette.primary),
      ),
      child: child,
    );
  }
}
