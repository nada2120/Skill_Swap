import 'package:skill_swap/shared/data/models/store/purchases.dart';

class GetPurchaseItems {
  final String? message;
  final List<Purchases> purchases;

  GetPurchaseItems({
    this.message,
    this.purchases = const [],
  });

  factory GetPurchaseItems.fromJson(Map<String, dynamic> json) {
    return GetPurchaseItems(
      message: json['message'],
      purchases: (json['purchases'] as List?)
              ?.map((e) => Purchases.fromJson(e))
              .toList() ??
          [],
    );
  }
}
