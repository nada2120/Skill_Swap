import 'package:dio/dio.dart';

class StoreApiService {
  final Dio _dio;
  static const String _baseUrl = 'https://skill-swaapp.vercel.app';

  StoreApiService(this._dio);

  Future<Map<String, dynamic>> getItems() async {
    final response = await _dio.get('$_baseUrl/store');
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> getPurchases() async {
    final response = await _dio.get('$_baseUrl/store/purchases');
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> purchaseItem(String itemId) async {
    final response = await _dio.post(
      '$_baseUrl/store/purchase',
      data: {"itemId": itemId},
    );

    return response.data ?? {};
  }
}
