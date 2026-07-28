import 'dart:math';

import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/color_filters.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/custom_preset_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/worker_selection_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/worker_balance_validator.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/custom_preset_notifier.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/shared/widgets/dialog_button_bar_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:companion_for_cacao/core/theme/app_shapes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Inline worker selector for preparation flow.
///
/// Shows a compact summary row with a "Modificar" button that opens
/// a full editor in a modal bottom sheet.
class WorkerSelectorWidget extends ConsumerWidget {
  const WorkerSelectorWidget({super.key});

  static String _presetLabel(AppLocalizations l10n, WorkerPresetType preset) {
    return switch (preset) {
      WorkerPresetType.baseOnly => l10n.workerPresetBaseOnly,
      WorkerPresetType.replaceWithNew => l10n.workerPresetReplace,
      WorkerPresetType.baseWith0004 => l10n.workerPresetBase0004,
      WorkerPresetType.addAll => l10n.workerPresetAddAll,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameSetupProvider).value;
    if (gameState == null) return const SizedBox.shrink();

    final selection = gameState.workerSelection;
    final hasSelection = selection != null;

    final l10n = AppLocalizations.of(context);
    final customPresetsAsync = ref.watch(customPresetProvider);
    final customPresets = customPresetsAsync.value ?? [];

    // A set the player named themselves wins over any generic label: the
    // custom-preset match is tried before the origin ("Surprise", "Manual").
    // The other way round, saving a surprise draw under a name and applying
    // it still read as "Surprise" — the match was unreachable.
    final matchingPreset = hasSelection
        ? customPresets
              .where(
                (p) => mapEquals(p.tileQuantities, selection.tileQuantities),
              )
              .firstOrNull
        : null;

    final String label;
    if (!hasSelection) {
      label = l10n.workerAddAllDefault;
    } else if (matchingPreset != null) {
      label = matchingPreset.name;
    } else if (selection.mode == WorkerSelectionMode.preset) {
      label = _presetLabel(l10n, selection.presetType);
    } else if (selection.isSurprise) {
      label = l10n.workerSurprise;
    } else {
      label = l10n.workerManual;
    }

    final tilesPerPlayer = hasSelection
        ? selection.tilesPerPlayer
        : 15; // addAll default

    final playerCount = gameState.players.length;
    final jungleTileCount = WorkerBalanceValidator.countJungleTiles(
      gameState.tiles,
    );
    final balance = WorkerBalanceValidator.validate(
      playerCount: playerCount,
      workerTilesPerPlayer: tilesPerPlayer,
      jungleTileCount: jungleTileCount,
    );

    // Same anatomy as every other preparation card (thumb + label +
    // check), with the choice summary and edit action in a green footer
    // — the same pattern the hut-throw card uses.
    return Opacity(
      opacity: hasSelection ? 0.6 : 1.0,
      child: Card(
        color: AppColors.cream,
        elevation: hasSelection ? 0 : 2,
        margin: const EdgeInsets.symmetric(
          horizontal: AppSpacing.l,
          vertical: 6,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppShapes.radius(AppShapes.radiusM),
          side: BorderSide(
            color: AppColors.brown.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: InkWell(
          borderRadius: AppShapes.radius(AppShapes.radiusM),
          onTap: () => _openEditor(context, ref, gameState),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.m,
              vertical: AppSpacing.s,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: AppShapes.radius(AppShapes.radiusM),
                      ),
                      child: const Icon(
                        Icons.people_outline,
                        color: AppColors.brown,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.m),
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context).newWorkersSelectionLabel,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.brown,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.s),
                    // The step completes by applying a selection in the
                    // editor (mirrors the checkbox of regular cards).
                    Icon(
                      hasSelection ? Icons.check_circle : Icons.circle_outlined,
                      color: AppColors.brown,
                      size: 26,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.s),
                Material(
                  color: AppColors.greenLight.withValues(alpha: 0.6),
                  borderRadius: AppShapes.radius(AppShapes.radiusS),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s,
                      vertical: AppSpacing.xs,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          hasSelection
                              ? Icons.check_circle
                              : Icons.app_registration,
                          color: hasSelection
                              ? AppColors.greenDark
                              : AppColors.greenDarker,
                          size: 18,
                        ),
                        const SizedBox(width: AppSpacing.s),
                        Expanded(
                          child: Text(
                            l10n.workerSummaryLine(label, tilesPerPlayer),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.brown,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.s),
                        // Only verdict a set the player actually chose. The
                        // implicit default ("add all") is out of the
                        // recommended range at 3+ players, so badging it made
                        // preparation open in a warning state over a decision
                        // nobody had taken yet. The full balance panel is one
                        // tap away, inside the editor.
                        if (hasSelection) ...[
                          _BalanceBadge(isValid: balance.isValid),
                          const SizedBox(width: AppSpacing.s),
                        ],
                        const Icon(
                          Icons.edit_outlined,
                          color: AppColors.greenDarker,
                          size: 16,
                        ),
                      ],
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

  void _openEditor(BuildContext context, WidgetRef ref, dynamic gameState) {
    final modules = gameState.modules as List;
    final isTreeOfLifeActive = modules.any((m) => m.id == 6);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _WorkerEditorSheet(
        initialSelection: gameState.workerSelection as WorkerSelectionEntity?,
        playerCount: gameState.players.length as int,
        jungleTileCount: WorkerBalanceValidator.countJungleTiles(
          gameState.tiles,
        ),
        isTreeOfLifeActive: isTreeOfLifeActive,
        onApply: (selection) {
          final reopened = ref
              .read(gameSetupProvider.notifier)
              .applyWorkerSelection(selection);
          // Only warn when the change re-opened a step the user had ticked —
          // otherwise they already know it's still pending. The SnackBar shows
          // in both the checklist and the paged view, where the re-opened step
          // may sit on another page.
          if (reopened && context.mounted) {
            final l10n = AppLocalizations.of(context);
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(l10n.workerSelectionResetNotice)),
              );
          }
        },
      ),
    );
  }
}

