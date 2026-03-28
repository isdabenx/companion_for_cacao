import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/module_preparation_handler.dart';

/// Constants for watering module tile IDs.
class _WateringTileIds {
  _WateringTileIds._();

  // Plantation tiles to be removed
  static const String singlePlantation = 'base.jungle_single_plantation';
  static const String doublePlantation = 'base.jungle_double_plantation';

  // Watering tiles to be added
  static const String wateringTile = 'chocolatl.jungle_watering';
}

/// Handler for the Watering Module (Chocolatl expansion, Module B).
///
/// Rules:
/// - Replaces plantation tiles with watering tiles.
/// - Action: Move water carrier back to get 4 cacao per space retreated.
/// - Changes initial tile (watering instead of market price 2).
///
/// Tile substitution logic:
///   - 3+ players: Remove 1 single plantation + 2 double plantations. Add 3 watering tiles.
///   - 2 players: Remove 2 double plantations. Add 2 watering tiles.
class WateringModuleHandler implements ModulePreparationHandler {
  static const int moduleId = 2;

  @override
  List<TileModel> adjustTiles(
    List<TileModel> tiles,
    int playerCount, {
    required List<BoardgameModel> activeExpansions,
  }) {
    var adjustedTiles = <TileModel>[...tiles];

    if (playerCount == 2) {
      // 2 players: remove 2 double plantations
      adjustedTiles = _reduceJungleTileById(
        adjustedTiles,
        id: _WateringTileIds.doublePlantation,
        amount: 2,
      );

      // Add 2 watering tiles
      adjustedTiles = _addWateringTiles(
        adjustedTiles,
        wateringTiles: 2,
        activeExpansions: activeExpansions,
      );
    } else if (playerCount >= 3) {
      // 3+ players: remove 1 single plantation and 2 double plantations
      adjustedTiles = _reduceJungleTileById(
        adjustedTiles,
        id: _WateringTileIds.singlePlantation,
        amount: 1,
      );
      adjustedTiles = _reduceJungleTileById(
        adjustedTiles,
        id: _WateringTileIds.doublePlantation,
        amount: 2,
      );

      // Add 3 watering tiles
      adjustedTiles = _addWateringTiles(
        adjustedTiles,
        wateringTiles: 3,
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

    // Find and modify the setup_initial_tiles_plantation_market step
    int initialTilesIndex = -1;
    for (int i = 0; i < preparation.length; i++) {
      if (preparation[i].id == 'setup_initial_tiles_plantation_market') {
        initialTilesIndex = i;
        break;
      }
    }

    if (initialTilesIndex >= 0) {
      final originalStep = preparation[initialTilesIndex];
      final modifiedStep = PreparationEntity(
        id: 'setup_initial_tiles_plantation_watering',
        description:
            'From the jungle tiles, get "single plantation" and "watering tile" and place them face up in the middle of the table diagonally to one another; they form the starting tiles of the playing area',
        color: originalStep.color,
        variables: originalStep.variables,
        imagePath: 'assets/images/preparation/initial_tiles_watering.webp',
        phase: originalStep.phase,
      );
      preparation[initialTilesIndex] = modifiedStep;
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

  /// Adds watering tiles to the tile list.
  /// If tiles don't exist in the list, creates them from expansion definitions.
  List<TileModel> _addWateringTiles(
    List<TileModel> tiles, {
    required int wateringTiles,
    required List<BoardgameModel> activeExpansions,
  }) {
    final result = <TileModel>[...tiles];

    // Find watering tile from expansion definitions
    TileModel? wateringTileDef;

    for (final expansion in activeExpansions) {
      for (final tile in expansion.tiles) {
        if (tile.id == _WateringTileIds.wateringTile) {
          wateringTileDef = tile;
          break;
        }
      }
      if (wateringTileDef != null) break;
    }

    // Find watering tile in the list and increase its quantity
    bool wateringFound = false;
    for (int i = 0; i < result.length; i++) {
      if (result[i].id == _WateringTileIds.wateringTile) {
        result[i] = result[i].copyWith(
          quantity: result[i].quantity + wateringTiles,
        );
        wateringFound = true;
        break;
      }
    }

    // If not found in list but definition exists, add it
    if (!wateringFound && wateringTileDef != null) {
      result.add(wateringTileDef.copyWith(quantity: wateringTiles));
    }

    return result;
  }
}
