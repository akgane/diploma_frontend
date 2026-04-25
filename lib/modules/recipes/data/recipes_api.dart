import 'package:dio/dio.dart';
import 'package:food_tracker/modules/recipes/data/recipes_models.dart';

class RecipesApi {
  final Dio _dio;

  RecipesApi(this._dio);

  /// Requests recipe recommendations based on the user's current inventory.
  /// The backend fetches the user's products directly — no need to pass them here.
  Future<List<RecipeRecommendation>> getRecommendedRecipes({
    String strategy = 'soft',
    int number = 10,
  }) async {
    if (number <= 0) return [];

    final response = await _dio.post(
      '/api/v1/recipes/by-ingredients',
      data: {
        'strategy': strategy,
        'number': number,
      },
    );

    final data = response.data;
    if (data is! List) return [];

    return data
        .whereType<Map<String, dynamic>>()
        .map(RecipeRecommendation.fromJson)
        .toList();
  }
}