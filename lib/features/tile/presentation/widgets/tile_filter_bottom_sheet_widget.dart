import 'dart:async';

import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_type_extension.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/tile/domain/entities/tile_filter_scope.dart';
import 'package:companion_for_cacao/features/tile/presentation/providers/tile_filter_notifier.dart';
import 'package:companion_for_cacao/shared/providers/boardgame_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TileFilterBottomSheetWidget extends ConsumerStatefulWidget {
  const TileFilterBottomSheetWidget({required this.scope, super.key});

  /// Which independent filter state this sheet edits.
  final TileFilterScope scope;

  @override
  ConsumerState<TileFilterBottomSheetWidget> createState() =>
      _TileFilterBottomSheetWidgetState();
}

class _TileFilterBottomSheetWidgetState
    extends ConsumerState<TileFilterBottomSheetWidget> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref
          .read(tileFilterProvider(widget.scope).notifier)
          .updateSearchQuery(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Use ref.select to only rebuild when selectedBoardgameIds changes
    final selectedBoardgameIds = ref.watch(
      tileFilterProvider(
        widget.scope,
      ).select((state) => state.selectedBoardgameIds),
    );
    // Use ref.select to only rebuild when selectedTileTypes changes
    final selectedTileTypes = ref.watch(
      tileFilterProvider(
        widget.scope,
      ).select((state) => state.selectedTileTypes),
    );

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: AppSpacing.l,
        right: AppSpacing.l,
        top: AppSpacing.l,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpacing.verticalXl,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'FILTERS',
                  style: AppTextStyles.boardgameTitlePlain.copyWith(
                    fontSize: 22,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ref
                        .read(tileFilterProvider(widget.scope).notifier)
                        .clearFilters();
                  },
                  child: Text(
                    'CLEAR ALL',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.brown.withValues(alpha: 0.6),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.verticalL,
            TextField(
              decoration: InputDecoration(
                hintText: 'Search tile by name...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.brown.withValues(alpha: 0.5),
                ),
                prefixIcon: const Icon(Icons.search, color: AppColors.brown),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.greenNormal),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.greenNormal),
                ),
                filled: true,
                fillColor: AppColors.white,
              ),
              style: AppTextStyles.bodyMedium,
              onChanged: _onSearchChanged,
            ),
            AppSpacing.verticalXl,
            Text(
              'EXPANSIONS',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                letterSpacing: 1.2,
                color: AppColors.brown.withValues(alpha: 0.8),
              ),
            ),
            AppSpacing.verticalM,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Built from the loaded boardgames so the filter always
                // matches the actual catalog (no hardcoded ids/names)
                for (final boardgame
                    in ref.watch(boardgameProvider).value ??
                        const <BoardgameModel>[])
                  _buildBoardgameChip(
                    ref,
                    selectedBoardgameIds,
                    boardgame.id,
                    boardgame.name,
                  ),
              ],
            ),
            AppSpacing.verticalXl,
            Text(
              'TILE TYPES',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                letterSpacing: 1.2,
                color: AppColors.brown.withValues(alpha: 0.8),
              ),
            ),
            AppSpacing.verticalM,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: TileType.values.map((type) {
                return _buildTypeChip(
                  ref,
                  selectedTileTypes,
                  type.displayName,
                  chipKey: ValueKey('tile_type_${type.name}'),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildBoardgameChip(
    WidgetRef ref,
    Set<int> selectedBoardgameIds,
    int id,
    String label,
  ) {
    final isSelected = selectedBoardgameIds.contains(id);
    return FilterChip(
      label: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isSelected ? AppColors.white : AppColors.brown,
        ),
      ),
      selected: isSelected,
      onSelected: (_) {
        ref.read(tileFilterProvider(widget.scope).notifier).toggleBoardgame(id);
      },
      selectedColor: AppColors.greenDark,
      backgroundColor: AppColors.white,
      side: const BorderSide(color: AppColors.greenNormal),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      showCheckmark: false,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
    );
  }

  Widget _buildTypeChip(
    WidgetRef ref,
    Set<String> selectedTileTypes,
    String type, {
    Key? chipKey,
  }) {
    final isSelected = selectedTileTypes.contains(type);
    return FilterChip(
      key: chipKey,
      label: Text(
        type,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isSelected ? AppColors.white : AppColors.brown,
        ),
      ),
      selected: isSelected,
      onSelected: (_) {
        ref
            .read(tileFilterProvider(widget.scope).notifier)
            .toggleTileType(type);
      },
      selectedColor: AppColors.greenDark,
      backgroundColor: AppColors.white,
      side: const BorderSide(color: AppColors.greenNormal),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      showCheckmark: false,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
    );
  }
}
