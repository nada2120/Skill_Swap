import 'package:flutter/material.dart';

class RewardItem extends StatelessWidget {
  final String image;
  final String label;

  const RewardItem({
    super.key,
    required this.image,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: image.startsWith("http")
              ? Image.network(
            image,
            width: 24,
            height: 24,
            errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
          )
              : Image.asset(
            image,
            width: 24,
            height: 24,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
