import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
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

  @override
  List<TileModel> adjustTiles(
    List<TileModel> tiles,
    int playerCount, {
    required List<BoardgameModel> activeExpansions,
  }) {
    // The huts module doesn't modify the tiles of the jungle pile.
    return tiles;
  }

  @override
  List<PreparationEntity> modifyPreparationSteps(
    List<PlayerEntity> players,
    List<TileModel> tiles,
    List<PreparationEntity> currentSteps,
  ) {
    final preparation = <PreparationEntity>[...currentSteps];

    // Find the last step of the boardSetup phase
    int lastBoardSetupIndex = -1;
    for (int i = 0; i < preparation.length; i++) {
      if (preparation[i].phase == PreparationPhase.boardSetup) {
        lastBoardSetupIndex = i;
      }
    }

    // Insert the huts market setup step at the end of boardSetup phase
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
    }

    return preparation;
  }
}
