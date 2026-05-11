import '../../data/models/store/get_items_response.dart';
import '../../data/models/store/get_purchase_items.dart';
import '../../data/models/store/purchase_item_response.dart';

abstract class StoreRepository {
  Future<GetItemsResponse> getItems();

  Future<GetPurchaseItems> getPurchases();

  Future<PurchaseItemResponse> purchaseItem(String itemId);
}
