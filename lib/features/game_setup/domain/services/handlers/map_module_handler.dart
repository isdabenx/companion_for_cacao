import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/module_preparation_handler.dart';

/// Handler for the Map Module (Chocolatl expansion, Module A).
///
/// Rules:
/// - Each player receives 2 map tokens.
/// - Players can choose jungle tiles from a map board instead of only the draw pile.
/// - Unused map tokens are worth 0 gold at game end.
///
/// TODO: Implement map token setup steps.
/// TODO: Implement map board initialization and tile selection flow.
class MapModuleHandler implements ModulePreparationHandler {
  static const int moduleId = 1;

  @override
  List<TileModel> adjustTiles(List<TileModel> tiles, int playerCount) {
    // TODO: Implement map module tile adjustments.
    return tiles;
  }

  @override
  List<PreparationEntity> modifyPreparationSteps(
    List<PlayerEntity> players,
    List<TileModel> tiles,
    List<PreparationEntity> currentSteps,
  ) {
    // TODO: Implement map module preparation steps.
    return currentSteps;
  }
}
