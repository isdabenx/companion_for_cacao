import 'dart:async';

import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/tile/domain/entities/tile_filter_state_entity.dart';
import 'package:companion_for_cacao/features/tile/presentation/providers/tile_filter_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TileFilterBottomSheetWidget extends ConsumerStatefulWidget {
  const TileFilterBottomSheetWidget({super.key});

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
      ref.read(tileFilterProvider.notifier).updateSearchQuery(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final filterState = ref.watch(tileFilterProvider);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
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
                    ref.read(tileFilterProvider.notifier).clearFilters();
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
            const SizedBox(height: 16),
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
            const SizedBox(height: 24),
            Text(
              'EXPANSIONS',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                letterSpacing: 1.2,
                color: AppColors.brown.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildBoardgameChip(ref, filterState, 1, 'Cacao'),
                _buildBoardgameChip(ref, filterState, 2, 'Chocolatl'),
                _buildBoardgameChip(ref, filterState, 3, 'Diamante'),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'TILE TYPES',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                letterSpacing: 1.2,
                color: AppColors.brown.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: TileType.values.map((type) {
                // To get the string representation we create a dummy model just to use the getter,
                // or we could extract it to an extension. Since the app is small, let's use a dummy.
                final dummyModel = TileModel(
                  id: 0,
                  name: '',
                  description: '',
                  filenameImage: '',
                  quantity: 0,
                  type: type,
                );
                return _buildTypeChip(
                  ref,
                  filterState,
                  dummyModel.typeAsString,
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildBoardgameChip(
    WidgetRef ref,
    TileFilterStateEntity filterState,
    int id,
    String label,
  ) {
    final isSelected = filterState.selectedBoardgameIds.contains(id);
    return FilterChip(
      label: Text(
        label,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isSelected ? AppColors.white : AppColors.brown,
        ),
      ),
      selected: isSelected,
      onSelected: (_) {
        ref.read(tileFilterProvider.notifier).toggleBoardgame(id);
      },
      selectedColor: AppColors.greenDark,
      backgroundColor: AppColors.white,
      side: const BorderSide(color: AppColors.greenNormal),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      showCheckmark: false,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }

  Widget _buildTypeChip(
    WidgetRef ref,
    TileFilterStateEntity filterState,
    String type,
  ) {
    final isSelected = filterState.selectedTileTypes.contains(type);
    return FilterChip(
      label: Text(
        type,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isSelected ? AppColors.white : AppColors.brown,
        ),
      ),
      selected: isSelected,
      onSelected: (_) {
        ref.read(tileFilterProvider.notifier).toggleTileType(type);
      },
      selectedColor: AppColors.greenDark,
      backgroundColor: AppColors.white,
      side: const BorderSide(color: AppColors.greenNormal),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      showCheckmark: false,
      visualDensity: VisualDensity.compact,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    );
  }
}
