import 'package:flutter/material.dart';
import 'package:food_tracker/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_tracker/modules/inventory/data/inventory_models.dart';
import 'package:food_tracker/modules/inventory/providers/inventory_provider.dart';
import 'package:food_tracker/modules/inventory/screens/edit_item_sheet.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class InventoryItemCard extends ConsumerWidget {
  final InventoryItem item;
  const InventoryItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final days = item.daysUntilExpiry;

    Color statusColor;
    String statusLabel;
    IconData statusIcon;

    if (item.isExpired) {
      statusColor = Colors.red;
      statusLabel = l.expired;
      statusIcon = Icons.warning_amber_rounded;
    } else if (item.isExpiringSoon) {
      statusColor = Colors.orange;
      statusLabel = days == 0 ? l.today : l.inDays(days);
      statusIcon = Icons.access_time_rounded;
    } else {
      statusColor = Colors.green;
      statusLabel = l.inDays(days);
      statusIcon = Icons.check_circle_outline;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: statusColor.withOpacity(0.3), width: 1.2),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showActions(context, ref, l),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                child: Center(child: _categoryIcon(item.category, statusColor)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.displayName, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    Text('${item.amount % 1 == 0 ? item.amount.toInt() : item.amount} ${UnitEnum.fromString(item.unit).label}',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6))),
                    if (item.location != null) ...[
                      const SizedBox(height: 2),
                      Row(children: [
                        Icon(Icons.place_outlined, size: 12, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                        const SizedBox(width: 3),
                        Text(item.location!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.5))),
                      ]),
                    ],
                    if (item.notes != null && item.notes!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Row(children: [
                        Icon(Icons.notes_outlined, size: 12, color: theme.colorScheme.onSurface.withOpacity(0.5)),
                        const SizedBox(width: 3),
                        Expanded(child: Text(item.notes!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.5), fontStyle: FontStyle.italic), maxLines: 1, overflow: TextOverflow.ellipsis)),
                      ]),
                    ],
                    const SizedBox(height: 4),
                    Text(l.addedDate(DateFormat('dd MMM yyyy').format(item.addedAt.toLocal())),
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.35), fontSize: 10)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(statusIcon, color: statusColor, size: 16),
                  const SizedBox(height: 2),
                  Text(statusLabel, style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showActions(BuildContext context, WidgetRef ref, AppLocalizations l) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(width: 36, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.edit_outlined, color: Colors.blue),
              title: Text(l.edit),
              onTap: () {
                Navigator.of(context).pop();
                showModalBottomSheet(
                  context: context, isScrollControlled: true,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                  builder: (_) => EditItemSheet(item: item),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle_outline, color: Colors.green),
              title: Text(l.markAsUsed),
              onTap: () async {
                Navigator.of(context).pop();
                try {
                  await ref.read(inventoryProvider.notifier).consumeItem(item.id);
                } catch (e) {
                  if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${l.errorPrefix}$e')));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: Text(l.delete),
              onTap: () async {
                Navigator.of(context).pop();
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(l.deleteProduct),
                    content: Text(l.willBeRemovedFromInventory(item.displayName)),
                    actions: [
                      TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text(l.cancel)),
                      TextButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text(l.delete, style: const TextStyle(color: Colors.red))),
                    ],
                  ),
                );
                if (confirmed == true) {
                  try {
                    await ref.read(inventoryProvider.notifier).deleteItem(item.id);
                  } catch (e) {
                    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${l.errorPrefix}$e')));
                  }
                }
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _categoryIcon(String? category, Color color) {
    const map = {
      'dairy': FontAwesomeIcons.cow, 'meat': FontAwesomeIcons.drumstickBite,
      'fish': FontAwesomeIcons.fish, 'vegetables': FontAwesomeIcons.carrot,
      'fruits': FontAwesomeIcons.appleWhole, 'bakery': FontAwesomeIcons.breadSlice,
      'drinks': FontAwesomeIcons.wineBottle, 'frozen': FontAwesomeIcons.snowflake,
      'snacks': FontAwesomeIcons.cookieBite,
    };
    return FaIcon(map[category] ?? FontAwesomeIcons.cartShopping, size: 20, color: color);
  }
}