import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/worker_selection_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/module_preparation_handler.dart';

class NewWorkersModuleHandler implements ModulePreparationHandler {
  NewWorkersModuleHandler({this.workerSelection});

  static const int moduleId = 8;

  /// Preparation step rendered as the interactive worker selector.
  /// It has no checkbox, so the UI excludes it from completion counts.
  static const String selectionStepId = 'setup_new_workers_selection';

  /// The user's worker tile selection. When null, defaults to addAll behavior.
  final WorkerSelectionEntity? workerSelection;

  @override
  List<TileModel> adjustTiles(
    List<TileModel> tiles,
    int playerCount, {
    required List<BoardgameModel> activeExpansions,
    bool isBigGame = false,
  }) {
    // Big Game: all tiles already loaded by base handler
    if (isBigGame) return tiles;

    final selection =
        workerSelection ??
        const WorkerSelectionEntity(
          mode: WorkerSelectionMode.preset,
          presetType: WorkerPresetType.addAll,
        );

    final effective = Map.of(selection.effectiveQuantities);

    // Tree of Life for 2 players requires each player's 0-0-0-4 tile
    // (mandatory per the Diamante rulebook). Tree of Life runs before this
    // handler (moduleId 6 < 8), so its jungle tiles are already in the pool.
    final isTreeOfLifeActive = tiles.any(
      (t) => t.type == TileType.treeOfLife && t.quantity > 0,
    );
    if (isTreeOfLifeActive &&
        playerCount == 2 &&
        (effective['0-0-0-4'] ?? 0) < 1) {
      effective['0-0-0-4'] = 1;
    }

    var result = <TileModel>[...tiles];

    // Get active player colors from existing tiles in the pool
    final playerColors = result
        .where((t) => t.type == TileType.player && t.color != null)
        .map((t) => t.color!)
        .toSet();

    // Adjust base worker tile quantities based on selection.
    // Always set the quantity — the selector is authoritative and must
    // override any player-count reductions applied by the base handler.
    for (final entry in WorkerSelectionEntity.baseDistributions.entries) {
      final distribution = entry.key;
      final selectedQty = effective[distribution] ?? entry.value;

      result = result.map((t) {
        if (t.type == TileType.player &&
            t.name == distribution &&
            t.moduleId == null &&
            playerColors.contains(t.color)) {
          return t.copyWith(quantity: selectedQty);
        }
        return t;
      }).toList();
    }

    // Collect IDs already in the pool to avoid duplicates
    // (e.g., 0-0-0-4 may already be added by TreeOfLifeModuleHandler for 2p)
    final existingIds = result.map((t) => t.id).toSet();

    // Add new worker tiles based on selection
    for (final color in playerColors) {
      for (final expansion in activeExpansions) {
        for (final tile in expansion.tiles) {
          if (tile.moduleId == moduleId &&
              tile.color == color &&
              !existingIds.contains(tile.id)) {
            final selectedQty = effective[tile.name] ?? 0;
            if (selectedQty > 0) {
              result.add(tile.copyWith(quantity: selectedQty));
            }
          }
        }
      }
    }

    // Handle tiles already in pool (e.g., 0-0-0-4 from TreeOfLifeModuleHandler)
    // Update their quantity if our selection differs
    for (final entry in WorkerSelectionEntity.newDistributions.entries) {
      final distribution = entry.key;
      final selectedQty = effective[distribution] ?? 0;

      result = result.map((t) {
        if (t.type == TileType.player &&
            t.name == distribution &&
            t.moduleId == moduleId &&
            playerColors.contains(t.color) &&
            existingIds.contains(t.id)) {
          return t.copyWith(quantity: selectedQty);
        }
        return t;
      }).toList();
    }

    return result;
  }

  @override
  List<PreparationEntity> modifyPreparationSteps(
    List<PlayerEntity> players,
    List<TileModel> tiles,
    List<PreparationEntity> currentSteps, {
    bool isBigGame = false,
  }) {
    // Big Game: all workers are used, no selection needed
    if (isBigGame) return currentSteps;

    final preparation = <PreparationEntity>[...currentSteps];

    // Remove base game worker removal steps unconditionally. The interactive
    // selector (via adjustTiles) already defines the exact tile composition
    // for each player — keeping these removal steps would conflict with or
    // duplicate the selector's choices regardless of the preset.
    preparation.removeWhere(
      (step) => step.id.startsWith('setup_remove_worker_1_'),
    );
    preparation.removeWhere(
      (step) => step.id.startsWith('setup_remove_worker_2_'),
    );

    // Remove Tree of Life's per-player 0-0-0-4 addition step. The selector
    // already includes this tile (and enforces min 1 when Tree of Life is
    // active for 2 players), so a separate step is redundant.
    preparation.removeWhere(
      (step) => step.id.startsWith('setup_tree_of_life_add_0004_'),
    );

    // Insert before 'setup_shuffle_workers' so players decide about new
    // worker tiles after taking their base tiles (and any removals for 3p/4p),
    // but before shuffling everything together.
    final shuffleIndex = preparation.indexWhere(
      (step) => step.id == 'setup_shuffle_workers',
    );
    final insertIndex = shuffleIndex >= 0 ? shuffleIndex : preparation.length;

    preparation.insert(
      insertIndex,
      PreparationEntity(
        id: selectionStepId,
        description: 'Select which worker tiles you want to use for this game.',
        phase: PreparationPhase.playerSetup,
      ),
    );

    return preparation;
  }
}
