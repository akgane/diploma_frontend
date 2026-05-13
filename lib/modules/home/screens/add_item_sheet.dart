import 'package:flutter/material.dart';
import 'package:food_tracker/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/core/api/providers.dart';
import 'package:food_tracker/modules/inventory/data/inventory_models.dart';
import 'package:food_tracker/modules/inventory/data/storage_recommendation_api.dart';
import 'package:food_tracker/modules/inventory/data/storage_recommendation_models.dart';
import 'package:food_tracker/modules/inventory/data/storage_recommendation_sheet.dart';
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
  bool _isLoadingRecommendation = false;

  static const _categoryKeys = [
    'dairy', 'meat', 'fish', 'vegetables', 'fruits',
    'bakery', 'drinks', 'frozen', 'snacks', 'other',
  ];

  // Маппинг location из формы → в формат бэка
  String? _locationToBackend(String? loc) {
    const map = {
      'Fridge': 'fridge',
      'Freezer': 'freezer',
      'Pantry': 'pantry',
      'Shelf': 'room',
      'Kitchen cabinet': 'room',
    };
    return loc != null ? map[loc] : null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  /// Запрашивает рекомендацию после того как пользователь закончил вводить имя
  Future<void> _fetchAndShowRecommendation() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isLoadingRecommendation = true);

    try {
      final dio = ref.read(dioProvider);
      final api = StorageRecommendationApi(dio);

      final rec = await api.getRecommendation(
        StorageRecommendationRequest(
          name: name,
          category: _selectedCategory,
          location: _locationToBackend(_selectedLocation),
          language: Localizations.localeOf(context).languageCode,
        ),
      );

      if (!mounted) return;

      final chosenDays = await showStorageRecommendationDialog(context, rec, inputName: name);
      if (chosenDays != null && mounted) {
        setState(() {
          _expirationDate = DateTime.now().add(Duration(days: chosenDays));
        });
      }
    } catch (e) {
      // Тихо игнорируем ошибку рекомендации — не блокируем добавление
    } finally {
      if (mounted) setState(() => _isLoadingRecommendation = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expirationDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) setState(() => _expirationDate = picked);
  }

  Future<void> _submit() async {
    final l = AppLocalizations.of(context)!;
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.enterProductName)));
      return;
    }
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l.enterValidQuantity)));
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
              ? (_locationController.text.trim().isEmpty
              ? null
              : _locationController.text.trim())
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
            SnackBar(content: Text('${l.errorPrefix}$e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _categoryLabel(String key, AppLocalizations l) {
    final map = {
      'dairy': l.categoryDairy, 'meat': l.categoryMeat,
      'fish': l.categoryFish, 'vegetables': l.categoryVegetables,
      'fruits': l.categoryFruits, 'bakery': l.categoryBakery,
      'drinks': l.categoryDrinks, 'frozen': l.categoryFrozen,
      'snacks': l.categorySnacks, 'other': l.categoryOther,
    };
    return map[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 16, right: 16, top: 16,
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
                Text(l.addProduct,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Product name + кнопка получить рекомендацию
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: l.productName,
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.fastfood_outlined),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    onSubmitted: (_) => _fetchAndShowRecommendation(),
                  ),
                ),
                const SizedBox(width: 8),
                // Кнопка "получить рекомендацию"
                SizedBox(
                  height: 56,
                  child: _isLoadingRecommendation
                      ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                      : Tooltip(
                    message: 'Get storage recommendation',
                    child: OutlinedButton(
                      onPressed: _fetchAndShowRecommendation,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Icon(Icons.lightbulb_outline,
                          size: 20),
                    ),
                  ),
                ),
              ],
            ),

            // Подсказка под полем имени
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4),
              child: Text(
                AppLocalizations.of(context)!.getTipAfterName,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                  fontSize: 11,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Quantity + Unit
            Row(children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _amountController,
                  keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: l.quantity,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<UnitEnum>(
                  value: _selectedUnit,
                  decoration: InputDecoration(
                    labelText: l.unit,
                    border: const OutlineInputBorder(),
                  ),
                  items: UnitEnum.values
                      .map((u) =>
                      DropdownMenuItem(value: u, child: Text(u.label)))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedUnit = v!),
                ),
              ),
            ]),
            const SizedBox(height: 12),

            // Expiry date
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(4),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l.expiryDate,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.calendar_today_outlined),
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
              decoration: InputDecoration(
                labelText: l.category,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.category_outlined),
              ),
              items: [
                DropdownMenuItem(
                    value: null, child: Text(l.notSpecified)),
                ..._categoryKeys.map((c) => DropdownMenuItem(
                    value: c, child: Text(_categoryLabel(c, l)))),
              ],
              onChanged: (v) => setState(() => _selectedCategory = v),
            ),
            const SizedBox(height: 12),

            // Location
            DropdownButtonFormField<String>(
              value: _selectedLocation,
              decoration: InputDecoration(
                labelText: l.storageLocation,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.place_outlined),
              ),
              items: [
                DropdownMenuItem(
                    value: 'Fridge', child: Text(l.locationFridge)),
                DropdownMenuItem(
                    value: 'Freezer', child: Text(l.locationFreezer)),
                DropdownMenuItem(
                    value: 'Shelf', child: Text(l.locationShelf)),
                DropdownMenuItem(
                    value: 'Kitchen cabinet',
                    child: Text(l.locationKitchenCabinet)),
                DropdownMenuItem(
                    value: 'Pantry', child: Text(l.locationPantry)),
                DropdownMenuItem(
                    value: 'Other', child: Text(l.locationOther)),
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
                decoration: InputDecoration(
                  labelText: l.enterStorageLocation,
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.edit_outlined),
                ),
                textCapitalization: TextCapitalization.sentences,
                autofocus: true,
              ),
            ],
            const SizedBox(height: 12),

            // Notes
            TextField(
              controller: _notesController,
              decoration: InputDecoration(
                labelText: l.notes,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.notes_outlined),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 20),

            // Submit
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : Text(l.add, style: const TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}