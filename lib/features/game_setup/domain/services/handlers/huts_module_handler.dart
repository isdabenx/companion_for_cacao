import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/module_preparation_handler.dart';

/// Handler for the Huts Module (Chocolatl expansion, Module D).
///
/// Rules:
/// - Adds purchasable huts with ongoing or end-game effects.
/// - Players can own at most one hut of each type.
/// - 12 hut tiles are randomly placed and sorted by building cost next to the bank.
class HutsModuleHandler implements ModulePreparationHandler {
  static const int moduleId = 4;

  /// Interactive step where the throw result (face-up side of each of the
  /// 12 hut tiles) can optionally be registered, so the score calculator
  /// knows the exact hut supply of this game.
  static const String layoutStepId = 'setup_huts_register_layout';

  @override
  List<TileEntity> adjustTiles(
    List<TileEntity> tiles,
    int playerCount, {
    required List<BoardgameEntity> activeExpansions,
    bool isBigGame = false,
  }) {
    // Big Game: all tiles already loaded by base handler
    if (isBigGame) return tiles;

    final result = <TileEntity>[...tiles];

    // Add all hut tiles from the expansions
    for (final expansion in activeExpansions) {
      for (final tile in expansion.tiles) {
        if (tile.moduleId == moduleId) {
          result.add(tile);
        }
      }
    }

    return result;
  }

  @override
  List<PreparationEntity> modifyPreparationSteps(
    List<PlayerEntity> players,
    List<TileEntity> tiles,
    List<PreparationEntity> currentSteps, {
    bool isBigGame = false,
  }) {
    final preparation = <PreparationEntity>[...currentSteps];

    // Find the last step of the boardSetup phase
    int lastBoardSetupIndex = -1;
    for (int i = 0; i < preparation.length; i++) {
      if (preparation[i].phase == PreparationPhase.boardSetup) {
        lastBoardSetupIndex = i;
      }
    }

    // Insert the huts market setup step at the end of boardSetup phase,
    // followed by the optional interactive throw-registration step.
    if (lastBoardSetupIndex >= 0) {
      preparation.insert(
        lastBoardSetupIndex + 1,
        PreparationEntity(
          id: 'setup_huts_market',
          description:
              'Take the 12 hut tiles, drop them from a low height to randomly determine their face-up side, and sort them by building cost next to the bank as a supply.\n\nVariant: Alternatively, players can agree on a specific selection of huts instead of a random assortment.',
          phase: PreparationPhase.boardSetup,
        ),
      );
      preparation.insert(
        lastBoardSetupIndex + 2,
        PreparationEntity(
          id: layoutStepId,
          description:
              'Optionally register which side of each hut tile landed face '
              'up. The score calculator will then offer exactly the huts in '
              'play.',
          phase: PreparationPhase.boardSetup,
        ),
      );
    }

    return preparation;
  }
}
