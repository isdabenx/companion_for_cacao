import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/module_preparation_handler.dart';

class EmperorFavorModuleHandler implements ModulePreparationHandler {
  static const int moduleId = 7;

  @override
  List<TileModel> adjustTiles(
    List<TileModel> tiles,
    int playerCount, {
    required List<BoardgameModel> activeExpansions,
    bool isBigGame = false,
  }) {
    return tiles;
  }

  @override
  List<PreparationEntity> modifyPreparationSteps(
    List<PlayerEntity> players,
    List<TileModel> tiles,
    List<PreparationEntity> currentSteps, {
    bool isBigGame = false,
  }) {
    final preparation = <PreparationEntity>[...currentSteps];

    int initialTilesIndex = -1;
    bool isWateringModule = false;

    // Find the initial tiles step and detect if watering module is active
    for (int i = 0; i < preparation.length; i++) {
      if (preparation[i].id == 'setup_initial_tiles_plantation_water') {
        initialTilesIndex = i;
        isWateringModule = true;
        break;
      } else if (preparation[i].id == 'setup_initial_tiles_plantation_market') {
        initialTilesIndex = i;
        isWateringModule = false;
        break;
      }
    }

    final emperorDescription = isWateringModule
        ? 'After laying out the starting tiles, place the Emperor figure on the water tile.'
        : 'After laying out the starting tiles, place the Emperor figure on the market, selling price 2.';

    final emperorStep = PreparationEntity(
      id: 'setup_emperor',
      description: emperorDescription,
      phase: PreparationPhase.boardSetup,
      imageKey: 'emperor_figure',
    );

    if (initialTilesIndex >= 0) {
      preparation.insert(initialTilesIndex + 1, emperorStep);
    } else {
      preparation.add(emperorStep);
    }

    return preparation;
  }
}
