import 'package:dio/dio.dart';
import 'package:food_tracker/modules/recipes/data/recipes_models.dart';

class RecipesApi {
  final Dio _dio;

  RecipesApi(this._dio);

  Future<List<RecipeRecommendation>> getRecommendedRecipes({
    String strategy = 'soft',
    int number = 10,
  }) async {
    if (number <= 0) return [];

    final response = await _dio.post(
      '/api/v1/recipes/by-ingredients',
      data: {'strategy': strategy, 'number': number},
    );

    final data = response.data;
    if (data is! List) return [];

    return data
        .whereType<Map<String, dynamic>>()
        .map(RecipeRecommendation.fromJson)
        .toList();
  }

  Future<RecipeDetail> getRecipeDetail(int spoonacularId) async {
    final response =
    await _dio.get('/api/v1/recipes/$spoonacularId');
    return RecipeDetail.fromJson(response.data as Map<String, dynamic>);
  }
}