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
    final isBigGame = state.isBigGame;

    var tiles = baseHandler.adjustTiles(
      [],
      state.players.length,
      activeExpansions: state.expansions,
      isBigGame: isBigGame,
    );
    var preparation = baseHandler.modifyPreparationSteps(
      state.players,
      tiles,
      const [],
      isBigGame: isBigGame,
    );

    for (final module in state.modules) {
      final handler = moduleHandlers[module.id];
      if (handler == null) {
        continue;
      }

      // Big Game: base handler already loaded ALL tiles, skip module tile adjustments
      if (!isBigGame) {
        tiles = handler.adjustTiles(
          tiles,
          state.players.length,
          activeExpansions: state.expansions,
        );
      }
      preparation = handler.modifyPreparationSteps(
        state.players,
        tiles,
        preparation,
        isBigGame: isBigGame,
      );
    }

    // Filter out tiles with quantity == 0
    final filteredTiles = tiles.where((t) => t.quantity > 0).toList();

    // Sort tiles by type (huts at the end) and then by name alphabetically
    filteredTiles.sort(TileModel.defaultSort);

    return (tiles: filteredTiles, preparation: preparation);
  }
}
