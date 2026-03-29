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
  static const String chocolateKitchen = 'chocolatl.jungle_chocolate_kitchen';
  static const String chocolateMarket = 'chocolatl.jungle_chocolate_market';
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
  }) {
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

      // Add 2 chocolate kitchens and 2 chocolate markets
      adjustedTiles = _addChocolateTiles(
        adjustedTiles,
        chocolateKitchens: 2,
        chocolateMarkets: 2,
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

      // Add 3 chocolate kitchens and 3 chocolate markets
      adjustedTiles = _addChocolateTiles(
        adjustedTiles,
        chocolateKitchens: 3,
        chocolateMarkets: 3,
        activeExpansions: activeExpansions,
      );
    }

    return adjustedTiles;
  }

  @override
  List<PreparationEntity> modifyPreparationSteps(
    List<PlayerEntity> players,
    List<TileModel> tiles,
    List<PreparationEntity> currentSteps,
  ) {
    final preparation = <PreparationEntity>[...currentSteps];

    // Find and modify the setup_resources_bank step
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

    return preparation;
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
    required int chocolateKitchens,
    required int chocolateMarkets,
    required List<BoardgameModel> activeExpansions,
  }) {
    final result = <TileModel>[...tiles];

    // Find chocolate kitchen tile from expansion definitions
    TileModel? chocolateKitchenTile;
    TileModel? chocolateMarketTile;

    for (final expansion in activeExpansions) {
      for (final tile in expansion.tiles) {
        if (tile.id == _ChocolateTileIds.chocolateKitchen) {
          chocolateKitchenTile = tile;
        } else if (tile.id == _ChocolateTileIds.chocolateMarket) {
          chocolateMarketTile = tile;
        }
      }
    }

    // Update kitchen tiles: increment if exists, add if doesn't
    bool kitchenFound = false;
    for (int i = 0; i < result.length; i++) {
      if (result[i].id == _ChocolateTileIds.chocolateKitchen) {
        result[i] = result[i].copyWith(
          quantity: result[i].quantity + chocolateKitchens,
        );
        kitchenFound = true;
        break;
      }
    }
    if (!kitchenFound && chocolateKitchenTile != null) {
      result.add(chocolateKitchenTile.copyWith(quantity: chocolateKitchens));
    }

    // Update market tiles: increment if exists, add if doesn't
    bool marketFound = false;
    for (int i = 0; i < result.length; i++) {
      if (result[i].id == _ChocolateTileIds.chocolateMarket) {
        result[i] = result[i].copyWith(
          quantity: result[i].quantity + chocolateMarkets,
        );
        marketFound = true;
        break;
      }
    }
    if (!marketFound && chocolateMarketTile != null) {
      result.add(chocolateMarketTile.copyWith(quantity: chocolateMarkets));
    }

    return result;
  }
}
