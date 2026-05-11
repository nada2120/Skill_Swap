import 'package:flutter/material.dart';

class DesktopScaffold extends StatelessWidget {
  final Widget body;
  final Widget? rightPanel;
  final Widget? sidebar;

  const DesktopScaffold({
    super.key,
    required this.body,
    this.rightPanel,
    this.sidebar,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.background, // 👈 الخلفية العامة
      body: Row(
        children: [
          /// Sidebar
          if (sidebar != null)
            Container(
              width: 250,
              color: colors.surfaceVariant,
              child: sidebar!,
            ),

          /// Main Content
          Expanded(
            child: Container(
              color: colors.surface,
              child: body,
            ),
          ),

          /// Right Panel
          if (width >= 900 && rightPanel != null)
            Container(
              width: 350,
              color: colors.surfaceVariant,
              child: rightPanel!,
            ),
        ],
      ),
    );
  }
}
