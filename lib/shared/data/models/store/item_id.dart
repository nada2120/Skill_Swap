import 'package:skill_swap/shared/data/models/store/store_img.dart';

class ItemId {
  final StoreImage? img;
  final String? id;
  final String? title;
  final String? type;
  final num? priceInPoints;
  final String? value;
  final num? validityDays;
  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;
  final num? v;

  ItemId({
    this.img,
    this.id,
    this.title,
    this.type,
    this.priceInPoints,
    this.value,
    this.validityDays,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory ItemId.fromJson(Map<String, dynamic> json) {
    return ItemId(
      img: json['img'] != null ? StoreImage.fromJson(json['img']) : null,
      id: json['_id'],
      title: json['title'],
      type: json['type'],
      priceInPoints: json['priceInPoints'],
      value: json['value'],
      validityDays: json['validityDays'],
      isActive: json['isActive'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }
}
