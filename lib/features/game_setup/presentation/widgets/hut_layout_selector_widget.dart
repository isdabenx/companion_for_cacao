import 'package:companion_for_cacao/core/domain/entities/hut_type.dart';
import 'package:companion_for_cacao/core/domain/services/hut_tile_supply.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/hut_layout_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/shared/utils/hut_type_assets.dart';
import 'package:companion_for_cacao/shared/widgets/safe_asset_image.dart';
import 'package:companion_for_cacao/shared/widgets/selectable_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Inline card in the preparation flow to register the hut throw: which
/// side of each of the 12 physical hut tiles landed face up. Optional —
/// when registered, the score calculator offers exactly the huts in play.
class HutLayoutSelectorWidget extends ConsumerWidget {
  const HutLayoutSelectorWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = ref.watch(
      gameSetupProvider.select((s) => s.value?.hutLayout),
    );

    // Match PreparationCard margins so the row aligns with the other cards
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
        vertical: 6,
      ),
      child: Material(
        color: AppColors.cream,
        borderRadius: BorderRadius.circular(12),
        elevation: 1,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _openEditor(context, ref, layout),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.m,
              vertical: AppSpacing.s,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.greenDark.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.cottage_outlined,
                  color: AppColors.brown,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hut throw (optional)',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.brown,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        layout == null
                            ? 'Not registered · score calculator will allow '
                                  'any combination'
                            : 'Registered · exact hut supply known',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.brown.withValues(alpha: 0.7),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                Icon(
                  layout == null ? Icons.help_outline : Icons.check_circle,
                  color: layout == null
                      ? AppColors.brown.withValues(alpha: 0.4)
                      : AppColors.greenDark,
                  size: 18,
                ),
                const SizedBox(width: AppSpacing.s),
                const Icon(
                  Icons.edit_outlined,
                  color: AppColors.greenDarker,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openEditor(
    BuildContext context,
    WidgetRef ref,
    HutLayoutEntity? layout,
  ) {
    final notifier = ref.read(gameSetupProvider.notifier);
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _HutLayoutEditorSheet(
        initialLayout: layout,
        onApply: notifier.applyHutLayout,
        onClear: notifier.clearHutLayout,
      ),
    );
  }
}

class _HutLayoutEditorSheet extends StatefulWidget {
  const _HutLayoutEditorSheet({
    required this.initialLayout,
    required this.onApply,
    required this.onClear,
  });

  final HutLayoutEntity? initialLayout;
  final ValueChanged<HutLayoutEntity> onApply;
  final VoidCallback onClear;

  @override
  State<_HutLayoutEditorSheet> createState() => _HutLayoutEditorSheetState();
}

class _HutLayoutEditorSheetState extends State<_HutLayoutEditorSheet> {
  late final List<HutType?> _faceUp = widget.initialLayout != null
      ? List<HutType?>.from(widget.initialLayout!.faceUp)
      : List<HutType?>.filled(HutTileSupply.tiles.length, null);

  int get _chosenCount => _faceUp.whereType<HutType>().length;

  bool get _isComplete => _chosenCount == _faceUp.length;

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.85;

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.l,
            AppSpacing.m,
            AppSpacing.l,
            AppSpacing.m,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Register the hut throw',
                      style: AppTextStyles.sectionTitlePlain.copyWith(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Text(
                    '$_chosenCount / ${_faceUp.length}',
                    style: AppTextStyles.badgeCount,
                  ),
                ],
              ),
              AppSpacing.verticalS,
              Text(
                'For each physical tile, pick the side that landed face up.',
                style: AppTextStyles.instruction,
              ),
              AppSpacing.verticalM,
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: HutTileSupply.tiles.length,
                  separatorBuilder: (_, _) => AppSpacing.verticalS,
                  itemBuilder: (context, index) {
                    final (sideA, sideB) = HutTileSupply.tiles[index];
                    return Row(
                      children: [
                        SizedBox(
                          width: 24,
                          child: Text(
                            '${index + 1}',
                            style: AppTextStyles.badgeCount,
                          ),
                        ),
                        Expanded(
                          child: _SideChip(
                            hut: sideA,
                            isSelected: _faceUp[index] == sideA,
                            onTap: () => setState(() => _faceUp[index] = sideA),
                          ),
                        ),
                        AppSpacing.horizontalS,
                        Expanded(
                          child: _SideChip(
                            hut: sideB,
                            isSelected: _faceUp[index] == sideB,
                            onTap: () => setState(() => _faceUp[index] = sideB),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              AppSpacing.verticalM,
              Row(
                children: [
                  if (widget.initialLayout != null)
                    TextButton(
                      onPressed: () {
                        widget.onClear();
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Forget throw',
                        style: TextStyle(color: AppColors.red),
                      ),
                    ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: _isComplete
                        ? () {
                            widget.onApply(
                              HutLayoutEntity(
                                faceUp: _faceUp.whereType<HutType>().toList(),
                              ),
                            );
                            Navigator.of(context).pop();
                          }
                        : null,
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Apply'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One side of a physical hut tile: image, name and cost.
class _SideChip extends StatelessWidget {
  const _SideChip({
    required this.hut,
    required this.isSelected,
    required this.onTap,
  });

  final HutType hut;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SelectableChip(
      isSelected: isSelected,
      selectedColor: AppColors.greenDark.withValues(alpha: 0.2),
      selectedBorderColor: AppColors.greenDark,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      onTap: onTap,
      child: Row(
        children: [
          SafeAssetImage(
            assetPath: hut.imageAsset,
            width: 28,
            height: 28,
            fit: BoxFit.contain,
          ),
          AppSpacing.horizontalS,
          Expanded(
            child: Text(
              '${hut.label} (${hut.cost})',
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.tileNameSmall,
            ),
          ),
        ],
      ),
    );
  }
}
