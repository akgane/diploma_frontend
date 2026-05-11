import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/modules/shopping_list/data/shopping_list_models.dart';
import 'package:food_tracker/modules/shopping_list/providers/shopping_list_provider.dart';

class ShoppingListScreen extends ConsumerWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(shoppingListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shopping List',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          listAsync.whenOrNull(
            data: (items) {
              final hasChecked = items.any((i) => i.isChecked);
              if (!hasChecked) return const SizedBox.shrink();
              return TextButton.icon(
                onPressed: () => _confirmClearChecked(context, ref),
                icon: const Icon(Icons.delete_sweep_outlined, size: 20),
                label: const Text('Clear done'),
              );
            },
          ) ?? const SizedBox.shrink(),
        ],
      ),
      body: listAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text('Error loading list',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(e.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.read(shoppingListProvider.notifier).refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🛒', style: TextStyle(fontSize: 56)),
                  const SizedBox(height: 16),
                  Text(
                    'List is empty',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add items using the button below',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            );
          }

          final unchecked = items.where((i) => !i.isChecked).toList();
          final checked = items.where((i) => i.isChecked).toList();

          return RefreshIndicator(
            onRefresh: () =>
                ref.read(shoppingListProvider.notifier).refresh(),
            child: ListView(
              padding: const EdgeInsets.only(bottom: 100, top: 8),
              children: [
                if (unchecked.isNotEmpty) ...[
                  _SectionHeader(
                    label: 'To buy (${unchecked.length})',
                  ),
                  ...unchecked.map((item) => _ShoppingItemTile(item: item)),
                ],
                if (checked.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _SectionHeader(
                    label: 'Done (${checked.length})',
                    color: Colors.grey,
                  ),
                  ...checked.map((item) => _ShoppingItemTile(item: item)),
                ],
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'add_shopping_item_fab',
        onPressed: () => _showAddSheet(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add item'),
      ),
    );
  }

  void _showAddSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const _AddShoppingItemSheet(),
    );
  }

  Future<void> _confirmClearChecked(
      BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear done items?'),
        content:
        const Text('All checked items will be removed from the list.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(shoppingListProvider.notifier).clearChecked();
    }
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final Color? color;

  const _SectionHeader({required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: color ?? Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _ShoppingItemTile extends ConsumerWidget {
  final ShoppingListItem item;

  const _ShoppingItemTile({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        color: Colors.red,
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) {
        ref.read(shoppingListProvider.notifier).deleteItem(item.id);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: theme.colorScheme.outline.withOpacity(0.15),
          ),
        ),
        child: ListTile(
          leading: Checkbox(
            value: item.isChecked,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            onChanged: (_) {
              ref.read(shoppingListProvider.notifier).toggleCheck(item.id);
            },
          ),
          title: Text(
            item.name,
            style: TextStyle(
              decoration: item.isChecked
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              color: item.isChecked
                  ? theme.colorScheme.onSurface.withOpacity(0.4)
                  : null,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Text(
            '${item.amount % 1 == 0 ? item.amount.toInt() : item.amount} ${item.unit}'
                '${item.category != null ? ' · ${item.category}' : ''}',
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(
                item.isChecked ? 0.3 : 0.6,
              ),
              fontSize: 12,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            color: Colors.red.withOpacity(0.6),
            onPressed: () {
              ref.read(shoppingListProvider.notifier).deleteItem(item.id);
            },
          ),
        ),
      ),
    );
  }
}

class _AddShoppingItemSheet extends ConsumerStatefulWidget {
  const _AddShoppingItemSheet();

  @override
  ConsumerState<_AddShoppingItemSheet> createState() =>
      _AddShoppingItemSheetState();
}

class _AddShoppingItemSheetState
    extends ConsumerState<_AddShoppingItemSheet> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController(text: '1');
  String _selectedUnit = 'pcs';
  String? _selectedCategory;
  bool _isLoading = false;

  static const _units = [
    'pcs', 'g', 'kg', 'ml', 'l', 'oz', 'lb', 'pack',
  ];

  static const _categories = [
    'dairy', 'meat', 'fish', 'vegetables', 'fruits',
    'bakery', 'drinks', 'frozen', 'snacks', 'other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter item name')),
      );
      return;
    }

    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid quantity')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(shoppingListProvider.notifier).addItem(
        AddShoppingItemRequest(
          name: name,
          category: _selectedCategory,
          amount: amount,
          unit: _selectedUnit,
        ),
      );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add to shopping list',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Item name *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.shopping_cart_outlined),
              ),
              textCapitalization: TextCapitalization.sentences,
              autofocus: true,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _amountController,
                    keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Quantity *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    value: _selectedUnit,
                    decoration: const InputDecoration(
                      labelText: 'Unit',
                      border: OutlineInputBorder(),
                    ),
                    items: _units
                        .map((u) => DropdownMenuItem(
                      value: u,
                      child: Text(u),
                    ))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedUnit = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String?>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: [
                const DropdownMenuItem(
                    value: null, child: Text('Not specified')),
                ..._categories.map((c) => DropdownMenuItem(
                  value: c,
                  child: Text(_categoryLabel(c)),
                )),
              ],
              onChanged: (v) => setState(() => _selectedCategory = v),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : const Text('Add', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _categoryLabel(String c) {
    const labels = {
      'dairy': 'Dairy', 'meat': 'Meat', 'fish': 'Fish',
      'vegetables': 'Vegetables', 'fruits': 'Fruits',
      'bakery': 'Bakery', 'drinks': 'Drinks',
      'frozen': 'Frozen', 'snacks': 'Snacks', 'other': 'Other',
    };
    return labels[c] ?? c;
  }
}