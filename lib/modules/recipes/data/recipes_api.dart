import 'package:dio/dio.dart';
import 'package:food_tracker/modules/recipes/data/recipes_models.dart';

class RecipesApi {
  final Dio _dio;

  RecipesApi(this._dio);

  Future<List<RecipeRecommendation>> getRecommendedRecipes({
    String strategy = 'soft',
    int number = 10,
    String lang = 'en',
  }) async {
    if (number <= 0) return [];

    final response = await _dio.post(
      '/api/v1/recipes/by-ingredients',
      queryParameters: {'lang': lang},
      data: {'strategy': strategy, 'number': number},
    );

    final data = response.data;
    if (data is! List) return [];

    return data
        .whereType<Map<String, dynamic>>()
        .map(RecipeRecommendation.fromJson)
        .toList();
  }

  Future<RecipeDetail> getRecipeDetail(int spoonacularId, {String lang = 'en'}) async {
    final response = await _dio.get(
      '/api/v1/recipes/$spoonacularId',
      queryParameters: {'lang': lang},
    );
    return RecipeDetail.fromJson(response.data as Map<String, dynamic>);
  }
}