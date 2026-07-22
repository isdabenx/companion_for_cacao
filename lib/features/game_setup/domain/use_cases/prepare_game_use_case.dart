import 'package:companion_for_cacao/config/constants/game_constants.dart';
import 'package:companion_for_cacao/features/game_setup/domain/content/preparation_l10n.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/base_game_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/chocolate_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/huts_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/map_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/watering_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/gem_mines_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/tree_of_life_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/emperor_favor_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/new_workers_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/preparation_pipeline.dart';

class PrepareGameUseCase {
  PrepareGameUseCase({PreparationL10n? l10n})
    : copy = l10n ?? PreparationL10n.en();

  /// Localized step content, injected into every handler so the whole
  /// preparation is generated in the active locale.
  final PreparationL10n copy;

  GameSetupStateEntity execute(GameSetupStateEntity currentSetup) {
    final modules = currentSetup.modules
        .where((m) => currentSetup.expansions.any((e) => e.id == m.boardgameId))
        .toList();
    // A name is optional — a selected player without one is shown by their
    // color (PlayerEntity.displayName), matching the score calculator.
    final players = currentSetup.players.where((p) => p.isSelected).toList();

    final playerColors = players.map((p) => p.color).toSet();
    final filteredColors = AppColors.colors.keys
        .where(playerColors.contains)
        .toList();

    final baseGame = currentSetup.expansions.firstWhere(
      (e) => e.id == GameConstants.baseGameId,
    );

    final pipeline = PreparationPipeline(
      baseHandler: BaseGameHandler(
        baseGame: baseGame,
        activeExpansions: currentSetup.expansions,
        selectedColors: filteredColors,
        l10n: copy,
      ),
      moduleHandlers: {
        MapModuleHandler.moduleId: MapModuleHandler(l10n: copy),
        WateringModuleHandler.moduleId: WateringModuleHandler(l10n: copy),
        ChocolateModuleHandler.moduleId: ChocolateModuleHandler(l10n: copy),
        HutsModuleHandler.moduleId: HutsModuleHandler(l10n: copy),
        GemMinesModuleHandler.moduleId: GemMinesModuleHandler(l10n: copy),
        TreeOfLifeModuleHandler.moduleId: TreeOfLifeModuleHandler(l10n: copy),
        EmperorFavorModuleHandler.moduleId: EmperorFavorModuleHandler(),
        NewWorkersModuleHandler.moduleId: NewWorkersModuleHandler(
          workerSelection: currentSetup.workerSelection,
          l10n: copy,
        ),
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
