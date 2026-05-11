import 'package:dio/dio.dart';
import 'package:food_tracker/modules/shopping_list/data/shopping_list_models.dart';

class ShoppingListApi {
  final Dio _dio;

  ShoppingListApi(this._dio);

  Future<List<ShoppingListItem>> getList() async {
    final response = await _dio.get('/api/v1/shopping-list');
    final List data = response.data as List;
    return data.map((e) => ShoppingListItem.fromJson(e)).toList();
  }

  Future<ShoppingListItem> addItem(AddShoppingItemRequest request) async {
    final response = await _dio.post(
      '/api/v1/shopping-list',
      data: request.toJson(),
    );
    return ShoppingListItem.fromJson(response.data);
  }

  Future<ShoppingListItem> toggleCheck(String itemId) async {
    final response = await _dio.patch(
      '/api/v1/shopping-list/$itemId/check',
    );
    return ShoppingListItem.fromJson(response.data);
  }

  Future<void> deleteItem(String itemId) async {
    await _dio.delete('/api/v1/shopping-list/$itemId');
  }

  Future<void> clearChecked() async {
    await _dio.delete('/api/v1/shopping-list/checked');
  }
}