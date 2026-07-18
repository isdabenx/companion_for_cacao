// Shared realistic game fixtures matching tiles.json, plus a pipeline
// runner used by the preparation pipeline integration tests.
// ignore_for_file: lines_longer_than_80_chars
import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/module_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/worker_selection_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/base_game_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/chocolate_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/emperor_favor_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/gem_mines_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/huts_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/map_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/new_workers_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/tree_of_life_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/watering_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/preparation_pipeline.dart';

// =============================================================================
// Helpers: Create realistic game data matching tiles.json
// =============================================================================

/// All base game tiles (boardgameId: 1), colorless (jungle) only.
List<TileModel> baseGameJungleTiles() {
  return [
    // Plantations
    TileModel(
      id: 'base.jungle_single_plantation',
      name: 'Single Plantation',
      description: '',
      filenameImage: 'base/single_plantation.webp',
      quantity: 6,
      type: TileType.plantation,
      boardgameId: 1,
    ),
    TileModel(
      id: 'base.jungle_double_plantation',
      name: 'Double Plantation',
      description: '',
      filenameImage: 'base/double_plantation.webp',
      quantity: 2,
      type: TileType.plantation,
      boardgameId: 1,
    ),
    // Markets
    TileModel(
      id: 'base.jungle_market_selling_2',
      name: 'Selling price 2',
      description: '',
      filenameImage: 'base/selling_price_2.webp',
      quantity: 2,
      type: TileType.market,
      boardgameId: 1,
    ),
    TileModel(
      id: 'base.jungle_market_selling_3',
      name: 'Selling price 3',
      description: '',
      filenameImage: 'base/selling_price_3.webp',
      quantity: 4,
      type: TileType.market,
      boardgameId: 1,
    ),
    TileModel(
      id: 'base.jungle_market_selling_4',
      name: 'Selling price 4',
      description: '',
      filenameImage: 'base/selling_price_4.webp',
      quantity: 1,
      type: TileType.market,
      boardgameId: 1,
    ),
    // Gold Mines
    TileModel(
      id: 'base.jungle_gold_mine_value_1',
      name: 'Value 1',
      description: '',
      filenameImage: 'base/value_1.webp',
      quantity: 2,
      type: TileType.goldMine,
      boardgameId: 1,
    ),
    TileModel(
      id: 'base.jungle_gold_mine_value_2',
      name: 'Value 2',
      description: '',
      filenameImage: 'base/value_2.webp',
      quantity: 2,
      type: TileType.goldMine,
      boardgameId: 1,
    ),
    // Water
    TileModel(
      id: 'base.jungle_water',
      name: 'Water',
      description: '',
      filenameImage: 'base/water.webp',
      quantity: 3,
      type: TileType.water,
      boardgameId: 1,
    ),
    // Sun-Worshiping Site
    TileModel(
      id: 'base.jungle_sun_worshiping_site',
      name: 'Sun-Worshiping Site',
      description: '',
      filenameImage: 'base/sun_worshiping_site.webp',
      quantity: 2,
      type: TileType.sunWorshipingSite,
      boardgameId: 1,
    ),
    // Temple
    TileModel(
      id: 'base.jungle_temple',
      name: 'Temple',
      description: '',
      filenameImage: 'base/temple.webp',
      quantity: 5,
      type: TileType.temple,
      boardgameId: 1,
    ),
  ];
}

/// Worker tiles for a given color (base game, boardgameId: 1).
List<TileModel> baseWorkerTilesForColor(TileColor color) {
  final c = color.name;
  return [
    TileModel(
      id: 'base.worker_${c}_1-1-1-1',
      name: '1-1-1-1',
      description: '',
      filenameImage: 'base/player_${c}_1_1_1_1.webp',
      quantity: 4,
      type: TileType.player,
      color: color,
      boardgameId: 1,
    ),
    TileModel(
      id: 'base.worker_${c}_2-1-0-1',
      name: '2-1-0-1',
      description: '',
      filenameImage: 'base/player_${c}_2_1_0_1.webp',
      quantity: 5,
      type: TileType.player,
      color: color,
      boardgameId: 1,
    ),
    TileModel(
      id: 'base.worker_${c}_3-0-0-1',
      name: '3-0-0-1',
      description: '',
      filenameImage: 'base/player_${c}_3_0_0_1.webp',
      quantity: 1,
      type: TileType.player,
      color: color,
      boardgameId: 1,
    ),
    TileModel(
      id: 'base.worker_${c}_3-1-0-0',
      name: '3-1-0-0',
      description: '',
      filenameImage: 'base/player_${c}_3_1_0_0.webp',
      quantity: 1,
      type: TileType.player,
      color: color,
      boardgameId: 1,
    ),
  ];
}

