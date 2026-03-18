import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/module_preparation_handler.dart';

/// Handler for the Huts Module (Chocolatl expansion, Module D).
///
/// Rules:
/// - Adds purchasable huts with ongoing or end-game effects.
/// - Players can own at most one hut of each type.
///
/// TODO: Implement hut market/data setup once hut model exists.
/// TODO: Implement preparation steps to lay out huts by cost/type.
class HutsModuleHandler implements ModulePreparationHandler {
  static const int moduleId = 4;

  @override
  List<TileModel> adjustTiles(List<TileModel> tiles, int playerCount) {
    // TODO: Implement huts module tile adjustments if needed.
    return tiles;
  }

  @override
  List<PreparationEntity> generatePreparation(
    List<PlayerEntity> players,
    List<TileModel> tiles,
  ) {
    // TODO: Implement huts module preparation steps.
    return [];
  }
}
