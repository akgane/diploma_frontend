import 'package:dio/dio.dart';
import 'package:food_tracker/modules/menu/data/menu_models.dart';

class MenuApi {
  final Dio _dio;
  MenuApi(this._dio);

  Future<List<MenuItem>> getMenu() async {
    final response = await _dio.get('/api/v1/menu');
    return (response.data as List).map((e) => MenuItem.fromJson(e)).toList();
  }

  Future<MenuItem> createMenuItem(CreateMenuItemRequest request) async {
    final response = await _dio.post('/api/v1/menu', data: request.toJson());
    return MenuItem.fromJson(response.data);
  }
}