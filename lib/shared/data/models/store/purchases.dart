import 'item_id.dart';

class Purchases {
  final String? id;
  final String? userId;
  final ItemId? itemId;
  final String? type;
  final num? pointsPaid;
  final bool? isUsed;
  final String? validUntil;
  final String? createdAt;
  final String? updatedAt;
  final num? v;

  Purchases(
      {this.id,
      this.userId,
      this.itemId,
      this.type,
      this.pointsPaid,
      this.validUntil,
      this.createdAt,
      this.updatedAt,
      this.v,
      this.isUsed});

  factory Purchases.fromJson(Map<String, dynamic> json) {
    return Purchases(
      id: json['_id'],
      userId: json['userId'],
      itemId: json['itemId'] != null ? ItemId.fromJson(json['itemId']) : null,
      type: json['type'],
      pointsPaid: json['pointsPaid'],
      validUntil: json['validUntil'],
      isUsed: json['isUsed'] ?? false,
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }
}
