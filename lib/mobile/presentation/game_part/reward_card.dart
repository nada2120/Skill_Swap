import 'package:flutter/material.dart';
import 'package:skill_swap/mobile/presentation/game_part/reward_item.dart';
import 'package:skill_swap/mobile/presentation/game_stor/models/store_item_model.dart';

class RewardCard extends StatelessWidget {
  final int? rank;
  final String? range;
  final bool preview;
  final bool isClaim;
  final bool isClaimed;
  final bool isLoading;
  final VoidCallback? onCollect;
  final List<StoreItem> rewards;

  const RewardCard(
      {super.key,
      this.rank,
      this.range,
      this.preview = false,
      this.isClaim = false,
      this.isClaimed = false,
      this.isLoading = false,
      this.onCollect,
      this.rewards = const []});

  @override
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onCollect?.call();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: _getGradient(),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Column(
          children: [
            Text(
              rank != null ? "Rank #$rank" : "Rank $range",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: rewards.map((item) {
                return RewardItem(
                  image: item.image,
                  label: item.title,
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            if (preview)
              Text(
                "Finish in this rank to win 🎯",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            if (isClaim)
              const Text(
                "Tap card to test collect 🎯",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  /// 🎨 Gradient حسب الرانك
  Gradient _getGradient() {
    if (rank == 1) {
      return const LinearGradient(
        colors: [Color(0xFFFFD54F), Color(0xFFFFA000)],
      );
    } else if (rank == 2) {
      return const LinearGradient(
        colors: [Color(0xFFE0E0E0), Color(0xFF90A4AE)],
      );
    } else if (rank == 3) {
      return const LinearGradient(
        colors: [Color(0xFFFFB74D), Color(0xFFE65100)],
      );
    }

    return const LinearGradient(
      colors: [Colors.white, Colors.white],
    );
  }
}
