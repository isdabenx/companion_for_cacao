import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/content/preparation_l10n.dart';
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

  MapModuleHandler({PreparationL10n? l10n})
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

    // First pass: after the generalized "each player takes their tiles" step,
    // add a single "each player takes 2 map tokens" step (actor allPlayers).
    // Runs before the New Workers handler (moduleId 1 < 8), so `setup_tiles`
    // is still present here even when that handler later removes it.
    int lastMapTokenIndex = -1;
    for (int i = 0; i < preparation.length; i++) {
      modifiedSteps.add(preparation[i]);

      if (preparation[i].phase == PreparationPhase.playerSetup &&
          preparation[i].id == 'setup_tiles') {
        modifiedSteps.add(
          PreparationEntity(
            id: 'setup_map_tokens',
            label: copy.mapTokensLabel,
            detail: copy.mapTokensDetailAll,
            actor: PreparationActor.allPlayers,
            tableZone: TableZone.playerArea,
            quantity: 2,
            phase: PreparationPhase.playerSetup,
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
        PreparationEntity(
          id: 'setup_map_tokens_surplus',
          label: copy.mapTokensSurplusLabel,
          detail: copy.mapTokensSurplusDetail,
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
          PreparationEntity(
            id: 'setup_map_board',
            label: copy.mapBoardLabel,
            detail: copy.mapBoardDetail,
            tableZone: TableZone.jungleDisplay,
            groupId: PreparationGroups.jungle,
            phase: PreparationPhase.boardSetup,
            imageKey: 'map_board',
          ),
        );
        finalSteps.add(
          PreparationEntity(
            id: 'setup_jungle_display_map',
            label: copy.jungleDisplayMapLabel,
            detail: copy.jungleDisplayMapDetail,
            tableZone: TableZone.jungleDisplay,
            groupId: PreparationGroups.jungle,
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
