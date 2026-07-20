import 'package:companion_for_cacao/core/domain/entities/hut_type.dart';
import 'package:companion_for_cacao/core/domain/services/hut_tile_supply.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/hut_layout_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:companion_for_cacao/shared/utils/hut_type_assets.dart';
import 'package:companion_for_cacao/shared/utils/hut_type_l10n.dart';
import 'package:companion_for_cacao/shared/widgets/safe_asset_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                      ? AppLocalizations.of(context).hutRegisterAction
                      : AppLocalizations.of(context).hutRegisteredEdit,
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

  /// Tapping a tile picks side A first; every further tap flips it over.
  /// A registered throw never goes back to undecided — "forget throw"
  /// clears the whole layout instead.
  void _flipTile(int index) {
    final (sideA, sideB) = HutTileSupply.tiles[index];
    HapticFeedback.selectionClick();
    setState(() {
      _faceUp[index] = _faceUp[index] == sideA ? sideB : sideA;
    });
  }

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
                      AppLocalizations.of(context).hutRegisterTitle,
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
                AppLocalizations.of(context).hutRegisterHint,
                style: AppTextStyles.instruction,
              ),
              AppSpacing.verticalM,
              Flexible(
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: AppSpacing.s,
                    crossAxisSpacing: AppSpacing.s,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: HutTileSupply.tiles.length,
                  itemBuilder: (context, index) {
                    final (sideA, sideB) = HutTileSupply.tiles[index];
                    return _HutTileFlipCell(
                      key: ValueKey('hut_tile_$index'),
                      index: index,
                      sideA: sideA,
                      sideB: sideB,
                      faceUp: _faceUp[index],
                      onFlip: () => _flipTile(index),
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
                      child: Text(
                        AppLocalizations.of(context).forgetThrowAction,
                        style: const TextStyle(color: AppColors.red),
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
                    label: Text(AppLocalizations.of(context).applyAction),
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

/// One physical hut tile in the throw grid. Undecided cells show both
/// sides small; a decided cell shows the face-up side big. Tapping flips
/// the tile with a horizontal card-flip animation, mirroring the physical
/// gesture of turning the tile over on the table.
class _HutTileFlipCell extends StatelessWidget {
  const _HutTileFlipCell({
    required this.index,
    required this.sideA,
    required this.sideB,
    required this.faceUp,
    required this.onFlip,
    super.key,
  });

  final int index;
  final HutType sideA;
  final HutType sideB;
  final HutType? faceUp;
  final VoidCallback onFlip;

  /// Card-flip illusion without 3D: the outgoing face squashes to a
  /// vertical edge during the first half, the incoming face grows from
  /// it during the second half.
  static Widget _flipTransition(Widget child, Animation<double> animation) {
    final flip = CurvedAnimation(
      parent: animation,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    );
    return AnimatedBuilder(
      animation: flip,
      child: child,
      builder: (_, child) => Transform.scale(scaleX: flip.value, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final chosen = faceUp;
    final isChosen = chosen != null;
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : const Duration(milliseconds: 300);

    return Semantics(
      button: true,
      label: isChosen
          ? chosen.localizedName(l10n)
          : '${sideA.localizedName(l10n)} / ${sideB.localizedName(l10n)}',
      child: Material(
        color: isChosen
            ? AppColors.greenDark.withValues(alpha: 0.12)
            : AppColors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onFlip,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isChosen
                    ? AppColors.greenDark
                    : AppColors.brown.withValues(alpha: 0.25),
                width: isChosen ? 1.5 : 1,
              ),
            ),
            padding: const EdgeInsets.all(AppSpacing.xs),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 2,
                  child: Text('${index + 1}', style: AppTextStyles.badgeCount),
                ),
                Positioned.fill(
                  child: AnimatedSwitcher(
                    duration: duration,
                    transitionBuilder: _flipTransition,
                    child: isChosen
                        ? _ChosenFace(key: ValueKey(chosen), hut: chosen)
                        : _UndecidedFaces(
                            key: const ValueKey('undecided'),
                            sideA: sideA,
                            sideB: sideB,
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The face-up side of a decided tile: image front and center, name and
/// cost below.
class _ChosenFace extends StatelessWidget {
  const _ChosenFace({required this.hut, super.key});

  final HutType hut;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: SafeAssetImage(assetPath: hut.imageAsset, fit: BoxFit.contain),
        ),
        const SizedBox(height: AppSpacing.xxs),
        Text(
          hut.localizedName(AppLocalizations.of(context)),
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.tileNameSmall,
        ),
        Text('(${hut.cost})', style: AppTextStyles.sectionSublabel),
      ],
    );
  }
}

/// Both sides of a tile nobody has decided yet, small, so the player can
/// find the matching physical tile before the first tap.
class _UndecidedFaces extends StatelessWidget {
  const _UndecidedFaces({required this.sideA, required this.sideB, super.key});

  final HutType sideA;
  final HutType sideB;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _MiniSide(hut: sideA),
        Divider(
          height: AppSpacing.s,
          thickness: 1,
          color: AppColors.brown.withValues(alpha: 0.15),
        ),
        _MiniSide(hut: sideB),
      ],
    );
  }
}

class _MiniSide extends StatelessWidget {
  const _MiniSide({required this.hut});

  final HutType hut;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SafeAssetImage(
          assetPath: hut.imageAsset,
          width: 22,
          height: 22,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            hut.localizedName(AppLocalizations.of(context)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyles.sectionSublabel,
          ),
        ),
      ],
    );
  }
}
