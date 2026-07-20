import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/content/preparation_copy.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_actor.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/table_zone.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/module_preparation_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/preparation_steps.dart';

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
  List<TileEntity> adjustTiles(
    List<TileEntity> tiles,
    int playerCount, {
    required List<BoardgameEntity> activeExpansions,
    bool isBigGame = false,
  }) {
    // The map module doesn't modify the tiles of the jungle pile.
    return tiles;
  }

  @override
  List<PreparationEntity> modifyPreparationSteps(
    List<PlayerEntity> players,
    List<TileEntity> tiles,
    List<PreparationEntity> currentSteps, {
    bool isBigGame = false,
  }) {
    final preparation = <PreparationEntity>[...currentSteps];
    final modifiedSteps = <PreparationEntity>[];

    // First pass: identify where playerSetup phase ends and add player map token steps
    int lastMapTokenIndex = -1;
    for (int i = 0; i < preparation.length; i++) {
      modifiedSteps.add(preparation[i]);

      // After a player's setup_tiles step, add the map tokens step
      if (preparation[i].phase == PreparationPhase.playerSetup &&
          preparation[i].id.startsWith('setup_tiles_')) {
        final color = preparation[i].color ?? '';
        modifiedSteps.add(
          PreparationEntity(
            id: 'setup_map_tokens_$color',
            label: PreparationCopy.mapTokensLabel,
            detail: PreparationCopy.mapTokensDetail(color),
            actor: PreparationActor.player,
            tableZone: TableZone.playerArea,
            groupId: PreparationGroups.player(color),
            quantity: 2,
            phase: PreparationPhase.playerSetup,
            color: color,
            imageKey: 'map_token',
          ),
        );
        lastMapTokenIndex = modifiedSteps.length - 1;
      }
    }

    // Add surplus step only when there are fewer than 4 players (8 tiles / 2 per player)
    if (players.length < 4 && lastMapTokenIndex >= 0) {
      modifiedSteps.insert(
        lastMapTokenIndex + 1,
        const PreparationEntity(
          id: 'setup_map_tokens_surplus',
          label: PreparationCopy.mapTokensSurplusLabel,
          detail: PreparationCopy.mapTokensSurplusDetail,
          tableZone: TableZone.box,
          phase: PreparationPhase.playerSetup,
          imageKey: 'map_token',
        ),
      );
    }

    // Second pass: find and replace the setup_jungle_display step in boardSetup
    final finalSteps = <PreparationEntity>[];
    for (int i = 0; i < modifiedSteps.length; i++) {
      if (modifiedSteps[i].id == 'setup_jungle_display' &&
          modifiedSteps[i].phase == PreparationPhase.boardSetup) {
        // Replace with two new steps
        finalSteps.add(
          const PreparationEntity(
            id: 'setup_map_board',
            label: PreparationCopy.mapBoardLabel,
            detail: PreparationCopy.mapBoardDetail,
            tableZone: TableZone.jungleDisplay,
            phase: PreparationPhase.boardSetup,
            imageKey: 'map_board',
          ),
        );
        finalSteps.add(
          const PreparationEntity(
            id: 'setup_jungle_display_map',
            label: PreparationCopy.jungleDisplayMapLabel,
            detail: PreparationCopy.jungleDisplayMapDetail,
            tableZone: TableZone.jungleDisplay,
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
