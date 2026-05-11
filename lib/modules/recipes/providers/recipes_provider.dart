import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/core/api/providers.dart';
import 'package:food_tracker/modules/recipes/data/recipes_api.dart';
import 'package:food_tracker/modules/recipes/data/recipes_models.dart';

final recipesApiProvider = Provider<RecipesApi>((ref) {
  final dio = ref.watch(dioProvider);
  return RecipesApi(dio);
});

final recommendedRecipesProvider =
FutureProvider<List<RecipeRecommendation>>((ref) async {
  final api = ref.read(recipesApiProvider);
  return api.getRecommendedRecipes(number: 10);
});

final recipeDetailProvider =
FutureProvider.family<RecipeDetail, int>((ref, spoonacularId) async {
  final api = ref.read(recipesApiProvider);
  return api.getRecipeDetail(spoonacularId);
});