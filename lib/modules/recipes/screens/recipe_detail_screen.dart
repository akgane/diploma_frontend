import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/modules/inventory/providers/inventory_provider.dart';
import 'package:food_tracker/modules/recipes/data/recipes_models.dart';
import 'package:food_tracker/modules/recipes/providers/recipes_provider.dart';
import 'package:food_tracker/modules/shopping_list/data/shopping_list_models.dart';
import 'package:food_tracker/modules/shopping_list/providers/shopping_list_provider.dart';

class RecipeDetailScreen extends ConsumerWidget {
  final RecipeRecommendation recipe;

  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(recipeDetailProvider(recipe.spoonacularId));

    return Scaffold(
      body: detailAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              const Text('Could not load recipe'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.invalidate(recipeDetailProvider(recipe.spoonacularId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (detail) => _RecipeDetailView(detail: detail),
      ),
    );
  }
}

class _RecipeDetailView extends ConsumerWidget {
  final RecipeDetail detail;

  const _RecipeDetailView({required this.detail});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get inventory item names for matching
    final inventoryAsync = ref.watch(inventoryProvider);
    final inventoryNames = inventoryAsync.whenOrNull(
      data: (state) => state.items
          .map((i) => i.displayName.toLowerCase())
          .toSet(),
    ) ??
        {};

    return CustomScrollView(
      slivers: [
        // Hero image + back button
        SliverAppBar(
          expandedHeight: 260,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              detail.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(blurRadius: 4, color: Colors.black54)],
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            background: detail.image != null && detail.image!.isNotEmpty
                ? Image.network(
              detail.image!,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) =>
              const ColoredBox(color: Colors.black12),
            )
                : const ColoredBox(color: Colors.black12),
          ),
        ),

        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Info chips
                _InfoChips(detail: detail),
                const SizedBox(height: 24),

                // Ingredients section
                _IngredientsSection(
                  ingredients: detail.ingredients,
                  inventoryNames: inventoryNames,
                  ref: ref,
                ),
                const SizedBox(height: 24),

                // Steps section
                if (detail.steps.isNotEmpty) ...[
                  _StepsSection(steps: detail.steps),
                  const SizedBox(height: 40),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoChips extends StatelessWidget {
  final RecipeDetail detail;

  const _InfoChips({required this.detail});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chips = <Widget>[];

    if (detail.readyInMinutes != null) {
      chips.add(_InfoChip(
        icon: Icons.access_time,
        label: '${detail.readyInMinutes} min',
        color: Colors.orange,
      ));
    }
    if (detail.servings != null) {
      chips.add(_InfoChip(
        icon: Icons.people_outline,
        label: '${detail.servings} servings',
        color: Colors.blue,
      ));
    }
    if (detail.calories != null) {
      chips.add(_InfoChip(
        icon: Icons.local_fire_department_outlined,
        label: '${detail.calories!.toInt()} kcal',
        color: Colors.red,
      ));
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return Wrap(spacing: 8, children: chips);
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _InfoChip(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
                fontSize: 12, color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _IngredientsSection extends StatelessWidget {
  final List<RecipeIngredient> ingredients;
  final Set<String> inventoryNames;
  final WidgetRef ref;

  const _IngredientsSection({
    required this.ingredients,
    required this.inventoryNames,
    required this.ref,
  });

  String _normalizeUnit(String unit) {
    const allowed = {'g', 'kg', 'oz', 'lb', 'ml', 'l', 'fl_oz', 'pcs', 'pack'};
    final u = unit.trim().toLowerCase();
    if (allowed.contains(u)) return u;
    const map = {'serving': 'pcs', 'servings': 'pcs', 'piece': 'pcs', 'pieces': 'pcs', 'slice': 'pcs', 'slices': 'pcs', 'clove': 'pcs', 'cloves': 'pcs', 'cup': 'ml', 'cups': 'ml', 'tbsp': 'ml', 'tablespoon': 'ml', 'tablespoons': 'ml', 'tsp': 'ml', 'teaspoon': 'ml', 'teaspoons': 'ml', 'handful': 'g', 'pinch': 'g', 'bunch': 'pcs', 'can': 'pcs', 'cans': 'pcs', 'bottle': 'pcs', 'bottles': 'pcs', 'package': 'pack', 'packages': 'pack', 'large': 'pcs', 'medium': 'pcs', 'small': 'pcs'};
    return map[u] ?? 'pcs';
  }

  bool _inFridge(String name) {
    final lower = name.toLowerCase();
    return inventoryNames.any((n) => n.contains(lower) || lower.contains(n));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final missing =
    ingredients.where((i) => !_inFridge(i.name)).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Ingredients',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            Text(
              '(${ingredients.length})',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: Colors.grey),
            ),
            const Spacer(),
            if (missing.isNotEmpty)
              TextButton.icon(
                onPressed: () => _addAllMissingToCart(context, missing),
                icon: const Icon(Icons.add_shopping_cart, size: 16),
                label: Text('Add missing (${missing.length})'),
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.primary,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        ...ingredients.map((ing) {
          final have = _inFridge(ing.name);
          return _IngredientTile(
            ingredient: ing,
            inFridge: have,
            onAddToCart: have
                ? null
                : () => _addToCart(context, ing),
          );
        }),
      ],
    );
  }

  Future<void> _addToCart(BuildContext context, RecipeIngredient ing) async {
    try {
      await ref.read(shoppingListProvider.notifier).addItem(
        AddShoppingItemRequest(
          name: ing.name,
          amount: (ing.amount > 0 ? ing.amount : 1.0).ceilToDouble(),
          unit: _normalizeUnit(ing.unit),
        ),
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${ing.name} added to shopping list'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _addAllMissingToCart(
      BuildContext context, List<RecipeIngredient> missing) async {
    int added = 0;
    for (final ing in missing) {
      try {
        await ref.read(shoppingListProvider.notifier).addItem(
          AddShoppingItemRequest(
            name: ing.name,
            amount: (ing.amount > 0 ? ing.amount : 1.0).ceilToDouble(),
            unit: _normalizeUnit(ing.unit),
          ),
        );
        added++;
      } catch (_) {}
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$added items added to shopping list'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}

class _IngredientTile extends StatelessWidget {
  final RecipeIngredient ingredient;
  final bool inFridge;
  final VoidCallback? onAddToCart;

  const _IngredientTile({
    required this.ingredient,
    required this.inFridge,
    this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = inFridge ? Colors.green : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            inFridge ? Icons.kitchen_outlined : Icons.shopping_cart_outlined,
            size: 18,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingredient.name,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w500),
                ),
                Text(
                  '${ingredient.amount % 1 == 0 ? ingredient.amount.toInt() : ingredient.amount}'
                      '${ingredient.unit.isNotEmpty ? ' ${ingredient.unit}' : ''}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
          if (inFridge)
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                '✓ In fridge',
                style: TextStyle(
                    fontSize: 11,
                    color: Colors.green,
                    fontWeight: FontWeight.w600),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.add_circle_outline, size: 22),
              color: Colors.orange,
              tooltip: 'Add to shopping list',
              onPressed: onAddToCart,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}

class _StepsSection extends StatelessWidget {
  final List<RecipeStep> steps;

  const _StepsSection({required this.steps});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Instructions',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...steps.map((s) => _StepTile(step: s)),
      ],
    );
  }
}

class _StepTile extends StatelessWidget {
  final RecipeStep step;

  const _StepTile({required this.step});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${step.number}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                step.step,
                style: theme.textTheme.bodyMedium
                    ?.copyWith(height: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}