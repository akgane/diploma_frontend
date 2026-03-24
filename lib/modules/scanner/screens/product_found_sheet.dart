import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/modules/inventory/data/inventory_models.dart';
import 'package:food_tracker/modules/inventory/providers/inventory_provider.dart';
import 'package:food_tracker/modules/products/data/product_models.dart';

class ProductFoundSheet extends ConsumerStatefulWidget {
  final ProductModel product;

  const ProductFoundSheet({super.key, required this.product});

  @override
  ConsumerState<ProductFoundSheet> createState() => _ProductFoundSheetState();
}

class _ProductFoundSheetState extends ConsumerState<ProductFoundSheet> {
  final _amountController = TextEditingController(text: '1');
  UnitEnum _selectedUnit = UnitEnum.pcs;
  DateTime _expirationDate = DateTime.now().add(const Duration(days: 7));
  bool _isLoading = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
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
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Enter a valid quantity')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref
          .read(inventoryProvider.notifier)
          .addItem(
            AddInventoryItemRequest(
              productId: widget.product.id,
              barcode: widget.product.barcode,
              customName: widget.product.name,
              amount: amount,
              unit: _selectedUnit,
              expirationDate: _expirationDate,
            ),
          );
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
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
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Product found',
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

            // Product card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant.withOpacity(0.4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  if (product.imageUrl != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        product.imageUrl!,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const _PlaceholderImage(),
                      ),
                    )
                  else
                    const _PlaceholderImage(),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: TextEditingController(text: product.name),
                          decoration: const InputDecoration(
                            labelText: 'Product name *',
                            border: OutlineInputBorder(),
                            // prefixIcon: Icon(Icons.fastfood_outlined),
                          ),
                          // style: theme.textTheme.bodyLarge?.copyWith(
                          //   fontWeight: FontWeight.w600,
                          // ),
                          // maxLines: 2,
                          // overflow: TextOverflow.ellipsis,
                        ),
                        if (product.brand != null)
                          Text(
                            product.brand!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.6,
                              ),
                            ),
                          ),
                        if (product.quantity != null)
                          Text(
                            product.quantity!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(
                                0.6,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Amount and unit
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
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
                    items:
                        UnitEnum.values
                            .map(
                              (u) => DropdownMenuItem(
                                value: u,
                                child: Text(u.label),
                              ),
                            )
                            .toList(),
                    onChanged: (v) => setState(() => _selectedUnit = v!),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Date
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
            const SizedBox(height: 20),

            // Button
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
                child:
                    _isLoading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Text(
                          'Add to inventory',
                          style: TextStyle(fontSize: 16),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Icon(Icons.image_not_supported_outlined, color: Colors.grey),
    );
  }
}
