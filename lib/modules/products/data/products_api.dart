import 'package:dio/dio.dart';
import 'package:food_tracker/modules/products/data/product_models.dart';

class ProductsApi {
  final Dio _dio;

  ProductsApi(this._dio);

  Future<ProductModel?> getByBarcode(String barcode) async {
    try {
      final response = await _dio.get('/api/v1/products/$barcode');
      return ProductModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }
}