/// Chocolatl expansion tiles (boardgameId: 2).
List<TileModel> chocolatlExpansionTiles() {
  return [
    // Watering (moduleId: 2)
    TileModel(
      id: 'chocolatl.jungle_watering',
      name: 'Watering',
      description: '',
      filenameImage: 'chocolatl/watering.webp',
      quantity: 3,
      type: TileType.watering,
      boardgameId: 2,
      moduleId: 2,
    ),
    // Chocolate Kitchen (moduleId: 3)
    TileModel(
      id: 'chocolatl.jungle_chocolate_kitchen',
      name: 'Chocolate Kitchen',
      description: '',
      filenameImage: 'chocolatl/chocolate_kitchen.webp',
      quantity: 3,
      type: TileType.chocolateKitchen,
      boardgameId: 2,
      moduleId: 3,
    ),
    // Chocolate Market (moduleId: 3)
    TileModel(
      id: 'chocolatl.jungle_chocolate_market',
      name: 'Chocolate Market',
      description: '',
      filenameImage: 'chocolatl/chocolate_market.webp',
      quantity: 3,
      type: TileType.chocolateMarket,
      boardgameId: 2,
      moduleId: 3,
    ),
    // 12 hut tiles (moduleId: 4)
    TileModel(
      id: 'chocolatl.hut_market_crier',
      name: 'Market Crier',
      description: '',
      filenameImage: 'chocolatl/hut_market_crier.webp',
      quantity: 1,
      type: TileType.hut,
      boardgameId: 2,
      moduleId: 4,
      hutCost: 4,
    ),
    TileModel(
      id: 'chocolatl.hut_hermit',
      name: 'Hermit',
      description: '',
      filenameImage: 'chocolatl/hut_hermit.webp',
      quantity: 1,
      type: TileType.hut,
      boardgameId: 2,
      moduleId: 4,
      hutCost: 6,
    ),
    TileModel(
      id: 'chocolatl.hut_road_worker',
      name: 'Road Worker',
      description: '',
      filenameImage: 'chocolatl/hut_road_worker.webp',
      quantity: 1,
      type: TileType.hut,
      boardgameId: 2,
      moduleId: 4,
      hutCost: 6,
    ),
    TileModel(
      id: 'chocolatl.hut_trader',
      name: 'Trader',
      description: '',
      filenameImage: 'chocolatl/hut_trader.webp',
      quantity: 1,
      type: TileType.hut,
      boardgameId: 2,
      moduleId: 4,
      hutCost: 6,
    ),
    TileModel(
      id: 'chocolatl.hut_farmer',
      name: 'Farmer',
      description: '',
      filenameImage: 'chocolatl/hut_farmer.webp',
      quantity: 1,
      type: TileType.hut,
      boardgameId: 2,
      moduleId: 4,
      hutCost: 8,
    ),
    TileModel(
      id: 'chocolatl.hut_shaman',
      name: 'Shaman',
      description: '',
      filenameImage: 'chocolatl/hut_shaman.webp',
      quantity: 1,
      type: TileType.hut,
      boardgameId: 2,
      moduleId: 4,
      hutCost: 8,
    ),
    TileModel(
      id: 'chocolatl.hut_monk',
      name: 'Monk',
      description: '',
      filenameImage: 'chocolatl/hut_monk.webp',
      quantity: 1,
      type: TileType.hut,
      boardgameId: 2,
      moduleId: 4,
      hutCost: 10,
    ),
    TileModel(
      id: 'chocolatl.hut_master_builder',
      name: 'Master Builder',
      description: '',
      filenameImage: 'chocolatl/hut_master_builder.webp',
      quantity: 1,
      type: TileType.hut,
      boardgameId: 2,
      moduleId: 4,
      hutCost: 10,
    ),
    TileModel(
      id: 'chocolatl.hut_foreman',
      name: 'Foreman',
      description: '',
      filenameImage: 'chocolatl/hut_foreman.webp',
      quantity: 1,
      type: TileType.hut,
      boardgameId: 2,
      moduleId: 4,
      hutCost: 12,
    ),
    TileModel(
      id: 'chocolatl.hut_fountain_master',
      name: 'Fountain Master',
      description: '',
      filenameImage: 'chocolatl/hut_fountain_master.webp',
      quantity: 1,
      type: TileType.hut,
      boardgameId: 2,
      moduleId: 4,
      hutCost: 12,
    ),
    TileModel(
      id: 'chocolatl.hut_chiefs_daughter',
      name: "Chief's Daughter",
      description: '',
      filenameImage: 'chocolatl/hut_chief_s_daughter.webp',
      quantity: 1,
      type: TileType.hut,
      boardgameId: 2,
      moduleId: 4,
      hutCost: 14,
    ),
    TileModel(
      id: 'chocolatl.hut_chiefs_son',
      name: "Chief's Son",
      description: '',
      filenameImage: 'chocolatl/hut_chief_s_son.webp',
      quantity: 1,
      type: TileType.hut,
      boardgameId: 2,
      moduleId: 4,
      hutCost: 16,
    ),
    TileModel(
      id: 'chocolatl.hut_chiefs_wife',
      name: "Chief's Wife",
      description: '',
      filenameImage: 'chocolatl/hut_chief_s_wife.webp',
      quantity: 1,
      type: TileType.hut,
      boardgameId: 2,
      moduleId: 4,
      hutCost: 20,
    ),
    TileModel(
      id: 'chocolatl.hut_chief',
      name: 'Chief',
      description: '',
      filenameImage: 'chocolatl/hut_chief.webp',
      quantity: 1,
      type: TileType.hut,
      boardgameId: 2,
      moduleId: 4,
      hutCost: 24,
    ),
  ];
}

