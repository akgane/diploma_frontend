import 'package:dio/dio.dart';
import 'package:food_tracker/modules/recipes/data/recipes_models.dart';

class RecipesApi {
  final Dio _dio;

  RecipesApi(this._dio);

  Future<List<RecipeRecommendation>> getRecommendedRecipes({
    required List<String> ingredients,
    Map<String, List<String>> tagsMap = const {},
    String strategy = 'soft',
    int number = 5,
  }) async {
    if (ingredients.isEmpty) return [];

    final response = await _dio.post(
      '/api/v1/recipes/by-ingredients',
      data: {
        'ingredients': ingredients,
        'tags_map': tagsMap,
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
