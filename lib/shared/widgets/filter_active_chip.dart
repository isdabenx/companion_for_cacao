import 'package:companion_for_cacao/features/tile/presentation/providers/tile_filter_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget que mostra un chip quan hi ha filtres actius aplicats.
/// Permet netejar tots els filtres fàcilment.
class FilterActiveChip extends ConsumerWidget {
  const FilterActiveChip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use ref.select to only rebuild when hasActiveFilters changes
    final hasFilters = ref.watch(
      tileFilterProvider.select((state) => state.hasActiveFilters),
    );

    if (!hasFilters) {
      return const SizedBox.shrink();
    }

    // Use ref.select to only rebuild when activeFilterCount changes
    final filterCount = ref.watch(
      tileFilterProvider.select((state) => state.activeFilterCount),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: Row(
        children: [
          Expanded(
            child: Chip(
              avatar: const Icon(Icons.filter_list, size: 18),
              label: Text(
                '$filterCount filter${filterCount > 1 ? 's' : ''} active',
              ),
              deleteIcon: const Icon(Icons.close, size: 18),
              onDeleted: () {
                ref.read(tileFilterProvider.notifier).clearFilters();
              },
            ),
          ),
        ],
      ),
    );
  }
}