/// Diamante expansion tiles (boardgameId: 3) — colorless.
List<TileModel> diamanteExpansionColorlessTiles() {
  return [
    TileModel(
      id: 'diamante.jungle_gem_mine',
      name: 'Gem Mine',
      description: '',
      filenameImage: 'diamante/gem_mine.webp',
      quantity: 5,
      type: TileType.gemMine,
      boardgameId: 3,
      moduleId: 5,
    ),
    TileModel(
      id: 'diamante.jungle_tree_of_life',
      name: 'Tree of Life',
      description: '',
      filenameImage: 'diamante/tree_of_life.webp',
      quantity: 3,
      type: TileType.treeOfLife,
      boardgameId: 3,
      moduleId: 6,
    ),
  ];
}

/// Diamante expansion worker tiles for a color (boardgameId: 3, moduleId: 8).
List<TileModel> diamanteWorkerTilesForColor(TileColor color) {
  final c = color.name;
  return [
    TileModel(
      id: 'diamante.worker_${c}_0-0-0-4',
      name: '0-0-0-4',
      description: '',
      filenameImage: 'diamante/player_${c}_0_0_0_4.webp',
      quantity: 1,
      type: TileType.player,
      color: color,
      boardgameId: 3,
      moduleId: 8,
    ),
    TileModel(
      id: 'diamante.worker_${c}_0-0-2-2',
      name: '0-0-2-2',
      description: '',
      filenameImage: 'diamante/player_${c}_0_0_2_2.webp',
      quantity: 1,
      type: TileType.player,
      color: color,
      boardgameId: 3,
      moduleId: 8,
    ),
    TileModel(
      id: 'diamante.worker_${c}_0-2-0-2',
      name: '0-2-0-2',
      description: '',
      filenameImage: 'diamante/player_${c}_0_2_0_2.webp',
      quantity: 1,
      type: TileType.player,
      color: color,
      boardgameId: 3,
      moduleId: 8,
    ),
    TileModel(
      id: 'diamante.worker_${c}_0-1-0-3',
      name: '0-1-0-3',
      description: '',
      filenameImage: 'diamante/player_${c}_0_1_0_3.webp',
      quantity: 1,
      type: TileType.player,
      color: color,
      boardgameId: 3,
      moduleId: 8,
    ),
  ];
}

// =============================================================================
// Helpers: BoardgameModels with modules and tiles
// =============================================================================

final mapModule = ModuleModel(
  id: 1,
  name: 'Map',
  description: '',
  boardgameId: 2,
);
final wateringModule = ModuleModel(
  id: 2,
  name: 'Watering',
  description: '',
  boardgameId: 2,
);
final chocolateModule = ModuleModel(
  id: 3,
  name: 'Chocolate',
  description: '',
  boardgameId: 2,
);
final hutModule = ModuleModel(
  id: 4,
  name: 'Huts',
  description: '',
  boardgameId: 2,
);
final gemMinesModule = ModuleModel(
  id: 5,
  name: 'Gem Mines',
  description: '',
  boardgameId: 3,
);
final treeOfLifeModule = ModuleModel(
  id: 6,
  name: 'Tree of Life',
  description: '',
  boardgameId: 3,
);
final emperorModule = ModuleModel(
  id: 7,
  name: 'Emperor Favour',
  description: '',
  boardgameId: 2,
);
final newWorkersModule = ModuleModel(
  id: 8,
  name: 'New Workers',
  description: '',
  boardgameId: 3,
);

BoardgameModel createBaseGame(List<String> selectedColors) {
  final tiles = <TileModel>[
    ...baseGameJungleTiles(),
    for (final color in selectedColors)
      ...baseWorkerTilesForColor(
        TileColor.values.firstWhere((c) => c.name == color),
      ),
  ];
  return BoardgameModel(
    id: 1,
    name: 'Cacao',
    description: '',
    filenameImage: 'cacao.webp',
    tiles: tiles,
  );
}

