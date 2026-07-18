import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/module_preparation_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/tile_adjustments.dart';

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
class WateringModuleHandler
    with TileAdjustments
    implements ModulePreparationHandler {
  static const int moduleId = 2;

  @override
  List<TileEntity> adjustTiles(
    List<TileEntity> tiles,
    int playerCount, {
    required List<BoardgameEntity> activeExpansions,
    bool isBigGame = false,
  }) {
    // Big Game: all tiles already loaded by base handler
    if (isBigGame) return tiles;

    var adjustedTiles = <TileEntity>[...tiles];

    if (playerCount == 2) {
      // 2 players: remove 2 double plantations
      adjustedTiles = reduceTileById(
        adjustedTiles,
        id: _WateringTileIds.doublePlantation,
        amount: 2,
      );

      // Add 2 watering tiles
      adjustedTiles = addModuleTiles(
        adjustedTiles,
        moduleId: moduleId,
        quantityEach: 2,
        activeExpansions: activeExpansions,
      );
    } else if (playerCount >= 3) {
      // 3+ players: remove 1 single plantation and 2 double plantations
      adjustedTiles = reduceTileById(
        adjustedTiles,
        id: _WateringTileIds.singlePlantation,
        amount: 1,
      );
      adjustedTiles = reduceTileById(
        adjustedTiles,
        id: _WateringTileIds.doublePlantation,
        amount: 2,
      );

      // Add 3 watering tiles
      adjustedTiles = addModuleTiles(
        adjustedTiles,
        moduleId: moduleId,
        quantityEach: 3,
        activeExpansions: activeExpansions,
      );
    }

    return adjustedTiles;
  }

  @override
  List<PreparationEntity> modifyPreparationSteps(
    List<PlayerEntity> players,
    List<TileEntity> tiles,
    List<PreparationEntity> currentSteps, {
    bool isBigGame = false,
  }) {
    final preparation = <PreparationEntity>[...currentSteps];

    // Find and modify the setup_initial_tiles_plantation_market step
    // (applies to both normal and Big Game — starting tile always changes)
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

    // Big Game: skip tile substitution steps (all tiles already in the pool)
    if (isBigGame) return preparation;

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
}
