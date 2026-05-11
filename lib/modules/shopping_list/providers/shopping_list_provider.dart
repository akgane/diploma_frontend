import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/core/api/providers.dart';
import 'package:food_tracker/modules/shopping_list/data/shopping_list_api.dart';
import 'package:food_tracker/modules/shopping_list/data/shopping_list_models.dart';

final shoppingListApiProvider = Provider<ShoppingListApi>((ref) {
  final dio = ref.watch(dioProvider);
  return ShoppingListApi(dio);
});

class ShoppingListNotifier extends AsyncNotifier<List<ShoppingListItem>> {
  @override
  Future<List<ShoppingListItem>> build() async {
    return _fetch();
  }

  Future<List<ShoppingListItem>> _fetch() async {
    final api = ref.read(shoppingListApiProvider);
    return api.getList();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetch());
  }

  Future<void> addItem(AddShoppingItemRequest request) async {
    final api = ref.read(shoppingListApiProvider);
    final newItem = await api.addItem(request);
    state = state.whenData((items) => [newItem, ...items]);
  }

  Future<void> toggleCheck(String itemId) async {
    final api = ref.read(shoppingListApiProvider);
    final updated = await api.toggleCheck(itemId);
    state = state.whenData(
          (items) => items.map((i) => i.id == itemId ? updated : i).toList(),
    );
  }

  Future<void> deleteItem(String itemId) async {
    final api = ref.read(shoppingListApiProvider);
    await api.deleteItem(itemId);
    state = state.whenData(
          (items) => items.where((i) => i.id != itemId).toList(),
    );
  }

  Future<void> clearChecked() async {
    final api = ref.read(shoppingListApiProvider);
    await api.clearChecked();
    state = state.whenData(
          (items) => items.where((i) => !i.isChecked).toList(),
    );
  }
}

final shoppingListProvider =
AsyncNotifierProvider<ShoppingListNotifier, List<ShoppingListItem>>(
  ShoppingListNotifier.new,
);