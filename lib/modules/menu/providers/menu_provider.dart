import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/core/api/providers.dart';
import 'package:food_tracker/modules/menu/data/menu_api.dart';
import 'package:food_tracker/modules/menu/data/menu_models.dart';
import 'package:food_tracker/modules/inventory/providers/inventory_provider.dart';

final menuApiProvider = Provider<MenuApi>((ref) {
  final dio = ref.watch(dioProvider);
  return MenuApi(dio);
});

final menuProvider = AsyncNotifierProvider<MenuNotifier, List<MenuItem>>(MenuNotifier.new);

class MenuNotifier extends AsyncNotifier<List<MenuItem>> {
  @override
  Future<List<MenuItem>> build() async {
    final api = ref.read(menuApiProvider);
    return api.getMenu();
  }

  Future<void> addItem(CreateMenuItemRequest request) async {
    final api = ref.read(menuApiProvider);
    final newItem = await api.createMenuItem(request);
    state = AsyncData([...state.value ?? [], newItem]);
  }
}

// Провайдер стоп-листа — блюда у которых нет или просрочен хотя бы один ингредиент
final stopListProvider = Provider<List<MenuItem>>((ref) {
  final menuAsync = ref.watch(menuProvider);
  final inventory = ref.watch(filteredInventoryProvider);
  final now = DateTime.now();

  final menu = menuAsync.value ?? [];

  return menu.where((dish) {
    return dish.ingredients.any((ingredient) {
      final name = ingredient.name.toLowerCase();

      // Нечёткий поиск по displayName
      final found = inventory.where((item) {
        final a = item.displayName.toLowerCase();
        return a.contains(name) || name.contains(a);
      }).toList();

      // Продукт не найден в инвентаре совсем
      if (found.isEmpty) return true;

      // Все найденные просрочены
      return found.every((item) => item.isExpired);
    });
  }).toList();
});