import 'package:skill_swap/shared/data/models/store/purchases.dart';

import '../../../../mobile/presentation/game_stor/models/store_item_model.dart';

extension PurchasesMapper on Purchases {
  StoreItem toStoreItem() {
    return StoreItem(
        id: itemId?.id ?? '',
        title: itemId?.title ?? '',
        type: itemId?.type ?? '',
        price: itemId?.priceInPoints?.toInt() ?? 0,
        image: itemId?.img?.secureUrl?.isNotEmpty == true
            ? itemId!.img!.secureUrl!
            : "assets/images/store_images/coin.png",
        rarity: _mapRarity(itemId?.priceInPoints?.toInt() ?? 0),
        isPurchased: true,
        isLocked: true);
  }

  String _mapRarity(int price) {
    if (price >= 500) return "epic";
    if (price >= 300) return "rare";
    return "common";
  }
}
