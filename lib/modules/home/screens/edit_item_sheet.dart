import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/modules/inventory/data/inventory_models.dart';
import 'package:food_tracker/modules/inventory/providers/inventory_provider.dart';

class EditItemSheet extends ConsumerStatefulWidget {
  final InventoryItem item;

  const EditItemSheet({super.key, required this.item});

  @override
  ConsumerState<EditItemSheet> createState() => _EditItemSheetState();
}

class _EditItemSheetState extends ConsumerState<EditItemSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late final TextEditingController _notesController;
  late final TextEditingController _locationController;

  late UnitEnum _selectedUnit;
  late String? _selectedCategory;
  late String? _selectedLocation;
  late DateTime _expirationDate;
  bool _isLoading = false;

  static const _categories = [
    'dairy', 'meat', 'fish', 'vegetables', 'fruits',
    'bakery', 'drinks', 'frozen', 'snacks', 'other',
  ];

  static const _predefinedLocations = [
    'Fridge', 'Freezer', 'Shelf', 'Kitchen cabinet', 'Pantry',
  ];

  @override
  void initState() {
    super.initState();
    final item = widget.item;

    _nameController = TextEditingController(text: item.customName ?? '');
    _amountController = TextEditingController(
      text: item.amount % 1 == 0
          ? item.amount.toInt().toString()
          : item.amount.toString(),
    );
    _notesController = TextEditingController(text: item.notes ?? '');

    _selectedUnit = UnitEnum.fromString(item.unit);
    _selectedCategory = item.category;
    _expirationDate = item.expirationDate;

    // Determine if location is predefined or custom
    if (item.location != null && _predefinedLocations.contains(item.location)) {
      _selectedLocation = item.location;
      _locationController = TextEditingController();
    } else if (item.location != null) {
      _selectedLocation = 'Other';
      _locationController = TextEditingController(text: item.location);
    } else {
      _selectedLocation = null;
      _locationController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expirationDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) setState(() => _expirationDate = picked);
  }

  Future<void> _submit() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter product name')),
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

    // Resolve final location value
    String? finalLocation;
    if (_selectedLocation == 'Other') {
      final custom = _locationController.text.trim();
      finalLocation = custom.isEmpty ? null : custom;
    } else {
      finalLocation = _selectedLocation;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(inventoryProvider.notifier).updateItem(
        widget.item.id,
        UpdateInventoryItemRequest(
          customName: name,
          amount: amount,
          unit: _selectedUnit,
          expirationDate: _expirationDate,
          category: _selectedCategory,
          location: finalLocation,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
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
                  'Edit product',
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

            // Name
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Product name *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.fastfood_outlined),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),

            // Amount + Unit
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      labelText: 'Quantity *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<UnitEnum>(
                    value: _selectedUnit,
                    decoration: const InputDecoration(
                      labelText: 'Unit',
                      border: OutlineInputBorder(),
                    ),
                    items: UnitEnum.values.map((u) => DropdownMenuItem(
                      value: u,
                      child: Text(u.label),
                    )).toList(),
                    onChanged: (v) => setState(() => _selectedUnit = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Expiration date
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(4),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Expiry date *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
                child: Text(
                  '${_expirationDate.day.toString().padLeft(2, '0')}'
                  '.${_expirationDate.month.toString().padLeft(2, '0')}'
                  '.${_expirationDate.year}',
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Category
            DropdownButtonFormField<String?>(
              value: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.category_outlined),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('Not specified')),
                ..._categories.map((c) => DropdownMenuItem(
                  value: c,
                  child: Text(_categoryLabel(c)),
                )),
              ],
              onChanged: (v) => setState(() => _selectedCategory = v),
            ),
            const SizedBox(height: 12),

            // Location
            DropdownButtonFormField<String>(
              value: _selectedLocation,
              decoration: const InputDecoration(
                labelText: 'Storage location',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.place_outlined),
              ),
              items: const [
                DropdownMenuItem(value: 'Fridge', child: Text('🧊 Fridge')),
                DropdownMenuItem(value: 'Freezer', child: Text('❄️ Freezer')),
                DropdownMenuItem(value: 'Shelf', child: Text('🗄️ Shelf')),
                DropdownMenuItem(value: 'Kitchen cabinet', child: Text('🚪 Kitchen cabinet')),
                DropdownMenuItem(value: 'Pantry', child: Text('📦 Pantry')),
                DropdownMenuItem(value: 'Other', child: Text('✏️ Other...')),
              ],
              onChanged: (v) => setState(() {
                _selectedLocation = v;
                if (v != 'Other') _locationController.clear();
              }),
            ),
            if (_selectedLocation == 'Other') ...[
              const SizedBox(height: 12),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Enter storage location',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.edit_outlined),
                ),
                textCapitalization: TextCapitalization.sentences,
                autofocus: true,
              ),
            ],
            const SizedBox(height: 12),

            // Notes
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.notes_outlined),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 20),

            // Save button
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
                    : const Text('Save', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _categoryLabel(String category) {
    const labels = {
      'dairy': 'Dairy',
      'meat': 'Meat',
      'fish': 'Fish',
      'vegetables': 'Vegetables',
      'fruits': 'Fruits',
      'bakery': 'Bakery',
      'drinks': 'Drinks',
      'frozen': 'Frozen',
      'snacks': 'Snacks',
      'other': 'Other',
    };
    return labels[category] ?? category;
  }
}