// =============================================================================
// Build Summary — the physical "take these" instruction
// =============================================================================

/// Translates the applied worker selection into a physical action: which
/// tiles to take from the base game and which from the expansion. Reads the
/// current selection (defaults to "add all"), so it always matches the bag.
class WorkerBuildSummary extends ConsumerWidget {
  const WorkerBuildSummary({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selection = ref.watch(
      gameSetupProvider.select((s) => s.value?.workerSelection),
    );
    final effective =
        selection?.effectiveQuantities ??
        const {
          ...WorkerSelectionEntity.baseDistributions,
          ...WorkerSelectionEntity.newDistributions,
        };

    List<(String, int)> pick(Iterable<String> keys) => [
      for (final d in keys)
        if ((effective[d] ?? 0) > 0) (d, effective[d]!),
    ];

    final base = pick(WorkerSelectionEntity.baseDistributions.keys);
    final neu = pick(WorkerSelectionEntity.newDistributions.keys);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _BuildGroup(label: l10n.workerBuildFromBase, tiles: base, isNew: false),
        if (neu.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.s),
          _BuildGroup(
            label: l10n.workerBuildFromExpansion,
            tiles: neu,
            isNew: true,
          ),
        ],
      ],
    );
  }
}

class _BuildGroup extends StatelessWidget {
  const _BuildGroup({
    required this.label,
    required this.tiles,
    required this.isNew,
  });

  final String label;
  final List<(String, int)> tiles;
  final bool isNew;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.greenDarker,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.s,
          runSpacing: AppSpacing.s,
          children: [
            for (final (distribution, qty) in tiles)
              _BuildTile(distribution: distribution, qty: qty, isNew: isNew),
          ],
        ),
      ],
    );
  }
}

class _BuildTile extends StatelessWidget {
  const _BuildTile({
    required this.distribution,
    required this.qty,
    required this.isNew,
  });

  final String distribution;
  final int qty;
  final bool isNew;

