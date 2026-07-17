// ignore_for_file: lines_longer_than_80_chars
import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/module_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/worker_selection_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
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
import 'package:flutter_test/flutter_test.dart';

// =============================================================================
// Helpers: Create realistic game data matching tiles.json
// =============================================================================

/// All base game tiles (boardgameId: 1), colorless (jungle) only.
List<TileModel> _baseGameJungleTiles() {
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
List<TileModel> _baseWorkerTilesForColor(TileColor color) {
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
List<TileModel> _chocolatlExpansionTiles() {
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
List<TileModel> _diamanteExpansionColorlessTiles() {
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
List<TileModel> _diamanteWorkerTilesForColor(TileColor color) {
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

final _mapModule = ModuleModel(
  id: 1,
  name: 'Map',
  description: '',
  boardgameId: 2,
);
final _wateringModule = ModuleModel(
  id: 2,
  name: 'Watering',
  description: '',
  boardgameId: 2,
);
final _chocolateModule = ModuleModel(
  id: 3,
  name: 'Chocolate',
  description: '',
  boardgameId: 2,
);
final _hutModule = ModuleModel(
  id: 4,
  name: 'Huts',
  description: '',
  boardgameId: 2,
);
final _gemMinesModule = ModuleModel(
  id: 5,
  name: 'Gem Mines',
  description: '',
  boardgameId: 3,
);
final _treeOfLifeModule = ModuleModel(
  id: 6,
  name: 'Tree of Life',
  description: '',
  boardgameId: 3,
);
final _emperorModule = ModuleModel(
  id: 7,
  name: 'Emperor Favour',
  description: '',
  boardgameId: 2,
);
final _newWorkersModule = ModuleModel(
  id: 8,
  name: 'New Workers',
  description: '',
  boardgameId: 3,
);

BoardgameModel _createBaseGame(List<String> selectedColors) {
  final tiles = <TileModel>[
    ..._baseGameJungleTiles(),
    for (final color in selectedColors)
      ..._baseWorkerTilesForColor(
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

BoardgameModel _createChocolatlExpansion({
  required List<String> selectedColors,
  required List<ModuleModel> modules,
}) {
  return BoardgameModel(
    id: 2,
    name: 'Chocolatl',
    description: '',
    filenameImage: 'chocolatl.webp',
    modules: modules,
    tiles: _chocolatlExpansionTiles(),
  );
}

BoardgameModel _createDiamanteExpansion({
  required List<String> selectedColors,
  required List<ModuleModel> modules,
}) {
  final tiles = <TileModel>[
    ..._diamanteExpansionColorlessTiles(),
    for (final color in selectedColors)
      ..._diamanteWorkerTilesForColor(
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

({List<TileModel> tiles, List<String> stepIds}) _runPipeline({
  required List<PlayerEntity> players,
  required List<String> selectedColors,
  required List<ModuleModel> activeModules,
  List<BoardgameModel>? expansions,
  bool isBigGame = false,
  WorkerSelectionEntity? workerSelection,
}) {
  final baseGame = _createBaseGame(selectedColors);

  final chocolatlModules = activeModules
      .where((m) => m.boardgameId == 2)
      .toList();
  final diamanteModules = activeModules
      .where((m) => m.boardgameId == 3)
      .toList();

  final activeExpansions = <BoardgameModel>[baseGame];
  if (chocolatlModules.isNotEmpty) {
    activeExpansions.add(
      _createChocolatlExpansion(
        selectedColors: selectedColors,
        modules: chocolatlModules,
      ),
    );
  }
  if (diamanteModules.isNotEmpty) {
    activeExpansions.add(
      _createDiamanteExpansion(
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

List<PlayerEntity> _makePlayers(int count) {
  const colors = ['red', 'purple', 'white', 'yellow'];
  return List.generate(
    count,
    (i) => PlayerEntity(name: 'P${i + 1}', color: colors[i]),
  );
}

List<String> _selectedColors(int count) {
  const colors = ['red', 'purple', 'white', 'yellow'];
  return colors.sublist(0, count);
}

// =============================================================================
// Tile query helpers
// =============================================================================

int _tileQty(List<TileModel> tiles, String id) {
  final matches = tiles.where((t) => t.id == id);
  if (matches.isEmpty) return 0;
  return matches.fold(0, (sum, t) => sum + t.quantity);
}

bool _hasStep(List<String> stepIds, String id) => stepIds.contains(id);

int _stepIndex(List<String> stepIds, String id) => stepIds.indexOf(id);

bool _hasAnyStepMatching(
  List<String> stepIds,
  bool Function(String) predicate,
) => stepIds.any(predicate);

// =============================================================================
// Tests
// =============================================================================

void main() {
  // ---------------------------------------------------------------------------
  // GRUP 1: Base Game
  // ---------------------------------------------------------------------------
  group('GRUP 1: Base Game (no modules)', () {
    test('Test 1 — Base, 2 players', () {
      final r = _runPipeline(
        players: _makePlayers(2),
        selectedColors: _selectedColors(2),
        activeModules: [],
      );

      // Player setup: village board, carrier, field, tiles for each player
      expect(_hasStep(r.stepIds, 'setup_village_board_red'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_village_board_purple'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_tiles_red'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_tiles_purple'), isTrue);

      // NO worker removal steps for 2 players
      expect(
        _hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_'),
        ),
        isFalse,
      );

      // Shuffle workers
      expect(_hasStep(r.stepIds, 'setup_shuffle_workers'), isTrue);

      // Starting tiles
      expect(
        _hasStep(r.stepIds, 'setup_initial_tiles_plantation_market'),
        isTrue,
      );

      // 6 sort out jungle tiles steps for 2p
      expect(
        _hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_single_plantation'),
        isTrue,
      );
      expect(
        _hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_market_selling_3'),
        isTrue,
      );
      expect(
        _hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_gold_mine_value_1'),
        isTrue,
      );
      expect(
        _hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_water'),
        isTrue,
      );
      expect(
        _hasStep(
          r.stepIds,
          'setup_jungle_tiles_2p_removal_sun_worshiping_site',
        ),
        isTrue,
      );
      expect(
        _hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_temple'),
        isTrue,
      );

      // Sort outs BEFORE jungle draw pile
      final drawPileIdx = _stepIndex(r.stepIds, 'setup_jungle_draw_pile');
      expect(
        _stepIndex(
          r.stepIds,
          'setup_jungle_tiles_2p_removal_single_plantation',
        ),
        lessThan(drawPileIdx),
      );

      // Jungle draw pile + display
      expect(_hasStep(r.stepIds, 'setup_jungle_draw_pile'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_jungle_display'), isTrue);

      // Supplies
      expect(_hasStep(r.stepIds, 'setup_resources_bank'), isTrue);

      // Tile quantities: 2p reductions applied
      expect(_tileQty(r.tiles, 'base.jungle_single_plantation'), 4); // 6-2
      expect(_tileQty(r.tiles, 'base.jungle_market_selling_3'), 3); // 4-1
      expect(_tileQty(r.tiles, 'base.jungle_gold_mine_value_1'), 1); // 2-1
      expect(_tileQty(r.tiles, 'base.jungle_water'), 2); // 3-1
      expect(_tileQty(r.tiles, 'base.jungle_sun_worshiping_site'), 1); // 2-1
      expect(_tileQty(r.tiles, 'base.jungle_temple'), 4); // 5-1
    });

    test('Test 2 — Base, 3 players', () {
      final r = _runPipeline(
        players: _makePlayers(3),
        selectedColors: _selectedColors(3),
        activeModules: [],
      );

      // Worker removal: 1x 1-1-1-1 per player
      expect(_hasStep(r.stepIds, 'setup_remove_worker_1_red'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_remove_worker_1_purple'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_remove_worker_1_white'), isTrue);

      // NO 2-1-0-1 removal
      expect(
        _hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_2_'),
        ),
        isFalse,
      );

      // NO 2p sort out steps
      expect(
        _hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_jungle_tiles_2p_'),
        ),
        isFalse,
      );

      // Worker quantities: 1-1-1-1 reduced by 1
      expect(_tileQty(r.tiles, 'base.worker_red_1-1-1-1'), 3);
      expect(_tileQty(r.tiles, 'base.worker_purple_1-1-1-1'), 3);
      expect(_tileQty(r.tiles, 'base.worker_white_1-1-1-1'), 3);

      // 2-1-0-1 unchanged
      expect(_tileQty(r.tiles, 'base.worker_red_2-1-0-1'), 5);

      // Jungle tile quantities: full (no 2p reductions)
      expect(_tileQty(r.tiles, 'base.jungle_single_plantation'), 6);
      expect(_tileQty(r.tiles, 'base.jungle_temple'), 5);
    });

    test('Test 3 — Base, 4 players', () {
      final r = _runPipeline(
        players: _makePlayers(4),
        selectedColors: _selectedColors(4),
        activeModules: [],
      );

      // Worker removal: 1-1-1-1 per player
      expect(_hasStep(r.stepIds, 'setup_remove_worker_1_red'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_remove_worker_1_yellow'), isTrue);

      // AND 2-1-0-1 per player
      expect(_hasStep(r.stepIds, 'setup_remove_worker_2_red'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_remove_worker_2_yellow'), isTrue);

      // Worker quantities: both reduced
      expect(_tileQty(r.tiles, 'base.worker_red_1-1-1-1'), 3);
      expect(_tileQty(r.tiles, 'base.worker_red_2-1-0-1'), 4);
    });
  });

  // ---------------------------------------------------------------------------
  // GRUP 2: Individual modules
  // ---------------------------------------------------------------------------
  group('GRUP 2: Individual modules', () {
    test('Test 4 — Map Module, 2 players', () {
      final r = _runPipeline(
        players: _makePlayers(2),
        selectedColors: _selectedColors(2),
        activeModules: [_mapModule],
      );

      // Map tokens per player
      expect(_hasStep(r.stepIds, 'setup_map_tokens_red'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_map_tokens_purple'), isTrue);

      // Surplus step (< 4 players)
      expect(_hasStep(r.stepIds, 'setup_map_tokens_surplus'), isTrue);

      // Map board + display
      expect(_hasStep(r.stepIds, 'setup_map_board'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_jungle_display_map'), isTrue);

      // Original jungle display replaced
      expect(_hasStep(r.stepIds, 'setup_jungle_display'), isFalse);
    });

    test('Test 5 — Map Module, 4 players', () {
      final r = _runPipeline(
        players: _makePlayers(4),
        selectedColors: _selectedColors(4),
        activeModules: [_mapModule],
      );

      // Map tokens per player
      expect(_hasStep(r.stepIds, 'setup_map_tokens_red'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_map_tokens_yellow'), isTrue);

      // NO surplus step (4 players = 0 surplus)
      expect(_hasStep(r.stepIds, 'setup_map_tokens_surplus'), isFalse);
    });

    test('Test 6 — Watering Module, 2 players', () {
      final chocolatlExp = _createChocolatlExpansion(
        selectedColors: _selectedColors(2),
        modules: [_wateringModule],
      );
      final r = _runPipeline(
        players: _makePlayers(2),
        selectedColors: _selectedColors(2),
        activeModules: [_wateringModule],
        expansions: [chocolatlExp],
      );

      // Starting tile changed to water
      expect(
        _hasStep(r.stepIds, 'setup_initial_tiles_plantation_water'),
        isTrue,
      );
      expect(
        _hasStep(r.stepIds, 'setup_initial_tiles_plantation_market'),
        isFalse,
      );

      // Substitution steps
      expect(
        _hasStep(r.stepIds, 'setup_watering_remove_double_plantation'),
        isTrue,
      );
      expect(_hasStep(r.stepIds, 'setup_watering_add_watering_tiles'), isTrue);

      // NO single plantation removal for 2p watering
      expect(
        _hasStep(r.stepIds, 'setup_watering_remove_single_plantation'),
        isFalse,
      );

      // Steps before draw pile
      final drawPileIdx = _stepIndex(r.stepIds, 'setup_jungle_draw_pile');
      expect(
        _stepIndex(r.stepIds, 'setup_watering_remove_double_plantation'),
        lessThan(drawPileIdx),
      );

      // Tiles: 2 double plantations removed, 2 watering added
      expect(_tileQty(r.tiles, 'base.jungle_double_plantation'), 0); // 2-2=0
      expect(_tileQty(r.tiles, 'chocolatl.jungle_watering'), 2);
    });

    test('Test 7 — Watering Module, 3 players', () {
      final chocolatlExp = _createChocolatlExpansion(
        selectedColors: _selectedColors(3),
        modules: [_wateringModule],
      );
      final r = _runPipeline(
        players: _makePlayers(3),
        selectedColors: _selectedColors(3),
        activeModules: [_wateringModule],
        expansions: [chocolatlExp],
      );

      // Starting tile changed
      expect(
        _hasStep(r.stepIds, 'setup_initial_tiles_plantation_water'),
        isTrue,
      );

      // 3 substitution steps
      expect(
        _hasStep(r.stepIds, 'setup_watering_remove_single_plantation'),
        isTrue,
      );
      expect(
        _hasStep(r.stepIds, 'setup_watering_remove_double_plantation'),
        isTrue,
      );
      expect(_hasStep(r.stepIds, 'setup_watering_add_watering_tiles'), isTrue);

      // Tiles: 1 single + 2 double removed, 3 watering added
      expect(_tileQty(r.tiles, 'base.jungle_single_plantation'), 5); // 6-1
      expect(_tileQty(r.tiles, 'base.jungle_double_plantation'), 0); // 2-2
      expect(_tileQty(r.tiles, 'chocolatl.jungle_watering'), 3);
    });

    test('Test 8 — Chocolate Module, 2 players', () {
      final chocolatlExp = _createChocolatlExpansion(
        selectedColors: _selectedColors(2),
        modules: [_chocolateModule],
      );
      final r = _runPipeline(
        players: _makePlayers(2),
        selectedColors: _selectedColors(2),
        activeModules: [_chocolateModule],
        expansions: [chocolatlExp],
      );

      // Base 2p gold mine v1 step modified to 2x (base 1 + chocolate 1)
      // Base 2p market selling 3 step modified to 3x (base 1 + chocolate 2)
      // These are the modified base steps, still with same IDs
      expect(
        _hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_gold_mine_value_1'),
        isTrue,
      );
      expect(
        _hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_market_selling_3'),
        isTrue,
      );

      // New chocolate-specific steps
      expect(
        _hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v2'),
        isTrue,
      );
      expect(_hasStep(r.stepIds, 'setup_chocolate_add_kitchen'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_chocolate_add_market'), isTrue);

      // Steps before draw pile
      final drawPileIdx = _stepIndex(r.stepIds, 'setup_jungle_draw_pile');
      expect(
        _stepIndex(r.stepIds, 'setup_chocolate_remove_gold_mine_v2'),
        lessThan(drawPileIdx),
      );
      expect(
        _stepIndex(r.stepIds, 'setup_chocolate_add_kitchen'),
        lessThan(drawPileIdx),
      );

      // Chocolate bars in supplies
      expect(_hasStep(r.stepIds, 'setup_chocolate_bars'), isTrue);

      // Tiles: gold mines and markets reduced, chocolate tiles added
      expect(
        _tileQty(r.tiles, 'base.jungle_gold_mine_value_1'),
        0,
      ); // 2-1(base)-1(choc)=0
      expect(
        _tileQty(r.tiles, 'base.jungle_gold_mine_value_2'),
        1,
      ); // 2-1(choc)=1
      expect(
        _tileQty(r.tiles, 'base.jungle_market_selling_3'),
        1,
      ); // 4-1(base)-2(choc)=1
      expect(_tileQty(r.tiles, 'chocolatl.jungle_chocolate_kitchen'), 2);
      expect(_tileQty(r.tiles, 'chocolatl.jungle_chocolate_market'), 2);
    });

    test('Test 9 — Chocolate Module, 3 players', () {
      final chocolatlExp = _createChocolatlExpansion(
        selectedColors: _selectedColors(3),
        modules: [_chocolateModule],
      );
      final r = _runPipeline(
        players: _makePlayers(3),
        selectedColors: _selectedColors(3),
        activeModules: [_chocolateModule],
        expansions: [chocolatlExp],
      );

      // 5 new steps (no base 2p steps to modify)
      expect(
        _hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v1'),
        isTrue,
      );
      expect(
        _hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v2'),
        isTrue,
      );
      expect(
        _hasStep(r.stepIds, 'setup_chocolate_remove_market_selling_3'),
        isTrue,
      );
      expect(_hasStep(r.stepIds, 'setup_chocolate_add_kitchen'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_chocolate_add_market'), isTrue);

      // Chocolate bars
      expect(_hasStep(r.stepIds, 'setup_chocolate_bars'), isTrue);

      // Tiles
      expect(_tileQty(r.tiles, 'base.jungle_gold_mine_value_1'), 0); // 2-2=0
      expect(_tileQty(r.tiles, 'base.jungle_gold_mine_value_2'), 1); // 2-1=1
      expect(_tileQty(r.tiles, 'base.jungle_market_selling_3'), 1); // 4-3=1
      expect(_tileQty(r.tiles, 'chocolatl.jungle_chocolate_kitchen'), 3);
      expect(_tileQty(r.tiles, 'chocolatl.jungle_chocolate_market'), 3);
    });

    test('Test 10 — Hut Module, 2 players', () {
      final chocolatlExp = _createChocolatlExpansion(
        selectedColors: _selectedColors(2),
        modules: [_hutModule],
      );
      final r = _runPipeline(
        players: _makePlayers(2),
        selectedColors: _selectedColors(2),
        activeModules: [_hutModule],
        expansions: [chocolatlExp],
      );

      // Huts market setup step
      expect(_hasStep(r.stepIds, 'setup_huts_market'), isTrue);

      // 14 hut tiles in the pool (per tiles.json data)
      final hutTiles = r.tiles.where((t) => t.type == TileType.hut);
      final totalHuts = hutTiles.fold(0, (sum, t) => sum + t.quantity);
      expect(totalHuts, 14);
    });

    test('Test 11 — Gem Mines Module, 2 players', () {
      final diamanteExp = _createDiamanteExpansion(
        selectedColors: _selectedColors(2),
        modules: [_gemMinesModule],
      );
      final r = _runPipeline(
        players: _makePlayers(2),
        selectedColors: _selectedColors(2),
        activeModules: [_gemMinesModule],
        expansions: [diamanteExp],
      );

      // Base temple removal step eliminated
      expect(
        _hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_temple'),
        isFalse,
      );

      // Gem mines steps
      expect(_hasStep(r.stepIds, 'setup_gem_mines_remove_temples'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_add_gem_mines'), isTrue);

      // Before draw pile
      final drawPileIdx = _stepIndex(r.stepIds, 'setup_jungle_draw_pile');
      expect(
        _stepIndex(r.stepIds, 'setup_gem_mines_remove_temples'),
        lessThan(drawPileIdx),
      );

      // Supplies
      expect(_hasStep(r.stepIds, 'setup_gem_mines_remove_gems'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_mine_car'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_masks'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_rule_reminder'), isTrue);

      // Tiles: all temples gone, 4 gem mines (5-1 for 2p)
      expect(_tileQty(r.tiles, 'base.jungle_temple'), 0);
      expect(_tileQty(r.tiles, 'diamante.jungle_gem_mine'), 4);
    });

    test('Test 12 — Gem Mines Module, 3 players', () {
      final diamanteExp = _createDiamanteExpansion(
        selectedColors: _selectedColors(3),
        modules: [_gemMinesModule],
      );
      final r = _runPipeline(
        players: _makePlayers(3),
        selectedColors: _selectedColors(3),
        activeModules: [_gemMinesModule],
        expansions: [diamanteExp],
      );

      // Steps
      expect(_hasStep(r.stepIds, 'setup_gem_mines_remove_temples'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_add_gem_mines'), isTrue);

      // Tiles: 5 gem mines for 3+ players
      expect(_tileQty(r.tiles, 'base.jungle_temple'), 0);
      expect(_tileQty(r.tiles, 'diamante.jungle_gem_mine'), 5);
    });

    test('Test 13 — Tree of Life Module, 2 players', () {
      final diamanteExp = _createDiamanteExpansion(
        selectedColors: _selectedColors(2),
        modules: [_treeOfLifeModule, _newWorkersModule],
      );
      final r = _runPipeline(
        players: _makePlayers(2),
        selectedColors: _selectedColors(2),
        activeModules: [_treeOfLifeModule],
        expansions: [diamanteExp],
      );

      // Base gold mine v1 step modified (1→2)
      expect(
        _hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_gold_mine_value_1'),
        isTrue,
      );

      // New gold mine v2 removal
      expect(
        _hasStep(r.stepIds, 'setup_tree_of_life_remove_gold_mine_v2'),
        isTrue,
      );

      // Tree of life tiles added
      expect(_hasStep(r.stepIds, 'setup_tree_of_life_add_tiles'), isTrue);

      // 0-0-0-4 worker tile per player
      expect(_hasStep(r.stepIds, 'setup_tree_of_life_add_0004_red'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_tree_of_life_add_0004_purple'), isTrue);

      // NO worker removal steps for 2p
      expect(
        _hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_'),
        ),
        isFalse,
      );

      // Tiles
      expect(
        _tileQty(r.tiles, 'base.jungle_gold_mine_value_1'),
        0,
      ); // 2-1(base)-1(tree)=0
      expect(
        _tileQty(r.tiles, 'base.jungle_gold_mine_value_2'),
        1,
      ); // 2-1(tree)=1 (base also removed 0 for this)
      // Actually for 2p base: gold mine v1 reduced by 1, tree of life reduces by 1 more = 0
      // gold mine v2: base doesn't reduce for 2p, tree of life reduces by 1 = 1
      expect(_tileQty(r.tiles, 'diamante.jungle_tree_of_life'), 2);

      // 0-0-0-4 worker tiles added by tree of life handler only (base handler filters out moduleId=8 tiles when module 8 is not active)
      expect(_tileQty(r.tiles, 'diamante.worker_red_0-0-0-4'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_purple_0-0-0-4'), 1);
    });

    test('Test 14 — Tree of Life Module, 3 players', () {
      final diamanteExp = _createDiamanteExpansion(
        selectedColors: _selectedColors(3),
        modules: [_treeOfLifeModule],
      );
      final r = _runPipeline(
        players: _makePlayers(3),
        selectedColors: _selectedColors(3),
        activeModules: [_treeOfLifeModule],
        expansions: [diamanteExp],
      );

      // Gold mine removal steps (3+p, no Chocolate)
      expect(
        _hasStep(r.stepIds, 'setup_tree_of_life_remove_gold_mine_v1'),
        isTrue,
      );
      expect(
        _hasStep(r.stepIds, 'setup_tree_of_life_remove_gold_mine_v2'),
        isTrue,
      );
      expect(_hasStep(r.stepIds, 'setup_tree_of_life_add_tiles'), isTrue);

      // Worker 1-1-1-1 NOT removed (Tree of Life restores)
      expect(
        _hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_1_'),
        ),
        isFalse,
      );

      // Tiles
      expect(_tileQty(r.tiles, 'base.jungle_gold_mine_value_1'), 0); // 2-2=0
      expect(_tileQty(r.tiles, 'base.jungle_gold_mine_value_2'), 1); // 2-1=1
      expect(_tileQty(r.tiles, 'diamante.jungle_tree_of_life'), 3);

      // Worker 1-1-1-1 quantity restored
      expect(_tileQty(r.tiles, 'base.worker_red_1-1-1-1'), 4); // 4-1+1=4
    });

    test('Test 15 — Tree of Life Module, 4 players', () {
      final diamanteExp = _createDiamanteExpansion(
        selectedColors: _selectedColors(4),
        modules: [_treeOfLifeModule],
      );
      final r = _runPipeline(
        players: _makePlayers(4),
        selectedColors: _selectedColors(4),
        activeModules: [_treeOfLifeModule],
        expansions: [diamanteExp],
      );

      // Gold mine removal steps
      expect(
        _hasStep(r.stepIds, 'setup_tree_of_life_remove_gold_mine_v1'),
        isTrue,
      );
      expect(
        _hasStep(r.stepIds, 'setup_tree_of_life_remove_gold_mine_v2'),
        isTrue,
      );
      expect(_hasStep(r.stepIds, 'setup_tree_of_life_add_tiles'), isTrue);

      // Worker 1-1-1-1 IS removed (4p: only restores 2-1-0-1)
      expect(_hasStep(r.stepIds, 'setup_remove_worker_1_red'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_remove_worker_1_yellow'), isTrue);

      // Worker 2-1-0-1 NOT removed (Tree of Life restores)
      expect(
        _hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_2_'),
        ),
        isFalse,
      );

      // Tiles
      expect(_tileQty(r.tiles, 'base.jungle_gold_mine_value_1'), 0);
      expect(_tileQty(r.tiles, 'base.jungle_gold_mine_value_2'), 1);
      expect(_tileQty(r.tiles, 'diamante.jungle_tree_of_life'), 3);

      // Worker 1-1-1-1 reduced, 2-1-0-1 restored
      expect(_tileQty(r.tiles, 'base.worker_red_1-1-1-1'), 3);
      expect(_tileQty(r.tiles, 'base.worker_red_2-1-0-1'), 5); // 5-1+1=5
    });

    test('Test 16 — Emperor Favour Module, 2 players', () {
      final chocolatlExp = _createChocolatlExpansion(
        selectedColors: _selectedColors(2),
        modules: [_emperorModule],
      );
      final r = _runPipeline(
        players: _makePlayers(2),
        selectedColors: _selectedColors(2),
        activeModules: [_emperorModule],
        expansions: [chocolatlExp],
      );

      // Emperor step present
      expect(_hasStep(r.stepIds, 'setup_emperor'), isTrue);

      // Emperor placed after initial tiles (no watering → market selling price 2)
      final initialIdx = _stepIndex(
        r.stepIds,
        'setup_initial_tiles_plantation_market',
      );
      final emperorIdx = _stepIndex(r.stepIds, 'setup_emperor');
      expect(emperorIdx, initialIdx + 1);
    });

    test('Test 17 — New Workers Module, 2 players', () {
      final diamanteExp = _createDiamanteExpansion(
        selectedColors: _selectedColors(2),
        modules: [_newWorkersModule],
      );
      final r = _runPipeline(
        players: _makePlayers(2),
        selectedColors: _selectedColors(2),
        activeModules: [_newWorkersModule],
        expansions: [diamanteExp],
      );

      // New workers selection step before shuffle
      expect(_hasStep(r.stepIds, 'setup_new_workers_selection'), isTrue);
      final nwIdx17 = _stepIndex(r.stepIds, 'setup_new_workers_selection');
      final shuffleIdx17 = _stepIndex(r.stepIds, 'setup_shuffle_workers');
      expect(nwIdx17, lessThan(shuffleIdx17));

      // Tiles unchanged (informational module — jungle tiles not modified)
      expect(
        _tileQty(r.tiles, 'base.jungle_single_plantation'),
        4,
      ); // 2p reduction

      // New worker tiles added to pool for each player color
      // TODO(future): When interactive selection is implemented, these should
      // reflect the user's choice instead of adding all tiles by default.
      expect(_tileQty(r.tiles, 'diamante.worker_red_0-0-0-4'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_red_0-0-2-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_red_0-2-0-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_red_0-1-0-3'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_purple_0-0-0-4'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_purple_0-0-2-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_purple_0-2-0-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_purple_0-1-0-3'), 1);
    });
  });

  // ---------------------------------------------------------------------------
  // GRUP 3: Cross-module interactions
  // ---------------------------------------------------------------------------
  group('GRUP 3: Cross-module interactions', () {
    test('Test 18 — Watering + Emperor, 2 players', () {
      final chocolatlExp = _createChocolatlExpansion(
        selectedColors: _selectedColors(2),
        modules: [_wateringModule, _emperorModule],
      );
      final r = _runPipeline(
        players: _makePlayers(2),
        selectedColors: _selectedColors(2),
        activeModules: [_wateringModule, _emperorModule],
        expansions: [chocolatlExp],
      );

      // Starting tiles: water (not market)
      expect(
        _hasStep(r.stepIds, 'setup_initial_tiles_plantation_water'),
        isTrue,
      );

      // Emperor references water tile (placed after initial tiles)
      final initialIdx = _stepIndex(
        r.stepIds,
        'setup_initial_tiles_plantation_water',
      );
      final emperorIdx = _stepIndex(r.stepIds, 'setup_emperor');
      expect(emperorIdx, initialIdx + 1);
    });

    test('Test 19 — Watering + Emperor, 3 players', () {
      final chocolatlExp = _createChocolatlExpansion(
        selectedColors: _selectedColors(3),
        modules: [_wateringModule, _emperorModule],
      );
      final r = _runPipeline(
        players: _makePlayers(3),
        selectedColors: _selectedColors(3),
        activeModules: [_wateringModule, _emperorModule],
        expansions: [chocolatlExp],
      );

      expect(
        _hasStep(r.stepIds, 'setup_initial_tiles_plantation_water'),
        isTrue,
      );
      expect(_hasStep(r.stepIds, 'setup_emperor'), isTrue);
    });

    test('Test 20 — Chocolate + Tree of Life, 2 players', () {
      final chocolatlExp = _createChocolatlExpansion(
        selectedColors: _selectedColors(2),
        modules: [_chocolateModule],
      );
      final diamanteExp = _createDiamanteExpansion(
        selectedColors: _selectedColors(2),
        modules: [_treeOfLifeModule, _newWorkersModule],
      );
      final r = _runPipeline(
        players: _makePlayers(2),
        selectedColors: _selectedColors(2),
        activeModules: [_chocolateModule, _treeOfLifeModule],
        expansions: [chocolatlExp, diamanteExp],
      );

      // Chocolate modifies base gold mine v1 (1→2) and market selling 3 (1→3)
      expect(
        _hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_gold_mine_value_1'),
        isTrue,
      );
      expect(
        _hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_market_selling_3'),
        isTrue,
      );

      // Chocolate adds gold mine v2 removal
      expect(
        _hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v2'),
        isTrue,
      );

      // Tree of Life does NOT add gold mine removal (Chocolate active)
      expect(
        _hasStep(r.stepIds, 'setup_tree_of_life_remove_gold_mine_v1'),
        isFalse,
      );
      expect(
        _hasStep(r.stepIds, 'setup_tree_of_life_remove_gold_mine_v2'),
        isFalse,
      );

      // Tree of Life adds tiles
      expect(_hasStep(r.stepIds, 'setup_tree_of_life_add_tiles'), isTrue);

      // 0-0-0-4 worker tiles for each player
      expect(_hasStep(r.stepIds, 'setup_tree_of_life_add_0004_red'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_tree_of_life_add_0004_purple'), isTrue);

      // Chocolate bars
      expect(_hasStep(r.stepIds, 'setup_chocolate_bars'), isTrue);

      // Tiles: Chocolate removes gold mines, Tree of Life does NOT
      expect(_tileQty(r.tiles, 'base.jungle_gold_mine_value_1'), 0);
      expect(_tileQty(r.tiles, 'base.jungle_gold_mine_value_2'), 1);
      expect(_tileQty(r.tiles, 'chocolatl.jungle_chocolate_kitchen'), 2);
      expect(_tileQty(r.tiles, 'chocolatl.jungle_chocolate_market'), 2);
      expect(_tileQty(r.tiles, 'diamante.jungle_tree_of_life'), 2);
    });

    test('Test 21 — Chocolate + Tree of Life, 3 players', () {
      final chocolatlExp = _createChocolatlExpansion(
        selectedColors: _selectedColors(3),
        modules: [_chocolateModule],
      );
      final diamanteExp = _createDiamanteExpansion(
        selectedColors: _selectedColors(3),
        modules: [_treeOfLifeModule],
      );
      final r = _runPipeline(
        players: _makePlayers(3),
        selectedColors: _selectedColors(3),
        activeModules: [_chocolateModule, _treeOfLifeModule],
        expansions: [chocolatlExp, diamanteExp],
      );

      // Chocolate steps
      expect(
        _hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v1'),
        isTrue,
      );
      expect(
        _hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v2'),
        isTrue,
      );
      expect(
        _hasStep(r.stepIds, 'setup_chocolate_remove_market_selling_3'),
        isTrue,
      );

      // Tree of Life NO gold mine removal (Chocolate active)
      expect(
        _hasStep(r.stepIds, 'setup_tree_of_life_remove_gold_mine_v1'),
        isFalse,
      );
      expect(
        _hasStep(r.stepIds, 'setup_tree_of_life_remove_gold_mine_v2'),
        isFalse,
      );

      // Tree of Life adds tiles
      expect(_hasStep(r.stepIds, 'setup_tree_of_life_add_tiles'), isTrue);

      // Worker 1-1-1-1 NOT removed (Tree of Life restores)
      expect(
        _hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_1_'),
        ),
        isFalse,
      );

      // Tiles
      expect(_tileQty(r.tiles, 'base.jungle_gold_mine_value_1'), 0);
      expect(_tileQty(r.tiles, 'base.jungle_gold_mine_value_2'), 1);
      expect(_tileQty(r.tiles, 'chocolatl.jungle_chocolate_kitchen'), 3);
      expect(_tileQty(r.tiles, 'chocolatl.jungle_chocolate_market'), 3);
      expect(_tileQty(r.tiles, 'diamante.jungle_tree_of_life'), 3);
    });

    test('Test 22 — Chocolate + Tree of Life, 4 players', () {
      final chocolatlExp = _createChocolatlExpansion(
        selectedColors: _selectedColors(4),
        modules: [_chocolateModule],
      );
      final diamanteExp = _createDiamanteExpansion(
        selectedColors: _selectedColors(4),
        modules: [_treeOfLifeModule],
      );
      final r = _runPipeline(
        players: _makePlayers(4),
        selectedColors: _selectedColors(4),
        activeModules: [_chocolateModule, _treeOfLifeModule],
        expansions: [chocolatlExp, diamanteExp],
      );

      // Worker 1-1-1-1 IS removed (4p)
      expect(_hasStep(r.stepIds, 'setup_remove_worker_1_red'), isTrue);

      // Worker 2-1-0-1 NOT removed (Tree of Life restores)
      expect(
        _hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_2_'),
        ),
        isFalse,
      );

      // Tiles
      expect(_tileQty(r.tiles, 'chocolatl.jungle_chocolate_kitchen'), 3);
      expect(_tileQty(r.tiles, 'chocolatl.jungle_chocolate_market'), 3);
      expect(_tileQty(r.tiles, 'diamante.jungle_tree_of_life'), 3);
    });

    test('Test 23 — Gem Mines + Chocolate, 2 players', () {
      final chocolatlExp = _createChocolatlExpansion(
        selectedColors: _selectedColors(2),
        modules: [_chocolateModule],
      );
      final diamanteExp = _createDiamanteExpansion(
        selectedColors: _selectedColors(2),
        modules: [_gemMinesModule],
      );
      final r = _runPipeline(
        players: _makePlayers(2),
        selectedColors: _selectedColors(2),
        activeModules: [_chocolateModule, _gemMinesModule],
        expansions: [chocolatlExp, diamanteExp],
      );

      // Chocolate modifies base steps
      expect(
        _hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_gold_mine_value_1'),
        isTrue,
      );
      expect(
        _hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_market_selling_3'),
        isTrue,
      );
      expect(
        _hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v2'),
        isTrue,
      );
      expect(_hasStep(r.stepIds, 'setup_chocolate_add_kitchen'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_chocolate_add_market'), isTrue);

      // Gem Mines eliminates base temple step and adds its own
      expect(
        _hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_temple'),
        isFalse,
      );
      expect(_hasStep(r.stepIds, 'setup_gem_mines_remove_temples'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_add_gem_mines'), isTrue);

      // Supplies
      expect(_hasStep(r.stepIds, 'setup_chocolate_bars'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_remove_gems'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_mine_car'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_masks'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_rule_reminder'), isTrue);

      // Tiles
      expect(_tileQty(r.tiles, 'base.jungle_temple'), 0);
      expect(_tileQty(r.tiles, 'diamante.jungle_gem_mine'), 4);
      expect(_tileQty(r.tiles, 'chocolatl.jungle_chocolate_kitchen'), 2);
    });

    test('Test 24 — Gem Mines + Tree of Life, 3 players', () {
      final diamanteExp = _createDiamanteExpansion(
        selectedColors: _selectedColors(3),
        modules: [_gemMinesModule, _treeOfLifeModule],
      );
      final r = _runPipeline(
        players: _makePlayers(3),
        selectedColors: _selectedColors(3),
        activeModules: [_gemMinesModule, _treeOfLifeModule],
        expansions: [diamanteExp],
      );

      // Gem Mines
      expect(_hasStep(r.stepIds, 'setup_gem_mines_remove_temples'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_add_gem_mines'), isTrue);

      // Tree of Life (no Chocolate → removes gold mines)
      expect(
        _hasStep(r.stepIds, 'setup_tree_of_life_remove_gold_mine_v1'),
        isTrue,
      );
      expect(
        _hasStep(r.stepIds, 'setup_tree_of_life_remove_gold_mine_v2'),
        isTrue,
      );
      expect(_hasStep(r.stepIds, 'setup_tree_of_life_add_tiles'), isTrue);

      // Worker 1-1-1-1 NOT removed (Tree of Life restores)
      expect(
        _hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_1_'),
        ),
        isFalse,
      );

      // Tiles
      expect(_tileQty(r.tiles, 'base.jungle_temple'), 0);
      expect(_tileQty(r.tiles, 'diamante.jungle_gem_mine'), 5);
      expect(_tileQty(r.tiles, 'base.jungle_gold_mine_value_1'), 0);
      expect(_tileQty(r.tiles, 'base.jungle_gold_mine_value_2'), 1);
      expect(_tileQty(r.tiles, 'diamante.jungle_tree_of_life'), 3);
    });

    test('Test 25 — Watering + Chocolate, 2 players', () {
      final chocolatlExp = _createChocolatlExpansion(
        selectedColors: _selectedColors(2),
        modules: [_wateringModule, _chocolateModule],
      );
      final r = _runPipeline(
        players: _makePlayers(2),
        selectedColors: _selectedColors(2),
        activeModules: [_wateringModule, _chocolateModule],
        expansions: [chocolatlExp],
      );

      // Starting tiles: water
      expect(
        _hasStep(r.stepIds, 'setup_initial_tiles_plantation_water'),
        isTrue,
      );

      // Watering steps
      expect(
        _hasStep(r.stepIds, 'setup_watering_remove_double_plantation'),
        isTrue,
      );
      expect(_hasStep(r.stepIds, 'setup_watering_add_watering_tiles'), isTrue);

      // Chocolate modifies base steps and adds its own
      expect(
        _hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v2'),
        isTrue,
      );
      expect(_hasStep(r.stepIds, 'setup_chocolate_add_kitchen'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_chocolate_add_market'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_chocolate_bars'), isTrue);

      // Tiles
      expect(_tileQty(r.tiles, 'base.jungle_double_plantation'), 0);
      expect(_tileQty(r.tiles, 'chocolatl.jungle_watering'), 2);
      expect(_tileQty(r.tiles, 'chocolatl.jungle_chocolate_kitchen'), 2);
    });

    test('Test 26 — Map + Watering + Emperor, 2 players', () {
      final chocolatlExp = _createChocolatlExpansion(
        selectedColors: _selectedColors(2),
        modules: [_mapModule, _wateringModule, _emperorModule],
      );
      final r = _runPipeline(
        players: _makePlayers(2),
        selectedColors: _selectedColors(2),
        activeModules: [_mapModule, _wateringModule, _emperorModule],
        expansions: [chocolatlExp],
      );

      // Map tokens per player
      expect(_hasStep(r.stepIds, 'setup_map_tokens_red'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_map_tokens_purple'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_map_tokens_surplus'), isTrue);

      // Starting tiles: water (Watering active)
      expect(
        _hasStep(r.stepIds, 'setup_initial_tiles_plantation_water'),
        isTrue,
      );

      // Emperor after initial tiles
      expect(_hasStep(r.stepIds, 'setup_emperor'), isTrue);
      final initialIdx = _stepIndex(
        r.stepIds,
        'setup_initial_tiles_plantation_water',
      );
      final emperorIdx = _stepIndex(r.stepIds, 'setup_emperor');
      expect(emperorIdx, initialIdx + 1);

      // Map board + jungle display map
      expect(_hasStep(r.stepIds, 'setup_map_board'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_jungle_display_map'), isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // GRUP 4: Big Game (all modules)
  // ---------------------------------------------------------------------------
  group('GRUP 4: Big Game (all modules)', () {
    final allChocolatlModules = [
      _mapModule,
      _wateringModule,
      _chocolateModule,
      _hutModule,
      _emperorModule,
    ];
    final allDiamanteModules = [
      _gemMinesModule,
      _treeOfLifeModule,
      _newWorkersModule,
    ];
    final allModules = [...allChocolatlModules, ...allDiamanteModules];

    test('Test 27 — All modules, 2 players', () {
      final chocolatlExp = _createChocolatlExpansion(
        selectedColors: _selectedColors(2),
        modules: allChocolatlModules,
      );
      final diamanteExp = _createDiamanteExpansion(
        selectedColors: _selectedColors(2),
        modules: allDiamanteModules,
      );
      final r = _runPipeline(
        players: _makePlayers(2),
        selectedColors: _selectedColors(2),
        activeModules: allModules,
        expansions: [chocolatlExp, diamanteExp],
      );

      // ---- Player Setup ----
      // New Workers before shuffle
      final nwIdx27 = _stepIndex(r.stepIds, 'setup_new_workers_selection');
      final shuffleIdx27 = _stepIndex(r.stepIds, 'setup_shuffle_workers');
      expect(nwIdx27, lessThan(shuffleIdx27));

      // Village board, carrier, field, tiles for each player
      expect(_hasStep(r.stepIds, 'setup_village_board_red'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_tiles_red'), isTrue);

      // Map tokens + surplus
      expect(_hasStep(r.stepIds, 'setup_map_tokens_red'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_map_tokens_surplus'), isTrue);

      // 0-0-0-4 worker tile steps removed by New Workers handler (selector
      // subsumes them when both Tree of Life and New Workers are active)
      expect(_hasStep(r.stepIds, 'setup_tree_of_life_add_0004_red'), isFalse);
      expect(
        _hasStep(r.stepIds, 'setup_tree_of_life_add_0004_purple'),
        isFalse,
      );

      // NO worker removal steps (2p)
      expect(
        _hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_'),
        ),
        isFalse,
      );

      // Shuffle workers
      expect(_hasStep(r.stepIds, 'setup_shuffle_workers'), isTrue);

      // ---- Board Setup ----
      // Starting tiles: water (Watering active)
      expect(
        _hasStep(r.stepIds, 'setup_initial_tiles_plantation_water'),
        isTrue,
      );

      // Emperor on water tile
      expect(_hasStep(r.stepIds, 'setup_emperor'), isTrue);

      // 2p sort out steps (base) — some modified by Chocolate
      expect(
        _hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_single_plantation'),
        isTrue,
      );
      expect(
        _hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_market_selling_3'),
        isTrue,
      ); // modified 1→3
      expect(
        _hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_gold_mine_value_1'),
        isTrue,
      ); // modified 1→2
      expect(
        _hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_water'),
        isTrue,
      );
      expect(
        _hasStep(
          r.stepIds,
          'setup_jungle_tiles_2p_removal_sun_worshiping_site',
        ),
        isTrue,
      );

      // Temple base step ELIMINATED by Gem Mines
      expect(
        _hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_temple'),
        isFalse,
      );

      // Watering substitution
      expect(
        _hasStep(r.stepIds, 'setup_watering_remove_double_plantation'),
        isTrue,
      );
      expect(_hasStep(r.stepIds, 'setup_watering_add_watering_tiles'), isTrue);

      // Chocolate substitution
      expect(
        _hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v2'),
        isTrue,
      );
      expect(_hasStep(r.stepIds, 'setup_chocolate_add_kitchen'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_chocolate_add_market'), isTrue);

      // Gem Mines
      expect(_hasStep(r.stepIds, 'setup_gem_mines_remove_temples'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_add_gem_mines'), isTrue);

      // Tree of Life NO gold mine removal (Chocolate active)
      expect(
        _hasStep(r.stepIds, 'setup_tree_of_life_remove_gold_mine_v1'),
        isFalse,
      );
      expect(
        _hasStep(r.stepIds, 'setup_tree_of_life_remove_gold_mine_v2'),
        isFalse,
      );
      expect(_hasStep(r.stepIds, 'setup_tree_of_life_add_tiles'), isTrue);

      // Map board + display
      expect(_hasStep(r.stepIds, 'setup_map_board'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_jungle_display_map'), isTrue);

      // Huts
      expect(_hasStep(r.stepIds, 'setup_huts_market'), isTrue);

      // ---- Supplies ----
      expect(_hasStep(r.stepIds, 'setup_resources_bank'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_chocolate_bars'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_remove_gems'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_mine_car'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_masks'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_rule_reminder'), isTrue);

      // ---- Tile quantities ----
      // Plantations reduced (base 2p + watering)
      expect(
        _tileQty(r.tiles, 'base.jungle_single_plantation'),
        4,
      ); // 6-2(base)
      expect(
        _tileQty(r.tiles, 'base.jungle_double_plantation'),
        0,
      ); // 2-2(watering)
      expect(_tileQty(r.tiles, 'chocolatl.jungle_watering'), 2);

      // Gold mines removed (base 2p + chocolate)
      expect(_tileQty(r.tiles, 'base.jungle_gold_mine_value_1'), 0);
      expect(_tileQty(r.tiles, 'base.jungle_gold_mine_value_2'), 1);
      expect(_tileQty(r.tiles, 'chocolatl.jungle_chocolate_kitchen'), 2);
      expect(_tileQty(r.tiles, 'chocolatl.jungle_chocolate_market'), 2);

      // Temples removed (gem mines)
      expect(_tileQty(r.tiles, 'base.jungle_temple'), 0);
      expect(_tileQty(r.tiles, 'diamante.jungle_gem_mine'), 4);

      // Tree of life
      expect(_tileQty(r.tiles, 'diamante.jungle_tree_of_life'), 2);

      // Huts
      final hutTiles = r.tiles.where((t) => t.type == TileType.hut);
      final totalHuts = hutTiles.fold(0, (sum, t) => sum + t.quantity);
      expect(totalHuts, 14);

      // 0-0-0-4 worker tiles: qty 1 per player (TreeOfLife adds, NewWorkers skips duplicate)
      expect(_tileQty(r.tiles, 'diamante.worker_red_0-0-0-4'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_purple_0-0-0-4'), 1);

      // Remaining new worker tiles added by NewWorkers handler
      expect(_tileQty(r.tiles, 'diamante.worker_red_0-0-2-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_red_0-2-0-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_red_0-1-0-3'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_purple_0-0-2-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_purple_0-2-0-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_purple_0-1-0-3'), 1);
    });

    test('Test 28 — All modules, 3 players', () {
      final chocolatlExp = _createChocolatlExpansion(
        selectedColors: _selectedColors(3),
        modules: allChocolatlModules,
      );
      final diamanteExp = _createDiamanteExpansion(
        selectedColors: _selectedColors(3),
        modules: allDiamanteModules,
      );
      final r = _runPipeline(
        players: _makePlayers(3),
        selectedColors: _selectedColors(3),
        activeModules: allModules,
        expansions: [chocolatlExp, diamanteExp],
      );

      // ---- Player Setup ----
      final nwIdx28 = _stepIndex(r.stepIds, 'setup_new_workers_selection');
      final shuffleIdx28 = _stepIndex(r.stepIds, 'setup_shuffle_workers');
      expect(nwIdx28, lessThan(shuffleIdx28));

      // Map tokens (3p → surplus exists: 8 total - 6 = 2 surplus)
      expect(_hasStep(r.stepIds, 'setup_map_tokens_red'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_map_tokens_surplus'), isTrue);

      // Worker 1-1-1-1 NOT removed (Tree of Life restores)
      expect(
        _hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_1_'),
        ),
        isFalse,
      );

      // ---- Board Setup ----
      // Starting tiles: water
      expect(
        _hasStep(r.stepIds, 'setup_initial_tiles_plantation_water'),
        isTrue,
      );
      expect(_hasStep(r.stepIds, 'setup_emperor'), isTrue);

      // NO 2p sort out steps
      expect(
        _hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_jungle_tiles_2p_'),
        ),
        isFalse,
      );

      // Watering (3+p: 3 steps)
      expect(
        _hasStep(r.stepIds, 'setup_watering_remove_single_plantation'),
        isTrue,
      );
      expect(
        _hasStep(r.stepIds, 'setup_watering_remove_double_plantation'),
        isTrue,
      );
      expect(_hasStep(r.stepIds, 'setup_watering_add_watering_tiles'), isTrue);

      // Chocolate (3+p: 5 steps)
      expect(
        _hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v1'),
        isTrue,
      );
      expect(
        _hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v2'),
        isTrue,
      );
      expect(
        _hasStep(r.stepIds, 'setup_chocolate_remove_market_selling_3'),
        isTrue,
      );
      expect(_hasStep(r.stepIds, 'setup_chocolate_add_kitchen'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_chocolate_add_market'), isTrue);

      // Gem Mines
      expect(_hasStep(r.stepIds, 'setup_gem_mines_remove_temples'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_add_gem_mines'), isTrue);

      // Tree of Life (Chocolate active → no gold mine removal)
      expect(
        _hasStep(r.stepIds, 'setup_tree_of_life_remove_gold_mine_v1'),
        isFalse,
      );
      expect(_hasStep(r.stepIds, 'setup_tree_of_life_add_tiles'), isTrue);

      // Map board
      expect(_hasStep(r.stepIds, 'setup_map_board'), isTrue);

      // Huts
      expect(_hasStep(r.stepIds, 'setup_huts_market'), isTrue);

      // ---- Supplies ----
      expect(_hasStep(r.stepIds, 'setup_chocolate_bars'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_mine_car'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_masks'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_rule_reminder'), isTrue);

      // ---- Tiles ----
      expect(
        _tileQty(r.tiles, 'base.jungle_single_plantation'),
        5,
      ); // 6-1(watering)
      expect(
        _tileQty(r.tiles, 'base.jungle_double_plantation'),
        0,
      ); // 2-2(watering)
      expect(_tileQty(r.tiles, 'chocolatl.jungle_watering'), 3);
      expect(
        _tileQty(r.tiles, 'base.jungle_gold_mine_value_1'),
        0,
      ); // 2-2(choc)
      expect(
        _tileQty(r.tiles, 'base.jungle_gold_mine_value_2'),
        1,
      ); // 2-1(choc)
      expect(_tileQty(r.tiles, 'chocolatl.jungle_chocolate_kitchen'), 3);
      expect(_tileQty(r.tiles, 'chocolatl.jungle_chocolate_market'), 3);
      expect(_tileQty(r.tiles, 'base.jungle_temple'), 0);
      expect(_tileQty(r.tiles, 'diamante.jungle_gem_mine'), 5);
      expect(_tileQty(r.tiles, 'diamante.jungle_tree_of_life'), 3);

      // Workers restored
      expect(_tileQty(r.tiles, 'base.worker_red_1-1-1-1'), 4);

      // New worker tiles added by NewWorkers handler for all 3 colors
      expect(_tileQty(r.tiles, 'diamante.worker_red_0-0-0-4'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_red_0-0-2-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_red_0-2-0-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_red_0-1-0-3'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_purple_0-0-0-4'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_purple_0-0-2-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_purple_0-2-0-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_purple_0-1-0-3'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_white_0-0-0-4'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_white_0-0-2-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_white_0-2-0-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_white_0-1-0-3'), 1);
    });

    test('Test 29 — All modules, 4 players', () {
      final chocolatlExp = _createChocolatlExpansion(
        selectedColors: _selectedColors(4),
        modules: allChocolatlModules,
      );
      final diamanteExp = _createDiamanteExpansion(
        selectedColors: _selectedColors(4),
        modules: allDiamanteModules,
      );
      final r = _runPipeline(
        players: _makePlayers(4),
        selectedColors: _selectedColors(4),
        activeModules: allModules,
        expansions: [chocolatlExp, diamanteExp],
      );

      // ---- Player Setup ----
      final nwIdx29 = _stepIndex(r.stepIds, 'setup_new_workers_selection');
      final shuffleIdx29 = _stepIndex(r.stepIds, 'setup_shuffle_workers');
      expect(nwIdx29, lessThan(shuffleIdx29));

      // Map tokens, NO surplus (4 players)
      expect(_hasStep(r.stepIds, 'setup_map_tokens_red'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_map_tokens_yellow'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_map_tokens_surplus'), isFalse);

      // Worker removal steps removed by New Workers selector (always authoritative)
      expect(
        _hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_1_'),
        ),
        isFalse,
      );

      // Worker 2-1-0-1 also removed by selector
      expect(
        _hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_2_'),
        ),
        isFalse,
      );

      // ---- Board Setup ----
      expect(
        _hasStep(r.stepIds, 'setup_initial_tiles_plantation_water'),
        isTrue,
      );
      expect(_hasStep(r.stepIds, 'setup_emperor'), isTrue);

      // NO 2p sort out steps
      expect(
        _hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_jungle_tiles_2p_'),
        ),
        isFalse,
      );

      // Same substitution steps as 3 players
      expect(
        _hasStep(r.stepIds, 'setup_watering_remove_single_plantation'),
        isTrue,
      );
      expect(
        _hasStep(r.stepIds, 'setup_watering_remove_double_plantation'),
        isTrue,
      );
      expect(_hasStep(r.stepIds, 'setup_watering_add_watering_tiles'), isTrue);
      expect(
        _hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v1'),
        isTrue,
      );
      expect(
        _hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v2'),
        isTrue,
      );
      expect(
        _hasStep(r.stepIds, 'setup_chocolate_remove_market_selling_3'),
        isTrue,
      );
      expect(_hasStep(r.stepIds, 'setup_gem_mines_remove_temples'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_tree_of_life_add_tiles'), isTrue);

      // ---- Tiles (same quantities as 3p for jungle tiles) ----
      expect(_tileQty(r.tiles, 'base.jungle_single_plantation'), 5);
      expect(_tileQty(r.tiles, 'base.jungle_double_plantation'), 0);
      expect(_tileQty(r.tiles, 'chocolatl.jungle_watering'), 3);
      expect(_tileQty(r.tiles, 'base.jungle_gold_mine_value_1'), 0);
      expect(_tileQty(r.tiles, 'base.jungle_gold_mine_value_2'), 1);
      expect(_tileQty(r.tiles, 'base.jungle_temple'), 0);
      expect(_tileQty(r.tiles, 'diamante.jungle_gem_mine'), 5);
      expect(_tileQty(r.tiles, 'diamante.jungle_tree_of_life'), 3);

      // Workers: selector overrides base 4p reductions
      expect(_tileQty(r.tiles, 'base.worker_red_1-1-1-1'), 4);
      expect(_tileQty(r.tiles, 'base.worker_red_2-1-0-1'), 5);

      // New worker tiles added by NewWorkers handler for all 4 colors
      expect(_tileQty(r.tiles, 'diamante.worker_red_0-0-0-4'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_red_0-0-2-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_red_0-2-0-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_red_0-1-0-3'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_purple_0-0-0-4'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_purple_0-0-2-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_purple_0-2-0-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_purple_0-1-0-3'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_white_0-0-0-4'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_white_0-0-2-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_white_0-2-0-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_white_0-1-0-3'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_yellow_0-0-0-4'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_yellow_0-0-2-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_yellow_0-2-0-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_yellow_0-1-0-3'), 1);
    });
  });

  // ---------------------------------------------------------------------------
  // GRUP 5: Big Game variant (isBigGame = true)
  // ---------------------------------------------------------------------------
  group('GRUP 5: Big Game variant', () {
    final allChocolatlModules = [
      _mapModule,
      _wateringModule,
      _chocolateModule,
      _hutModule,
      _emperorModule,
    ];
    final allDiamanteModules = [
      _gemMinesModule,
      _treeOfLifeModule,
      _newWorkersModule,
    ];
    final allModules = [...allChocolatlModules, ...allDiamanteModules];

    test('Test 30 — Big Game, 3 players', () {
      final r = _runPipeline(
        players: _makePlayers(3),
        selectedColors: _selectedColors(3),
        activeModules: allModules,
        isBigGame: true,
      );

      // ---- Player Setup ----
      // Village board, carrier, field, tiles for each player
      expect(_hasStep(r.stepIds, 'setup_village_board_red'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_village_board_purple'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_village_board_white'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_tiles_red'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_tiles_purple'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_tiles_white'), isTrue);

      // Map tokens (3p → surplus exists)
      expect(_hasStep(r.stepIds, 'setup_map_tokens_red'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_map_tokens_purple'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_map_tokens_white'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_map_tokens_surplus'), isTrue);

      // NO worker removal steps at all (Big Game = no removals)
      expect(
        _hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_'),
        ),
        isFalse,
      );

      // NO new workers selection step (Big Game: returns early)
      expect(_hasStep(r.stepIds, 'setup_new_workers_selection'), isFalse);

      // NO tree of life 0-0-0-4 steps (Big Game: returns early)
      expect(
        _hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_tree_of_life_add_0004_'),
        ),
        isFalse,
      );

      // Shuffle workers
      expect(_hasStep(r.stepIds, 'setup_shuffle_workers'), isTrue);

      // ---- Board Setup ----
      // Starting tiles: plantation + water (watering modifies this in Big Game too)
      expect(
        _hasStep(r.stepIds, 'setup_initial_tiles_plantation_water'),
        isTrue,
      );
      expect(
        _hasStep(r.stepIds, 'setup_initial_tiles_plantation_market'),
        isFalse,
      );

      // Emperor after initial tiles
      expect(_hasStep(r.stepIds, 'setup_emperor'), isTrue);
      final initialIdx30 = _stepIndex(
        r.stepIds,
        'setup_initial_tiles_plantation_water',
      );
      final emperorIdx30 = _stepIndex(r.stepIds, 'setup_emperor');
      expect(emperorIdx30, initialIdx30 + 1);

      // NO 2p sort out steps
      expect(
        _hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_jungle_tiles_2p_'),
        ),
        isFalse,
      );

      // Big Game 3p removal steps ARE present
      expect(
        _hasStep(r.stepIds, 'setup_big_game_3p_removal_single_plantation'),
        isTrue,
      );
      expect(
        _hasStep(r.stepIds, 'setup_big_game_3p_removal_gold_mine_v1'),
        isTrue,
      );
      expect(
        _hasStep(r.stepIds, 'setup_big_game_3p_removal_market_selling_2'),
        isTrue,
      );
      expect(
        _hasStep(r.stepIds, 'setup_big_game_3p_removal_market_selling_3'),
        isTrue,
      );
      expect(_hasStep(r.stepIds, 'setup_big_game_3p_removal_watering'), isTrue);

      // NO module substitution steps (Big Game skips all substitutions)
      expect(
        _hasStep(r.stepIds, 'setup_watering_remove_single_plantation'),
        isFalse,
      );
      expect(
        _hasStep(r.stepIds, 'setup_watering_remove_double_plantation'),
        isFalse,
      );
      expect(_hasStep(r.stepIds, 'setup_watering_add_watering_tiles'), isFalse);
      expect(
        _hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v1'),
        isFalse,
      );
      expect(
        _hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v2'),
        isFalse,
      );
      expect(
        _hasStep(r.stepIds, 'setup_chocolate_remove_market_selling_3'),
        isFalse,
      );
      expect(_hasStep(r.stepIds, 'setup_chocolate_add_kitchen'), isFalse);
      expect(_hasStep(r.stepIds, 'setup_chocolate_add_market'), isFalse);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_remove_temples'), isFalse);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_add_gem_mines'), isFalse);
      expect(_hasStep(r.stepIds, 'setup_tree_of_life_add_tiles'), isFalse);
      expect(
        _hasStep(r.stepIds, 'setup_tree_of_life_remove_gold_mine_v1'),
        isFalse,
      );

      // Map board + jungle display map
      expect(_hasStep(r.stepIds, 'setup_map_board'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_jungle_display_map'), isTrue);

      // Huts market
      expect(_hasStep(r.stepIds, 'setup_huts_market'), isTrue);

      // ---- Supplies ----
      expect(_hasStep(r.stepIds, 'setup_resources_bank'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_chocolate_bars'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_mine_car'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_masks'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_rule_reminder'), isTrue);
      // No remove_gems step in Big Game (only in normal mode)
      expect(_hasStep(r.stepIds, 'setup_gem_mines_remove_gems'), isFalse);

      // ---- Jungle tile quantities (Big Game 3p removals applied) ----
      expect(_tileQty(r.tiles, 'base.jungle_single_plantation'), 4); // 6-2
      expect(
        _tileQty(r.tiles, 'base.jungle_double_plantation'),
        2,
      ); // no removal
      expect(_tileQty(r.tiles, 'base.jungle_market_selling_2'), 1); // 2-1
      expect(_tileQty(r.tiles, 'base.jungle_market_selling_3'), 3); // 4-1
      expect(_tileQty(r.tiles, 'base.jungle_market_selling_4'), 1);
      expect(_tileQty(r.tiles, 'base.jungle_gold_mine_value_1'), 0); // 2-2
      expect(_tileQty(r.tiles, 'base.jungle_gold_mine_value_2'), 2);
      expect(_tileQty(r.tiles, 'base.jungle_water'), 3);
      expect(_tileQty(r.tiles, 'base.jungle_sun_worshiping_site'), 2);
      expect(_tileQty(r.tiles, 'base.jungle_temple'), 5);
      expect(_tileQty(r.tiles, 'chocolatl.jungle_watering'), 2); // 3-1
      expect(_tileQty(r.tiles, 'chocolatl.jungle_chocolate_kitchen'), 3);
      expect(_tileQty(r.tiles, 'chocolatl.jungle_chocolate_market'), 3);
      expect(_tileQty(r.tiles, 'diamante.jungle_gem_mine'), 5);
      expect(_tileQty(r.tiles, 'diamante.jungle_tree_of_life'), 3);

      // ---- Worker quantities (NO removals in Big Game) ----
      // Base workers at full quantity for 3 colors
      expect(_tileQty(r.tiles, 'base.worker_red_1-1-1-1'), 4);
      expect(_tileQty(r.tiles, 'base.worker_red_2-1-0-1'), 5);
      expect(_tileQty(r.tiles, 'base.worker_red_3-0-0-1'), 1);
      expect(_tileQty(r.tiles, 'base.worker_red_3-1-0-0'), 1);
      expect(_tileQty(r.tiles, 'base.worker_purple_1-1-1-1'), 4);
      expect(_tileQty(r.tiles, 'base.worker_purple_2-1-0-1'), 5);
      expect(_tileQty(r.tiles, 'base.worker_white_1-1-1-1'), 4);
      expect(_tileQty(r.tiles, 'base.worker_white_2-1-0-1'), 5);

      // New worker tiles loaded by base handler (isBigGame || moduleId == null)
      expect(_tileQty(r.tiles, 'diamante.worker_red_0-0-0-4'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_red_0-0-2-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_red_0-2-0-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_red_0-1-0-3'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_purple_0-0-0-4'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_purple_0-0-2-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_purple_0-2-0-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_purple_0-1-0-3'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_white_0-0-0-4'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_white_0-0-2-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_white_0-2-0-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_white_0-1-0-3'), 1);

      // No yellow workers (only 3 players)
      expect(_tileQty(r.tiles, 'base.worker_yellow_1-1-1-1'), 0);
      expect(_tileQty(r.tiles, 'diamante.worker_yellow_0-0-0-4'), 0);

      // Hut tiles present (loaded by base handler color == null filter)
      final hutTiles30 = r.tiles.where((t) => t.type == TileType.hut);
      final totalHuts30 = hutTiles30.fold(0, (sum, t) => sum + t.quantity);
      expect(totalHuts30, 14);
    });

    test('Test 31 — Big Game, 4 players', () {
      final r = _runPipeline(
        players: _makePlayers(4),
        selectedColors: _selectedColors(4),
        activeModules: allModules,
        isBigGame: true,
      );

      // ---- Player Setup ----
      // Village board, carrier, field, tiles for each player
      expect(_hasStep(r.stepIds, 'setup_village_board_red'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_village_board_purple'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_village_board_white'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_village_board_yellow'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_tiles_red'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_tiles_yellow'), isTrue);

      // Map tokens, NO surplus (4 players)
      expect(_hasStep(r.stepIds, 'setup_map_tokens_red'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_map_tokens_yellow'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_map_tokens_surplus'), isFalse);

      // NO worker removal steps at all
      expect(
        _hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_'),
        ),
        isFalse,
      );

      // NO new workers selection step
      expect(_hasStep(r.stepIds, 'setup_new_workers_selection'), isFalse);

      // NO tree of life 0-0-0-4 steps
      expect(
        _hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_tree_of_life_add_0004_'),
        ),
        isFalse,
      );

      // Shuffle workers
      expect(_hasStep(r.stepIds, 'setup_shuffle_workers'), isTrue);

      // ---- Board Setup ----
      // Starting tiles: plantation + water (watering modifies)
      expect(
        _hasStep(r.stepIds, 'setup_initial_tiles_plantation_water'),
        isTrue,
      );
      expect(
        _hasStep(r.stepIds, 'setup_initial_tiles_plantation_market'),
        isFalse,
      );

      // Emperor after initial tiles
      expect(_hasStep(r.stepIds, 'setup_emperor'), isTrue);
      final initialIdx31 = _stepIndex(
        r.stepIds,
        'setup_initial_tiles_plantation_water',
      );
      final emperorIdx31 = _stepIndex(r.stepIds, 'setup_emperor');
      expect(emperorIdx31, initialIdx31 + 1);

      // NO 2p sort out steps
      expect(
        _hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_jungle_tiles_2p_'),
        ),
        isFalse,
      );

      // NO Big Game 3p removal steps (4 players = ALL tiles)
      expect(
        _hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_big_game_3p_'),
        ),
        isFalse,
      );

      // NO module substitution steps
      expect(
        _hasStep(r.stepIds, 'setup_watering_remove_single_plantation'),
        isFalse,
      );
      expect(
        _hasStep(r.stepIds, 'setup_watering_remove_double_plantation'),
        isFalse,
      );
      expect(_hasStep(r.stepIds, 'setup_watering_add_watering_tiles'), isFalse);
      expect(
        _hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v1'),
        isFalse,
      );
      expect(
        _hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v2'),
        isFalse,
      );
      expect(
        _hasStep(r.stepIds, 'setup_chocolate_remove_market_selling_3'),
        isFalse,
      );
      expect(_hasStep(r.stepIds, 'setup_chocolate_add_kitchen'), isFalse);
      expect(_hasStep(r.stepIds, 'setup_chocolate_add_market'), isFalse);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_remove_temples'), isFalse);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_add_gem_mines'), isFalse);
      expect(_hasStep(r.stepIds, 'setup_tree_of_life_add_tiles'), isFalse);

      // Map board + jungle display map
      expect(_hasStep(r.stepIds, 'setup_map_board'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_jungle_display_map'), isTrue);

      // Huts market
      expect(_hasStep(r.stepIds, 'setup_huts_market'), isTrue);

      // ---- Supplies ----
      expect(_hasStep(r.stepIds, 'setup_resources_bank'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_chocolate_bars'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_mine_car'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_masks'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_rule_reminder'), isTrue);
      expect(_hasStep(r.stepIds, 'setup_gem_mines_remove_gems'), isFalse);

      // ---- Jungle tile quantities (NO removals for 4p Big Game) ----
      expect(_tileQty(r.tiles, 'base.jungle_single_plantation'), 6);
      expect(_tileQty(r.tiles, 'base.jungle_double_plantation'), 2);
      expect(_tileQty(r.tiles, 'base.jungle_market_selling_2'), 2);
      expect(_tileQty(r.tiles, 'base.jungle_market_selling_3'), 4);
      expect(_tileQty(r.tiles, 'base.jungle_market_selling_4'), 1);
      expect(_tileQty(r.tiles, 'base.jungle_gold_mine_value_1'), 2);
      expect(_tileQty(r.tiles, 'base.jungle_gold_mine_value_2'), 2);
      expect(_tileQty(r.tiles, 'base.jungle_water'), 3);
      expect(_tileQty(r.tiles, 'base.jungle_sun_worshiping_site'), 2);
      expect(_tileQty(r.tiles, 'base.jungle_temple'), 5);
      expect(_tileQty(r.tiles, 'chocolatl.jungle_watering'), 3);
      expect(_tileQty(r.tiles, 'chocolatl.jungle_chocolate_kitchen'), 3);
      expect(_tileQty(r.tiles, 'chocolatl.jungle_chocolate_market'), 3);
      expect(_tileQty(r.tiles, 'diamante.jungle_gem_mine'), 5);
      expect(_tileQty(r.tiles, 'diamante.jungle_tree_of_life'), 3);

      // ---- Worker quantities (NO removals, all 4 colors) ----
      expect(_tileQty(r.tiles, 'base.worker_red_1-1-1-1'), 4);
      expect(_tileQty(r.tiles, 'base.worker_red_2-1-0-1'), 5);
      expect(_tileQty(r.tiles, 'base.worker_red_3-0-0-1'), 1);
      expect(_tileQty(r.tiles, 'base.worker_red_3-1-0-0'), 1);
      expect(_tileQty(r.tiles, 'base.worker_purple_1-1-1-1'), 4);
      expect(_tileQty(r.tiles, 'base.worker_purple_2-1-0-1'), 5);
      expect(_tileQty(r.tiles, 'base.worker_white_1-1-1-1'), 4);
      expect(_tileQty(r.tiles, 'base.worker_white_2-1-0-1'), 5);
      expect(_tileQty(r.tiles, 'base.worker_yellow_1-1-1-1'), 4);
      expect(_tileQty(r.tiles, 'base.worker_yellow_2-1-0-1'), 5);

      // New worker tiles for all 4 colors
      expect(_tileQty(r.tiles, 'diamante.worker_red_0-0-0-4'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_red_0-0-2-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_red_0-2-0-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_red_0-1-0-3'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_purple_0-0-0-4'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_purple_0-0-2-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_purple_0-2-0-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_purple_0-1-0-3'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_white_0-0-0-4'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_white_0-0-2-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_white_0-2-0-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_white_0-1-0-3'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_yellow_0-0-0-4'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_yellow_0-0-2-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_yellow_0-2-0-2'), 1);
      expect(_tileQty(r.tiles, 'diamante.worker_yellow_0-1-0-3'), 1);

      // Hut tiles present
      final hutTiles31 = r.tiles.where((t) => t.type == TileType.hut);
      final totalHuts31 = hutTiles31.fold(0, (sum, t) => sum + t.quantity);
      expect(totalHuts31, 14);
    });
  });

  // ---------------------------------------------------------------------------
  // GRUP 5: New Workers module conflict resolution
  // ---------------------------------------------------------------------------
  group('GRUP 5: New Workers module conflict resolution', () {
    test('Test 32 — New Workers 3p addAll: removes base removal steps', () {
      final diamanteExp = _createDiamanteExpansion(
        selectedColors: _selectedColors(3),
        modules: [_newWorkersModule],
      );
      final r = _runPipeline(
        players: _makePlayers(3),
        selectedColors: _selectedColors(3),
        activeModules: [_newWorkersModule],
        expansions: [diamanteExp],
        workerSelection: const WorkerSelectionEntity(
          mode: WorkerSelectionMode.preset,
          presetType: WorkerPresetType.addAll,
        ),
      );

      // Selector is authoritative — all base removal steps removed
      expect(
        _hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_1_'),
        ),
        isFalse,
      );

      // New workers selection step is present
      expect(_hasStep(r.stepIds, 'setup_new_workers_selection'), isTrue);

      // Tile quantities: selector overrides base 3p reduction (4, not 3)
      expect(_tileQty(r.tiles, 'base.worker_red_1-1-1-1'), 4);
    });

    test(
      'Test 33 — New Workers 3p replaceWithNew: removes base removal step',
      () {
        final diamanteExp = _createDiamanteExpansion(
          selectedColors: _selectedColors(3),
          modules: [_newWorkersModule],
        );
        final r = _runPipeline(
          players: _makePlayers(3),
          selectedColors: _selectedColors(3),
          activeModules: [_newWorkersModule],
          expansions: [diamanteExp],
          workerSelection: const WorkerSelectionEntity(
            mode: WorkerSelectionMode.preset,
            presetType: WorkerPresetType.replaceWithNew,
          ),
        );

        // replaceWithNew sets 1-1-1-1 to 0 (≠ default 4), so removal steps gone
        expect(
          _hasAnyStepMatching(
            r.stepIds,
            (id) => id.startsWith('setup_remove_worker_1_'),
          ),
          isFalse,
        );

        // Selection step present
        expect(_hasStep(r.stepIds, 'setup_new_workers_selection'), isTrue);

        // Tile: 1-1-1-1 set to 0
        expect(_tileQty(r.tiles, 'base.worker_red_1-1-1-1'), 0);

        // New tiles added
        expect(_tileQty(r.tiles, 'diamante.worker_red_0-0-0-4'), 1);
        expect(_tileQty(r.tiles, 'diamante.worker_red_0-0-2-2'), 1);
      },
    );

    test(
      'Test 34 — New Workers 4p replaceWithNew: removes both removal steps',
      () {
        final diamanteExp = _createDiamanteExpansion(
          selectedColors: _selectedColors(4),
          modules: [_newWorkersModule],
        );
        final r = _runPipeline(
          players: _makePlayers(4),
          selectedColors: _selectedColors(4),
          activeModules: [_newWorkersModule],
          expansions: [diamanteExp],
          workerSelection: const WorkerSelectionEntity(
            mode: WorkerSelectionMode.preset,
            presetType: WorkerPresetType.replaceWithNew,
          ),
        );

        // Both removal step types removed (selector is always authoritative)
        expect(
          _hasAnyStepMatching(
            r.stepIds,
            (id) => id.startsWith('setup_remove_worker_1_'),
          ),
          isFalse,
        );

        // Selector removes all base removal steps unconditionally
        expect(
          _hasAnyStepMatching(
            r.stepIds,
            (id) => id.startsWith('setup_remove_worker_2_'),
          ),
          isFalse,
        );
      },
    );

    test('Test 35 — New Workers 4p manual both changed: removes both', () {
      final diamanteExp = _createDiamanteExpansion(
        selectedColors: _selectedColors(4),
        modules: [_newWorkersModule],
      );
      final r = _runPipeline(
        players: _makePlayers(4),
        selectedColors: _selectedColors(4),
        activeModules: [_newWorkersModule],
        expansions: [diamanteExp],
        workerSelection: const WorkerSelectionEntity(
          mode: WorkerSelectionMode.manual,
          tileQuantities: {
            '1-1-1-1': 2,
            '2-1-0-1': 3,
            '3-0-0-1': 1,
            '3-1-0-0': 1,
            '0-0-0-4': 1,
            '0-0-2-2': 1,
            '0-2-0-2': 1,
            '0-1-0-3': 1,
          },
        ),
      );

      // Both removal steps removed (both quantities differ from defaults)
      expect(
        _hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_1_'),
        ),
        isFalse,
      );
      expect(
        _hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_2_'),
        ),
        isFalse,
      );

      // Tiles: overridden to manual quantities
      expect(_tileQty(r.tiles, 'base.worker_red_1-1-1-1'), 2);
      expect(_tileQty(r.tiles, 'base.worker_red_2-1-0-1'), 3);
    });

    test(
      'Test 36 — Tree of Life + New Workers 2p: removes Tree of Life 0-0-0-4 step',
      () {
        final diamanteExp = _createDiamanteExpansion(
          selectedColors: _selectedColors(2),
          modules: [_treeOfLifeModule, _newWorkersModule],
        );
        final r = _runPipeline(
          players: _makePlayers(2),
          selectedColors: _selectedColors(2),
          activeModules: [_treeOfLifeModule, _newWorkersModule],
          expansions: [diamanteExp],
          workerSelection: const WorkerSelectionEntity(
            mode: WorkerSelectionMode.preset,
            presetType: WorkerPresetType.addAll,
          ),
        );

        // Tree of Life's per-player 0-0-0-4 step removed by New Workers handler
        expect(
          _hasAnyStepMatching(
            r.stepIds,
            (id) => id.startsWith('setup_tree_of_life_add_0004_'),
          ),
          isFalse,
        );

        // New workers selection step present instead
        expect(_hasStep(r.stepIds, 'setup_new_workers_selection'), isTrue);

        // Tree of Life jungle steps still present
        expect(_hasStep(r.stepIds, 'setup_tree_of_life_add_tiles'), isTrue);

        // 0-0-0-4 tile still in the pool (handled by selector)
        expect(_tileQty(r.tiles, 'diamante.worker_red_0-0-0-4'), 1);
        expect(_tileQty(r.tiles, 'diamante.worker_purple_0-0-0-4'), 1);
      },
    );

    test(
      'Test 37 — Tree of Life + New Workers 4p: removes worker_1 if selection changes 1-1-1-1',
      () {
        final diamanteExp = _createDiamanteExpansion(
          selectedColors: _selectedColors(4),
          modules: [_treeOfLifeModule, _newWorkersModule],
        );
        final r = _runPipeline(
          players: _makePlayers(4),
          selectedColors: _selectedColors(4),
          activeModules: [_treeOfLifeModule, _newWorkersModule],
          expansions: [diamanteExp],
          workerSelection: const WorkerSelectionEntity(
            mode: WorkerSelectionMode.preset,
            presetType: WorkerPresetType.replaceWithNew,
          ),
        );

        // New Workers handler removes all base removal steps unconditionally
        expect(
          _hasAnyStepMatching(
            r.stepIds,
            (id) => id.startsWith('setup_remove_worker_1_'),
          ),
          isFalse,
        );

        // Both handlers remove setup_remove_worker_2_ (Tree of Life 4p + New Workers)
        expect(
          _hasAnyStepMatching(
            r.stepIds,
            (id) => id.startsWith('setup_remove_worker_2_'),
          ),
          isFalse,
        );

        // Selection step present
        expect(_hasStep(r.stepIds, 'setup_new_workers_selection'), isTrue);

        // 1-1-1-1 tiles gone
        expect(_tileQty(r.tiles, 'base.worker_red_1-1-1-1'), 0);
      },
    );

    test('Test 38 — New Workers 3p baseOnly: removes base removal steps', () {
      final diamanteExp = _createDiamanteExpansion(
        selectedColors: _selectedColors(3),
        modules: [_newWorkersModule],
      );
      final r = _runPipeline(
        players: _makePlayers(3),
        selectedColors: _selectedColors(3),
        activeModules: [_newWorkersModule],
        expansions: [diamanteExp],
        workerSelection: const WorkerSelectionEntity(
          mode: WorkerSelectionMode.preset,
          presetType: WorkerPresetType.baseOnly,
        ),
      );

      // Selector is authoritative — all base removal steps removed
      expect(
        _hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_1_'),
        ),
        isFalse,
      );

      // No new worker tiles in pool
      expect(_tileQty(r.tiles, 'diamante.worker_red_0-0-0-4'), 0);
      expect(_tileQty(r.tiles, 'diamante.worker_red_0-0-2-2'), 0);
    });

    test(
      'Test 39 — Toggle order independence: [NW, ToL] 2p addAll same as [ToL, NW]',
      () {
        // User toggled New Workers BEFORE Tree of Life. The pipeline must
        // run handlers in moduleId order (6 before 8) regardless, otherwise
        // the 0-0-0-4 tile gets duplicated and Tree of Life re-inserts the
        // per-player steps that New Workers subsumes.
        final diamanteExp = _createDiamanteExpansion(
          selectedColors: _selectedColors(2),
          modules: [_newWorkersModule, _treeOfLifeModule],
        );
        final r = _runPipeline(
          players: _makePlayers(2),
          selectedColors: _selectedColors(2),
          activeModules: [_newWorkersModule, _treeOfLifeModule],
          expansions: [diamanteExp],
          workerSelection: const WorkerSelectionEntity(
            mode: WorkerSelectionMode.preset,
            presetType: WorkerPresetType.addAll,
          ),
        );

        // Exactly one 0-0-0-4 per player (no duplicate entry from ToL)
        expect(_tileQty(r.tiles, 'diamante.worker_red_0-0-0-4'), 1);
        expect(_tileQty(r.tiles, 'diamante.worker_purple_0-0-0-4'), 1);

        // Tree of Life's per-player steps stay removed
        expect(
          _hasAnyStepMatching(
            r.stepIds,
            (id) => id.startsWith('setup_tree_of_life_add_0004_'),
          ),
          isFalse,
        );
        expect(_hasStep(r.stepIds, 'setup_new_workers_selection'), isTrue);
      },
    );

    test(
      'Test 40 — Toggle order independence: [NW, ToL] 3p addAll keeps 1-1-1-1 at 4',
      () {
        // With handlers unsorted, Tree of Life (3p) would "restore" one
        // 1-1-1-1 AFTER the selector already set it to 4, yielding an
        // impossible quantity of 5 (only 4 copies exist per player).
        final diamanteExp = _createDiamanteExpansion(
          selectedColors: _selectedColors(3),
          modules: [_newWorkersModule, _treeOfLifeModule],
        );
        final r = _runPipeline(
          players: _makePlayers(3),
          selectedColors: _selectedColors(3),
          activeModules: [_newWorkersModule, _treeOfLifeModule],
          expansions: [diamanteExp],
          workerSelection: const WorkerSelectionEntity(
            mode: WorkerSelectionMode.preset,
            presetType: WorkerPresetType.addAll,
          ),
        );

        expect(_tileQty(r.tiles, 'base.worker_red_1-1-1-1'), 4);
        expect(_tileQty(r.tiles, 'base.worker_white_1-1-1-1'), 4);
      },
    );

    test(
      'Test 41 — Tree of Life + New Workers 2p baseOnly: keeps mandatory 0-0-0-4',
      () {
        // Diamante rulebook (p. 3): with Tree of Life at 2 players, each
        // player MUST take their 0-0-0-4 tile from the New Workers module.
        // The baseOnly preset must not drop it.
        final diamanteExp = _createDiamanteExpansion(
          selectedColors: _selectedColors(2),
          modules: [_treeOfLifeModule, _newWorkersModule],
        );
        final r = _runPipeline(
          players: _makePlayers(2),
          selectedColors: _selectedColors(2),
          activeModules: [_treeOfLifeModule, _newWorkersModule],
          expansions: [diamanteExp],
          workerSelection: const WorkerSelectionEntity(
            mode: WorkerSelectionMode.preset,
            presetType: WorkerPresetType.baseOnly,
          ),
        );

        expect(_tileQty(r.tiles, 'diamante.worker_red_0-0-0-4'), 1);
        expect(_tileQty(r.tiles, 'diamante.worker_purple_0-0-0-4'), 1);

        // Other new worker tiles stay excluded by the preset
        expect(_tileQty(r.tiles, 'diamante.worker_red_0-0-2-2'), 0);
        expect(_tileQty(r.tiles, 'diamante.worker_red_0-2-0-2'), 0);
        expect(_tileQty(r.tiles, 'diamante.worker_red_0-1-0-3'), 0);
      },
    );

    test(
      'Test 42 — New Workers 2p baseWith0004: base tiles plus only 0-0-0-4',
      () {
        final diamanteExp = _createDiamanteExpansion(
          selectedColors: _selectedColors(2),
          modules: [_newWorkersModule],
        );
        final r = _runPipeline(
          players: _makePlayers(2),
          selectedColors: _selectedColors(2),
          activeModules: [_newWorkersModule],
          expansions: [diamanteExp],
          workerSelection: const WorkerSelectionEntity(
            mode: WorkerSelectionMode.preset,
            presetType: WorkerPresetType.baseWith0004,
          ),
        );

        // Base tiles at default quantities
        expect(_tileQty(r.tiles, 'base.worker_red_1-1-1-1'), 4);
        expect(_tileQty(r.tiles, 'base.worker_red_2-1-0-1'), 5);
        expect(_tileQty(r.tiles, 'base.worker_red_3-0-0-1'), 1);
        expect(_tileQty(r.tiles, 'base.worker_red_3-1-0-0'), 1);

        // Only the 0-0-0-4 new tile added (12 per player total)
        expect(_tileQty(r.tiles, 'diamante.worker_red_0-0-0-4'), 1);
        expect(_tileQty(r.tiles, 'diamante.worker_red_0-0-2-2'), 0);
        expect(_tileQty(r.tiles, 'diamante.worker_red_0-2-0-2'), 0);
        expect(_tileQty(r.tiles, 'diamante.worker_red_0-1-0-3'), 0);
      },
    );
  });
}
