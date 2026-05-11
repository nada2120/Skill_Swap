import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../mobile/presentation/game_stor/models/store_item_model.dart';
import '../../../../shared/bloc/store_cubit/store_cubit.dart';
import '../../../../shared/common_ui/custom_range_slider.dart';

class StoreItemCard extends StatefulWidget {
  final StoreItem item;
  final bool isSelected;
  final VoidCallback onTap;

  const StoreItemCard({
    super.key,
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<StoreItemCard> createState() => _StoreItemCardState();
}

class _StoreItemCardState extends State<StoreItemCard>
    with TickerProviderStateMixin {
  late int selectedHours;

  final int minHours = 1;
  final int maxHours = 8;
  final int pricePerHour = 10;

  late AnimationController rotateController;
  late AnimationController buyEffectController;
  late AnimationController floatingController;
  late AnimationController coinFlyController;
  late Animation<double> coinFlyAnimation;

  @override
  void initState() {
    super.initState();

    selectedHours = minHours;

    rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    buyEffectController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    floatingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
      lowerBound: -5,
      upperBound: 5,
    )..repeat(reverse: true);

    coinFlyController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    coinFlyAnimation = Tween<double>(begin: 0, end: -80).animate(
      CurvedAnimation(
        parent: coinFlyController,
        curve: Curves.easeOut,
      ),
    );
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
  void didUpdateWidget(covariant StoreItemCard oldWidget) {
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
    buyEffectController.dispose();
    floatingController.dispose();
    coinFlyController.dispose();
    super.dispose();
  }

  // ================= BUY =================

  void onBuyPressed() async {
    if (widget.item.isPurchased) return;

    await buyEffectController.forward(from: 0);
    coinFlyController.forward(from: 0);

    context.read<StoreCubit>().buyItem(widget.item.id);

    buyEffectController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final color = getRarityColor();

    return AnimatedBuilder(
      animation: Listenable.merge(
          [buyEffectController, floatingController, coinFlyController]),
      builder: (context, child) {
        final scale = 1 + (buyEffectController.value * 0.2);
        final glow = buyEffectController.value;

        return Transform.scale(
          scale: scale,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.all(8),
            padding: const EdgeInsets.all(10),
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
                  color: color.withOpacity(glow),
                  blurRadius: 40,
                  spreadRadius: glow * 15,
                )
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                /// 💰 Coin Animation
                AnimatedBuilder(
                  animation: coinFlyController,
                  builder: (context, child) {
                    if (coinFlyController.value == 0) {
                      return const SizedBox();
                    }

                    return Positioned(
                      bottom: 60 + coinFlyAnimation.value,
                      child: Opacity(
                        opacity: 1 - coinFlyController.value,
                        child: Transform.scale(
                          scale: 1 + (coinFlyController.value * 0.5),
                          child: Image.asset(
                            "assets/images/store_images/coin.png",
                            height: 30,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                /// ✨ Glow
                if (buyEffectController.value > 0)
                  Container(
                    width: 120 + (buyEffectController.value * 100),
                    height: 120 + (buyEffectController.value * 100),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withOpacity(0.2 * (1 - glow)),
                    ),
                  ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// 🎯 HOURS ITEM
                    if (item.title.contains("Hours"))
                      Column(
                        children: [
                          const Text(
                            "Select Hours",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 150,
                            child: CustomSingleSlider(
                              min: minHours.toDouble(),
                              max: maxHours.toDouble(),
                              initialValue: selectedHours.toDouble(),
                              divisions: maxHours - minHours,
                              onChanged: (value) {
                                setState(() {
                                  selectedHours = value.round();
                                });
                              },
                            ),
                          ),
                        ],
                      )

                    /// 🎁 NORMAL ITEM
                    else
                      AnimatedBuilder(
                        animation: Listenable.merge(
                            [rotateController, floatingController]),
                        builder: (_, __) {
                          return Transform.translate(
                            offset: Offset(0, floatingController.value),
                            child: Transform.rotate(
                              angle: widget.isSelected
                                  ? rotateController.value * 6.28
                                  : 0,
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
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 12),

                    /// 💸 BUY BUTTON
                    GestureDetector(
                      onTap: onBuyPressed,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: LinearGradient(
                            colors: item.isPurchased
                                ? [Colors.grey, Colors.black]
                                : [
                                    getRarityColor(),
                                    getRarityColor().withOpacity(0.7)
                                  ],
                          ),
                        ),
                        child: item.isPurchased
                            ? const Text(
                                "Purchased",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    "assets/images/store_images/coin.png",
                                    height: 28,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    item.price.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
