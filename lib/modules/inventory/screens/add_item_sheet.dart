import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/modules/inventory/data/inventory_models.dart';
import 'package:food_tracker/modules/inventory/providers/inventory_provider.dart';

class AddItemSheet extends ConsumerStatefulWidget {
  const AddItemSheet({super.key});

  @override
  ConsumerState<AddItemSheet> createState() => _AddItemSheetState();
}

class _AddItemSheetState extends ConsumerState<AddItemSheet> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController(text: '1');
  final _notesController = TextEditingController();
  final _locationController = TextEditingController();

  UnitEnum _selectedUnit = UnitEnum.pcs;
  String? _selectedCategory;
  String? _selectedLocation;
  DateTime _expirationDate = DateTime.now().add(const Duration(days: 7));
  bool _isLoading = false;

  static const _categories = [
    'dairy', 'meat', 'fish', 'vegetables', 'fruits',
    'bakery', 'drinks', 'frozen', 'snacks', 'other',
  ];

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
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() => _expirationDate = picked);
    }
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

    setState(() => _isLoading = true);

    try {
      await ref.read(inventoryProvider.notifier).addItem(
        AddInventoryItemRequest(
          customName: name,
          category: _selectedCategory,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          location: _selectedLocation == null
              ? null
              : _selectedLocation == 'Other'
              ? (_locationController.text.trim().isEmpty ? null : _locationController.text.trim())
              : _selectedLocation,
          amount: amount,
          unit: _selectedUnit,
          expirationDate: _expirationDate,
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
                  'Add product',
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
                labelText: 'Product name *',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.fastfood_outlined),
              ),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),
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
                  '${_expirationDate.day.toString().padLeft(2, '0')}.${_expirationDate.month.toString().padLeft(2, '0')}.${_expirationDate.year}',
                ),
              ),
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
                const DropdownMenuItem(value: null, child: Text('Not specified')),
                ..._categories.map((c) => DropdownMenuItem(
                  value: c,
                  child: Text(_categoryLabel(c)),
                )),
              ],
              onChanged: (v) => setState(() => _selectedCategory = v),
            ),
            const SizedBox(height: 12),
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

  String _categoryLabel(String category) {
    const labels = {
      'dairy': 'dairy',
      'meat': 'meat',
      'fish': 'fish',
      'vegetables': 'vegetables',
      'fruits': 'fruits',
      'bakery': 'bakery',
      'drinks': 'drinks',
      'frozen': 'frozen',
      'snacks': 'snacks',
      'other': 'Other',
    };
    return labels[category] ?? category;
  }
}