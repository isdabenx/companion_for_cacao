import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/module_preparation_handler.dart';

/// Handler for the Chocolate Module (Chocolatl expansion, Module C).
///
/// Rules:
/// - Introduces chocolate kitchens and chocolate markets.
/// - Kitchens convert cacao into chocolate.
/// - Chocolate markets sell cacao for 3 gold or chocolate for 7 gold.
///
/// TODO: Implement jungle tile substitutions for chocolate kitchens/markets.
/// TODO: Implement preparation steps for chocolate resource setup.
/// TODO: Handle interaction rules with Tree of Life module.
class ChocolateModuleHandler implements ModulePreparationHandler {
  static const int moduleId = 3;

  @override
  List<TileModel> adjustTiles(List<TileModel> tiles, int playerCount) {
    // TODO: Implement chocolate module tile substitutions.
    return tiles;
  }

  @override
  List<PreparationEntity> generatePreparation(
    List<PlayerEntity> players,
    List<TileModel> tiles,
  ) {
    // TODO: Implement chocolate module preparation steps.
    return [];
  }
}
