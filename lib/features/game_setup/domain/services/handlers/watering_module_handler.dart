import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/content/preparation_l10n.dart';
import 'package:companion_for_cacao/core/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/module_preparation_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/preparation_steps.dart';
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

  WateringModuleHandler({PreparationL10n? l10n})
    : copy = l10n ?? PreparationL10n.en();

  /// Localized step content; defaults to English so tests need no wiring.
  final PreparationL10n copy;

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
      // copyWith keeps the structured fields (actor, zone...) of the
      // base step; only the identity and texts change.
      preparation[initialTilesIndex] = preparation[initialTilesIndex].copyWith(
        id: 'setup_initial_tiles_plantation_water',
        label: copy.initialTilesWaterLabel,
        detail: copy.initialTilesWaterDetail,
        rationale: copy.initialTilesWaterRationale,
        imageKey: 'initial_single_plantation_water',
      );
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
      return [
        PreparationSteps.removal(
          copy: copy,
          id: 'setup_watering_remove_double_plantation',
          quantity: 2,
          tileName: copy.tileDoublePlantation,
          imageKey: 'jungle_double_plantation',
        ),
        PreparationSteps.addition(
          copy: copy,
          id: 'setup_watering_add_watering_tiles',
          quantity: 2,
          tileName: copy.tileWatering,
          imageKey: 'jungle_watering',
        ),
      ];
    } else if (playerCount >= 3) {
      return [
        PreparationSteps.removal(
          copy: copy,
          id: 'setup_watering_remove_single_plantation',
          quantity: 1,
          tileName: copy.tileSinglePlantation,
          imageKey: 'jungle_single_plantation',
        ),
        PreparationSteps.removal(
          copy: copy,
          id: 'setup_watering_remove_double_plantation',
          quantity: 2,
          tileName: copy.tileDoublePlantation,
          imageKey: 'jungle_double_plantation',
        ),
        PreparationSteps.addition(
          copy: copy,
          id: 'setup_watering_add_watering_tiles',
          quantity: 3,
          tileName: copy.tileWatering,
          imageKey: 'jungle_watering',
        ),
      ];
    }
    return const [];
  }
}
