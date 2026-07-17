import 'dart:math';

import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/custom_preset_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/worker_selection_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/worker_balance_validator.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/custom_preset_notifier.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Inline worker selector for preparation flow.
///
/// Shows a compact summary row with a "Modificar" button that opens
/// a full editor in a modal bottom sheet.
class WorkerSelectorWidget extends ConsumerWidget {
  const WorkerSelectorWidget({super.key});

  static String _presetLabel(WorkerPresetType preset) {
    return switch (preset) {
      WorkerPresetType.baseOnly => 'Base only',
      WorkerPresetType.replaceWithNew => 'Replace',
      WorkerPresetType.baseWith0004 => 'Base + 0-0-0-4',
      WorkerPresetType.addAll => 'Add all',
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameSetupProvider).value;
    if (gameState == null) return const SizedBox.shrink();

    final selection = gameState.workerSelection;
    final hasSelection = selection != null;

    // Determine label: check if manual selection matches a custom preset
    final customPresetsAsync = ref.watch(customPresetProvider);
    final customPresets = customPresetsAsync.value ?? [];
    String label;
    if (!hasSelection) {
      label = 'Add all (default)';
    } else if (selection.mode == WorkerSelectionMode.preset) {
      label = _presetLabel(selection.presetType);
    } else if (selection.isSurprise) {
      label = 'Surprise';
    } else {
      // Manual mode — check if it matches a custom preset
      final matchingPreset = customPresets
          .where((p) => mapEquals(p.tileQuantities, selection.tileQuantities))
          .firstOrNull;
      label = matchingPreset != null ? matchingPreset.name : 'Manual';
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
          onTap: () => _openEditor(context, ref, gameState),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.m,
              vertical: AppSpacing.s,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.greenDark.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.people_outline,
                  color: AppColors.brown,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'The New Workers',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.brown,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$label · $tilesPerPlayer tiles/player',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.brown.withValues(alpha: 0.7),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                _BalanceBadge(isValid: balance.isValid),
                const SizedBox(width: AppSpacing.s),
                Icon(
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
          ref.read(gameSetupProvider.notifier).applyWorkerSelection(selection);
        },
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
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Save as preset'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            labelText: 'Preset name',
            hintText: 'e.g. Our favorite',
          ),
          textCapitalization: TextCapitalization.sentences,
          onSubmitted: (value) => Navigator.of(ctx).pop(value.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(controller.text.trim()),
            style: FilledButton.styleFrom(backgroundColor: AppColors.greenDark),
            child: const Text('Save'),
          ),
        ],
      ),
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
        title: const Text('Delete preset'),
        content: Text("Delete '${preset.name}'?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.red),
            child: const Text('Delete'),
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
    WorkerSelectionMode mode,
    WorkerPresetType preset, {
    bool isSurprise = false,
  }) {
    if (mode == WorkerSelectionMode.manual) {
      if (isSurprise) {
        return 'Surprise: base tiles + 2 new Diamante tiles picked at '
            'random. Tap again for a different pair.';
      }
      return 'Manual selection: adjust the quantity of each tile individually.';
    }
    return switch (preset) {
      WorkerPresetType.baseOnly =>
        'Uses only the base game tiles (11 per player). '
            'The new Diamante tiles are not added.',
      WorkerPresetType.replaceWithNew =>
        'Replaces 4 base tiles (1-1-1-1) with the 4 new Diamante ones. '
            'Total: 11 per player.',
      WorkerPresetType.baseWith0004 =>
        'Adds only the 0-0-0-4 tile to the 11 base tiles. Total: 12 per '
            'player. Recommended by the community (BGG).',
      WorkerPresetType.addAll =>
        'Adds the 4 new Diamante tiles to the 11 base ones. '
            'Total: 15 per player.',
    };
  }

  @override
  Widget build(BuildContext context) {
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
                      'The New Workers',
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
                    'Choose which worker tiles each player will use. '
                    'All players use the same set.',
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
                    'Presets',
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
                          label: 'Base only',
                          isSelected:
                              _mode == WorkerSelectionMode.preset &&
                              _presetType == WorkerPresetType.baseOnly,
                          onTap: () => _applyPreset(WorkerPresetType.baseOnly),
                        ),
                      _PresetChip(
                        label: 'Replace',
                        isSelected:
                            _mode == WorkerSelectionMode.preset &&
                            _presetType == WorkerPresetType.replaceWithNew,
                        onTap: () =>
                            _applyPreset(WorkerPresetType.replaceWithNew),
                      ),
                      _PresetChip(
                        label: 'Base + 0-0-0-4',
                        isSelected:
                            _mode == WorkerSelectionMode.preset &&
                            _presetType == WorkerPresetType.baseWith0004,
                        onTap: () =>
                            _applyPreset(WorkerPresetType.baseWith0004),
                      ),
                      _PresetChip(
                        label: 'Add all',
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
                          label: const Text('Save'),
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
                    'Random',
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
                      label: const Text('Surprise +2'),
                      tooltip:
                          'Base + 2 new tiles picked at random. '
                          'Tap again for a different pair.',
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
                        ? 'Custom preset: ${customPresets.where((p) => p.id == _selectedCustomPresetId).firstOrNull?.name ?? ''}'
                        : _presetDescription(
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
                    child: const Text('Reset'),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    // The balance range is a rulebook recommendation, not a
                    // hard rule — applying is always allowed; the balance
                    // indicator warns when out of range.
                    onPressed: _apply,
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Apply'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.greenDark,
                    ),
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
          'How does it work?',
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
            '• The New Workers adds 4 new worker tiles with '
            'distributions different from the base game ones.\n'
            '• You can use a quick preset or manually adjust '
            'the quantity of each tile.\n'
            '• The balance between workers and jungle tiles '
            'matters: if the difference falls outside the indicated '
            'range, the game may feel unbalanced.\n'
            '• By default, the game recommends keeping 11 tiles '
            'per player, but you can add more for a longer game.',
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
          'Base tiles',
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
          'New tiles (Diamante)',
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
        borderRadius: BorderRadius.circular(8),
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
                    message: 'Required by Tree of Life (2 players)',
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
    final color = balance.isValid ? AppColors.greenDark : AppColors.warning;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
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
                      ? 'Balance is fine'
                      : 'Outside recommended range',
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
              'The rulebook recommends this margin to keep the game '
              'balanced, but you can still apply the selection.',
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
                const TextSpan(text: ' workers − '),
                TextSpan(
                  text: '${balance.totalJungle}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const TextSpan(text: ' jungle = '),
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
                      '  (range: ${balance.minDifference}–${balance.maxDifference})',
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
              'Tiles per player: $tilesPerPlayer',
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
        borderRadius: BorderRadius.circular(12),
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
            isValid ? 'Valid' : 'Out of range',
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
