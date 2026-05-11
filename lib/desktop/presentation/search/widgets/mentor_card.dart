import 'package:flutter/material.dart';
import 'package:skill_swap/shared/data/models/user/skill_model.dart';

import '../../../../shared/core/theme/app_palette.dart';

class MentorCard extends StatelessWidget {
  final String image;
  final String name;
  final String role;
  final num rate;
  final num hours;
  final num price;
  final String track;
  final List<Skill> skills;
  final String responseTime;

  const MentorCard({
    super.key,
    required this.image,
    required this.name,
    required this.role,
    required this.rate,
    required this.hours,
    required this.price,
    required this.track,
    required this.skills,
    required this.responseTime,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;

    double r(double base, double min, double max) {
      final scale = width / 1440;
      return (base * scale).clamp(min, max);
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: r(8, 6, 12)),
      padding: EdgeInsets.all(r(16, 12, 20)),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          /// HEADER
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipOval(
                child: (image.startsWith("http"))
                    ? Image.network(
                        image,
                        width: r(60, 50, 80),
                        height: r(60, 50, 80),
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildPlaceholder(r),
                      )
                    : _buildPlaceholder(r),
              ),
              SizedBox(width: r(12, 8, 16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// NAME + TRACK + ROLE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "$name • $track",
                            style: Theme.of(context).textTheme.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: r(8, 6, 12),
                            vertical: r(4, 3, 8),
                          ),
                          decoration: BoxDecoration(
                            color: role == "Mentor"
                                ? Colors.green.withOpacity(0.15)
                                : Colors.blue.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            role,
                            style: TextStyle(
                              color:
                                  role == "Mentor" ? Colors.green : Colors.blue,
                              fontSize: r(12, 10, 14),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      ],
                    ),

                    SizedBox(height: r(8, 6, 12)),

                    /// STATS
                    Row(
                      children: [
                        const Icon(Icons.star, size: 18, color: Colors.amber),
                        SizedBox(width: r(6, 4, 10)),
                        Flexible(
                          child: Text(
                            "${rate.toStringAsFixed(1)} • $hours hours • ${price == 0 ? 'Free' : '\$$price/hr'}",
                            style: Theme.of(context).textTheme.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: r(12, 10, 16)),

          /// SKILLS
          Wrap(
            spacing: r(8, 6, 12),
            runSpacing: r(8, 6, 12),
            children: skills.map((skill) {
              return Container(
                padding: EdgeInsets.symmetric(
                  horizontal: r(10, 8, 14),
                  vertical: r(6, 4, 10),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFD6D6D6).withOpacity(0.25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  skill.skillName,
                  style: TextStyle(
                    fontSize: r(12, 10, 14),
                    color: isDark
                        ? AppPalette.darkTextSecondary
                        : AppPalette.lightTextSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder(double Function(double, double, double) r) {
    return Builder(
      builder: (context) {
        return Container(
          width: r(60, 50, 80),
          height: r(60, 50, 80),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey,
          ),
          child: const Icon(
            Icons.person,
            color: Colors.white,
          ),
        );
      },
    );
  }
}
