import 'package:flutter/material.dart';
import 'package:food_tracker/l10n/app_localizations.dart';
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

  static const _categoryKeys = ['dairy','meat','fish','vegetables','fruits','bakery','drinks','frozen','snacks','other'];
  static const _predefinedLocations = ['Fridge','Freezer','Shelf','Kitchen cabinet','Pantry'];

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _nameController = TextEditingController(text: item.customName ?? '');
    _amountController = TextEditingController(text: item.amount % 1 == 0 ? item.amount.toInt().toString() : item.amount.toString());
    _notesController = TextEditingController(text: item.notes ?? '');
    _selectedUnit = UnitEnum.fromString(item.unit);
    _selectedCategory = item.category;
    _expirationDate = item.expirationDate;
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
    _nameController.dispose(); _amountController.dispose();
    _notesController.dispose(); _locationController.dispose();
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
    final l = AppLocalizations.of(context)!;
    final name = _nameController.text.trim();
    if (name.isEmpty) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.enterProductName))); return; }
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) { ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.enterValidQuantity))); return; }

    String? finalLocation;
    if (_selectedLocation == 'Other') {
      final custom = _locationController.text.trim();
      finalLocation = custom.isEmpty ? null : custom;
    } else {
      finalLocation = _selectedLocation;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(inventoryProvider.notifier).updateItem(widget.item.id, UpdateInventoryItemRequest(
        customName: name, amount: amount, unit: _selectedUnit,
        expirationDate: _expirationDate, category: _selectedCategory,
        location: finalLocation,
        notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
      ));
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${l.errorPrefix}$e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _categoryLabel(String key, AppLocalizations l) {
    final map = {
      'dairy': l.categoryDairy, 'meat': l.categoryMeat, 'fish': l.categoryFish,
      'vegetables': l.categoryVegetables, 'fruits': l.categoryFruits,
      'bakery': l.categoryBakery, 'drinks': l.categoryDrinks,
      'frozen': l.categoryFrozen, 'snacks': l.categorySnacks, 'other': l.categoryOther,
    };
    return map[key] ?? key;
  }

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(l.editProduct, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
              ],
            ),
            const SizedBox(height: 16),
            TextField(controller: _nameController, decoration: InputDecoration(labelText: l.productName, border: const OutlineInputBorder(), prefixIcon: const Icon(Icons.fastfood_outlined)), textCapitalization: TextCapitalization.sentences),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(flex: 2, child: TextField(controller: _amountController, keyboardType: const TextInputType.numberWithOptions(decimal: true), decoration: InputDecoration(labelText: l.quantity, border: const OutlineInputBorder()))),
              const SizedBox(width: 12),
              Expanded(flex: 2, child: DropdownButtonFormField<UnitEnum>(
                value: _selectedUnit,
                decoration: InputDecoration(labelText: l.unit, border: const OutlineInputBorder()),
                items: UnitEnum.values.map((u) => DropdownMenuItem(value: u, child: Text(u.label))).toList(),
                onChanged: (v) => setState(() => _selectedUnit = v!),
              )),
            ]),
            const SizedBox(height: 12),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(4),
              child: InputDecorator(
                decoration: InputDecoration(labelText: l.expiryDate, border: const OutlineInputBorder(), prefixIcon: const Icon(Icons.calendar_today_outlined)),
                child: Text('${_expirationDate.day.toString().padLeft(2,'0')}.${_expirationDate.month.toString().padLeft(2,'0')}.${_expirationDate.year}'),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String?>(
              value: _selectedCategory,
              decoration: InputDecoration(labelText: l.category, border: const OutlineInputBorder(), prefixIcon: const Icon(Icons.category_outlined)),
              items: [
                DropdownMenuItem(value: null, child: Text(l.notSpecified)),
                ..._categoryKeys.map((c) => DropdownMenuItem(value: c, child: Text(_categoryLabel(c, l)))),
              ],
              onChanged: (v) => setState(() => _selectedCategory = v),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedLocation,
              decoration: InputDecoration(labelText: l.storageLocation, border: const OutlineInputBorder(), prefixIcon: const Icon(Icons.place_outlined)),
              items: [
                DropdownMenuItem(value: 'Fridge', child: Text(l.locationFridge)),
                DropdownMenuItem(value: 'Freezer', child: Text(l.locationFreezer)),
                DropdownMenuItem(value: 'Shelf', child: Text(l.locationShelf)),
                DropdownMenuItem(value: 'Kitchen cabinet', child: Text(l.locationKitchenCabinet)),
                DropdownMenuItem(value: 'Pantry', child: Text(l.locationPantry)),
                DropdownMenuItem(value: 'Other', child: Text(l.locationOther)),
              ],
              onChanged: (v) => setState(() { _selectedLocation = v; if (v != 'Other') _locationController.clear(); }),
            ),
            if (_selectedLocation == 'Other') ...[
              const SizedBox(height: 12),
              TextField(controller: _locationController, decoration: InputDecoration(labelText: l.enterStorageLocation, border: const OutlineInputBorder(), prefixIcon: const Icon(Icons.edit_outlined)), textCapitalization: TextCapitalization.sentences, autofocus: true),
            ],
            const SizedBox(height: 12),
            TextField(controller: _notesController, decoration: InputDecoration(labelText: l.notes, border: const OutlineInputBorder(), prefixIcon: const Icon(Icons.notes_outlined)), maxLines: 2),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity, height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: _isLoading ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(l.save, style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}