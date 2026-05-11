import 'item_model.dart';

class GetItemsResponse {
  final String message;
  final List<Item> items;

  GetItemsResponse({
    required this.message,
    required this.items,
  });

  factory GetItemsResponse.fromJson(Map<String, dynamic> json) {
    return GetItemsResponse(
      message: json['message'] ?? '',
      items:
          (json['items'] as List? ?? []).map((e) => Item.fromJson(e)).toList(),
    );
  }
}
