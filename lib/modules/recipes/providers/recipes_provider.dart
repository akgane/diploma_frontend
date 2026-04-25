import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/core/api/providers.dart';
import 'package:food_tracker/modules/recipes/data/recipes_api.dart';
import 'package:food_tracker/modules/recipes/data/recipes_models.dart';

final recipesApiProvider = Provider<RecipesApi>((ref) {
  final dio = ref.watch(dioProvider);
  return RecipesApi(dio);
});

/// Fetches recipe recommendations for the current user.
/// The backend resolves the user's inventory automatically via the auth token —
/// no need to pass ingredients from the client side.
final recommendedRecipesProvider =
    FutureProvider<List<RecipeRecommendation>>((ref) async {
  final api = ref.read(recipesApiProvider);
  return api.getRecommendedRecipes(number: 10);
});