BoardgameModel createChocolatlExpansion({
  required List<String> selectedColors,
  required List<ModuleModel> modules,
}) {
  return BoardgameModel(
    id: 2,
    name: 'Chocolatl',
    description: '',
    filenameImage: 'chocolatl.webp',
    modules: modules,
    tiles: chocolatlExpansionTiles(),
  );
}

BoardgameModel createDiamanteExpansion({
  required List<String> selectedColors,
  required List<ModuleModel> modules,
}) {
  final tiles = <TileModel>[
    ...diamanteExpansionColorlessTiles(),
    for (final color in selectedColors)
      ...diamanteWorkerTilesForColor(
        TileColor.values.firstWhere((c) => c.name == color),
      ),
  ];
  return BoardgameModel(
    id: 3,
    name: 'Diamante',
    description: '',
    filenameImage: 'diamante.webp',
    modules: modules,
    tiles: tiles,
  );
}

// =============================================================================
// Pipeline builder
// =============================================================================

({List<TileModel> tiles, List<String> stepIds}) runPipeline({
  required List<PlayerEntity> players,
  required List<String> selectedColors,
  required List<ModuleModel> activeModules,
  List<BoardgameModel>? expansions,
  bool isBigGame = false,
  WorkerSelectionEntity? workerSelection,
}) {
  final baseGame = createBaseGame(selectedColors);

  final chocolatlModules = activeModules
      .where((m) => m.boardgameId == 2)
      .toList();
  final diamanteModules = activeModules
      .where((m) => m.boardgameId == 3)
      .toList();

  final activeExpansions = <BoardgameModel>[baseGame];
  if (chocolatlModules.isNotEmpty) {
    activeExpansions.add(
      createChocolatlExpansion(
        selectedColors: selectedColors,
        modules: chocolatlModules,
      ),
    );
  }
  if (diamanteModules.isNotEmpty) {
    activeExpansions.add(
      createDiamanteExpansion(
        selectedColors: selectedColors,
        modules: diamanteModules,
      ),
    );
  }

  // Merge any additional expansions not built from modules
  if (expansions != null) {
    for (final exp in expansions) {
      if (!activeExpansions.any((e) => e.id == exp.id)) {
        activeExpansions.add(exp);
      }
    }
  }

  final baseHandler = BaseGameHandler(
    baseGame: baseGame,
    activeExpansions: activeExpansions,
    selectedColors: selectedColors,
  );

  final moduleHandlers = <int, dynamic>{};
  for (final m in activeModules) {
    switch (m.id) {
      case 1:
        moduleHandlers[1] = MapModuleHandler();
      case 2:
        moduleHandlers[2] = WateringModuleHandler();
      case 3:
        moduleHandlers[3] = ChocolateModuleHandler();
      case 4:
        moduleHandlers[4] = HutsModuleHandler();
      case 5:
        moduleHandlers[5] = GemMinesModuleHandler();
      case 6:
        moduleHandlers[6] = TreeOfLifeModuleHandler();
      case 7:
        moduleHandlers[7] = EmperorFavorModuleHandler();
      case 8:
        moduleHandlers[8] = NewWorkersModuleHandler(
          workerSelection: workerSelection,
        );
    }
  }

  final pipeline = PreparationPipeline(
    baseHandler: baseHandler,
    moduleHandlers: moduleHandlers.cast(),
  );

  final state = GameSetupStateEntity(
    players: players,
    expansions: activeExpansions,
    modules: activeModules,
    isBigGame: isBigGame,
  );

  final result = pipeline.execute(state);
  final stepIds = result.preparation.map((s) => s.id).toList();

  return (tiles: result.tiles, stepIds: stepIds);
}

// =============================================================================
// Player helpers
// =============================================================================

List<PlayerEntity> makePlayers(int count) {
  const colors = ['red', 'purple', 'white', 'yellow'];
  return List.generate(
    count,
    (i) => PlayerEntity(name: 'P${i + 1}', color: colors[i]),
  );
}

List<String> selectedColors(int count) {
  const colors = ['red', 'purple', 'white', 'yellow'];
  return colors.sublist(0, count);
}

// =============================================================================
// Tile query helpers
// =============================================================================

int tileQty(List<TileModel> tiles, String id) {
  final matches = tiles.where((t) => t.id == id);
  if (matches.isEmpty) return 0;
  return matches.fold(0, (sum, t) => sum + t.quantity);
}

bool hasStep(List<String> stepIds, String id) => stepIds.contains(id);

int stepIndex(List<String> stepIds, String id) => stepIds.indexOf(id);

bool hasAnyStepMatching(
  List<String> stepIds,
  bool Function(String) predicate,
) => stepIds.any(predicate);
