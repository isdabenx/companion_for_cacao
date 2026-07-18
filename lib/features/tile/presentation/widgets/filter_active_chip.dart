import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/features/tile/domain/entities/tile_filter_scope.dart';
import 'package:companion_for_cacao/features/tile/presentation/providers/tile_filter_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shows a chip when there are active filters applied.
/// Allows clearing all filters easily.
class FilterActiveChip extends ConsumerWidget {
  const FilterActiveChip({required this.scope, super.key});

  /// Which independent filter state this chip reflects.
  final TileFilterScope scope;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use ref.select to only rebuild when hasActiveFilters changes
    final hasFilters = ref.watch(
      tileFilterProvider(scope).select((state) => state.hasActiveFilters),
    );

    if (!hasFilters) {
      return const SizedBox.shrink();
    }

    // Use ref.select to only rebuild when activeFilterCount changes
    final filterCount = ref.watch(
      tileFilterProvider(scope).select((state) => state.activeFilterCount),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.s,
        AppSpacing.s,
        AppSpacing.s,
        0,
      ),
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
                ref.read(tileFilterProvider(scope).notifier).clearFilters();
              },
            ),
          ),
        ],
      ),
    );
  }
}
