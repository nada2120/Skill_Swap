import 'package:dio/dio.dart';

import '../../domain/repositories/store_repository.dart';
import '../models/store/get_items_response.dart';
import '../models/store/get_purchase_items.dart';
import '../models/store/purchase_item_response.dart';
import '../web_services/store/store_api_service.dart';

class StoreRepositoryImpl implements StoreRepository {
  final StoreApiService api;

  StoreRepositoryImpl({required this.api});

  String _extractError(DioException e) {
    try {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
      if (data is String) return data;
    } catch (_) {}
    return e.message ?? 'Network Error';
  }

  @override
  Future<GetItemsResponse> getItems() async {
    try {
      final response = await api.getItems();
      return GetItemsResponse.fromJson(response);
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  @override
  Future<GetPurchaseItems> getPurchases() async {
    try {
      final response = await api.getPurchases();
      return GetPurchaseItems.fromJson(response);
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }

  @override
  Future<PurchaseItemResponse> purchaseItem(String itemId) async {
    try {
      final response = await api.purchaseItem(itemId);
      return PurchaseItemResponse.fromJson(response);
    } on DioException catch (e) {
      throw _extractError(e);
    }
  }
}
