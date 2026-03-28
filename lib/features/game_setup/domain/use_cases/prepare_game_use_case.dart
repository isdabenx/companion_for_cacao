import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/base_game_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/chocolate_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/huts_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/map_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/watering_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/preparation_pipeline.dart';

class PrepareGameUseCase {
  GameSetupStateEntity execute(GameSetupStateEntity currentSetup) {
    final modules = currentSetup.modules
        .where((m) => currentSetup.expansions.any((e) => e.id == m.boardgameId))
        .toList();
    final players = currentSetup.players
        .where((p) => p.isSelected && p.name.isNotEmpty)
        .toList();

    final playerColors = players.map((p) => p.color).toSet();
    final filteredColors = AppColors.colors.keys
        .where(playerColors.contains)
        .toList();

    final baseGame = currentSetup.expansions.firstWhere((e) => e.id == 1);

    final pipeline = PreparationPipeline(
      baseHandler: BaseGameHandler(
        baseGame: baseGame,
        activeExpansions: currentSetup.expansions,
        selectedColors: filteredColors,
      ),
      moduleHandlers: {
        MapModuleHandler.moduleId: MapModuleHandler(),
        WateringModuleHandler.moduleId: WateringModuleHandler(),
        ChocolateModuleHandler.moduleId: ChocolateModuleHandler(),
        HutsModuleHandler.moduleId: HutsModuleHandler(),
      },
    );

    final result = pipeline.execute(
      currentSetup.copyWith(players: players, modules: modules),
    );

    return currentSetup.copyWith(
      players: players,
      modules: modules,
      tiles: result.tiles,
      preparation: result.preparation,
    );
  }
}
