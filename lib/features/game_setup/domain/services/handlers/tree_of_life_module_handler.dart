import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/chocolate_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/new_workers_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/module_preparation_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/tile_adjustments.dart';

class TreeOfLifeModuleHandler
    with TileAdjustments
    implements ModulePreparationHandler {
  static const int moduleId = 6;

  @override
  List<TileModel> adjustTiles(
    List<TileModel> tiles,
    int playerCount, {
    required List<BoardgameModel> activeExpansions,
    bool isBigGame = false,
  }) {
    // Big Game: all tiles already loaded by base handler, no worker adjustments needed
    if (isBigGame) return tiles;

    var result = <TileModel>[...tiles];

    final isChocolateActive = activeExpansions.any(
      (exp) => exp.modules.any((m) => m.id == ChocolateModuleHandler.moduleId),
    );

    // 1. Handle Jungle Tiles (Gold Mines vs Trees of Life)
    if (!isChocolateActive) {
      if (playerCount == 2) {
        // Remove 1 value-1 gold mine, 1 value-2 gold mine
        result = reduceTileById(
          result,
          id: 'base.jungle_gold_mine_value_1',
          amount: 1,
        );
        result = reduceTileById(
          result,
          id: 'base.jungle_gold_mine_value_2',
          amount: 1,
        );
      } else {
        // Remove all 3 gold mines (2 value-1, 1 value-2)
        result = reduceTileById(
          result,
          id: 'base.jungle_gold_mine_value_1',
          amount: 2,
        );
        result = reduceTileById(
          result,
          id: 'base.jungle_gold_mine_value_2',
          amount: 1,
        );
      }
    }

    // Add Tree of Life tiles
    for (final expansion in activeExpansions) {
      for (final tile in expansion.tiles) {
        if (tile.moduleId == moduleId) {
          if (playerCount == 2) {
            result.add(tile.copyWith(quantity: 2));
          } else {
            result.add(tile);
          }
        }
      }
    }

    // 2. Handle Worker Tiles balance
    final playerColors = result
        .where((t) => t.type == TileType.player && t.color != null)
        .map((t) => t.color!)
        .toSet();

    if (playerCount == 2) {
      // Add 0-0-0-4 worker tile for each player.
      for (final color in playerColors) {
        for (final expansion in activeExpansions) {
          for (final tile in expansion.tiles) {
            if (tile.moduleId == NewWorkersModuleHandler.moduleId &&
                tile.color == color &&
                tile.id.contains('0-0-0-4')) {
              result.add(tile.copyWith(quantity: 1));
              break;
            }
          }
        }
      }
    } else if (playerCount == 3) {
      // Restore 1-1-1-1 for each player (it was removed by base game handler)
      for (final color in playerColors) {
        final targetId = 'base.worker_${color.name}_1-1-1-1';
        for (int i = 0; i < result.length; i++) {
          if (result[i].id == targetId) {
            result[i] = result[i].copyWith(quantity: result[i].quantity + 1);
            break;
          }
        }
      }
    } else if (playerCount == 4) {
      // Restore 2-1-0-1 for each player (it was removed by base game handler)
      for (final color in playerColors) {
        final targetId = 'base.worker_${color.name}_2-1-0-1';
        for (int i = 0; i < result.length; i++) {
          if (result[i].id == targetId) {
            result[i] = result[i].copyWith(quantity: result[i].quantity + 1);
            break;
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
    // Big Game: no tile substitutions, no worker adjustments needed
    // (all tiles and workers already in the pool)
    if (isBigGame) return currentSteps;

    final preparation = <PreparationEntity>[...currentSteps];

    // Detect if Chocolate module is active by checking for chocolate-specific
    // preparation steps (Chocolate handler runs before Tree of Life: moduleId 3 < 6).
    final isChocolateActive = preparation.any(
      (step) => step.id == 'setup_chocolate_bars',
    );

    // Handle gold mine removal steps for 2 players
    if (players.length == 2 && !isChocolateActive) {
      _modifyBaseStepsFor2Players(preparation);
    }

    // Insert visible tile substitution steps before 'setup_jungle_draw_pile'
    final substitutionSteps = _tileSubstitutionSteps(
      players.length,
      isChocolateActive: isChocolateActive,
    );
    if (substitutionSteps.isNotEmpty) {
      final drawPileIndex = preparation.indexWhere(
        (step) => step.id == 'setup_jungle_draw_pile',
      );
      if (drawPileIndex >= 0) {
        preparation.insertAll(drawPileIndex, substitutionSteps);
      } else {
        preparation.addAll(substitutionSteps);
      }
    }

    if (players.length == 2) {
      // For 2 players, we need to add the 0-0-0-4 tile for each player
      // We'll insert it right before the 'setup_shuffle_workers' step
      int shuffleIndex = preparation.indexWhere(
        (step) => step.id == 'setup_shuffle_workers',
      );
      if (shuffleIndex == -1) shuffleIndex = preparation.length;

      final newSteps = players.map((player) {
        final workerTile = tiles
            .where(
              (t) => t.id.contains('0-0-0-4') && t.color?.name == player.color,
            )
            .firstOrNull;
        return PreparationEntity(
          id: 'setup_tree_of_life_add_0004_${player.color}',
          description:
              'Tree of Life Module: Player ${player.color} takes their 0-0-0-4 worker tile from the New Workers Module and adds it to their worker tiles.',
          color: player.color,
          imageKey: workerTile != null
              ? 'tile_${workerTile.filenameImage}'
              : null,
          phase: PreparationPhase.playerSetup,
        );
      }).toList();

      preparation.insertAll(shuffleIndex, newSteps);
    } else if (players.length == 3) {
      // For 3 players, base game says remove 1-1-1-1. Tree of Life says remove NONE.
      // So we delete the removal steps completely.
      preparation.removeWhere(
        (step) => step.id.startsWith('setup_remove_worker_1_'),
      );
    } else if (players.length == 4) {
      // For 4 players, base game says remove 1-1-1-1 AND 2-1-0-1. Tree of Life says remove ONLY 1-1-1-1.
      // So we delete the 2-1-0-1 removal steps.
      preparation.removeWhere(
        (step) => step.id.startsWith('setup_remove_worker_2_'),
      );
    }

    return preparation;
  }

  /// For 2 players (without Chocolate), modifies existing base game removal
  /// steps to reflect the combined total (base + tree of life removals).
  ///
  /// Base game 2p removes: 1x Gold Mine v1.
  /// Tree of Life 2p removes: 1x Gold Mine v1 + 1x Gold Mine v2.
  /// Combined: 2x Gold Mine v1 + 1x Gold Mine v2.
  void _modifyBaseStepsFor2Players(List<PreparationEntity> preparation) {
    for (int i = 0; i < preparation.length; i++) {
      final step = preparation[i];
      if (step.id == 'setup_jungle_tiles_2p_removal_gold_mine_value_1') {
        preparation[i] = PreparationEntity(
          id: step.id,
          description:
              'Sort out 2x Gold Mine, value 1 and put them back in the box',
          imageKey: step.imageKey,
          phase: step.phase,
        );
      }
    }
  }

  /// Generates visible preparation steps for tree of life tile substitution.
  ///
  /// When Chocolate is active, gold mines are already removed by the
  /// Chocolate handler — only tree of life tile additions are needed.
  ///
  /// When Chocolate is NOT active:
  /// - For 2 players: gold mine v1 removal is handled by modifying the base
  ///   game step. Only gold mine v2 removal and tree of life additions are new.
  /// - For 3+ players: all removal and addition steps are new.
  List<PreparationEntity> _tileSubstitutionSteps(
    int playerCount, {
    required bool isChocolateActive,
  }) {
    if (isChocolateActive) {
      // Gold mines already handled by Chocolate handler
      return [
        PreparationEntity(
          id: 'setup_tree_of_life_add_tiles',
          description:
              'Add ${playerCount == 2 ? 2 : 3}x Tree of Life tiles to the jungle tiles',
          imageKey: 'jungle_tree_of_life',
          phase: PreparationPhase.boardSetup,
        ),
      ];
    }

    if (playerCount == 2) {
      // Gold mine v1 handled by _modifyBaseStepsFor2Players (1→2)
      return const [
        PreparationEntity(
          id: 'setup_tree_of_life_remove_gold_mine_v2',
          description:
              'Sort out 1x Gold Mine, value 2 and put it back in the box',
          imageKey: 'jungle_gold_mine_v2',
          phase: PreparationPhase.boardSetup,
        ),
        PreparationEntity(
          id: 'setup_tree_of_life_add_tiles',
          description: 'Add 2x Tree of Life tiles to the jungle tiles',
          imageKey: 'jungle_tree_of_life',
          phase: PreparationPhase.boardSetup,
        ),
      ];
    } else if (playerCount >= 3) {
      return const [
        PreparationEntity(
          id: 'setup_tree_of_life_remove_gold_mine_v1',
          description:
              'Sort out 2x Gold Mine, value 1 and put them back in the box',
          imageKey: 'jungle_gold_mine_v1',
          phase: PreparationPhase.boardSetup,
        ),
        PreparationEntity(
          id: 'setup_tree_of_life_remove_gold_mine_v2',
          description:
              'Sort out 1x Gold Mine, value 2 and put it back in the box',
          imageKey: 'jungle_gold_mine_v2',
          phase: PreparationPhase.boardSetup,
        ),
        PreparationEntity(
          id: 'setup_tree_of_life_add_tiles',
          description: 'Add 3x Tree of Life tiles to the jungle tiles',
          imageKey: 'jungle_tree_of_life',
          phase: PreparationPhase.boardSetup,
        ),
      ];
    }
    return const [];
  }
}
