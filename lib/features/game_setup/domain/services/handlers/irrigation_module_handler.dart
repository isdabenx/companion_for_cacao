import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/module_preparation_handler.dart';

/// Handler for the Irrigation Module (Chocolatl expansion, Module B).
///
/// Rules:
/// - Replaces plantation tiles with irrigation tiles.
/// - Action: Move water carrier back to get 4 cacao per space retreated.
/// - Changes initial tile (water instead of market price 2).
///
/// TODO: Implement tile substitution logic:
///   - 4 players: replace 1 single plantation + 2 double plantations.
///   - 2 players: replace 2 double plantations.
/// TODO: Implement preparation steps for irrigation tiles.
/// TODO: Handle initial tile change when irrigation is active.
class IrrigationModuleHandler implements ModulePreparationHandler {
  static const int moduleId = 2;

  @override
  List<TileModel> adjustTiles(List<TileModel> tiles, int playerCount) {
    // TODO: Implement irrigation tile substitutions.
    return tiles;
  }

  @override
  List<PreparationEntity> generatePreparation(
    List<PlayerEntity> players,
    List<TileModel> tiles,
  ) {
    // TODO: Implement irrigation preparation steps.
    return [];
  }
}
