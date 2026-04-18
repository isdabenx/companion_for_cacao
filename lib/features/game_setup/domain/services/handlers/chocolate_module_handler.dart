import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/module_preparation_handler.dart';

/// Constants for chocolate module tile IDs.
class _ChocolateTileIds {
  _ChocolateTileIds._();

  // Jungle tiles to be removed
  static const String goldMineValue1 = 'base.jungle_gold_mine_value_1';
  static const String goldMineValue2 = 'base.jungle_gold_mine_value_2';
  static const String marketSelling3 = 'base.jungle_market_selling_3';

  // Chocolate tiles to be added
}

/// Handler for the Chocolate Module (Chocolatl expansion, Module C).
///
/// Rules:
/// - Introduces chocolate kitchens and chocolate markets.
/// - Kitchens convert cacao into chocolate.
/// - Chocolate markets sell cacao for 3 gold or chocolate for 7 gold.
/// - 2 players: Remove 1 gold mine value 2, 1 gold mine value 1, 2 markets selling 3. Add 2 chocolate kitchens, 2 chocolate markets.
/// - 3+ players: Remove 3 gold mines (any combination), 3 markets selling 3. Add 3 chocolate kitchens, 3 chocolate markets.
///
/// TODO: Handle interaction rules with Tree of Life module.
class ChocolateModuleHandler implements ModulePreparationHandler {
  static const int moduleId = 3;

  @override
  List<TileModel> adjustTiles(
    List<TileModel> tiles,
    int playerCount, {
    required List<BoardgameModel> activeExpansions,
    bool isBigGame = false,
  }) {
    // Big Game: all tiles already loaded by base handler
    if (isBigGame) return tiles;

    var adjustedTiles = <TileModel>[...tiles];

    if (playerCount == 2) {
      // 2 players: remove 1 gold mine value 1 and 1 gold mine value 2
      adjustedTiles = _reduceJungleTileById(
        adjustedTiles,
        id: _ChocolateTileIds.goldMineValue1,
        amount: 1,
      );
      adjustedTiles = _reduceJungleTileById(
        adjustedTiles,
        id: _ChocolateTileIds.goldMineValue2,
        amount: 1,
      );
      // Remove 2 markets with selling price 3
      adjustedTiles = _reduceJungleTileById(
        adjustedTiles,
        id: _ChocolateTileIds.marketSelling3,
        amount: 2,
      );

      // Add 2 of each chocolate module tile
      adjustedTiles = _addChocolateTiles(
        adjustedTiles,
        quantityToAdd: 2,
        activeExpansions: activeExpansions,
      );
    } else if (playerCount >= 3) {
      // 3+ players: remove 3 gold mines and 3 markets selling 3
      // Remove 2 value 1 and 1 value 2 gold mines
      adjustedTiles = _reduceJungleTileById(
        adjustedTiles,
        id: _ChocolateTileIds.goldMineValue1,
        amount: 2,
      );
      adjustedTiles = _reduceJungleTileById(
        adjustedTiles,
        id: _ChocolateTileIds.goldMineValue2,
        amount: 1,
      );
      // Remove 3 markets with selling price 3
      adjustedTiles = _reduceJungleTileById(
        adjustedTiles,
        id: _ChocolateTileIds.marketSelling3,
        amount: 3,
      );

      // Add 3 of each chocolate module tile
      adjustedTiles = _addChocolateTiles(
        adjustedTiles,
        quantityToAdd: 3,
        activeExpansions: activeExpansions,
      );
    }

    return adjustedTiles;
  }

  @override
  List<PreparationEntity> modifyPreparationSteps(
    List<PlayerEntity> players,
    List<TileModel> tiles,
    List<PreparationEntity> currentSteps, {
    bool isBigGame = false,
  }) {
    final preparation = <PreparationEntity>[...currentSteps];

    // Find and modify the setup_resources_bank step to add chocolate bars
    // (applies to both normal and Big Game — always need chocolate supplies)
    int resourceBankIndex = -1;
    for (int i = 0; i < preparation.length; i++) {
      if (preparation[i].id == 'setup_resources_bank') {
        resourceBankIndex = i;
        break;
      }
    }

    if (resourceBankIndex >= 0) {
      preparation.insert(
        resourceBankIndex + 1,
        const PreparationEntity(
          id: 'setup_chocolate_bars',
          description:
              'Lay out the 20 chocolate bars as a separate supply pile next to the cacao fruits.',
          phase: PreparationPhase.supplies,
          imageKey: 'resources_chocolate',
        ),
      );
    }

    // Big Game: skip tile substitution steps (all tiles already in the pool)
    if (isBigGame) return preparation;

    // For 2 players: modify existing base game removal steps to reflect
    // the combined total (base + chocolate module removals).
    if (players.length == 2) {
      _modifyBaseStepsFor2Players(preparation);
    }

    // Insert visible tile substitution steps before 'setup_jungle_draw_pile'
    final substitutionSteps = _tileSubstitutionSteps(players.length);
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

    return preparation;
  }

