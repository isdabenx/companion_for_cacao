import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/module_preparation_handler.dart';

/// Handler for the Gem Mines Module (Diamante expansion, Module A).
///
/// Rules:
/// - Replaces temples with gem mine tiles.
/// - Adds gem resources (4 colors) and mask scoring tokens.
/// - 2-player setup removes one temple replacement and high-value mask/gems.
///
/// TODO: Implement temple-to-gem-mine substitution by player count.
/// TODO: Implement gem and mask supply preparation steps.
class GemMinesModuleHandler implements ModulePreparationHandler {
  static const int moduleId = 5;

  @override
  List<TileModel> adjustTiles(List<TileModel> tiles, int playerCount) {
    // TODO: Implement gem mines tile substitutions.
    return tiles;
  }

  @override
  List<PreparationEntity> modifyPreparationSteps(
    List<PlayerEntity> players,
    List<TileModel> tiles,
    List<PreparationEntity> currentSteps,
  ) {
    // TODO: Implement gem mines preparation steps.
    return currentSteps;
  }
}
