import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/core/api/providers.dart';
import 'package:food_tracker/modules/inventory/data/inventory_api.dart';
import 'package:food_tracker/modules/inventory/data/inventory_models.dart';

final inventoryApiProvider = Provider<InventoryApi>((ref) {
  final dio = ref.watch(dioProvider);
  return InventoryApi(dio);
});

class InventoryState {
  final List<InventoryItem> items;
  final InventoryStats? stats;
  final bool isLoading;
  final String? error;

  const InventoryState({
    this.items = const [],
    this.stats,
    this.isLoading = false,
    this.error,
  });

  InventoryState copyWith({
    List<InventoryItem>? items,
    InventoryStats? stats,
    bool? isLoading,
    String? error,
  }) => InventoryState(
    items: items ?? this.items,
    stats: stats ?? this.stats,
    isLoading: isLoading ?? this.isLoading,
    error: error,
  );
}

class InventoryNotifier extends AsyncNotifier<InventoryState> {
  @override
  Future<InventoryState> build() async {
    return _fetchAll();
  }

  Future<InventoryState> _fetchAll() async {
    final api = ref.read(inventoryApiProvider);
    final results = await Future.wait([
      api.getInventory(),
      api.getStats(),
    ]);
    return InventoryState(
      items: results[0] as List<InventoryItem>,
      stats: results[1] as InventoryStats,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => _fetchAll());
  }

  Future<void> addItem(AddInventoryItemRequest request) async {
    final api = ref.read(inventoryApiProvider);
    final newItem = await api.addItem(request);
    state = state.whenData((s) => s.copyWith(
      items: [newItem, ...s.items],
    ));
    _refreshStats();
  }

  Future<void> updateItem(String itemId, UpdateInventoryItemRequest request) async {
    final api = ref.read(inventoryApiProvider);
    final updated = await api.updateItem(itemId, request);
    state = state.whenData((s) => s.copyWith(
      items: s.items.map((i) => i.id == itemId ? updated : i).toList(),
    ));
  }

  Future<void> deleteItem(String itemId) async {
    final api = ref.read(inventoryApiProvider);
    await api.deleteItem(itemId);
    state = state.whenData((s) => s.copyWith(
      items: s.items.where((i) => i.id != itemId).toList(),
    ));
    _refreshStats();
  }

  Future<void> consumeItem(String itemId) async {
    final api = ref.read(inventoryApiProvider);
    await api.consumeItem(itemId);
    state = state.whenData((s) => s.copyWith(
      items: s.items.where((i) => i.id != itemId).toList(),
    ));
    _refreshStats();
  }

  Future<void> _refreshStats() async {
    try {
      final api = ref.read(inventoryApiProvider);
      final stats = await api.getStats();
      state = state.whenData((s) => s.copyWith(stats: stats));
    } catch (_) {}
  }
}

final inventoryProvider =
AsyncNotifierProvider<InventoryNotifier, InventoryState>(
  InventoryNotifier.new,
);

final inventoryFilterProvider = StateProvider<String>((ref) => 'all');

final filteredInventoryProvider = Provider<List<InventoryItem>>((ref) {
  final asyncState = ref.watch(inventoryProvider);
  final filter = ref.watch(inventoryFilterProvider);

  return asyncState.when(
    data: (state) {
      final items = state.items;
      switch (filter) {
        case 'expiring':
          return items.where((i) => i.isExpiringSoon && !i.isExpired).toList();
        case 'expired':
          return items.where((i) => i.isExpired).toList();
        case 'active':
          return items.where((i) => !i.isExpired).toList();
        default:
          return items;
      }
    },
    loading: () => [],
    error: (_, __) => [],
  );
});