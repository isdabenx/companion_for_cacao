import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/module_preparation_handler.dart';

class NewWorkersModuleHandler implements ModulePreparationHandler {
  static const int moduleId = 8;

  @override
  List<TileModel> adjustTiles(
    List<TileModel> tiles,
    int playerCount, {
    required List<BoardgameModel> activeExpansions,
    bool isBigGame = false,
  }) {
    // Big Game: all tiles already loaded by base handler
    if (isBigGame) return tiles;

    // TODO(future): When the interactive worker selection feature is implemented
    // (see DESIGN.md "Mòdul D - Nous Treballadors"), this method should
    // dynamically add/remove tiles based on user selection (presets or manual)
    // instead of adding all new worker tiles by default.
    var result = <TileModel>[...tiles];

    // Get active player colors from existing tiles in the pool
    final playerColors = result
        .where((t) => t.type == TileType.player && t.color != null)
        .map((t) => t.color!)
        .toSet();

    // Collect IDs already in the pool to avoid duplicates
    // (e.g., 0-0-0-4 may already be added by TreeOfLifeModuleHandler for 2p)
    final existingIds = result.map((t) => t.id).toSet();

    // Add all new worker tiles for active player colors
    for (final color in playerColors) {
      for (final expansion in activeExpansions) {
        for (final tile in expansion.tiles) {
          if (tile.moduleId == moduleId &&
              tile.color == color &&
              !existingIds.contains(tile.id)) {
            result.add(tile.copyWith(quantity: 1));
          }
        }
      }
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

    // Insert before 'setup_shuffle_workers' so players decide about new
    // worker tiles after taking their base tiles (and any removals for 3p/4p),
    // but before shuffling everything together.
    final shuffleIndex = preparation.indexWhere(
      (step) => step.id == 'setup_shuffle_workers',
    );
    final insertIndex = shuffleIndex >= 0 ? shuffleIndex : preparation.length;

    final playerCount = players.length;
    final balanceRule = switch (playerCount) {
      2 => '1 to 8',
      3 => '2 to 12',
      _ => '3 to 16',
    };

    preparation.insert(
      insertIndex,
      PreparationEntity(
        id: 'setup_new_workers_selection',
        description:
            'Before starting the game, players can agree on any combination of worker tiles from the basic game and this module in one of two ways:\n\n'
            '1. Replace worker tiles from the base game to create a unique set. All players must take the same tiles, and the number of tiles per player should not be changed.\n'
            '2. Add the new tiles to the base game tiles to create a larger set for a longer game with more overbuilding options.\n\n'
            'Note: If adding tiles, all players must still use the exact same combination. To maintain balance, ensure there are $balanceRule more worker tiles than jungle tiles overall.',
        phase: PreparationPhase.playerSetup,
      ),
    );

    return preparation;
  }
}
