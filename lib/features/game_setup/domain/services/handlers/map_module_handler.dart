import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/module_preparation_handler.dart';

/// Handler for the Map Module (Chocolatl expansion, Module A).
///
/// Rules:
/// - Each player receives 2 map tokens.
/// - Players can choose jungle tiles from a map board instead of only the draw pile.
/// - Unused map tokens are worth 0 gold at game end.
///
/// Preparation steps:
/// - PlayerSetup phase: Each player gets 2 map tiles in a dedicated step.
/// - BoardSetup phase: Set up the map board next to the jungle draw pile and
///   place 4 jungle tiles on the map board (2 on marked spaces, 2 as display).
class MapModuleHandler implements ModulePreparationHandler {
  static const int moduleId = 1;

  @override
  List<TileModel> adjustTiles(
    List<TileModel> tiles,
    int playerCount, {
    required List<BoardgameModel> activeExpansions,
  }) {
    // The map module doesn't modify the tiles of the jungle pile.
    return tiles;
  }

  @override
  List<PreparationEntity> modifyPreparationSteps(
    List<PlayerEntity> players,
    List<TileModel> tiles,
    List<PreparationEntity> currentSteps,
  ) {
    final preparation = <PreparationEntity>[...currentSteps];
    final modifiedSteps = <PreparationEntity>[];

    // First pass: identify where playerSetup phase ends and add player map token steps
    for (int i = 0; i < preparation.length; i++) {
      modifiedSteps.add(preparation[i]);

      // After a player's setup_tiles step, add the map tokens step
      if (preparation[i].phase == PreparationPhase.playerSetup &&
          preparation[i].id.startsWith('setup_tiles_')) {
        final color = preparation[i].color ?? '';
        modifiedSteps.add(
          PreparationEntity(
            id: 'setup_map_tokens_$color',
            description:
                'Player $color gets 2 map tiles. The surplus map tiles are put back into the box.',
            phase: PreparationPhase.playerSetup,
            color: color,
            imagePath: 'assets/images/preparation/map_token.webp',
          ),
        );
      }
    }

    // Second pass: find and replace the setup_jungle_display step in boardSetup
    final finalSteps = <PreparationEntity>[];
    for (int i = 0; i < modifiedSteps.length; i++) {
      if (modifiedSteps[i].id == 'setup_jungle_display' &&
          modifiedSteps[i].phase == PreparationPhase.boardSetup) {
        // Replace with two new steps
        finalSteps.add(
          PreparationEntity(
            id: 'setup_map_board',
            description:
                'Place the map board directly next to the jungle draw pile.',
            phase: PreparationPhase.boardSetup,
          ),
        );
        finalSteps.add(
          PreparationEntity(
            id: 'setup_jungle_display_map',
            description:
                'Draw the 4 top jungle tiles from the jungle draw pile. Lay the first two tiles face up on the marked spaces of the map board. Place the other two tiles as a face-up jungle display next to the map board.',
            phase: PreparationPhase.boardSetup,
          ),
        );
      } else {
        finalSteps.add(modifiedSteps[i]);
      }
    }

    return finalSteps;
  }
}
