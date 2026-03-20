import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/module_preparation_handler.dart';

/// Handler for the Tree of Life Module (Diamante expansion, Module B).
///
/// Rules:
/// - Replaces gold mines with tree of life tiles.
/// - Grants gold per adjacent worker or bonus when no workers are adjacent.
///
/// TODO: Implement gold-mine-to-tree substitution by player count.
/// TODO: Implement preparation steps for tree of life tiles.
/// TODO: Respect special interaction with Chocolate module substitutions.
class TreeOfLifeModuleHandler implements ModulePreparationHandler {
  static const int moduleId = 6;

  @override
  List<TileModel> adjustTiles(List<TileModel> tiles, int playerCount) {
    // TODO: Implement tree of life tile substitutions.
    return tiles;
  }

  @override
  List<PreparationEntity> modifyPreparationSteps(
    List<PlayerEntity> players,
    List<TileModel> tiles,
    List<PreparationEntity> currentSteps,
  ) {
    // TODO: Implement tree of life preparation steps.
    return currentSteps;
  }
}
