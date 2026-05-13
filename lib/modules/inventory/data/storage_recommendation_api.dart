import 'package:dio/dio.dart';
import 'package:food_tracker/modules/inventory/data/storage_recommendation_models.dart';

class StorageRecommendationApi {
  final Dio _dio;

  StorageRecommendationApi(this._dio);

  /// Timeout увеличен до 30 секунд — бэкенд может обращаться к Gemini
  Future<StorageRecommendationResponse> getRecommendation(
      StorageRecommendationRequest request,
      ) async {
    final response = await _dio.post(
      '/api/v1/storage/recommendations',
      data: request.toJson(),
      options: Options(
        sendTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );
    return StorageRecommendationResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}