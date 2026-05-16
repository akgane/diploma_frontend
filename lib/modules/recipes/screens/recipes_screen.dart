import 'package:flutter/material.dart';
import 'package:food_tracker/modules/recipes/screens/recipe_detail_screen.dart';
import 'package:food_tracker/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/modules/recipes/data/recipes_models.dart';
import 'package:food_tracker/modules/recipes/providers/recipes_provider.dart';
import 'package:food_tracker/modules/auth/providers/auth_provider.dart';
import 'package:food_tracker/modules/menu/data/menu_models.dart';
import 'package:food_tracker/modules/menu/providers/menu_provider.dart';

class RecipesScreen extends ConsumerWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);
    final accountType = userAsync.value?.accountType ?? 'personal';

    if (accountType == 'business') {
      return const _BusinessMenuScreen();
    }
    return const _PersonalRecipesScreen();
  }
}

// ─── Personal: обычный экран рецептов ────────────────────────────────────────

class _PersonalRecipesScreen extends ConsumerWidget {
  const _PersonalRecipesScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final recipesAsync = ref.watch(recommendedRecipesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.recommendedRecipes, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), tooltip: l.refresh, onPressed: () => ref.invalidate(recommendedRecipesProvider)),
        ],
      ),
      body: recipesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _RecipesError(message: e.toString(), onRetry: () => ref.invalidate(recommendedRecipesProvider)),
        data: (recipes) {
          if (recipes.isEmpty) return const _RecipesEmptyState();
          return RefreshIndicator(
            onRefresh: () async => ref.refresh(recommendedRecipesProvider.future),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              itemCount: recipes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _RecipeCard(recipe: recipes[index]),
            ),
          );
        },
      ),
    );
  }
}

// ─── Business: стоп-лист ─────────────────────────────────────────────────────

class _BusinessMenuScreen extends ConsumerWidget {
  const _BusinessMenuScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final menuAsync = ref.watch(menuProvider);
    final stopList = ref.watch(stopListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l.stopList, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDishDialog(context, ref),
        icon: const Icon(Icons.add),
        label: Text(l.addDish),
      ),
      body: menuAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (menu) {
          if (menu.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.restaurant_menu_outlined, size: 56, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(l.noDishesYet, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                    const SizedBox(height: 8),
                    Text(l.noDishesSubtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: menu.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final dish = menu[index];
              final isInStopList = stopList.any((s) => s.id == dish.id);
              return _DishCard(dish: dish, isInStopList: isInStopList);
            },
          );
        },
      ),
    );
  }

  void _showAddDishDialog(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _AddDishSheet(ref: ref),
    );
  }
}

class _DishCard extends StatelessWidget {
  final MenuItem dish;
  final bool isInStopList;

  const _DishCard({required this.dish, required this.isInStopList});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isInStopList ? Colors.red.withOpacity(0.5) : theme.colorScheme.outline.withOpacity(0.15),
          width: isInStopList ? 1.5 : 1,
        ),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: isInStopList ? Colors.red.withOpacity(0.1) : theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            isInStopList ? Icons.block_outlined : Icons.check_circle_outline,
            color: isInStopList ? Colors.red : Colors.green,
          ),
        ),
        title: Text(dish.title, style: TextStyle(fontWeight: FontWeight.w600, decoration: isInStopList ? TextDecoration.lineThrough : null)),
        subtitle: Text(
          dish.ingredients.map((i) => i.name).join(', '),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withOpacity(0.6)),
        ),
        trailing: isInStopList
            ? Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: Colors.red.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: const Text('STOP', style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold)),
        )
            : null,
      ),
    );
  }
}

class _AddDishSheet extends StatefulWidget {
  final WidgetRef ref;
  const _AddDishSheet({required this.ref});

  @override
  State<_AddDishSheet> createState() => _AddDishSheetState();
}

class _AddDishSheetState extends State<_AddDishSheet> {
  final _titleController = TextEditingController();
  final _ingredientController = TextEditingController();
  final List<String> _ingredients = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 24),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Text(l.addDish, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: '${l.dishName} *', border: const OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            Text(l.ingredients, style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ingredientController,
                    decoration: InputDecoration(hintText: l.addIngredient, border: const OutlineInputBorder()),
                    onSubmitted: _addIngredient,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(onPressed: () => _addIngredient(_ingredientController.text), icon: const Icon(Icons.add)),
              ],
            ),
            if (_ingredients.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _ingredients.map((ing) => Chip(
                  label: Text(ing),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => setState(() => _ingredients.remove(ing)),
                )).toList(),
              ),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _save,
                child: _isLoading ? const CircularProgressIndicator() : Text(l.addDish),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addIngredient(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty || _ingredients.contains(trimmed)) return;
    setState(() => _ingredients.add(trimmed));
    _ingredientController.clear();
  }

  Future<void> _save() async {
    if (_titleController.text.trim().isEmpty || _ingredients.isEmpty) return;
    setState(() => _isLoading = true);
    try {
      int i = 0;
      final request = CreateMenuItemRequest(
        title: _titleController.text.trim(),
        ingredients: _ingredients.map((name) => MenuIngredient(id: i++, name: name, amount: 1, unit: '')).toList(),
      );
      await widget.ref.read(menuProvider.notifier).addItem(request);
      if (mounted) Navigator.of(context).pop();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}

// ─── Shared widgets ───────────────────────────────────────────────────────────

class _RecipeCard extends StatelessWidget {
  final RecipeRecommendation recipe;
  const _RecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => RecipeDetailScreen(recipe: recipe))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: recipe.image.isNotEmpty
                  ? Image.network(recipe.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const _RecipeImagePlaceholder())
                  : const _RecipeImagePlaceholder(),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(child: Text(recipe.title, style: theme.textTheme.titleMedium)),
                  if (recipe.matchScore > 0) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.green.withOpacity(0.3))),
                      child: Text(l.matchPercent(recipe.matchScore.toInt()), style: const TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipeImagePlaceholder extends StatelessWidget {
  const _RecipeImagePlaceholder();
  @override
  Widget build(BuildContext context) => const ColoredBox(color: Colors.black12, child: Center(child: Icon(Icons.image_not_supported_outlined, size: 32)));
}

class _RecipesEmptyState extends StatelessWidget {
  const _RecipesEmptyState();
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.menu_book_outlined, size: 56, color: Colors.grey),
      const SizedBox(height: 16),
      Text(l.noRecommendationsYet, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
      const SizedBox(height: 8),
      Text(l.addProductsForRecipes, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
    ])));
  }
}

class _RecipesError extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _RecipesError({required this.message, required this.onRetry});
  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
      const Icon(Icons.error_outline, size: 48, color: Colors.red),
      const SizedBox(height: 12),
      Text(l.couldNotLoadRecipes, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
      const SizedBox(height: 8),
      Text(message, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
      const SizedBox(height: 16),
      ElevatedButton(onPressed: onRetry, child: Text(l.retry)),
    ])));
  }
}