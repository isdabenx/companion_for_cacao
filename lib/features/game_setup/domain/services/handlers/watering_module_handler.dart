import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/module_preparation_handler.dart';

/// Constants for watering module tile IDs.
class _WateringTileIds {
  _WateringTileIds._();

  // Plantation tiles to be removed
  static const String singlePlantation = 'base.jungle_single_plantation';
  static const String doublePlantation = 'base.jungle_double_plantation';

  // Watering tiles to be added
}

/// Handler for the Watering Module (Chocolatl expansion, Module B).
///
/// Rules:
/// - Replaces plantation tiles with watering tiles.
/// - Action: Move water carrier back to get 4 cacao per space retreated.
/// - Changes initial tile (water instead of market price 2).
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
        id: 'setup_initial_tiles_plantation_water',
        description:
            'From the jungle tiles, get "single plantation" and "water" tiles and place them face up in the middle of the table diagonally to one another; they form the starting tiles of the playing area',
        color: originalStep.color,
        variables: originalStep.variables,
        imageKey: 'initial_single_plantation_water',
        phase: originalStep.phase,
      );
      preparation[initialTilesIndex] = modifiedStep;
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

  /// Generates visible preparation steps for the watering tile substitution.
  List<PreparationEntity> _tileSubstitutionSteps(int playerCount) {
    if (playerCount == 2) {
      return const [
        PreparationEntity(
          id: 'setup_watering_remove_double_plantation',
          description:
              'Sort out 2x Double Plantation and put them back in the box',
          imageKey: 'jungle_double_plantation',
          phase: PreparationPhase.boardSetup,
        ),
        PreparationEntity(
          id: 'setup_watering_add_watering_tiles',
          description: 'Add 2x Watering tiles to the jungle tiles',
          imageKey: 'jungle_watering',
          phase: PreparationPhase.boardSetup,
        ),
      ];
    } else if (playerCount >= 3) {
      return const [
        PreparationEntity(
          id: 'setup_watering_remove_single_plantation',
          description:
              'Sort out 1x Single Plantation and put it back in the box',
          imageKey: 'jungle_single_plantation',
          phase: PreparationPhase.boardSetup,
        ),
        PreparationEntity(
          id: 'setup_watering_remove_double_plantation',
          description:
              'Sort out 2x Double Plantation and put them back in the box',
          imageKey: 'jungle_double_plantation',
          phase: PreparationPhase.boardSetup,
        ),
        PreparationEntity(
          id: 'setup_watering_add_watering_tiles',
          description: 'Add 3x Watering tiles to the jungle tiles',
          imageKey: 'jungle_watering',
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
        if (tile.moduleId == moduleId) {
          wateringTileDef = tile;
          break;
        }
      }
      if (wateringTileDef != null) break;
    }

    // Find watering tile in the list and increase its quantity
    bool wateringFound = false;
    for (int i = 0; i < result.length; i++) {
      if (result[i].id == wateringTileDef?.id) {
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
