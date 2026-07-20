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

/// Opens the hut-throw editor sheet. Registering the throw is what marks
/// the hut-throw preparation step as completed.
void showHutLayoutEditor(BuildContext context, WidgetRef ref) {
  final notifier = ref.read(gameSetupProvider.notifier);
  final layout = ref.read(gameSetupProvider).value?.hutLayout;
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

/// Status row hosted inside the hut-throw preparation card: the step is
/// completed by registering which side of each of the 12 physical hut
/// tiles landed face up (no manual checkbox).
class HutThrowRegisterRow extends ConsumerWidget {
  const HutThrowRegisterRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final layout = ref.watch(
      gameSetupProvider.select((s) => s.value?.hutLayout),
    );

    return Material(
      color: AppColors.greenLight.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () => showHutLayoutEditor(context, ref),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.s,
            vertical: AppSpacing.xs,
          ),
          child: Row(
            children: [
              Icon(
                layout == null ? Icons.app_registration : Icons.check_circle,
                color: layout == null
                    ? AppColors.greenDarker
                    : AppColors.greenDark,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.s),
              Expanded(
                child: Text(
                  layout == null
                      ? 'Register which huts landed face up'
                      : 'Throw registered · tap to edit',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.brown,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.s),
              const Icon(
                Icons.edit_outlined,
                color: AppColors.greenDarker,
                size: 16,
              ),
            ],
          ),
        ),
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
