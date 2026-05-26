import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/core/api/providers.dart';
import 'package:food_tracker/modules/recipes/data/recipes_api.dart';
import 'package:food_tracker/modules/recipes/data/recipes_models.dart';
import 'package:food_tracker/modules/settings/providers/settings_provider.dart';

final recipesApiProvider = Provider<RecipesApi>((ref) {
  final dio = ref.watch(dioProvider);
  return RecipesApi(dio);
});

final recommendedRecipesProvider =
FutureProvider<List<RecipeRecommendation>>((ref) async {
  final api = ref.read(recipesApiProvider);
  final settings = ref.watch(settingsProvider);
  return api.getRecommendedRecipes(number: 10, lang: settings.language);
});

// Ключ теперь включает и id и язык
final recipeDetailProvider =
FutureProvider.family<RecipeDetail, (int, String)>((ref, args) async {
  final api = ref.read(recipesApiProvider);
  final spoonacularId = args.$1;
  final lang = args.$2;
  return api.getRecipeDetail(spoonacularId, lang: lang);
});