import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/core/api/providers.dart';
import 'package:food_tracker/modules/inventory/data/inventory_models.dart';
import 'package:food_tracker/modules/inventory/providers/inventory_provider.dart';
import 'package:food_tracker/modules/recipes/data/recipes_api.dart';
import 'package:food_tracker/modules/recipes/data/recipes_models.dart';

final recipesApiProvider = Provider<RecipesApi>((ref) {
  final dio = ref.watch(dioProvider);
  return RecipesApi(dio);
});

final recommendedRecipesProvider =
    FutureProvider<List<RecipeRecommendation>>((ref) async {
  final inventoryState = await ref.watch(inventoryProvider.future);
  final ingredients = _extractIngredientNames(inventoryState.items);

  if (ingredients.isEmpty) {
    return [];
  }

  final api = ref.read(recipesApiProvider);
  return api.getRecommendedRecipes(
    ingredients: ingredients,
    strategy: 'soft',
    number: 5,
  );
});

List<String> _extractIngredientNames(List<InventoryItem> items) {
  final unique = <String>{};

  for (final item in items) {
    final name = (item.customName ?? '').trim();
    if (name.isEmpty) continue;
    unique.add(name);
  }

  return unique.toList();
}
