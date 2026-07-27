import 'package:companion_for_cacao/core/domain/entities/hut_type.dart';
import 'package:companion_for_cacao/core/domain/services/hut_tile_supply.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_shapes.dart';
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
      borderRadius: AppShapes.radius(AppShapes.radiusS),
      child: InkWell(
        borderRadius: AppShapes.radius(AppShapes.radiusS),
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
  /// How many physical tiles can show each function (its supply cap).
  static final Map<HutType, int> _maxCopies = _computeMaxCopies();

  /// All functions ordered by building cost — matches how the bank is laid
  /// out on the table, so the list reads the same way.
  static final List<HutType> _ordered = HutType.values.toList()
    ..sort((a, b) => a.cost.compareTo(b.cost));

  static Map<HutType, int> _computeMaxCopies() {
    final counts = <HutType, int>{};
    for (final (sideA, sideB) in HutTileSupply.tiles) {
      counts[sideA] = (counts[sideA] ?? 0) + 1;
      counts[sideB] = (counts[sideB] ?? 0) + 1;
    }
    return counts;
  }

  /// Last grid slot each cell occupied, so a hidden cell fades out where it
  /// was while the others animate to their new positions.
  final Map<String, int> _slot = {};

  /// Which copies (by index) of each function are recorded face up. Tracking
  /// the exact copy — not just a count — means the cell you tap is the one
  /// that gets marked, even for duplicated functions.
  late final Map<HutType, Set<int>> _picked = _initPicked();

  Map<HutType, Set<int>> _initPicked() {
    final picked = {for (final h in HutType.values) h: <int>{}};
    final seen = <HutType, int>{};
    for (final h in widget.initialLayout?.faceUp ?? const <HutType>[]) {
      final next = seen[h] ?? 0;
      picked[h]!.add(next);
      seen[h] = next + 1;
    }
    return picked;
  }

  int _countOf(HutType hut) => _picked[hut]?.length ?? 0;

  int get _total => _picked.values.fold(0, (a, s) => a + s.length);

  bool get _isComplete => _total == HutTileSupply.tiles.length;

  /// The recorded face-up functions expanded into a flat list.
  List<HutType> _expanded() {
    final list = <HutType>[];
    _picked.forEach((hut, indices) {
      for (var i = 0; i < indices.length; i++) {
        list.add(hut);
      }
    });
    return list;
  }

  /// How many MORE copies of [hut] can still land face up right now, given
  /// what is already recorded. Because a physical tile carries two functions
  /// (e.g. Market Crier / Hermit share the same tiles), recording one copy
  /// of a function immediately lowers this for its tile-mates.
  int _extraAddable(HutType hut) {
    final count = _countOf(hut);
    final max = _maxCopies[hut] ?? 0;
    final base = _expanded();
    var extra = 0;
    for (var k = 1; count + k <= max; k++) {
      if (_total + k > HutTileSupply.tiles.length) break;
      if (!HutTileSupply.isRealizable([...base, ...List.filled(k, hut)])) break;
      extra = k;
    }
    return extra;
  }

  void _toggle(HutType hut, int index, {required bool selected}) {
    HapticFeedback.selectionClick();
    setState(() {
      if (selected) {
        _picked[hut]!.remove(index);
      } else {
        _picked[hut]!.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                      l10n.hutRegisterTitle,
                      style: AppTextStyles.sectionTitlePlain.copyWith(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Text(
                    '$_total / ${HutTileSupply.tiles.length}',
                    style: AppTextStyles.badgeCount,
                  ),
                ],
              ),
              AppSpacing.verticalS,
              Text(l10n.hutRegisterHint, style: AppTextStyles.instruction),
              AppSpacing.verticalM,
              Flexible(
                child: SingleChildScrollView(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      const columns = 3;
                      const cellHeight = 146.0;
                      final cellWidth = constraints.maxWidth / columns;
                      return _buildGrid(cellWidth, cellHeight, columns);
                    },
                  ),
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
                        l10n.forgetThrowAction,
                        style: const TextStyle(color: AppColors.red),
                      ),
                    ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: _isComplete
                        ? () {
                            widget.onApply(
                              HutLayoutEntity(faceUp: _expanded()),
                            );
                            Navigator.of(context).pop();
                          }
                        : null,
                    icon: const Icon(Icons.check, size: 18),
                    label: Text(l10n.applyAction),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Cost-ordered grid where every copy keeps a slot. Visible copies flow
  /// left-to-right / top-to-bottom; each cell is absolutely positioned and
  /// animates to its slot, so when a copy disappears the rest visibly slide
  /// to their new place — even across rows — instead of jumping.
  Widget _buildGrid(double cellWidth, double cellHeight, int columns) {
    final specs =
        <({String id, HutType hut, int index, bool selected, bool visible})>[];
    var visibleCount = 0;
    for (final hut in _ordered) {
      final max = _maxCopies[hut] ?? 0;
      // Recorded copies always show at their own index; on top of them show
      // only as many open slots as can still realistically land — tile-mates
      // share the supply.
      var openBudget = _extraAddable(hut);
      for (var i = 0; i < max; i++) {
        final selected = _picked[hut]?.contains(i) ?? false;
        final bool visible;
        if (selected) {
          visible = true;
        } else if (openBudget > 0) {
          visible = true;
          openBudget--;
        } else {
          visible = false;
        }
        final id = '${hut.name}_$i';
        if (visible) {
          _slot[id] = visibleCount;
          visibleCount++;
        }
        specs.add((
          id: id,
          hut: hut,
          index: i,
          selected: selected,
          visible: visible,
        ));
      }
    }

    final rows = (visibleCount / columns).ceil();
    final gridHeight = rows * cellHeight;

    const move = Duration(milliseconds: 300);
    const curve = Curves.easeInOutCubic;

    return AnimatedContainer(
      duration: move,
      curve: curve,
      height: gridHeight,
      child: Stack(
        children: [
          for (final c in specs)
            AnimatedPositioned(
              key: ValueKey('pos_${c.id}'),
              duration: move,
              curve: curve,
              left: ((_slot[c.id] ?? 0) % columns) * cellWidth,
              top: ((_slot[c.id] ?? 0) ~/ columns) * cellHeight,
              width: cellWidth,
              height: cellHeight,
              child: _AnimatedGridCell(
                key: ValueKey('hut_cell_${c.id}'),
                visible: c.visible,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  child: _FunctionCell(
                    hut: c.hut,
                    selected: c.selected,
                    onTap: () => _toggle(c.hut, c.index, selected: c.selected),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Fades and scales a grid cell in/out with the same motion both ways
/// (its slide across the grid is handled by the enclosing AnimatedPositioned).
/// While animating out it keeps showing the cell; once gone it leaves the
/// tree (and never intercepts taps while hidden).
class _AnimatedGridCell extends StatefulWidget {
  const _AnimatedGridCell({
    required this.visible,
    required this.child,
    super.key,
  });

  final bool visible;
  final Widget child;

  @override
  State<_AnimatedGridCell> createState() => _AnimatedGridCellState();
}

class _AnimatedGridCellState extends State<_AnimatedGridCell>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 260),
    value: widget.visible ? 1 : 0,
  );
  late final Animation<double> _anim = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOutCubic,
  );

  @override
  void didUpdateWidget(covariant _AnimatedGridCell oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visible != oldWidget.visible) {
      widget.visible ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        if (!widget.visible && _controller.isDismissed) {
          return const SizedBox.shrink();
        }
        return IgnorePointer(
          ignoring: !widget.visible,
          child: FadeTransition(
            opacity: _anim,
            child: ScaleTransition(scale: _anim, child: widget.child),
          ),
        );
      },
    );
  }
}

/// One selectable hut face: the tile art (cost is printed on it) and the
/// name. Green with a check when recorded face up; tap again to undo it.
class _FunctionCell extends StatelessWidget {
  const _FunctionCell({
    required this.hut,
    required this.selected,
    required this.onTap,
  });

  final HutType hut;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Semantics(
      button: true,
      selected: selected,
      label: hut.localizedName(l10n),
      child: Material(
        color: selected
            ? AppColors.greenDark.withValues(alpha: 0.10)
            : AppColors.surfaceCard,
        borderRadius: AppShapes.radius(AppShapes.radiusM),
        child: InkWell(
          borderRadius: AppShapes.radius(AppShapes.radiusM),
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: AppShapes.radius(AppShapes.radiusM),
              // Constant width (only the colour changes) so selecting a cell
              // never nudges its content and reflows the grid.
              border: Border.all(
                color: selected
                    ? AppColors.greenDark
                    : AppColors.brown.withValues(alpha: 0.10),
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xs,
              AppSpacing.s,
              AppSpacing.xs,
              AppSpacing.s,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // Centred: the cell fills a fixed-height slot, so short and
              // two-line names sit consistently.
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      SafeAssetImage(
                        assetPath: hut.imageAsset,
                        width: 80,
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                      if (selected)
                        Positioned(
                          right: -4,
                          bottom: -4,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.greenDark,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.white,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.check,
                              size: 13,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  hut.localizedName(l10n),
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  // Constant weight: bolding on select changes the text
                  // metrics and can rewrap the name, shifting the layout.
                  style: AppTextStyles.sectionSublabel.copyWith(
                    color: AppColors.brown,
                    fontWeight: FontWeight.w600,
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
