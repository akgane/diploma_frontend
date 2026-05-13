import 'package:flutter/material.dart';
import 'package:food_tracker/l10n/app_localizations.dart';
import 'package:food_tracker/modules/inventory/data/storage_recommendation_models.dart';

Future<int?> showStorageRecommendationDialog(
    BuildContext context,
    StorageRecommendationResponse rec,
    {String? inputName}
    ) {
  return showModalBottomSheet<int>(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _StorageRecommendationSheet(rec: rec, inputName: inputName),
  );
}

class _StorageRecommendationSheet extends StatelessWidget {
  final StorageRecommendationResponse rec;
  final String? inputName;

  const _StorageRecommendationSheet({required this.rec, this.inputName});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
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
            Center(
              child: Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('🗓️', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l.storageRecommendations,
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(null),
                ),
              ],
            ),
            Text(
              inputName ?? rec.displayName,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),

            if (!rec.requiresClarification &&
                rec.options.isEmpty &&
                rec.recommendedDays != null)
              _SingleRecommendationTile(rec: rec,
                  onTap: () => Navigator.of(context).pop(rec.recommendedDays)),

            if (rec.options.isNotEmpty) ...[
              Text(
                l.chooseStorageCondition,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ...rec.options.map((opt) => _OptionTile(
                option: opt,
                onTap: () =>
                    Navigator.of(context).pop(opt.recommendedDays),
              )),
            ],

            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(null),
                child: Text(l.skipSetManually),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SingleRecommendationTile extends StatelessWidget {
  final StorageRecommendationResponse rec;
  final VoidCallback onTap;

  const _SingleRecommendationTile({required this.rec, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final days = rec.recommendedDays!;
    final daysLabel = (rec.minDays != null &&
        rec.maxDays != null &&
        rec.minDays != rec.maxDays)
        ? '${rec.minDays}–${rec.maxDays} ${l.daysUnit}'
        : '$days ${l.daysUnit}';

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.primary.withOpacity(0.3)),
      ),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(Icons.calendar_today_outlined,
              color: theme.colorScheme.primary),
        ),
        title: Text(
          l.recommendedDays(daysLabel),
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: rec.location != null
            ? Text(
          '${_locationLabel(rec.location!, l)}'
              '${rec.state != null ? ' · ${_stateLabel(rec.state!, l)}' : ''}',
        )
            : null,
        trailing: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12)),
          child: Text(l.applyRecommendation),
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final StorageRecommendationOption option;
  final VoidCallback onTap;

  const _OptionTile({required this.option, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final daysLabel = (option.minDays != null &&
        option.maxDays != null &&
        option.minDays != option.maxDays)
        ? '${option.minDays}–${option.maxDays} ${l.daysUnit}'
        : '${option.recommendedDays} ${l.daysUnit}';

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.colorScheme.outline.withOpacity(0.2)),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(_locationEmoji(option.location),
                style: const TextStyle(fontSize: 18)),
          ),
        ),
        title: Text(
          '${_locationLabel(option.location, l)} · ${_stateLabel(option.state, l)}',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(daysLabel),
        trailing: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12)),
          child: Text(l.applyRecommendation),
        ),
      ),
    );
  }

  String _locationEmoji(String loc) {
    const map = {'fridge': '🧊', 'freezer': '❄️', 'pantry': '📦', 'room': '🏠'};
    return map[loc] ?? '📍';
  }
}

String _locationLabel(String loc, AppLocalizations l) {
  final map = {
    'fridge': '🧊 ${l.locationFridgeShort}',
    'freezer': '❄️ ${l.locationFreezerShort}',
    'pantry': '📦 ${l.locationPantryShort}',
    'room': '🏠 ${l.locationRoomShort}',
  };
  return map[loc] ?? loc;
}

String _stateLabel(String state, AppLocalizations l) {
  final map = {
    'whole': l.stateWhole,
    'cut': l.stateCut,
    'raw': l.stateRaw,
    'cooked': l.stateCooked,
    'opened': l.stateOpened,
    'unopened': l.stateUnopened,
    'fresh': l.stateFresh,
  };
  return map[state] ?? state;
}