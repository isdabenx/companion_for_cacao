import 'package:companion_for_cacao/config/constants/game_constants.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/content/preparation_l10n.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/table_zone.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/preparation_steps.dart';
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
      preparation: _appendMixedStorageNotes(result.tiles, result.preparation),
    );
  }

  /// The jungle tiles each expansion brings (with how many), so we can warn
  /// about the ones a given game doesn't use (if the player stores everything
  /// mixed). Quantities match the physical components.
  static const _jungleExpansions = <(String, List<(TileType, int)>)>[
    (
      'Xocolatl',
      [
        (TileType.watering, 3),
        (TileType.chocolateKitchen, 3),
        (TileType.chocolateMarket, 3),
      ],
    ),
    ('Diamante', [(TileType.gemMine, 5), (TileType.treeOfLife, 3)]),
  ];

  /// Adds, into the jungle card before the shuffle step, a no-check note per
  /// expansion whose jungle tiles are NOT in this game: "if you keep [X]
  /// mixed in, take out [tiles]". Pre-completed so it never blocks progress.
  List<PreparationEntity> _appendMixedStorageNotes(
    List<TileEntity> tiles,
    List<PreparationEntity> preparation,
  ) {
    bool inPlay(TileType type) =>
        tiles.any((t) => t.type == type && t.quantity > 0);

    final notes = <PreparationEntity>[];
    for (final (expansion, expansionTiles) in _jungleExpansions) {
      final unused = expansionTiles.where((t) => !inPlay(t.$1)).toList();
      if (unused.isEmpty) continue;
      final tileNames = unused
          .map((t) => '${t.$2}× ${_jungleTileName(t.$1)}')
          .join(', ');
      notes.add(
        PreparationEntity(
          id: 'setup_jungle_purge_${expansion.toLowerCase()}',
          label: copy.junglePurgeLabel(expansion),
          detail: copy.junglePurgeDetail(expansion, tileNames),
          tableZone: TableZone.box,
          imageKey: 'expansion_cover_${expansion.toLowerCase()}',
          groupId: PreparationGroups.jungle,
          phase: PreparationPhase.boardSetup,
          informational: true,
          isCompleted: true,
          imageStrip: [
            for (final t in unused)
              (imageKey: _jungleImageKey(t.$1), quantity: t.$2),
          ],
        ),
      );
    }
    if (notes.isEmpty) return preparation;

    final result = [...preparation];
    final shuffleIndex = result.indexWhere(
      (s) => s.id == 'setup_jungle_draw_pile',
    );
    result.insertAll(shuffleIndex >= 0 ? shuffleIndex : result.length, notes);
    return result;
  }

  String _jungleTileName(TileType type) => switch (type) {
    TileType.watering => copy.tileWatering,
    TileType.chocolateKitchen => copy.tileChocolateKitchen,
    TileType.chocolateMarket => copy.tileChocolateMarket,
    TileType.gemMine => copy.tileGemMine,
    TileType.treeOfLife => copy.tileTreeOfLife,
    _ => type.name,
  };

  String _jungleImageKey(TileType type) => switch (type) {
    TileType.watering => 'jungle_watering',
    TileType.chocolateKitchen => 'jungle_chocolate_kitchen',
    TileType.chocolateMarket => 'jungle_chocolate_market',
    TileType.gemMine => 'jungle_gem_mine',
    TileType.treeOfLife => 'jungle_tree_of_life',
    _ => '',
  };
}
