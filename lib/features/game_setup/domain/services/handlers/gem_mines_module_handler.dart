import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/module_preparation_handler.dart';

class GemMinesModuleHandler implements ModulePreparationHandler {
  static const int moduleId = 5;

  @override
  List<TileModel> adjustTiles(
    List<TileModel> tiles,
    int playerCount, {
    required List<BoardgameModel> activeExpansions,
  }) {
    final result = <TileModel>[...tiles];

    // Remove all temples
    result.removeWhere((tile) => tile.type == TileType.temple);

    // Add gem mines from expansion
    for (final expansion in activeExpansions) {
      for (final tile in expansion.tiles) {
        if (tile.type == TileType.gemMine) {
          if (playerCount == 2) {
            result.add(tile.copyWith(quantity: tile.quantity - 1));
          } else {
            result.add(tile);
          }
        }
      }
    }

    return result;
  }

  @override
  List<PreparationEntity> modifyPreparationSteps(
    List<PlayerEntity> players,
    List<TileModel> tiles,
    List<PreparationEntity> currentSteps,
  ) {
    final preparation = <PreparationEntity>[...currentSteps];

    // For 2 players: remove the base game temple removal step (it only
    // removes 1 temple, but gem mines removes ALL temples).
    if (players.length == 2) {
      preparation.removeWhere(
        (step) => step.id == 'setup_jungle_tiles_2p_removal_temple',
      );
    }

    // Insert visible tile substitution steps before 'setup_jungle_draw_pile'
    final substitutionSteps = _tileSubstitutionSteps(players.length);
    final drawPileIndex = preparation.indexWhere(
      (step) => step.id == 'setup_jungle_draw_pile',
    );
    if (drawPileIndex >= 0) {
      preparation.insertAll(drawPileIndex, substitutionSteps);
    } else {
      preparation.addAll(substitutionSteps);
    }

    // Add gem mine supplies steps
    if (players.length == 2) {
      preparation.add(
        const PreparationEntity(
          id: 'setup_gem_mines_remove_gems',
          description:
              'Remove 8 gems (2 of each color) and put them back into the box.',
          phase: PreparationPhase.supplies,
          imageKey: 'resources_gems',
        ),
      );
    }

    preparation.add(
      PreparationEntity(
        id: 'setup_gem_mines_mine_car',
        description: players.length == 2
            ? 'Fill the remaining gems into the mine car and mix them by shaking. Place the mine car next to the playing area.'
            : 'Fill all 32 gems into the mine car and mix them by shaking. Place the mine car next to the playing area.',
        phase: PreparationPhase.supplies,
        imageKey: 'resources_mine_car',
      ),
    );

    preparation.add(
      PreparationEntity(
        id: 'setup_gem_mines_masks',
        description: players.length == 2
            ? 'Sort the masks (without the value 12 mask) by their values in an ascending, overlapping row as a supply.'
            : 'Sort the 7 masks by their values in an ascending, overlapping row as a supply.',
        phase: PreparationPhase.supplies,
        imageKey: 'resources_masks',
      ),
    );

    preparation.add(
      const PreparationEntity(
        id: 'setup_gem_mines_rule_reminder',
        description:
            'Rule reminder: As soon as a gem mine tile is placed in the jungle display or onto the map board, shake out 6 gems from the mine car and put them on the gem mine tile.',
        phase: PreparationPhase.supplies,
      ),
    );

    return preparation;
  }

  /// Generates visible preparation steps for the gem mines tile substitution.
  List<PreparationEntity> _tileSubstitutionSteps(int playerCount) {
    return [
      const PreparationEntity(
        id: 'setup_gem_mines_remove_temples',
        description: 'Sort out all Temple tiles and put them back in the box',
        imageKey: 'jungle_temple',
        phase: PreparationPhase.boardSetup,
      ),
      PreparationEntity(
        id: 'setup_gem_mines_add_gem_mines',
        description:
            'Add ${playerCount == 2 ? 4 : 5}x Gem Mine tiles to the jungle tiles',
        imageKey: 'jungle_gem_mine',
        phase: PreparationPhase.boardSetup,
      ),
    ];
  }
}
