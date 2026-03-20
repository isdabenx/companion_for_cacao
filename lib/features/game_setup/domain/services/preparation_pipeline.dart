import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/base_game_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/module_preparation_handler.dart';

class PreparationPipeline {
  PreparationPipeline({
    required this.baseHandler,
    this.moduleHandlers = const {},
  });

  final BaseGameHandler baseHandler;

  /// Map of moduleId -> handler. Expansion handlers registered here.
  final Map<int, ModulePreparationHandler> moduleHandlers;

  /// Executes the full preparation pipeline.
  /// Returns a record with the final tiles and preparation steps.
  ({List<TileModel> tiles, List<PreparationEntity> preparation}) execute(
    GameSetupStateEntity state,
  ) {
    var tiles = baseHandler.adjustTiles([], state.players.length);
    var preparation = baseHandler.modifyPreparationSteps(
      state.players,
      tiles,
      const [],
    );

    for (final module in state.modules) {
      final handler = moduleHandlers[module.id];
      if (handler == null) {
        continue;
      }

      tiles = handler.adjustTiles(tiles, state.players.length);
      preparation = handler.modifyPreparationSteps(
        state.players,
        tiles,
        preparation,
      );
    }

    return (tiles: tiles, preparation: preparation);
  }
}
