import 'package:flutter/material.dart';
import 'package:skill_swap/shared/core/theme/app_palette.dart';
import 'package:skill_swap/shared/core/utils/app_launcher.dart';

class UnrealExperienceCard extends StatefulWidget {
  const UnrealExperienceCard({super.key});

  @override
  State<UnrealExperienceCard> createState() => _UnrealExperienceCardState();
}

class _UnrealExperienceCardState extends State<UnrealExperienceCard> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: GestureDetector(
        onTap: () {
          AppLauncher.openUnrealGame();
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              colors: [
                AppPalette.primary,
                Color(0xFF00C2FF),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppPalette.primary.withOpacity(isHovering ? 0.8 : 0.4),
                blurRadius: isHovering ? 25 : 12,
                spreadRadius: 1,
              )
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.12),
                ),
                child: const Icon(
                  Icons.sports_esports_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Unreal Experience",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Try the 3D Skill World",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: isHovering
                      ? [
                          BoxShadow(
                            color: Colors.white,
                            blurRadius: 12,
                            spreadRadius: 2,
                          )
                        ]
                      : [],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
