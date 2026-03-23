import 'package:dio/dio.dart';
import 'package:food_tracker/modules/inventory/data/inventory_models.dart';

class InventoryApi {
  final Dio _dio;

  InventoryApi(this._dio);

  Future<List<InventoryItem>> getInventory({String? status}) async {
    final response = await _dio.get(
      '/api/v1/inventory',
      queryParameters: status != null ? {'status': status} : null,
    );
    final List data = response.data as List;
    return data.map((e) => InventoryItem.fromJson(e)).toList();
  }

  Future<InventoryStats> getStats() async {
    final response = await _dio.get('/api/v1/inventory/stats');
    return InventoryStats.fromJson(response.data);
  }

  Future<List<InventoryItem>> getExpiring({int days = 3}) async {
    final response = await _dio.get(
      '/api/v1/inventory/expiring',
      queryParameters: {'days': days},
    );
    final List data = response.data as List;
    return data.map((e) => InventoryItem.fromJson(e)).toList();
  }

  Future<InventoryItem> addItem(AddInventoryItemRequest request) async {
    final response = await _dio.post(
      '/api/v1/inventory/add',
      data: request.toJson(),
    );
    return InventoryItem.fromJson(response.data);
  }

  Future<InventoryItem> updateItem(
      String itemId,
      UpdateInventoryItemRequest request,
      ) async {
    final response = await _dio.patch(
      '/api/v1/inventory/$itemId',
      data: request.toJson(),
    );
    return InventoryItem.fromJson(response.data);
  }

  Future<void> deleteItem(String itemId) async {
    await _dio.delete('/api/v1/inventory/$itemId');
  }

  Future<InventoryItem> consumeItem(String itemId) async {
    final response = await _dio.patch('/api/v1/inventory/$itemId/consume');
    return InventoryItem.fromJson(response.data);
  }

  Future<List<String>> getCategories() async {
    final response = await _dio.get('/api/v1/inventory/meta/categories');
    final List data = response.data as List;
    return data.map((e) => e.toString()).toList();
  }

  Future<List<String>> getUnits() async {
    final response = await _dio.get('/api/v1/inventory/meta/units');
    final List data = response.data as List;
    return data.map((e) => e.toString()).toList();
  }
}