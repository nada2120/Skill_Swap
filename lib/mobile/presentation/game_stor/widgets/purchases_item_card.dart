import 'package:flutter/material.dart';

import '../models/store_item_model.dart';

class PurchasesItemCard extends StatefulWidget {
  final StoreItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const PurchasesItemCard({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<PurchasesItemCard> createState() => _PurchasesItemCardState();
}

class _PurchasesItemCardState extends State<PurchasesItemCard>
    with TickerProviderStateMixin {
  late AnimationController rotateController;
  late AnimationController floatingController;

  @override
  void initState() {
    super.initState();

    rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      lowerBound: -5,
      upperBound: 5,
    )..repeat(reverse: true);
  }

  Widget buildStatus(StoreItem item) {
    final isUsed = item;

    if (isUsed == true) {
      return const Text(
        "Purchased",
        style: TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    if (isUsed == false) {
      return const Text(
        "Not Purchased",
        style: TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    // default (null / undefined)
    return const Text(
      "Purchased",
      style: TextStyle(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant PurchasesItemCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isSelected) {
      rotateController.repeat();
    } else {
      rotateController.stop();
      rotateController.reset();
    }
  }

  @override
  void dispose() {
    rotateController.dispose();
    floatingController.dispose();
    super.dispose();
  }

  Color getRarityColor() {
    switch (widget.item.rarity) {
      case "rare":
        return Colors.blue;
      case "epic":
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final color = getRarityColor();

    return AnimatedBuilder(
      animation: Listenable.merge([rotateController, floatingController]),
      builder: (context, child) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).cardColor,
                Theme.of(context).scaffoldBackgroundColor,
              ],
            ),
            border: Border.all(color: color),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 30,
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// 🎁 Animated Item
              AnimatedBuilder(
                animation: floatingController,
                builder: (_, __) {
                  return Transform.translate(
                    offset: Offset(0, floatingController.value),
                    child: Transform.rotate(
                      angle:
                          widget.isSelected ? rotateController.value * 6.28 : 0,
                      child: item.image.startsWith("http")
                          ? Image.network(item.image, height: 60)
                          : Image.asset(item.image, height: 60),
                    ),
                  );
                },
              ),

              const SizedBox(height: 10),

              Text(
                item.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 6),

              /// 💰 PRICE (read only)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "assets/images/store_images/coin.png",
                    height: 20,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    item.price.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              /// ✔ Purchased badge
              buildStatus(item),
            ],
          ),
        );
      },
    );
  }
}
