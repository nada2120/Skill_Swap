class StoreItem {
  final String id;
  final String title;
  final String type;
  final int price;
  final String image;
  final String rarity;
  final bool isUsed;
  final bool isLocked; // 👈 NEW
  final bool isPurchased;

  StoreItem({
    required this.id,
    required this.title,
    required this.type,
    required this.price,
    required this.image,
    required this.rarity,
    this.isUsed = false,
    this.isLocked = false,
    this.isPurchased = false,
  });

  StoreItem copyWith({
    String? id,
    String? title,
    int? price,
    String? type,
    String? image,
    String? rarity,
    bool? isLocked,
    bool? isUsed,
    bool? isPurchased,
  }) {
    return StoreItem(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      price: price ?? this.price,
      image: image ?? this.image,
      rarity: rarity ?? this.rarity,
      isLocked: isLocked ?? this.isLocked,
      isUsed: isUsed ?? this.isUsed,
      isPurchased: isPurchased ?? this.isPurchased,
    );
  }
}
