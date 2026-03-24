import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/modules/auth/providers/auth_provider.dart';
import 'package:food_tracker/modules/inventory/data/inventory_models.dart';
import 'package:food_tracker/modules/inventory/providers/inventory_provider.dart';
import 'package:food_tracker/modules/inventory/screens/add_item_sheet.dart';
import 'package:food_tracker/modules/inventory/screens/inventory_item_card.dart';
import 'package:go_router/go_router.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inventoryAsync = ref.watch(inventoryProvider);
    final filter = ref.watch(inventoryFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Fridge',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            tooltip: 'Exit',
            onPressed: () async {
              await ref.read(authProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: inventoryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text('Download error',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(e.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.read(inventoryProvider.notifier).refresh(),
                child: const Text('Repeat'),
              ),
            ],
          ),
        ),
        data: (state) => RefreshIndicator(
          onRefresh: () => ref.read(inventoryProvider.notifier).refresh(),
          child: CustomScrollView(
            slivers: [
              if (state.stats != null)
                SliverToBoxAdapter(
                  child: _StatsBar(stats: state.stats!),
                ),
              SliverToBoxAdapter(
                child: _FilterChips(currentFilter: filter),
              ),
              _InventoryList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add_item_fab',
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (_) => const AddItemSheet(),
        ),
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
    );
  }
}

class _StatsBar extends StatelessWidget {
  final InventoryStats stats;
  const _StatsBar({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          _StatChip(
            value: stats.totalActive,
            label: 'Total',
            color: Colors.blue,
            icon: Icons.inventory_2_outlined,
          ),
          const SizedBox(width: 8),
          _StatChip(
            value: stats.expiringIn3Days,
            label: 'Expiring Soon',
            color: Colors.orange,
            icon: Icons.access_time_rounded,
          ),
          const SizedBox(width: 8),
          _StatChip(
            value: stats.expired,
            label: 'Expired.',
            color: Colors.red,
            icon: Icons.warning_amber_rounded,
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final int value;
  final String label;
  final Color color;
  final IconData icon;

  const _StatChip({
    required this.value,
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$value',
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    height: 1,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    color: color.withOpacity(0.8),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChips extends ConsumerWidget {
  final String currentFilter;
  const _FilterChips({required this.currentFilter});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const filters = [
      ('all', 'All'),
      ('active', 'Active'),
      ('expiring', 'Expiring Soon'),
      ('expired', 'Expired'),
    ];

    return SizedBox(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: filters.map(((String, String) f) {
          final isSelected = currentFilter == f.$1;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(f.$2),
              selected: isSelected,
              onSelected: (_) =>
              ref.read(inventoryFilterProvider.notifier).state = f.$1,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _InventoryList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(filteredInventoryProvider);

    if (items.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🧊', style: TextStyle(fontSize: 56)),
              const SizedBox(height: 16),
              Text(
                'Fridge is empty',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Add products using the button\nat the bottom of the screen',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.only(top: 8, bottom: 100),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
              (context, index) => InventoryItemCard(item: items[index]),
          childCount: items.length,
        ),
      ),
    );
  }
}