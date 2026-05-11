import 'package:skill_swap/shared/data/models/store/store_img.dart';

class Item {
  final String id;
  final StoreImage img;
  final String title;
  final String type;
  final int priceInPoints;
  final String value;
  final int validityDays;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int v;
  final bool isLocked;
  final String? lockReason;

  Item({
    required this.id,
    required this.img,
    required this.title,
    required this.type,
    required this.priceInPoints,
    required this.value,
    required this.validityDays,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.isLocked,
    this.lockReason,
  });

  factory Item.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Item.empty();
    }

    return Item(
      id: json['_id']?.toString() ?? '',
      img: json['img'] != null
          ? StoreImage.fromJson(json['img'])
          : StoreImage.empty(),
      title: json['title']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      priceInPoints: _toInt(json['priceInPoints']),
      value: json['value']?.toString() ?? '',
      validityDays: _toInt(json['validityDays']),
      isActive: json['isActive'] == true,
      createdAt: DateTime.tryParse(json['createdAt'] ?? ''),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? ''),
      v: _toInt(json['__v']),
      isLocked: json['isLocked'] == true,
      lockReason: json['lockReason']?.toString(),
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  factory Item.empty() {
    return Item(
      id: '',
      img: StoreImage.empty(),
      title: '',
      type: '',
      priceInPoints: 0,
      value: '',
      validityDays: 0,
      isActive: false,
      createdAt: null,
      updatedAt: null,
      v: 0,
      isLocked: false,
      lockReason: null,
    );
  }
}