  String get _imagePath {
    final underscored = distribution.replaceAll('-', '_');
    final folder = isNew ? 'diamante' : 'base';
    return 'assets/images/tiles/$folder/player_white_$underscored.webp';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: AppShapes.radius(AppShapes.radiusM),
        border: Border.all(color: AppColors.brown.withValues(alpha: 0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 56,
            height: 56,
            // Worker tiles come in each player's colour; shown as a neutral
            // (grayscale) reference, like the other "each player" steps.
            child: ColorFiltered(
              colorFilter: kGrayscaleFilter,
              child: Image.asset(
                _imagePath,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColors.grey,
                  size: 28,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            '×$qty',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.brown,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Editor Bottom Sheet
// =============================================================================

class _WorkerEditorSheet extends ConsumerStatefulWidget {
  const _WorkerEditorSheet({
    required this.initialSelection,
    required this.playerCount,
    required this.jungleTileCount,
    required this.isTreeOfLifeActive,
    required this.onApply,
  });

  final WorkerSelectionEntity? initialSelection;
  final int playerCount;
  final int jungleTileCount;
  final bool isTreeOfLifeActive;
  final ValueChanged<WorkerSelectionEntity> onApply;

  @override
  ConsumerState<_WorkerEditorSheet> createState() => _WorkerEditorSheetState();
}

class _WorkerEditorSheetState extends ConsumerState<_WorkerEditorSheet> {
  late Map<String, int> _quantities;
  late WorkerSelectionMode _mode;
  late WorkerPresetType _presetType;

  /// Whether the current quantities came from the "Surprise +2" action.
  bool _isSurprise = false;

  /// ID of the currently selected custom preset, or null if none.
  String? _selectedCustomPresetId;

  @override
  void initState() {
    super.initState();
    final sel = widget.initialSelection;
    if (sel != null) {
      _mode = sel.mode;
      _presetType = sel.presetType;
      _isSurprise = sel.isSurprise;
      _quantities = Map.of(sel.effectiveQuantities);
    } else {
      _mode = WorkerSelectionMode.preset;
      _presetType = WorkerPresetType.addAll;
      _quantities = {
        ...WorkerSelectionEntity.baseDistributions,
        ...WorkerSelectionEntity.newDistributions,
      };
    }
    _enforceMinimums();
  }

  void _applyPreset(WorkerPresetType preset) {
    setState(() {
      _mode = WorkerSelectionMode.preset;
      _presetType = preset;
      _isSurprise = false;
      _selectedCustomPresetId = null;
      final selection = WorkerSelectionEntity(
        mode: WorkerSelectionMode.preset,
        presetType: preset,
      );
      _quantities = Map.of(selection.effectiveQuantities);
      _enforceMinimums();
    });
  }

  /// "Surprise +2": base tiles plus 2 of the 4 new distributions picked at
  /// random (community variant suggested on BGG). When Tree of Life (2p)
  /// locks the 0-0-0-4 tile, it is always one of the two picks.
  void _applySurprise() {
    final rng = Random();
    final picked = <String>{};
    if (_isLocked('0-0-0-4')) picked.add('0-0-0-4');
    final candidates =
        WorkerSelectionEntity.newDistributions.keys
            .where((k) => !picked.contains(k))
            .toList()
          ..shuffle(rng);
    picked.addAll(candidates.take(2 - picked.length));

    setState(() {
      _mode = WorkerSelectionMode.manual;
      _isSurprise = true;
      _selectedCustomPresetId = null;
      _quantities = {
        ...WorkerSelectionEntity.baseDistributions,
        for (final key in picked) key: 1,
      };
      _enforceMinimums();
    });
  }

  void _applyCustomPreset(CustomPresetEntity preset) {
    setState(() {
      _mode = WorkerSelectionMode.manual;
      _isSurprise = false;
      _selectedCustomPresetId = preset.id;
      _quantities = Map.of(preset.tileQuantities);
      _enforceMinimums();
    });
  }

  void _updateQuantity(String distribution, int delta) {
    setState(() {
      _mode = WorkerSelectionMode.manual;
      _isSurprise = false;
      _selectedCustomPresetId = null;
      final current = _quantities[distribution] ?? 0;
      final maxQty =
          WorkerSelectionEntity.baseDistributions[distribution] ??
          WorkerSelectionEntity.newDistributions[distribution] ??
          1;
      final minQty = _minQuantityFor(distribution);
      _quantities[distribution] = (current + delta).clamp(minQty, maxQty);
    });
  }

  /// Returns the minimum allowed quantity for a tile distribution.
  ///
  /// Tree of Life for 2 players requires the 0-0-0-4 tile (mandatory per
  /// the Diamante rulebook), so its minimum is 1 in that scenario.
  int _minQuantityFor(String distribution) {
    if (_isLocked(distribution)) return 1;
    return 0;
  }

  /// Whether a tile distribution is locked to a minimum quantity.
  bool _isLocked(String distribution) {
    return widget.isTreeOfLifeActive &&
        widget.playerCount == 2 &&
        distribution == '0-0-0-4';
  }

  /// With Tree of Life at 2 players the 0-0-0-4 tile is mandatory, so
  /// "Base only" is not a legal option — it would collapse into
  /// "Base + 0-0-0-4" anyway, so the chip is hidden.
  bool get _isBaseOnlyAvailable =>
      !(widget.isTreeOfLifeActive && widget.playerCount == 2);

  /// Enforces minimum quantities after a preset is applied.
  void _enforceMinimums() {
    for (final key in _quantities.keys.toList()) {
      final min = _minQuantityFor(key);
      if ((_quantities[key] ?? 0) < min) {
        _quantities[key] = min;
      }
    }
    // Ensure locked tiles exist in the map even if the preset omits them.
    if (widget.isTreeOfLifeActive && widget.playerCount == 2) {
      _quantities.putIfAbsent('0-0-0-4', () => 1);
    }
  }

  void _reset() {
    setState(() {
      _mode = WorkerSelectionMode.preset;
      _presetType = WorkerPresetType.addAll;
      _isSurprise = false;
      _selectedCustomPresetId = null;
      _quantities = {
        ...WorkerSelectionEntity.baseDistributions,
        ...WorkerSelectionEntity.newDistributions,
      };
      _enforceMinimums();
    });
  }

  void _apply() {
    // If enforced minimums (e.g. Tree of Life 2p locking 0-0-0-4) diverged
    // the displayed quantities from the pure preset, apply as manual so the
    // result matches exactly what the UI shows.
    var mode = _mode;
    if (mode == WorkerSelectionMode.preset) {
      final pure = WorkerSelectionEntity(
        mode: WorkerSelectionMode.preset,
        presetType: _presetType,
      ).effectiveQuantities;
      if (!mapEquals(pure, _quantities)) {
        mode = WorkerSelectionMode.manual;
      }
    }
    final selection = WorkerSelectionEntity(
      mode: mode,
      presetType: _presetType,
      tileQuantities: mode == WorkerSelectionMode.manual
          ? Map.of(_quantities)
          : const {},
      isSurprise: mode == WorkerSelectionMode.manual && _isSurprise,
    );
    widget.onApply(selection);
    Navigator.of(context).pop();
  }

  /// Whether the current quantities match any built-in or custom preset.
  bool _matchesAnyPreset(List<CustomPresetEntity> customPresets) {
    // Check built-in presets
    for (final preset in WorkerPresetType.values) {
      final sel = WorkerSelectionEntity(
        mode: WorkerSelectionMode.preset,
        presetType: preset,
      );
      if (mapEquals(_quantities, sel.effectiveQuantities)) return true;
    }
    // Check custom presets
    for (final preset in customPresets) {
      if (mapEquals(_quantities, preset.tileQuantities)) return true;
    }
    return false;
  }

  Future<void> _showSaveDialog() async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => const _SavePresetDialog(),
    );

    if (name == null || name.isEmpty) return;

    final preset = CustomPresetEntity(
      id: CustomPresetEntity.generateId(),
      name: name,
      tileQuantities: Map.of(_quantities),
    );
    ref.read(customPresetProvider.notifier).addPreset(preset);
    setState(() {
      _selectedCustomPresetId = preset.id;
    });
  }

  Future<void> _showDeleteDialog(CustomPresetEntity preset) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(ctx).deletePresetTitle),
        content: Text(
          AppLocalizations.of(ctx).deletePresetConfirm(preset.name),
        ),
        actions: [
          DialogButtonBarWidget(
            onCancel: () => Navigator.of(ctx).pop(false),
            onConfirm: () => Navigator.of(ctx).pop(true),
            confirmLabel: AppLocalizations.of(ctx).deleteAction,
            isDestructive: true,
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    ref.read(customPresetProvider.notifier).deletePreset(preset.id);
    if (_selectedCustomPresetId == preset.id) {
      setState(() {
        _selectedCustomPresetId = null;
      });
    }
  }

  static String _presetDescription(
    AppLocalizations l10n,
    WorkerSelectionMode mode,
    WorkerPresetType preset, {
    bool isSurprise = false,
  }) {
    if (mode == WorkerSelectionMode.manual) {
      if (isSurprise) {
        return l10n.workerDescSurprise;
      }
      return l10n.workerDescManual;
    }
    return switch (preset) {
      WorkerPresetType.baseOnly => l10n.workerDescBaseOnly,
      WorkerPresetType.replaceWithNew => l10n.workerDescReplace,
      WorkerPresetType.baseWith0004 => l10n.workerDescBase0004,
      WorkerPresetType.addAll => l10n.workerDescAddAll,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final tilesPerPlayer = _quantities.values.fold(0, (sum, q) => sum + q);
    final balance = WorkerBalanceValidator.validate(
      playerCount: widget.playerCount,
      workerTilesPerPlayer: tilesPerPlayer,
      jungleTileCount: widget.jungleTileCount,
    );
    final customPresetsAsync = ref.watch(customPresetProvider);
    final customPresets = customPresetsAsync.value ?? [];
    final showSaveButton =
        _mode == WorkerSelectionMode.manual &&
        _selectedCustomPresetId == null &&
        !_matchesAnyPreset(customPresets);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Column(
          children: [
            // Drag handle
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.grey.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
              child: Row(
                children: [
                  const Icon(
                    Icons.people_outline,
                    color: AppColors.brown,
                    size: 22,
                  ),
                  const SizedBox(width: AppSpacing.s),
                  Expanded(
                    child: Text(
                      l10n.workerSheetTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.brown,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    color: AppColors.brown,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            // Scrollable content
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
                children: [
                  // Description
                  Text(
                    l10n.workerChooseIntro,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.brown.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s),

                  // Expandable help
                  _HelpSection(),
                  const SizedBox(height: AppSpacing.m),

                  // Presets
                  Text(
                    l10n.workerPresetsSection,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.brown.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.s,
                    runSpacing: AppSpacing.xs,
                    children: [
                      if (_isBaseOnlyAvailable)
                        _PresetChip(
                          label: l10n.workerPresetBaseOnly,
                          isSelected:
                              _mode == WorkerSelectionMode.preset &&
                              _presetType == WorkerPresetType.baseOnly,
                          onTap: () => _applyPreset(WorkerPresetType.baseOnly),
                        ),
                      _PresetChip(
                        label: l10n.workerPresetReplace,
                        isSelected:
                            _mode == WorkerSelectionMode.preset &&
                            _presetType == WorkerPresetType.replaceWithNew,
                        onTap: () =>
                            _applyPreset(WorkerPresetType.replaceWithNew),
                      ),
                      _PresetChip(
                        label: l10n.workerPresetBase0004,
                        isSelected:
                            _mode == WorkerSelectionMode.preset &&
                            _presetType == WorkerPresetType.baseWith0004,
                        onTap: () =>
                            _applyPreset(WorkerPresetType.baseWith0004),
                      ),
                      _PresetChip(
                        label: l10n.workerPresetAddAll,
                        isSelected:
                            _mode == WorkerSelectionMode.preset &&
                            _presetType == WorkerPresetType.addAll,
                        onTap: () => _applyPreset(WorkerPresetType.addAll),
                      ),
                      // Custom presets
                      for (final preset in customPresets)
                        _CustomPresetChip(
                          label: preset.name,
                          isSelected: _selectedCustomPresetId == preset.id,
                          onTap: () => _applyCustomPreset(preset),
                          onLongPress: () => _showDeleteDialog(preset),
                        ),
                      // Save button (only when manual and not matching)
                      if (showSaveButton)
                        ActionChip(
                          avatar: const Icon(
                            Icons.save_outlined,
                            size: 16,
                            color: AppColors.greenDarker,
                          ),
                          label: Text(l10n.saveAction),
                          onPressed: _showSaveDialog,
                          backgroundColor: AppColors.greenNormal.withValues(
                            alpha: 0.2,
                          ),
                          side: BorderSide(
                            color: AppColors.greenDark.withValues(alpha: 0.4),
                          ),
                          labelStyle: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.greenDarker,
                              ),
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.s),

                  // Random — an action that generates a manual selection,
                  // visually separated from the fixed presets.
                  Text(
                    l10n.workerRandomSection,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.brown.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: FilterChip(
                      avatar: Icon(
                        Icons.casino_outlined,
                        size: 16,
                        color: AppColors.brown.withValues(
                          alpha: _isSurprise ? 1.0 : 0.7,
                        ),
                      ),
                      label: Text(l10n.workerSurpriseChip),
                      tooltip: l10n.workerSurpriseTooltip,
                      selected: _isSurprise,
                      showCheckmark: false,
                      // Each tap reshuffles, even when already selected
                      onSelected: (_) => _applySurprise(),
                      backgroundColor: AppColors.gold.withValues(alpha: 0.15),
                      selectedColor: AppColors.gold.withValues(alpha: 0.45),
                      side: BorderSide(
                        color: AppColors.gold,
                        width: _isSurprise ? 2 : 1,
                      ),
                      labelStyle: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(
                            color: AppColors.brown,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                          ),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s),
                  Text(
                    _selectedCustomPresetId != null
                        ? l10n.workerCustomPreset(
                            customPresets
                                    .where(
                                      (p) => p.id == _selectedCustomPresetId,
                                    )
                                    .firstOrNull
                                    ?.name ??
                                '',
                          )
                        : _presetDescription(
                            l10n,
                            _mode,
                            _presetType,
                            isSurprise: _isSurprise,
                          ),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.brown.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.l),

                  // Balance indicator
                  _BalanceIndicator(
                    balance: balance,
                    tilesPerPlayer: tilesPerPlayer,
                  ),
                  const SizedBox(height: AppSpacing.l),

                  // Tile grid
                  _TileGrid(
                    quantities: _quantities,
                    onQuantityChanged: _updateQuantity,
                    isLocked: _isLocked,
                  ),
                  const SizedBox(height: AppSpacing.l),
                ],
              ),
            ),
            // Sticky action buttons
            Container(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.l,
                AppSpacing.s,
                AppSpacing.l,
                AppSpacing.l,
              ),
              decoration: BoxDecoration(
                color: AppColors.cream,
                border: Border(
                  top: BorderSide(color: AppColors.grey.withValues(alpha: 0.2)),
                ),
              ),
              child: Row(
                children: [
                  TextButton(
                    onPressed: _reset,
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.brown.withValues(alpha: 0.7),
                    ),
                    child: Text(l10n.resetAction),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    // The balance range is a rulebook recommendation, not a
                    // hard rule — applying is always allowed; the balance
                    // indicator warns when out of range.
                    onPressed: _apply,
                    icon: const Icon(Icons.check, size: 18),
                    label: Text(l10n.applyAction),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

// =============================================================================
// Help Section (expandable)
// =============================================================================

class _HelpSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(bottom: AppSpacing.s),
        dense: true,
        visualDensity: VisualDensity.compact,
        title: Text(
          AppLocalizations.of(context).workerHowItWorks,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.greenDarker,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: const Icon(
          Icons.help_outline,
          color: AppColors.greenDarker,
          size: 16,
        ),
        iconColor: AppColors.greenDarker,
        collapsedIconColor: AppColors.greenDarker,
        children: [
          Text(
            AppLocalizations.of(context).workerHelpBody,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.brown.withValues(alpha: 0.7),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Tile Grid
// =============================================================================

class _TileGrid extends StatelessWidget {
  const _TileGrid({
    required this.quantities,
    required this.onQuantityChanged,
    required this.isLocked,
  });

  final Map<String, int> quantities;
  final void Function(String distribution, int delta) onQuantityChanged;
  final bool Function(String distribution) isLocked;

  @override
  Widget build(BuildContext context) {
    final baseDistributions = WorkerSelectionEntity.baseDistributions.keys
        .toList();
    final newDistributions = WorkerSelectionEntity.newDistributions.keys
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Base tiles section
        Text(
          AppLocalizations.of(context).workerBaseTiles,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.brown.withValues(alpha: 0.6),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        for (final distribution in baseDistributions)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: _TileQuantityCard(
              distribution: distribution,
              isNew: false,
              quantity: quantities[distribution] ?? 0,
              maxQuantity:
                  WorkerSelectionEntity.baseDistributions[distribution]!,
              isLocked: isLocked(distribution),
              onDecrement:
                  (quantities[distribution] ?? 0) > 0 && !isLocked(distribution)
                  ? () => onQuantityChanged(distribution, -1)
                  : null,
              onIncrement:
                  (quantities[distribution] ?? 0) <
                      WorkerSelectionEntity.baseDistributions[distribution]!
                  ? () => onQuantityChanged(distribution, 1)
                  : null,
            ),
          ),
        const SizedBox(height: AppSpacing.s),
        // New tiles section
        Text(
          AppLocalizations.of(context).workerNewTiles,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: AppColors.brown.withValues(alpha: 0.6),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        for (final distribution in newDistributions)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs),
            child: _TileQuantityCard(
              distribution: distribution,
              isNew: true,
              quantity: quantities[distribution] ?? 0,
              maxQuantity:
                  WorkerSelectionEntity.newDistributions[distribution]!,
              isLocked: isLocked(distribution),
              onDecrement:
                  (quantities[distribution] ?? 0) >
                      (isLocked(distribution) ? 1 : 0)
                  ? () => onQuantityChanged(distribution, -1)
                  : null,
              onIncrement:
                  (quantities[distribution] ?? 0) <
                      WorkerSelectionEntity.newDistributions[distribution]!
                  ? () => onQuantityChanged(distribution, 1)
                  : null,
            ),
          ),
      ],
    );
  }
}

// =============================================================================
// Tile Quantity Card
// =============================================================================

class _TileQuantityCard extends StatelessWidget {
  const _TileQuantityCard({
    required this.distribution,
    required this.isNew,
    required this.quantity,
    required this.maxQuantity,
    required this.onDecrement,
    required this.onIncrement,
    this.isLocked = false,
  });

  final String distribution;
  final bool isNew;
  final int quantity;
  final int maxQuantity;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;
  final bool isLocked;

  String get _imagePath {
    final underscored = distribution.replaceAll('-', '_');
    final folder = isNew ? 'diamante' : 'base';
    return 'assets/images/tiles/$folder/player_white_$underscored.webp';
  }

  @override
  Widget build(BuildContext context) {
    final isActive = quantity > 0;

    return Container(
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.white
            : AppColors.grey.withValues(alpha: 0.15),
        borderRadius: AppShapes.radius(AppShapes.radiusS),
        border: Border.all(
          color: isActive
              ? AppColors.greenDark.withValues(alpha: 0.4)
              : AppColors.grey.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      child: Row(
        children: [
          // Tile image
          SizedBox(
            width: 40,
            height: 40,
            child: Opacity(
              opacity: isActive ? 1.0 : 0.4,
              child: Image.asset(
                _imagePath,
                fit: BoxFit.contain,
                errorBuilder: (_, _, _) => const Icon(
                  Icons.image_not_supported_outlined,
                  color: AppColors.grey,
                  size: 24,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.m),
          // Distribution name + lock indicator
          Expanded(
            child: Row(
              children: [
                Text(
                  distribution,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isActive
                        ? AppColors.brown
                        : AppColors.brown.withValues(alpha: 0.5),
                  ),
                ),
                if (isLocked) ...[
                  const SizedBox(width: 4),
                  Tooltip(
                    message: AppLocalizations.of(context).workerLockedTooltip,
                    child: Icon(
                      Icons.lock_outline,
                      size: 14,
                      color: AppColors.brown.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Quantity controls
          _QuantityControls(
            quantity: quantity,
            maxQuantity: maxQuantity,
            onDecrement: onDecrement,
            onIncrement: onIncrement,
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Quantity Controls
// =============================================================================

class _QuantityControls extends StatelessWidget {
  const _QuantityControls({
    required this.quantity,
    required this.maxQuantity,
    required this.onDecrement,
    required this.onIncrement,
  });

  final int quantity;
  final int maxQuantity;
  final VoidCallback? onDecrement;
  final VoidCallback? onIncrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SmallIconButton(icon: Icons.remove, onPressed: onDecrement),
        SizedBox(
          width: 28,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.brown,
            ),
          ),
        ),
        _SmallIconButton(icon: Icons.add, onPressed: onIncrement),
      ],
    );
  }
}

class _SmallIconButton extends StatelessWidget {
  const _SmallIconButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      height: 34,
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        style: IconButton.styleFrom(
          backgroundColor: onPressed != null
              ? AppColors.greenNormal.withValues(alpha: 0.5)
              : AppColors.grey.withValues(alpha: 0.15),
          foregroundColor: onPressed != null ? AppColors.brown : AppColors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: AppShapes.radius(AppShapes.radiusS),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Balance Indicator
// =============================================================================

class _BalanceIndicator extends StatelessWidget {
  const _BalanceIndicator({required this.balance, this.tilesPerPlayer});

  final WorkerBalanceResult balance;
  final int? tilesPerPlayer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color = balance.isValid ? AppColors.greenDark : AppColors.warning;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: AppShapes.radius(AppShapes.radiusS),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                balance.isValid ? Icons.check_circle : Icons.warning_amber,
                color: color,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.s),
              Expanded(
                child: Text(
                  balance.isValid
                      ? l10n.workerBalanceOk
                      : l10n.workerBalanceOut,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          if (!balance.isValid) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(
              l10n.workerBalanceHint,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.brown.withValues(alpha: 0.7),
                fontSize: 11,
                height: 1.3,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.s),
          // Formula: workers - jungle = difference (range)
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.brown.withValues(alpha: 0.8),
              ),
              children: [
                TextSpan(
                  text: '${balance.totalWorkers}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' ${l10n.workerBalanceWorkersWord} − '),
                TextSpan(
                  text: '${balance.totalJungle}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' ${l10n.workerBalanceJungleWord} = '),
                TextSpan(
                  text: '${balance.difference}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 14,
                  ),
                ),
                TextSpan(
                  text:
                      '  ${l10n.workerBalanceRange(balance.minDifference, balance.maxDifference)}',
                  style: TextStyle(
                    color: AppColors.brown.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          if (tilesPerPlayer != null) ...[
            const SizedBox(height: AppSpacing.xxs),
            Text(
              l10n.workerTilesPerPlayerLine(tilesPerPlayer!),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.brown.withValues(alpha: 0.6),
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// =============================================================================
// Shared Components
// =============================================================================

class _BalanceBadge extends StatelessWidget {
  const _BalanceBadge({required this.isValid});

  final bool isValid;

  @override
  Widget build(BuildContext context) {
    final color = isValid ? AppColors.greenDark : AppColors.warning;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppShapes.radius(AppShapes.radiusM),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.warning_amber,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 3),
          Text(
            isValid
                ? AppLocalizations.of(context).workerBalanceValid
                : AppLocalizations.of(context).workerBalanceOutShort,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _PresetChip extends StatelessWidget {
  const _PresetChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppColors.greenNormal,
      checkmarkColor: AppColors.brown,
      backgroundColor: AppColors.white,
      side: BorderSide(
        color: isSelected
            ? AppColors.greenDark
            : AppColors.grey.withValues(alpha: 0.4),
      ),
      labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        color: AppColors.brown,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    );
  }
}

class _CustomPresetChip extends StatelessWidget {
  const _CustomPresetChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.onLongPress,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: onLongPress,
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.greenNormal,
        checkmarkColor: AppColors.brown,
        backgroundColor: AppColors.cream,
        avatar: Icon(
          Icons.bookmark_outline,
          size: 14,
          color: isSelected
              ? AppColors.brown
              : AppColors.brown.withValues(alpha: 0.5),
        ),
        side: BorderSide(
          color: isSelected
              ? AppColors.greenDark
              : AppColors.brown.withValues(alpha: 0.3),
        ),
        labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: AppColors.brown,
        ),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}

/// Preset-name entry dialog. Owns its text controller so it is disposed with
/// the dialog's own lifecycle instead of racing the route exit animation.
class _SavePresetDialog extends StatefulWidget {
  const _SavePresetDialog();

  @override
  State<_SavePresetDialog> createState() => _SavePresetDialogState();
}

class _SavePresetDialogState extends State<_SavePresetDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.savePresetTitle),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(
          labelText: l10n.presetNameLabel,
          hintText: l10n.presetNameHint,
        ),
        textCapitalization: TextCapitalization.sentences,
        onSubmitted: (value) => Navigator.of(context).pop(value.trim()),
      ),
      actions: [
        DialogButtonBarWidget(
          onCancel: () => Navigator.of(context).pop(),
          onConfirm: () => Navigator.of(context).pop(_controller.text.trim()),
          confirmLabel: l10n.saveAction,
        ),
      ],
    );
  }
}