  /// For 2 players, modifies existing base game removal steps to reflect
  /// the combined removal total (base removals + chocolate module removals).
  ///
  /// Base game 2p removes: 1x Gold Mine v1 + 1x Market selling 3.
  /// Chocolate 2p removes: 1x Gold Mine v1 + 1x Gold Mine v2 + 2x Market selling 3.
  /// Combined: 2x Gold Mine v1 + 1x Gold Mine v2 + 3x Market selling 3.
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
      } else if (step.id == 'setup_jungle_tiles_2p_removal_market_selling_3') {
        preparation[i] = PreparationEntity(
          id: step.id,
          description:
              'Sort out 3x Market, selling price 3 and put them back in the box',
          imageKey: step.imageKey,
          phase: step.phase,
        );
      }
    }
  }

  /// Generates visible preparation steps for the chocolate tile substitution.
  ///
  /// For 2 players: gold mine v1 and market selling 3 are already handled by
  /// modifying the base game steps. Only gold mine v2 removal and chocolate
  /// tile additions need new steps.
  ///
  /// For 3+ players: all removal and addition steps are new.
  List<PreparationEntity> _tileSubstitutionSteps(int playerCount) {
    if (playerCount == 2) {
      return const [
        PreparationEntity(
          id: 'setup_chocolate_remove_gold_mine_v2',
          description:
              'Sort out 1x Gold Mine, value 2 and put it back in the box',
          imageKey: 'jungle_gold_mine_v2',
          phase: PreparationPhase.boardSetup,
        ),
        PreparationEntity(
          id: 'setup_chocolate_add_kitchen',
          description: 'Add 2x Chocolate Kitchen tiles to the jungle tiles',
          imageKey: 'jungle_chocolate_kitchen',
          phase: PreparationPhase.boardSetup,
        ),
        PreparationEntity(
          id: 'setup_chocolate_add_market',
          description: 'Add 2x Chocolate Market tiles to the jungle tiles',
          imageKey: 'jungle_chocolate_market',
          phase: PreparationPhase.boardSetup,
        ),
      ];
    } else if (playerCount >= 3) {
      return const [
        PreparationEntity(
          id: 'setup_chocolate_remove_gold_mine_v1',
          description:
              'Sort out 2x Gold Mine, value 1 and put them back in the box',
          imageKey: 'jungle_gold_mine_v1',
          phase: PreparationPhase.boardSetup,
        ),
        PreparationEntity(
          id: 'setup_chocolate_remove_gold_mine_v2',
          description:
              'Sort out 1x Gold Mine, value 2 and put it back in the box',
          imageKey: 'jungle_gold_mine_v2',
          phase: PreparationPhase.boardSetup,
        ),
        PreparationEntity(
          id: 'setup_chocolate_remove_market_selling_3',
          description:
              'Sort out 3x Market, selling price 3 and put them back in the box',
          imageKey: 'jungle_market_selling_3',
          phase: PreparationPhase.boardSetup,
        ),
        PreparationEntity(
          id: 'setup_chocolate_add_kitchen',
          description: 'Add 3x Chocolate Kitchen tiles to the jungle tiles',
          imageKey: 'jungle_chocolate_kitchen',
          phase: PreparationPhase.boardSetup,
        ),
        PreparationEntity(
          id: 'setup_chocolate_add_market',
          description: 'Add 3x Chocolate Market tiles to the jungle tiles',
          imageKey: 'jungle_chocolate_market',
          phase: PreparationPhase.boardSetup,
        ),
      ];
    }
    return const [];
  }

  /// Reduces a jungle tile by the specified amount.
  List<TileModel> _reduceJungleTileById(
    List<TileModel> tiles, {
    required String id,
    required int amount,
  }) {
    var remaining = amount;

    return tiles.map((tile) {
      if (remaining == 0 || tile.id != id) {
        return tile;
      }

      final reduction = tile.quantity >= remaining ? remaining : tile.quantity;
      remaining -= reduction;

      return tile.copyWith(quantity: tile.quantity - reduction);
    }).toList();
  }

  /// Adds chocolate tiles to the tile list.
  /// If tiles don't exist in the list, creates them from expansion definitions.
  List<TileModel> _addChocolateTiles(
    List<TileModel> tiles, {
    required int quantityToAdd,
    required List<BoardgameModel> activeExpansions,
  }) {
    final result = <TileModel>[...tiles];

    // Find all chocolate module tiles from expansion definitions
    final chocolateTilesDefs = <TileModel>[];
    for (final expansion in activeExpansions) {
      for (final tile in expansion.tiles) {
        if (tile.moduleId == moduleId) {
          chocolateTilesDefs.add(tile);
        }
      }
    }

    // Update quantities for each tile found
    for (final tileDef in chocolateTilesDefs) {
      bool found = false;
      for (int i = 0; i < result.length; i++) {
        if (result[i].id == tileDef.id) {
          result[i] = result[i].copyWith(
            quantity: result[i].quantity + quantityToAdd,
          );
          found = true;
          break;
        }
      }

      if (!found) {
        result.add(tileDef.copyWith(quantity: quantityToAdd));
      }
    }

    return result;
  }
}
