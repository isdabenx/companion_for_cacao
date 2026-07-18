// ignore_for_file: lines_longer_than_80_chars
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/worker_selection_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/game_fixtures.dart';

// =============================================================================
// Tests
// =============================================================================

void main() {
  // ---------------------------------------------------------------------------
  // GRUP 1: Base Game
  // ---------------------------------------------------------------------------
  group('GRUP 1: Base Game (no modules)', () {
    test('Test 1 — Base, 2 players', () {
      final r = runPipeline(
        players: makePlayers(2),
        selectedColors: selectedColors(2),
        activeModules: [],
      );

      // Player setup: village board, carrier, field, tiles for each player
      expect(hasStep(r.stepIds, 'setup_village_board_red'), isTrue);
      expect(hasStep(r.stepIds, 'setup_village_board_purple'), isTrue);
      expect(hasStep(r.stepIds, 'setup_tiles_red'), isTrue);
      expect(hasStep(r.stepIds, 'setup_tiles_purple'), isTrue);

      // NO worker removal steps for 2 players
      expect(
        hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_'),
        ),
        isFalse,
      );

      // Shuffle workers
      expect(hasStep(r.stepIds, 'setup_shuffle_workers'), isTrue);

      // Starting tiles
      expect(
        hasStep(r.stepIds, 'setup_initial_tiles_plantation_market'),
        isTrue,
      );

      // 6 sort out jungle tiles steps for 2p
      expect(
        hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_single_plantation'),
        isTrue,
      );
      expect(
        hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_market_selling_3'),
        isTrue,
      );
      expect(
        hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_gold_mine_value_1'),
        isTrue,
      );
      expect(hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_water'), isTrue);
      expect(
        hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_sun_worshiping_site'),
        isTrue,
      );
      expect(
        hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_temple'),
        isTrue,
      );

      // Sort outs BEFORE jungle draw pile
      final drawPileIdx = stepIndex(r.stepIds, 'setup_jungle_draw_pile');
      expect(
        stepIndex(r.stepIds, 'setup_jungle_tiles_2p_removal_single_plantation'),
        lessThan(drawPileIdx),
      );

      // Jungle draw pile + display
      expect(hasStep(r.stepIds, 'setup_jungle_draw_pile'), isTrue);
      expect(hasStep(r.stepIds, 'setup_jungle_display'), isTrue);

      // Supplies
      expect(hasStep(r.stepIds, 'setup_resources_bank'), isTrue);

      // Tile quantities: 2p reductions applied
      expect(tileQty(r.tiles, 'base.jungle_single_plantation'), 4); // 6-2
      expect(tileQty(r.tiles, 'base.jungle_market_selling_3'), 3); // 4-1
      expect(tileQty(r.tiles, 'base.jungle_gold_mine_value_1'), 1); // 2-1
      expect(tileQty(r.tiles, 'base.jungle_water'), 2); // 3-1
      expect(tileQty(r.tiles, 'base.jungle_sun_worshiping_site'), 1); // 2-1
      expect(tileQty(r.tiles, 'base.jungle_temple'), 4); // 5-1
    });

    test('Test 2 — Base, 3 players', () {
      final r = runPipeline(
        players: makePlayers(3),
        selectedColors: selectedColors(3),
        activeModules: [],
      );

      // Worker removal: 1x 1-1-1-1 per player
      expect(hasStep(r.stepIds, 'setup_remove_worker_1_red'), isTrue);
      expect(hasStep(r.stepIds, 'setup_remove_worker_1_purple'), isTrue);
      expect(hasStep(r.stepIds, 'setup_remove_worker_1_white'), isTrue);

      // NO 2-1-0-1 removal
      expect(
        hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_2_'),
        ),
        isFalse,
      );

      // NO 2p sort out steps
      expect(
        hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_jungle_tiles_2p_'),
        ),
        isFalse,
      );

      // Worker quantities: 1-1-1-1 reduced by 1
      expect(tileQty(r.tiles, 'base.worker_red_1-1-1-1'), 3);
      expect(tileQty(r.tiles, 'base.worker_purple_1-1-1-1'), 3);
      expect(tileQty(r.tiles, 'base.worker_white_1-1-1-1'), 3);

      // 2-1-0-1 unchanged
      expect(tileQty(r.tiles, 'base.worker_red_2-1-0-1'), 5);

      // Jungle tile quantities: full (no 2p reductions)
      expect(tileQty(r.tiles, 'base.jungle_single_plantation'), 6);
      expect(tileQty(r.tiles, 'base.jungle_temple'), 5);
    });

    test('Test 3 — Base, 4 players', () {
      final r = runPipeline(
        players: makePlayers(4),
        selectedColors: selectedColors(4),
        activeModules: [],
      );

      // Worker removal: 1-1-1-1 per player
      expect(hasStep(r.stepIds, 'setup_remove_worker_1_red'), isTrue);
      expect(hasStep(r.stepIds, 'setup_remove_worker_1_yellow'), isTrue);

      // AND 2-1-0-1 per player
      expect(hasStep(r.stepIds, 'setup_remove_worker_2_red'), isTrue);
      expect(hasStep(r.stepIds, 'setup_remove_worker_2_yellow'), isTrue);

      // Worker quantities: both reduced
      expect(tileQty(r.tiles, 'base.worker_red_1-1-1-1'), 3);
      expect(tileQty(r.tiles, 'base.worker_red_2-1-0-1'), 4);
    });
  });

  // ---------------------------------------------------------------------------
  // GRUP 2: Individual modules
  // ---------------------------------------------------------------------------
  group('GRUP 2: Individual modules', () {
    test('Test 4 — Map Module, 2 players', () {
      final r = runPipeline(
        players: makePlayers(2),
        selectedColors: selectedColors(2),
        activeModules: [mapModule],
      );

      // Map tokens per player
      expect(hasStep(r.stepIds, 'setup_map_tokens_red'), isTrue);
      expect(hasStep(r.stepIds, 'setup_map_tokens_purple'), isTrue);

      // Surplus step (< 4 players)
      expect(hasStep(r.stepIds, 'setup_map_tokens_surplus'), isTrue);

      // Map board + display
      expect(hasStep(r.stepIds, 'setup_map_board'), isTrue);
      expect(hasStep(r.stepIds, 'setup_jungle_display_map'), isTrue);

      // Original jungle display replaced
      expect(hasStep(r.stepIds, 'setup_jungle_display'), isFalse);
    });

    test('Test 5 — Map Module, 4 players', () {
      final r = runPipeline(
        players: makePlayers(4),
        selectedColors: selectedColors(4),
        activeModules: [mapModule],
      );

      // Map tokens per player
      expect(hasStep(r.stepIds, 'setup_map_tokens_red'), isTrue);
      expect(hasStep(r.stepIds, 'setup_map_tokens_yellow'), isTrue);

      // NO surplus step (4 players = 0 surplus)
      expect(hasStep(r.stepIds, 'setup_map_tokens_surplus'), isFalse);
    });

    test('Test 6 — Watering Module, 2 players', () {
      final chocolatlExp = createChocolatlExpansion(
        selectedColors: selectedColors(2),
        modules: [wateringModule],
      );
      final r = runPipeline(
        players: makePlayers(2),
        selectedColors: selectedColors(2),
        activeModules: [wateringModule],
        expansions: [chocolatlExp],
      );

      // Starting tile changed to water
      expect(
        hasStep(r.stepIds, 'setup_initial_tiles_plantation_water'),
        isTrue,
      );
      expect(
        hasStep(r.stepIds, 'setup_initial_tiles_plantation_market'),
        isFalse,
      );

      // Substitution steps
      expect(
        hasStep(r.stepIds, 'setup_watering_remove_double_plantation'),
        isTrue,
      );
      expect(hasStep(r.stepIds, 'setup_watering_add_watering_tiles'), isTrue);

      // NO single plantation removal for 2p watering
      expect(
        hasStep(r.stepIds, 'setup_watering_remove_single_plantation'),
        isFalse,
      );

      // Steps before draw pile
      final drawPileIdx = stepIndex(r.stepIds, 'setup_jungle_draw_pile');
      expect(
        stepIndex(r.stepIds, 'setup_watering_remove_double_plantation'),
        lessThan(drawPileIdx),
      );

      // Tiles: 2 double plantations removed, 2 watering added
      expect(tileQty(r.tiles, 'base.jungle_double_plantation'), 0); // 2-2=0
      expect(tileQty(r.tiles, 'chocolatl.jungle_watering'), 2);
    });

    test('Test 7 — Watering Module, 3 players', () {
      final chocolatlExp = createChocolatlExpansion(
        selectedColors: selectedColors(3),
        modules: [wateringModule],
      );
      final r = runPipeline(
        players: makePlayers(3),
        selectedColors: selectedColors(3),
        activeModules: [wateringModule],
        expansions: [chocolatlExp],
      );

      // Starting tile changed
      expect(
        hasStep(r.stepIds, 'setup_initial_tiles_plantation_water'),
        isTrue,
      );

      // 3 substitution steps
      expect(
        hasStep(r.stepIds, 'setup_watering_remove_single_plantation'),
        isTrue,
      );
      expect(
        hasStep(r.stepIds, 'setup_watering_remove_double_plantation'),
        isTrue,
      );
      expect(hasStep(r.stepIds, 'setup_watering_add_watering_tiles'), isTrue);

      // Tiles: 1 single + 2 double removed, 3 watering added
      expect(tileQty(r.tiles, 'base.jungle_single_plantation'), 5); // 6-1
      expect(tileQty(r.tiles, 'base.jungle_double_plantation'), 0); // 2-2
      expect(tileQty(r.tiles, 'chocolatl.jungle_watering'), 3);
    });

    test('Test 8 — Chocolate Module, 2 players', () {
      final chocolatlExp = createChocolatlExpansion(
        selectedColors: selectedColors(2),
        modules: [chocolateModule],
      );
      final r = runPipeline(
        players: makePlayers(2),
        selectedColors: selectedColors(2),
        activeModules: [chocolateModule],
        expansions: [chocolatlExp],
      );

      // Base 2p gold mine v1 step modified to 2x (base 1 + chocolate 1)
      // Base 2p market selling 3 step modified to 3x (base 1 + chocolate 2)
      // These are the modified base steps, still with same IDs
      expect(
        hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_gold_mine_value_1'),
        isTrue,
      );
      expect(
        hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_market_selling_3'),
        isTrue,
      );

      // New chocolate-specific steps
      expect(hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v2'), isTrue);
      expect(hasStep(r.stepIds, 'setup_chocolate_add_kitchen'), isTrue);
      expect(hasStep(r.stepIds, 'setup_chocolate_add_market'), isTrue);

      // Steps before draw pile
      final drawPileIdx = stepIndex(r.stepIds, 'setup_jungle_draw_pile');
      expect(
        stepIndex(r.stepIds, 'setup_chocolate_remove_gold_mine_v2'),
        lessThan(drawPileIdx),
      );
      expect(
        stepIndex(r.stepIds, 'setup_chocolate_add_kitchen'),
        lessThan(drawPileIdx),
      );

      // Chocolate bars in supplies
      expect(hasStep(r.stepIds, 'setup_chocolate_bars'), isTrue);

      // Tiles: gold mines and markets reduced, chocolate tiles added
      expect(
        tileQty(r.tiles, 'base.jungle_gold_mine_value_1'),
        0,
      ); // 2-1(base)-1(choc)=0
      expect(
        tileQty(r.tiles, 'base.jungle_gold_mine_value_2'),
        1,
      ); // 2-1(choc)=1
      expect(
        tileQty(r.tiles, 'base.jungle_market_selling_3'),
        1,
      ); // 4-1(base)-2(choc)=1
      expect(tileQty(r.tiles, 'chocolatl.jungle_chocolate_kitchen'), 2);
      expect(tileQty(r.tiles, 'chocolatl.jungle_chocolate_market'), 2);
    });

    test('Test 9 — Chocolate Module, 3 players', () {
      final chocolatlExp = createChocolatlExpansion(
        selectedColors: selectedColors(3),
        modules: [chocolateModule],
      );
      final r = runPipeline(
        players: makePlayers(3),
        selectedColors: selectedColors(3),
        activeModules: [chocolateModule],
        expansions: [chocolatlExp],
      );

      // 5 new steps (no base 2p steps to modify)
      expect(hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v1'), isTrue);
      expect(hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v2'), isTrue);
      expect(
        hasStep(r.stepIds, 'setup_chocolate_remove_market_selling_3'),
        isTrue,
      );
      expect(hasStep(r.stepIds, 'setup_chocolate_add_kitchen'), isTrue);
      expect(hasStep(r.stepIds, 'setup_chocolate_add_market'), isTrue);

      // Chocolate bars
      expect(hasStep(r.stepIds, 'setup_chocolate_bars'), isTrue);

      // Tiles
      expect(tileQty(r.tiles, 'base.jungle_gold_mine_value_1'), 0); // 2-2=0
      expect(tileQty(r.tiles, 'base.jungle_gold_mine_value_2'), 1); // 2-1=1
      expect(tileQty(r.tiles, 'base.jungle_market_selling_3'), 1); // 4-3=1
      expect(tileQty(r.tiles, 'chocolatl.jungle_chocolate_kitchen'), 3);
      expect(tileQty(r.tiles, 'chocolatl.jungle_chocolate_market'), 3);
    });

    test('Test 10 — Hut Module, 2 players', () {
      final chocolatlExp = createChocolatlExpansion(
        selectedColors: selectedColors(2),
        modules: [hutModule],
      );
      final r = runPipeline(
        players: makePlayers(2),
        selectedColors: selectedColors(2),
        activeModules: [hutModule],
        expansions: [chocolatlExp],
      );

      // Huts market setup step
      expect(hasStep(r.stepIds, 'setup_huts_market'), isTrue);

      // 14 hut tiles in the pool (per tiles.json data)
      final hutTiles = r.tiles.where((t) => t.type == TileType.hut);
      final totalHuts = hutTiles.fold(0, (sum, t) => sum + t.quantity);
      expect(totalHuts, 14);
    });

    test('Test 11 — Gem Mines Module, 2 players', () {
      final diamanteExp = createDiamanteExpansion(
        selectedColors: selectedColors(2),
        modules: [gemMinesModule],
      );
      final r = runPipeline(
        players: makePlayers(2),
        selectedColors: selectedColors(2),
        activeModules: [gemMinesModule],
        expansions: [diamanteExp],
      );

      // Base temple removal step eliminated
      expect(
        hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_temple'),
        isFalse,
      );

      // Gem mines steps
      expect(hasStep(r.stepIds, 'setup_gem_mines_remove_temples'), isTrue);
      expect(hasStep(r.stepIds, 'setup_gem_mines_add_gem_mines'), isTrue);

      // Before draw pile
      final drawPileIdx = stepIndex(r.stepIds, 'setup_jungle_draw_pile');
      expect(
        stepIndex(r.stepIds, 'setup_gem_mines_remove_temples'),
        lessThan(drawPileIdx),
      );

      // Supplies
      expect(hasStep(r.stepIds, 'setup_gem_mines_remove_gems'), isTrue);
      expect(hasStep(r.stepIds, 'setup_gem_mines_mine_car'), isTrue);
      expect(hasStep(r.stepIds, 'setup_gem_mines_masks'), isTrue);
      expect(hasStep(r.stepIds, 'setup_gem_mines_rule_reminder'), isTrue);

      // Tiles: all temples gone, 4 gem mines (5-1 for 2p)
      expect(tileQty(r.tiles, 'base.jungle_temple'), 0);
      expect(tileQty(r.tiles, 'diamante.jungle_gem_mine'), 4);
    });

    test('Test 12 — Gem Mines Module, 3 players', () {
      final diamanteExp = createDiamanteExpansion(
        selectedColors: selectedColors(3),
        modules: [gemMinesModule],
      );
      final r = runPipeline(
        players: makePlayers(3),
        selectedColors: selectedColors(3),
        activeModules: [gemMinesModule],
        expansions: [diamanteExp],
      );

      // Steps
      expect(hasStep(r.stepIds, 'setup_gem_mines_remove_temples'), isTrue);
      expect(hasStep(r.stepIds, 'setup_gem_mines_add_gem_mines'), isTrue);

      // Tiles: 5 gem mines for 3+ players
      expect(tileQty(r.tiles, 'base.jungle_temple'), 0);
      expect(tileQty(r.tiles, 'diamante.jungle_gem_mine'), 5);
    });

    test('Test 13 — Tree of Life Module, 2 players', () {
      final diamanteExp = createDiamanteExpansion(
        selectedColors: selectedColors(2),
        modules: [treeOfLifeModule, newWorkersModule],
      );
      final r = runPipeline(
        players: makePlayers(2),
        selectedColors: selectedColors(2),
        activeModules: [treeOfLifeModule],
        expansions: [diamanteExp],
      );

      // Base gold mine v1 step modified (1→2)
      expect(
        hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_gold_mine_value_1'),
        isTrue,
      );

      // New gold mine v2 removal
      expect(
        hasStep(r.stepIds, 'setup_tree_of_life_remove_gold_mine_v2'),
        isTrue,
      );

      // Tree of life tiles added
      expect(hasStep(r.stepIds, 'setup_tree_of_life_add_tiles'), isTrue);

      // 0-0-0-4 worker tile per player
      expect(hasStep(r.stepIds, 'setup_tree_of_life_add_0004_red'), isTrue);
      expect(hasStep(r.stepIds, 'setup_tree_of_life_add_0004_purple'), isTrue);

      // NO worker removal steps for 2p
      expect(
        hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_'),
        ),
        isFalse,
      );

      // Tiles
      expect(
        tileQty(r.tiles, 'base.jungle_gold_mine_value_1'),
        0,
      ); // 2-1(base)-1(tree)=0
      expect(
        tileQty(r.tiles, 'base.jungle_gold_mine_value_2'),
        1,
      ); // 2-1(tree)=1 (base also removed 0 for this)
      // Actually for 2p base: gold mine v1 reduced by 1, tree of life reduces by 1 more = 0
      // gold mine v2: base doesn't reduce for 2p, tree of life reduces by 1 = 1
      expect(tileQty(r.tiles, 'diamante.jungle_tree_of_life'), 2);

      // 0-0-0-4 worker tiles added by tree of life handler only (base handler filters out moduleId=8 tiles when module 8 is not active)
      expect(tileQty(r.tiles, 'diamante.worker_red_0-0-0-4'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_purple_0-0-0-4'), 1);
    });

    test('Test 14 — Tree of Life Module, 3 players', () {
      final diamanteExp = createDiamanteExpansion(
        selectedColors: selectedColors(3),
        modules: [treeOfLifeModule],
      );
      final r = runPipeline(
        players: makePlayers(3),
        selectedColors: selectedColors(3),
        activeModules: [treeOfLifeModule],
        expansions: [diamanteExp],
      );

      // Gold mine removal steps (3+p, no Chocolate)
      expect(
        hasStep(r.stepIds, 'setup_tree_of_life_remove_gold_mine_v1'),
        isTrue,
      );
      expect(
        hasStep(r.stepIds, 'setup_tree_of_life_remove_gold_mine_v2'),
        isTrue,
      );
      expect(hasStep(r.stepIds, 'setup_tree_of_life_add_tiles'), isTrue);

      // Worker 1-1-1-1 NOT removed (Tree of Life restores)
      expect(
        hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_1_'),
        ),
        isFalse,
      );

      // Tiles
      expect(tileQty(r.tiles, 'base.jungle_gold_mine_value_1'), 0); // 2-2=0
      expect(tileQty(r.tiles, 'base.jungle_gold_mine_value_2'), 1); // 2-1=1
      expect(tileQty(r.tiles, 'diamante.jungle_tree_of_life'), 3);

      // Worker 1-1-1-1 quantity restored
      expect(tileQty(r.tiles, 'base.worker_red_1-1-1-1'), 4); // 4-1+1=4
    });

    test('Test 15 — Tree of Life Module, 4 players', () {
      final diamanteExp = createDiamanteExpansion(
        selectedColors: selectedColors(4),
        modules: [treeOfLifeModule],
      );
      final r = runPipeline(
        players: makePlayers(4),
        selectedColors: selectedColors(4),
        activeModules: [treeOfLifeModule],
        expansions: [diamanteExp],
      );

      // Gold mine removal steps
      expect(
        hasStep(r.stepIds, 'setup_tree_of_life_remove_gold_mine_v1'),
        isTrue,
      );
      expect(
        hasStep(r.stepIds, 'setup_tree_of_life_remove_gold_mine_v2'),
        isTrue,
      );
      expect(hasStep(r.stepIds, 'setup_tree_of_life_add_tiles'), isTrue);

      // Worker 1-1-1-1 IS removed (4p: only restores 2-1-0-1)
      expect(hasStep(r.stepIds, 'setup_remove_worker_1_red'), isTrue);
      expect(hasStep(r.stepIds, 'setup_remove_worker_1_yellow'), isTrue);

      // Worker 2-1-0-1 NOT removed (Tree of Life restores)
      expect(
        hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_2_'),
        ),
        isFalse,
      );

      // Tiles
      expect(tileQty(r.tiles, 'base.jungle_gold_mine_value_1'), 0);
      expect(tileQty(r.tiles, 'base.jungle_gold_mine_value_2'), 1);
      expect(tileQty(r.tiles, 'diamante.jungle_tree_of_life'), 3);

      // Worker 1-1-1-1 reduced, 2-1-0-1 restored
      expect(tileQty(r.tiles, 'base.worker_red_1-1-1-1'), 3);
      expect(tileQty(r.tiles, 'base.worker_red_2-1-0-1'), 5); // 5-1+1=5
    });

    test('Test 16 — Emperor Favour Module, 2 players', () {
      final chocolatlExp = createChocolatlExpansion(
        selectedColors: selectedColors(2),
        modules: [emperorModule],
      );
      final r = runPipeline(
        players: makePlayers(2),
        selectedColors: selectedColors(2),
        activeModules: [emperorModule],
        expansions: [chocolatlExp],
      );

      // Emperor step present
      expect(hasStep(r.stepIds, 'setup_emperor'), isTrue);

      // Emperor placed after initial tiles (no watering → market selling price 2)
      final initialIdx = stepIndex(
        r.stepIds,
        'setup_initial_tiles_plantation_market',
      );
      final emperorIdx = stepIndex(r.stepIds, 'setup_emperor');
      expect(emperorIdx, initialIdx + 1);
    });

    test('Test 17 — New Workers Module, 2 players', () {
      final diamanteExp = createDiamanteExpansion(
        selectedColors: selectedColors(2),
        modules: [newWorkersModule],
      );
      final r = runPipeline(
        players: makePlayers(2),
        selectedColors: selectedColors(2),
        activeModules: [newWorkersModule],
        expansions: [diamanteExp],
      );

      // New workers selection step before shuffle
      expect(hasStep(r.stepIds, 'setup_new_workers_selection'), isTrue);
      final nwIdx17 = stepIndex(r.stepIds, 'setup_new_workers_selection');
      final shuffleIdx17 = stepIndex(r.stepIds, 'setup_shuffle_workers');
      expect(nwIdx17, lessThan(shuffleIdx17));

      // Tiles unchanged (informational module — jungle tiles not modified)
      expect(
        tileQty(r.tiles, 'base.jungle_single_plantation'),
        4,
      ); // 2p reduction

      // New worker tiles added to pool for each player color
      // TODO(future): When interactive selection is implemented, these should
      // reflect the user's choice instead of adding all tiles by default.
      expect(tileQty(r.tiles, 'diamante.worker_red_0-0-0-4'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_red_0-0-2-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_red_0-2-0-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_red_0-1-0-3'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_purple_0-0-0-4'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_purple_0-0-2-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_purple_0-2-0-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_purple_0-1-0-3'), 1);
    });
  });

  // ---------------------------------------------------------------------------
  // GRUP 3: Cross-module interactions
  // ---------------------------------------------------------------------------
  group('GRUP 3: Cross-module interactions', () {
    test('Test 18 — Watering + Emperor, 2 players', () {
      final chocolatlExp = createChocolatlExpansion(
        selectedColors: selectedColors(2),
        modules: [wateringModule, emperorModule],
      );
      final r = runPipeline(
        players: makePlayers(2),
        selectedColors: selectedColors(2),
        activeModules: [wateringModule, emperorModule],
        expansions: [chocolatlExp],
      );

      // Starting tiles: water (not market)
      expect(
        hasStep(r.stepIds, 'setup_initial_tiles_plantation_water'),
        isTrue,
      );

      // Emperor references water tile (placed after initial tiles)
      final initialIdx = stepIndex(
        r.stepIds,
        'setup_initial_tiles_plantation_water',
      );
      final emperorIdx = stepIndex(r.stepIds, 'setup_emperor');
      expect(emperorIdx, initialIdx + 1);
    });

    test('Test 19 — Watering + Emperor, 3 players', () {
      final chocolatlExp = createChocolatlExpansion(
        selectedColors: selectedColors(3),
        modules: [wateringModule, emperorModule],
      );
      final r = runPipeline(
        players: makePlayers(3),
        selectedColors: selectedColors(3),
        activeModules: [wateringModule, emperorModule],
        expansions: [chocolatlExp],
      );

      expect(
        hasStep(r.stepIds, 'setup_initial_tiles_plantation_water'),
        isTrue,
      );
      expect(hasStep(r.stepIds, 'setup_emperor'), isTrue);
    });

    test('Test 20 — Chocolate + Tree of Life, 2 players', () {
      final chocolatlExp = createChocolatlExpansion(
        selectedColors: selectedColors(2),
        modules: [chocolateModule],
      );
      final diamanteExp = createDiamanteExpansion(
        selectedColors: selectedColors(2),
        modules: [treeOfLifeModule, newWorkersModule],
      );
      final r = runPipeline(
        players: makePlayers(2),
        selectedColors: selectedColors(2),
        activeModules: [chocolateModule, treeOfLifeModule],
        expansions: [chocolatlExp, diamanteExp],
      );

      // Chocolate modifies base gold mine v1 (1→2) and market selling 3 (1→3)
      expect(
        hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_gold_mine_value_1'),
        isTrue,
      );
      expect(
        hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_market_selling_3'),
        isTrue,
      );

      // Chocolate adds gold mine v2 removal
      expect(hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v2'), isTrue);

      // Tree of Life does NOT add gold mine removal (Chocolate active)
      expect(
        hasStep(r.stepIds, 'setup_tree_of_life_remove_gold_mine_v1'),
        isFalse,
      );
      expect(
        hasStep(r.stepIds, 'setup_tree_of_life_remove_gold_mine_v2'),
        isFalse,
      );

      // Tree of Life adds tiles
      expect(hasStep(r.stepIds, 'setup_tree_of_life_add_tiles'), isTrue);

      // 0-0-0-4 worker tiles for each player
      expect(hasStep(r.stepIds, 'setup_tree_of_life_add_0004_red'), isTrue);
      expect(hasStep(r.stepIds, 'setup_tree_of_life_add_0004_purple'), isTrue);

      // Chocolate bars
      expect(hasStep(r.stepIds, 'setup_chocolate_bars'), isTrue);

      // Tiles: Chocolate removes gold mines, Tree of Life does NOT
      expect(tileQty(r.tiles, 'base.jungle_gold_mine_value_1'), 0);
      expect(tileQty(r.tiles, 'base.jungle_gold_mine_value_2'), 1);
      expect(tileQty(r.tiles, 'chocolatl.jungle_chocolate_kitchen'), 2);
      expect(tileQty(r.tiles, 'chocolatl.jungle_chocolate_market'), 2);
      expect(tileQty(r.tiles, 'diamante.jungle_tree_of_life'), 2);
    });

    test('Test 21 — Chocolate + Tree of Life, 3 players', () {
      final chocolatlExp = createChocolatlExpansion(
        selectedColors: selectedColors(3),
        modules: [chocolateModule],
      );
      final diamanteExp = createDiamanteExpansion(
        selectedColors: selectedColors(3),
        modules: [treeOfLifeModule],
      );
      final r = runPipeline(
        players: makePlayers(3),
        selectedColors: selectedColors(3),
        activeModules: [chocolateModule, treeOfLifeModule],
        expansions: [chocolatlExp, diamanteExp],
      );

      // Chocolate steps
      expect(hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v1'), isTrue);
      expect(hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v2'), isTrue);
      expect(
        hasStep(r.stepIds, 'setup_chocolate_remove_market_selling_3'),
        isTrue,
      );

      // Tree of Life NO gold mine removal (Chocolate active)
      expect(
        hasStep(r.stepIds, 'setup_tree_of_life_remove_gold_mine_v1'),
        isFalse,
      );
      expect(
        hasStep(r.stepIds, 'setup_tree_of_life_remove_gold_mine_v2'),
        isFalse,
      );

      // Tree of Life adds tiles
      expect(hasStep(r.stepIds, 'setup_tree_of_life_add_tiles'), isTrue);

      // Worker 1-1-1-1 NOT removed (Tree of Life restores)
      expect(
        hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_1_'),
        ),
        isFalse,
      );

      // Tiles
      expect(tileQty(r.tiles, 'base.jungle_gold_mine_value_1'), 0);
      expect(tileQty(r.tiles, 'base.jungle_gold_mine_value_2'), 1);
      expect(tileQty(r.tiles, 'chocolatl.jungle_chocolate_kitchen'), 3);
      expect(tileQty(r.tiles, 'chocolatl.jungle_chocolate_market'), 3);
      expect(tileQty(r.tiles, 'diamante.jungle_tree_of_life'), 3);
    });

    test('Test 22 — Chocolate + Tree of Life, 4 players', () {
      final chocolatlExp = createChocolatlExpansion(
        selectedColors: selectedColors(4),
        modules: [chocolateModule],
      );
      final diamanteExp = createDiamanteExpansion(
        selectedColors: selectedColors(4),
        modules: [treeOfLifeModule],
      );
      final r = runPipeline(
        players: makePlayers(4),
        selectedColors: selectedColors(4),
        activeModules: [chocolateModule, treeOfLifeModule],
        expansions: [chocolatlExp, diamanteExp],
      );

      // Worker 1-1-1-1 IS removed (4p)
      expect(hasStep(r.stepIds, 'setup_remove_worker_1_red'), isTrue);

      // Worker 2-1-0-1 NOT removed (Tree of Life restores)
      expect(
        hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_2_'),
        ),
        isFalse,
      );

      // Tiles
      expect(tileQty(r.tiles, 'chocolatl.jungle_chocolate_kitchen'), 3);
      expect(tileQty(r.tiles, 'chocolatl.jungle_chocolate_market'), 3);
      expect(tileQty(r.tiles, 'diamante.jungle_tree_of_life'), 3);
    });

    test('Test 23 — Gem Mines + Chocolate, 2 players', () {
      final chocolatlExp = createChocolatlExpansion(
        selectedColors: selectedColors(2),
        modules: [chocolateModule],
      );
      final diamanteExp = createDiamanteExpansion(
        selectedColors: selectedColors(2),
        modules: [gemMinesModule],
      );
      final r = runPipeline(
        players: makePlayers(2),
        selectedColors: selectedColors(2),
        activeModules: [chocolateModule, gemMinesModule],
        expansions: [chocolatlExp, diamanteExp],
      );

      // Chocolate modifies base steps
      expect(
        hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_gold_mine_value_1'),
        isTrue,
      );
      expect(
        hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_market_selling_3'),
        isTrue,
      );
      expect(hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v2'), isTrue);
      expect(hasStep(r.stepIds, 'setup_chocolate_add_kitchen'), isTrue);
      expect(hasStep(r.stepIds, 'setup_chocolate_add_market'), isTrue);

      // Gem Mines eliminates base temple step and adds its own
      expect(
        hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_temple'),
        isFalse,
      );
      expect(hasStep(r.stepIds, 'setup_gem_mines_remove_temples'), isTrue);
      expect(hasStep(r.stepIds, 'setup_gem_mines_add_gem_mines'), isTrue);

      // Supplies
      expect(hasStep(r.stepIds, 'setup_chocolate_bars'), isTrue);
      expect(hasStep(r.stepIds, 'setup_gem_mines_remove_gems'), isTrue);
      expect(hasStep(r.stepIds, 'setup_gem_mines_mine_car'), isTrue);
      expect(hasStep(r.stepIds, 'setup_gem_mines_masks'), isTrue);
      expect(hasStep(r.stepIds, 'setup_gem_mines_rule_reminder'), isTrue);

      // Tiles
      expect(tileQty(r.tiles, 'base.jungle_temple'), 0);
      expect(tileQty(r.tiles, 'diamante.jungle_gem_mine'), 4);
      expect(tileQty(r.tiles, 'chocolatl.jungle_chocolate_kitchen'), 2);
    });

    test('Test 24 — Gem Mines + Tree of Life, 3 players', () {
      final diamanteExp = createDiamanteExpansion(
        selectedColors: selectedColors(3),
        modules: [gemMinesModule, treeOfLifeModule],
      );
      final r = runPipeline(
        players: makePlayers(3),
        selectedColors: selectedColors(3),
        activeModules: [gemMinesModule, treeOfLifeModule],
        expansions: [diamanteExp],
      );

      // Gem Mines
      expect(hasStep(r.stepIds, 'setup_gem_mines_remove_temples'), isTrue);
      expect(hasStep(r.stepIds, 'setup_gem_mines_add_gem_mines'), isTrue);

      // Tree of Life (no Chocolate → removes gold mines)
      expect(
        hasStep(r.stepIds, 'setup_tree_of_life_remove_gold_mine_v1'),
        isTrue,
      );
      expect(
        hasStep(r.stepIds, 'setup_tree_of_life_remove_gold_mine_v2'),
        isTrue,
      );
      expect(hasStep(r.stepIds, 'setup_tree_of_life_add_tiles'), isTrue);

      // Worker 1-1-1-1 NOT removed (Tree of Life restores)
      expect(
        hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_1_'),
        ),
        isFalse,
      );

      // Tiles
      expect(tileQty(r.tiles, 'base.jungle_temple'), 0);
      expect(tileQty(r.tiles, 'diamante.jungle_gem_mine'), 5);
      expect(tileQty(r.tiles, 'base.jungle_gold_mine_value_1'), 0);
      expect(tileQty(r.tiles, 'base.jungle_gold_mine_value_2'), 1);
      expect(tileQty(r.tiles, 'diamante.jungle_tree_of_life'), 3);
    });

    test('Test 25 — Watering + Chocolate, 2 players', () {
      final chocolatlExp = createChocolatlExpansion(
        selectedColors: selectedColors(2),
        modules: [wateringModule, chocolateModule],
      );
      final r = runPipeline(
        players: makePlayers(2),
        selectedColors: selectedColors(2),
        activeModules: [wateringModule, chocolateModule],
        expansions: [chocolatlExp],
      );

      // Starting tiles: water
      expect(
        hasStep(r.stepIds, 'setup_initial_tiles_plantation_water'),
        isTrue,
      );

      // Watering steps
      expect(
        hasStep(r.stepIds, 'setup_watering_remove_double_plantation'),
        isTrue,
      );
      expect(hasStep(r.stepIds, 'setup_watering_add_watering_tiles'), isTrue);

      // Chocolate modifies base steps and adds its own
      expect(hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v2'), isTrue);
      expect(hasStep(r.stepIds, 'setup_chocolate_add_kitchen'), isTrue);
      expect(hasStep(r.stepIds, 'setup_chocolate_add_market'), isTrue);
      expect(hasStep(r.stepIds, 'setup_chocolate_bars'), isTrue);

      // Tiles
      expect(tileQty(r.tiles, 'base.jungle_double_plantation'), 0);
      expect(tileQty(r.tiles, 'chocolatl.jungle_watering'), 2);
      expect(tileQty(r.tiles, 'chocolatl.jungle_chocolate_kitchen'), 2);
    });

    test('Test 26 — Map + Watering + Emperor, 2 players', () {
      final chocolatlExp = createChocolatlExpansion(
        selectedColors: selectedColors(2),
        modules: [mapModule, wateringModule, emperorModule],
      );
      final r = runPipeline(
        players: makePlayers(2),
        selectedColors: selectedColors(2),
        activeModules: [mapModule, wateringModule, emperorModule],
        expansions: [chocolatlExp],
      );

      // Map tokens per player
      expect(hasStep(r.stepIds, 'setup_map_tokens_red'), isTrue);
      expect(hasStep(r.stepIds, 'setup_map_tokens_purple'), isTrue);
      expect(hasStep(r.stepIds, 'setup_map_tokens_surplus'), isTrue);

      // Starting tiles: water (Watering active)
      expect(
        hasStep(r.stepIds, 'setup_initial_tiles_plantation_water'),
        isTrue,
      );

      // Emperor after initial tiles
      expect(hasStep(r.stepIds, 'setup_emperor'), isTrue);
      final initialIdx = stepIndex(
        r.stepIds,
        'setup_initial_tiles_plantation_water',
      );
      final emperorIdx = stepIndex(r.stepIds, 'setup_emperor');
      expect(emperorIdx, initialIdx + 1);

      // Map board + jungle display map
      expect(hasStep(r.stepIds, 'setup_map_board'), isTrue);
      expect(hasStep(r.stepIds, 'setup_jungle_display_map'), isTrue);
    });
  });

  // ---------------------------------------------------------------------------
  // GRUP 4: Big Game (all modules)
  // ---------------------------------------------------------------------------
  group('GRUP 4: Big Game (all modules)', () {
    final allChocolatlModules = [
      mapModule,
      wateringModule,
      chocolateModule,
      hutModule,
      emperorModule,
    ];
    final allDiamanteModules = [
      gemMinesModule,
      treeOfLifeModule,
      newWorkersModule,
    ];
    final allModules = [...allChocolatlModules, ...allDiamanteModules];

    test('Test 27 — All modules, 2 players', () {
      final chocolatlExp = createChocolatlExpansion(
        selectedColors: selectedColors(2),
        modules: allChocolatlModules,
      );
      final diamanteExp = createDiamanteExpansion(
        selectedColors: selectedColors(2),
        modules: allDiamanteModules,
      );
      final r = runPipeline(
        players: makePlayers(2),
        selectedColors: selectedColors(2),
        activeModules: allModules,
        expansions: [chocolatlExp, diamanteExp],
      );

      // ---- Player Setup ----
      // New Workers before shuffle
      final nwIdx27 = stepIndex(r.stepIds, 'setup_new_workers_selection');
      final shuffleIdx27 = stepIndex(r.stepIds, 'setup_shuffle_workers');
      expect(nwIdx27, lessThan(shuffleIdx27));

      // Village board, carrier, field, tiles for each player
      expect(hasStep(r.stepIds, 'setup_village_board_red'), isTrue);
      expect(hasStep(r.stepIds, 'setup_tiles_red'), isTrue);

      // Map tokens + surplus
      expect(hasStep(r.stepIds, 'setup_map_tokens_red'), isTrue);
      expect(hasStep(r.stepIds, 'setup_map_tokens_surplus'), isTrue);

      // 0-0-0-4 worker tile steps removed by New Workers handler (selector
      // subsumes them when both Tree of Life and New Workers are active)
      expect(hasStep(r.stepIds, 'setup_tree_of_life_add_0004_red'), isFalse);
      expect(hasStep(r.stepIds, 'setup_tree_of_life_add_0004_purple'), isFalse);

      // NO worker removal steps (2p)
      expect(
        hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_'),
        ),
        isFalse,
      );

      // Shuffle workers
      expect(hasStep(r.stepIds, 'setup_shuffle_workers'), isTrue);

      // ---- Board Setup ----
      // Starting tiles: water (Watering active)
      expect(
        hasStep(r.stepIds, 'setup_initial_tiles_plantation_water'),
        isTrue,
      );

      // Emperor on water tile
      expect(hasStep(r.stepIds, 'setup_emperor'), isTrue);

      // 2p sort out steps (base) — some modified by Chocolate
      expect(
        hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_single_plantation'),
        isTrue,
      );
      expect(
        hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_market_selling_3'),
        isTrue,
      ); // modified 1→3
      expect(
        hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_gold_mine_value_1'),
        isTrue,
      ); // modified 1→2
      expect(hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_water'), isTrue);
      expect(
        hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_sun_worshiping_site'),
        isTrue,
      );

      // Temple base step ELIMINATED by Gem Mines
      expect(
        hasStep(r.stepIds, 'setup_jungle_tiles_2p_removal_temple'),
        isFalse,
      );

      // Watering substitution
      expect(
        hasStep(r.stepIds, 'setup_watering_remove_double_plantation'),
        isTrue,
      );
      expect(hasStep(r.stepIds, 'setup_watering_add_watering_tiles'), isTrue);

      // Chocolate substitution
      expect(hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v2'), isTrue);
      expect(hasStep(r.stepIds, 'setup_chocolate_add_kitchen'), isTrue);
      expect(hasStep(r.stepIds, 'setup_chocolate_add_market'), isTrue);

      // Gem Mines
      expect(hasStep(r.stepIds, 'setup_gem_mines_remove_temples'), isTrue);
      expect(hasStep(r.stepIds, 'setup_gem_mines_add_gem_mines'), isTrue);

      // Tree of Life NO gold mine removal (Chocolate active)
      expect(
        hasStep(r.stepIds, 'setup_tree_of_life_remove_gold_mine_v1'),
        isFalse,
      );
      expect(
        hasStep(r.stepIds, 'setup_tree_of_life_remove_gold_mine_v2'),
        isFalse,
      );
      expect(hasStep(r.stepIds, 'setup_tree_of_life_add_tiles'), isTrue);

      // Map board + display
      expect(hasStep(r.stepIds, 'setup_map_board'), isTrue);
      expect(hasStep(r.stepIds, 'setup_jungle_display_map'), isTrue);

      // Huts
      expect(hasStep(r.stepIds, 'setup_huts_market'), isTrue);

      // ---- Supplies ----
      expect(hasStep(r.stepIds, 'setup_resources_bank'), isTrue);
      expect(hasStep(r.stepIds, 'setup_chocolate_bars'), isTrue);
      expect(hasStep(r.stepIds, 'setup_gem_mines_remove_gems'), isTrue);
      expect(hasStep(r.stepIds, 'setup_gem_mines_mine_car'), isTrue);
      expect(hasStep(r.stepIds, 'setup_gem_mines_masks'), isTrue);
      expect(hasStep(r.stepIds, 'setup_gem_mines_rule_reminder'), isTrue);

      // ---- Tile quantities ----
      // Plantations reduced (base 2p + watering)
      expect(tileQty(r.tiles, 'base.jungle_single_plantation'), 4); // 6-2(base)
      expect(
        tileQty(r.tiles, 'base.jungle_double_plantation'),
        0,
      ); // 2-2(watering)
      expect(tileQty(r.tiles, 'chocolatl.jungle_watering'), 2);

      // Gold mines removed (base 2p + chocolate)
      expect(tileQty(r.tiles, 'base.jungle_gold_mine_value_1'), 0);
      expect(tileQty(r.tiles, 'base.jungle_gold_mine_value_2'), 1);
      expect(tileQty(r.tiles, 'chocolatl.jungle_chocolate_kitchen'), 2);
      expect(tileQty(r.tiles, 'chocolatl.jungle_chocolate_market'), 2);

      // Temples removed (gem mines)
      expect(tileQty(r.tiles, 'base.jungle_temple'), 0);
      expect(tileQty(r.tiles, 'diamante.jungle_gem_mine'), 4);

      // Tree of life
      expect(tileQty(r.tiles, 'diamante.jungle_tree_of_life'), 2);

      // Huts
      final hutTiles = r.tiles.where((t) => t.type == TileType.hut);
      final totalHuts = hutTiles.fold(0, (sum, t) => sum + t.quantity);
      expect(totalHuts, 14);

      // 0-0-0-4 worker tiles: qty 1 per player (TreeOfLife adds, NewWorkers skips duplicate)
      expect(tileQty(r.tiles, 'diamante.worker_red_0-0-0-4'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_purple_0-0-0-4'), 1);

      // Remaining new worker tiles added by NewWorkers handler
      expect(tileQty(r.tiles, 'diamante.worker_red_0-0-2-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_red_0-2-0-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_red_0-1-0-3'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_purple_0-0-2-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_purple_0-2-0-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_purple_0-1-0-3'), 1);
    });

    test('Test 28 — All modules, 3 players', () {
      final chocolatlExp = createChocolatlExpansion(
        selectedColors: selectedColors(3),
        modules: allChocolatlModules,
      );
      final diamanteExp = createDiamanteExpansion(
        selectedColors: selectedColors(3),
        modules: allDiamanteModules,
      );
      final r = runPipeline(
        players: makePlayers(3),
        selectedColors: selectedColors(3),
        activeModules: allModules,
        expansions: [chocolatlExp, diamanteExp],
      );

      // ---- Player Setup ----
      final nwIdx28 = stepIndex(r.stepIds, 'setup_new_workers_selection');
      final shuffleIdx28 = stepIndex(r.stepIds, 'setup_shuffle_workers');
      expect(nwIdx28, lessThan(shuffleIdx28));

      // Map tokens (3p → surplus exists: 8 total - 6 = 2 surplus)
      expect(hasStep(r.stepIds, 'setup_map_tokens_red'), isTrue);
      expect(hasStep(r.stepIds, 'setup_map_tokens_surplus'), isTrue);

      // Worker 1-1-1-1 NOT removed (Tree of Life restores)
      expect(
        hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_1_'),
        ),
        isFalse,
      );

      // ---- Board Setup ----
      // Starting tiles: water
      expect(
        hasStep(r.stepIds, 'setup_initial_tiles_plantation_water'),
        isTrue,
      );
      expect(hasStep(r.stepIds, 'setup_emperor'), isTrue);

      // NO 2p sort out steps
      expect(
        hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_jungle_tiles_2p_'),
        ),
        isFalse,
      );

      // Watering (3+p: 3 steps)
      expect(
        hasStep(r.stepIds, 'setup_watering_remove_single_plantation'),
        isTrue,
      );
      expect(
        hasStep(r.stepIds, 'setup_watering_remove_double_plantation'),
        isTrue,
      );
      expect(hasStep(r.stepIds, 'setup_watering_add_watering_tiles'), isTrue);

      // Chocolate (3+p: 5 steps)
      expect(hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v1'), isTrue);
      expect(hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v2'), isTrue);
      expect(
        hasStep(r.stepIds, 'setup_chocolate_remove_market_selling_3'),
        isTrue,
      );
      expect(hasStep(r.stepIds, 'setup_chocolate_add_kitchen'), isTrue);
      expect(hasStep(r.stepIds, 'setup_chocolate_add_market'), isTrue);

      // Gem Mines
      expect(hasStep(r.stepIds, 'setup_gem_mines_remove_temples'), isTrue);
      expect(hasStep(r.stepIds, 'setup_gem_mines_add_gem_mines'), isTrue);

      // Tree of Life (Chocolate active → no gold mine removal)
      expect(
        hasStep(r.stepIds, 'setup_tree_of_life_remove_gold_mine_v1'),
        isFalse,
      );
      expect(hasStep(r.stepIds, 'setup_tree_of_life_add_tiles'), isTrue);

      // Map board
      expect(hasStep(r.stepIds, 'setup_map_board'), isTrue);

      // Huts
      expect(hasStep(r.stepIds, 'setup_huts_market'), isTrue);

      // ---- Supplies ----
      expect(hasStep(r.stepIds, 'setup_chocolate_bars'), isTrue);
      expect(hasStep(r.stepIds, 'setup_gem_mines_mine_car'), isTrue);
      expect(hasStep(r.stepIds, 'setup_gem_mines_masks'), isTrue);
      expect(hasStep(r.stepIds, 'setup_gem_mines_rule_reminder'), isTrue);

      // ---- Tiles ----
      expect(
        tileQty(r.tiles, 'base.jungle_single_plantation'),
        5,
      ); // 6-1(watering)
      expect(
        tileQty(r.tiles, 'base.jungle_double_plantation'),
        0,
      ); // 2-2(watering)
      expect(tileQty(r.tiles, 'chocolatl.jungle_watering'), 3);
      expect(tileQty(r.tiles, 'base.jungle_gold_mine_value_1'), 0); // 2-2(choc)
      expect(tileQty(r.tiles, 'base.jungle_gold_mine_value_2'), 1); // 2-1(choc)
      expect(tileQty(r.tiles, 'chocolatl.jungle_chocolate_kitchen'), 3);
      expect(tileQty(r.tiles, 'chocolatl.jungle_chocolate_market'), 3);
      expect(tileQty(r.tiles, 'base.jungle_temple'), 0);
      expect(tileQty(r.tiles, 'diamante.jungle_gem_mine'), 5);
      expect(tileQty(r.tiles, 'diamante.jungle_tree_of_life'), 3);

      // Workers restored
      expect(tileQty(r.tiles, 'base.worker_red_1-1-1-1'), 4);

      // New worker tiles added by NewWorkers handler for all 3 colors
      expect(tileQty(r.tiles, 'diamante.worker_red_0-0-0-4'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_red_0-0-2-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_red_0-2-0-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_red_0-1-0-3'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_purple_0-0-0-4'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_purple_0-0-2-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_purple_0-2-0-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_purple_0-1-0-3'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_white_0-0-0-4'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_white_0-0-2-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_white_0-2-0-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_white_0-1-0-3'), 1);
    });

    test('Test 29 — All modules, 4 players', () {
      final chocolatlExp = createChocolatlExpansion(
        selectedColors: selectedColors(4),
        modules: allChocolatlModules,
      );
      final diamanteExp = createDiamanteExpansion(
        selectedColors: selectedColors(4),
        modules: allDiamanteModules,
      );
      final r = runPipeline(
        players: makePlayers(4),
        selectedColors: selectedColors(4),
        activeModules: allModules,
        expansions: [chocolatlExp, diamanteExp],
      );

      // ---- Player Setup ----
      final nwIdx29 = stepIndex(r.stepIds, 'setup_new_workers_selection');
      final shuffleIdx29 = stepIndex(r.stepIds, 'setup_shuffle_workers');
      expect(nwIdx29, lessThan(shuffleIdx29));

      // Map tokens, NO surplus (4 players)
      expect(hasStep(r.stepIds, 'setup_map_tokens_red'), isTrue);
      expect(hasStep(r.stepIds, 'setup_map_tokens_yellow'), isTrue);
      expect(hasStep(r.stepIds, 'setup_map_tokens_surplus'), isFalse);

      // Worker removal steps removed by New Workers selector (always authoritative)
      expect(
        hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_1_'),
        ),
        isFalse,
      );

      // Worker 2-1-0-1 also removed by selector
      expect(
        hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_2_'),
        ),
        isFalse,
      );

      // ---- Board Setup ----
      expect(
        hasStep(r.stepIds, 'setup_initial_tiles_plantation_water'),
        isTrue,
      );
      expect(hasStep(r.stepIds, 'setup_emperor'), isTrue);

      // NO 2p sort out steps
      expect(
        hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_jungle_tiles_2p_'),
        ),
        isFalse,
      );

      // Same substitution steps as 3 players
      expect(
        hasStep(r.stepIds, 'setup_watering_remove_single_plantation'),
        isTrue,
      );
      expect(
        hasStep(r.stepIds, 'setup_watering_remove_double_plantation'),
        isTrue,
      );
      expect(hasStep(r.stepIds, 'setup_watering_add_watering_tiles'), isTrue);
      expect(hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v1'), isTrue);
      expect(hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v2'), isTrue);
      expect(
        hasStep(r.stepIds, 'setup_chocolate_remove_market_selling_3'),
        isTrue,
      );
      expect(hasStep(r.stepIds, 'setup_gem_mines_remove_temples'), isTrue);
      expect(hasStep(r.stepIds, 'setup_tree_of_life_add_tiles'), isTrue);

      // ---- Tiles (same quantities as 3p for jungle tiles) ----
      expect(tileQty(r.tiles, 'base.jungle_single_plantation'), 5);
      expect(tileQty(r.tiles, 'base.jungle_double_plantation'), 0);
      expect(tileQty(r.tiles, 'chocolatl.jungle_watering'), 3);
      expect(tileQty(r.tiles, 'base.jungle_gold_mine_value_1'), 0);
      expect(tileQty(r.tiles, 'base.jungle_gold_mine_value_2'), 1);
      expect(tileQty(r.tiles, 'base.jungle_temple'), 0);
      expect(tileQty(r.tiles, 'diamante.jungle_gem_mine'), 5);
      expect(tileQty(r.tiles, 'diamante.jungle_tree_of_life'), 3);

      // Workers: selector overrides base 4p reductions
      expect(tileQty(r.tiles, 'base.worker_red_1-1-1-1'), 4);
      expect(tileQty(r.tiles, 'base.worker_red_2-1-0-1'), 5);

      // New worker tiles added by NewWorkers handler for all 4 colors
      expect(tileQty(r.tiles, 'diamante.worker_red_0-0-0-4'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_red_0-0-2-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_red_0-2-0-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_red_0-1-0-3'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_purple_0-0-0-4'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_purple_0-0-2-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_purple_0-2-0-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_purple_0-1-0-3'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_white_0-0-0-4'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_white_0-0-2-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_white_0-2-0-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_white_0-1-0-3'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_yellow_0-0-0-4'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_yellow_0-0-2-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_yellow_0-2-0-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_yellow_0-1-0-3'), 1);
    });
  });

  // ---------------------------------------------------------------------------
  // GRUP 5: Big Game variant (isBigGame = true)
  // ---------------------------------------------------------------------------
  group('GRUP 5: Big Game variant', () {
    final allChocolatlModules = [
      mapModule,
      wateringModule,
      chocolateModule,
      hutModule,
      emperorModule,
    ];
    final allDiamanteModules = [
      gemMinesModule,
      treeOfLifeModule,
      newWorkersModule,
    ];
    final allModules = [...allChocolatlModules, ...allDiamanteModules];

    test('Test 30 — Big Game, 3 players', () {
      final r = runPipeline(
        players: makePlayers(3),
        selectedColors: selectedColors(3),
        activeModules: allModules,
        isBigGame: true,
      );

      // ---- Player Setup ----
      // Village board, carrier, field, tiles for each player
      expect(hasStep(r.stepIds, 'setup_village_board_red'), isTrue);
      expect(hasStep(r.stepIds, 'setup_village_board_purple'), isTrue);
      expect(hasStep(r.stepIds, 'setup_village_board_white'), isTrue);
      expect(hasStep(r.stepIds, 'setup_tiles_red'), isTrue);
      expect(hasStep(r.stepIds, 'setup_tiles_purple'), isTrue);
      expect(hasStep(r.stepIds, 'setup_tiles_white'), isTrue);

      // Map tokens (3p → surplus exists)
      expect(hasStep(r.stepIds, 'setup_map_tokens_red'), isTrue);
      expect(hasStep(r.stepIds, 'setup_map_tokens_purple'), isTrue);
      expect(hasStep(r.stepIds, 'setup_map_tokens_white'), isTrue);
      expect(hasStep(r.stepIds, 'setup_map_tokens_surplus'), isTrue);

      // NO worker removal steps at all (Big Game = no removals)
      expect(
        hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_'),
        ),
        isFalse,
      );

      // NO new workers selection step (Big Game: returns early)
      expect(hasStep(r.stepIds, 'setup_new_workers_selection'), isFalse);

      // NO tree of life 0-0-0-4 steps (Big Game: returns early)
      expect(
        hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_tree_of_life_add_0004_'),
        ),
        isFalse,
      );

      // Shuffle workers
      expect(hasStep(r.stepIds, 'setup_shuffle_workers'), isTrue);

      // ---- Board Setup ----
      // Starting tiles: plantation + water (watering modifies this in Big Game too)
      expect(
        hasStep(r.stepIds, 'setup_initial_tiles_plantation_water'),
        isTrue,
      );
      expect(
        hasStep(r.stepIds, 'setup_initial_tiles_plantation_market'),
        isFalse,
      );

      // Emperor after initial tiles
      expect(hasStep(r.stepIds, 'setup_emperor'), isTrue);
      final initialIdx30 = stepIndex(
        r.stepIds,
        'setup_initial_tiles_plantation_water',
      );
      final emperorIdx30 = stepIndex(r.stepIds, 'setup_emperor');
      expect(emperorIdx30, initialIdx30 + 1);

      // NO 2p sort out steps
      expect(
        hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_jungle_tiles_2p_'),
        ),
        isFalse,
      );

      // Big Game 3p removal steps ARE present
      expect(
        hasStep(r.stepIds, 'setup_big_game_3p_removal_single_plantation'),
        isTrue,
      );
      expect(
        hasStep(r.stepIds, 'setup_big_game_3p_removal_gold_mine_v1'),
        isTrue,
      );
      expect(
        hasStep(r.stepIds, 'setup_big_game_3p_removal_market_selling_2'),
        isTrue,
      );
      expect(
        hasStep(r.stepIds, 'setup_big_game_3p_removal_market_selling_3'),
        isTrue,
      );
      expect(hasStep(r.stepIds, 'setup_big_game_3p_removal_watering'), isTrue);

      // NO module substitution steps (Big Game skips all substitutions)
      expect(
        hasStep(r.stepIds, 'setup_watering_remove_single_plantation'),
        isFalse,
      );
      expect(
        hasStep(r.stepIds, 'setup_watering_remove_double_plantation'),
        isFalse,
      );
      expect(hasStep(r.stepIds, 'setup_watering_add_watering_tiles'), isFalse);
      expect(
        hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v1'),
        isFalse,
      );
      expect(
        hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v2'),
        isFalse,
      );
      expect(
        hasStep(r.stepIds, 'setup_chocolate_remove_market_selling_3'),
        isFalse,
      );
      expect(hasStep(r.stepIds, 'setup_chocolate_add_kitchen'), isFalse);
      expect(hasStep(r.stepIds, 'setup_chocolate_add_market'), isFalse);
      expect(hasStep(r.stepIds, 'setup_gem_mines_remove_temples'), isFalse);
      expect(hasStep(r.stepIds, 'setup_gem_mines_add_gem_mines'), isFalse);
      expect(hasStep(r.stepIds, 'setup_tree_of_life_add_tiles'), isFalse);
      expect(
        hasStep(r.stepIds, 'setup_tree_of_life_remove_gold_mine_v1'),
        isFalse,
      );

      // Map board + jungle display map
      expect(hasStep(r.stepIds, 'setup_map_board'), isTrue);
      expect(hasStep(r.stepIds, 'setup_jungle_display_map'), isTrue);

      // Huts market
      expect(hasStep(r.stepIds, 'setup_huts_market'), isTrue);

      // ---- Supplies ----
      expect(hasStep(r.stepIds, 'setup_resources_bank'), isTrue);
      expect(hasStep(r.stepIds, 'setup_chocolate_bars'), isTrue);
      expect(hasStep(r.stepIds, 'setup_gem_mines_mine_car'), isTrue);
      expect(hasStep(r.stepIds, 'setup_gem_mines_masks'), isTrue);
      expect(hasStep(r.stepIds, 'setup_gem_mines_rule_reminder'), isTrue);
      // No remove_gems step in Big Game (only in normal mode)
      expect(hasStep(r.stepIds, 'setup_gem_mines_remove_gems'), isFalse);

      // ---- Jungle tile quantities (Big Game 3p removals applied) ----
      expect(tileQty(r.tiles, 'base.jungle_single_plantation'), 4); // 6-2
      expect(
        tileQty(r.tiles, 'base.jungle_double_plantation'),
        2,
      ); // no removal
      expect(tileQty(r.tiles, 'base.jungle_market_selling_2'), 1); // 2-1
      expect(tileQty(r.tiles, 'base.jungle_market_selling_3'), 3); // 4-1
      expect(tileQty(r.tiles, 'base.jungle_market_selling_4'), 1);
      expect(tileQty(r.tiles, 'base.jungle_gold_mine_value_1'), 0); // 2-2
      expect(tileQty(r.tiles, 'base.jungle_gold_mine_value_2'), 2);
      expect(tileQty(r.tiles, 'base.jungle_water'), 3);
      expect(tileQty(r.tiles, 'base.jungle_sun_worshiping_site'), 2);
      expect(tileQty(r.tiles, 'base.jungle_temple'), 5);
      expect(tileQty(r.tiles, 'chocolatl.jungle_watering'), 2); // 3-1
      expect(tileQty(r.tiles, 'chocolatl.jungle_chocolate_kitchen'), 3);
      expect(tileQty(r.tiles, 'chocolatl.jungle_chocolate_market'), 3);
      expect(tileQty(r.tiles, 'diamante.jungle_gem_mine'), 5);
      expect(tileQty(r.tiles, 'diamante.jungle_tree_of_life'), 3);

      // ---- Worker quantities (NO removals in Big Game) ----
      // Base workers at full quantity for 3 colors
      expect(tileQty(r.tiles, 'base.worker_red_1-1-1-1'), 4);
      expect(tileQty(r.tiles, 'base.worker_red_2-1-0-1'), 5);
      expect(tileQty(r.tiles, 'base.worker_red_3-0-0-1'), 1);
      expect(tileQty(r.tiles, 'base.worker_red_3-1-0-0'), 1);
      expect(tileQty(r.tiles, 'base.worker_purple_1-1-1-1'), 4);
      expect(tileQty(r.tiles, 'base.worker_purple_2-1-0-1'), 5);
      expect(tileQty(r.tiles, 'base.worker_white_1-1-1-1'), 4);
      expect(tileQty(r.tiles, 'base.worker_white_2-1-0-1'), 5);

      // New worker tiles loaded by base handler (isBigGame || moduleId == null)
      expect(tileQty(r.tiles, 'diamante.worker_red_0-0-0-4'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_red_0-0-2-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_red_0-2-0-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_red_0-1-0-3'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_purple_0-0-0-4'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_purple_0-0-2-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_purple_0-2-0-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_purple_0-1-0-3'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_white_0-0-0-4'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_white_0-0-2-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_white_0-2-0-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_white_0-1-0-3'), 1);

      // No yellow workers (only 3 players)
      expect(tileQty(r.tiles, 'base.worker_yellow_1-1-1-1'), 0);
      expect(tileQty(r.tiles, 'diamante.worker_yellow_0-0-0-4'), 0);

      // Hut tiles present (loaded by base handler color == null filter)
      final hutTiles30 = r.tiles.where((t) => t.type == TileType.hut);
      final totalHuts30 = hutTiles30.fold(0, (sum, t) => sum + t.quantity);
      expect(totalHuts30, 14);
    });

    test('Test 31 — Big Game, 4 players', () {
      final r = runPipeline(
        players: makePlayers(4),
        selectedColors: selectedColors(4),
        activeModules: allModules,
        isBigGame: true,
      );

      // ---- Player Setup ----
      // Village board, carrier, field, tiles for each player
      expect(hasStep(r.stepIds, 'setup_village_board_red'), isTrue);
      expect(hasStep(r.stepIds, 'setup_village_board_purple'), isTrue);
      expect(hasStep(r.stepIds, 'setup_village_board_white'), isTrue);
      expect(hasStep(r.stepIds, 'setup_village_board_yellow'), isTrue);
      expect(hasStep(r.stepIds, 'setup_tiles_red'), isTrue);
      expect(hasStep(r.stepIds, 'setup_tiles_yellow'), isTrue);

      // Map tokens, NO surplus (4 players)
      expect(hasStep(r.stepIds, 'setup_map_tokens_red'), isTrue);
      expect(hasStep(r.stepIds, 'setup_map_tokens_yellow'), isTrue);
      expect(hasStep(r.stepIds, 'setup_map_tokens_surplus'), isFalse);

      // NO worker removal steps at all
      expect(
        hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_'),
        ),
        isFalse,
      );

      // NO new workers selection step
      expect(hasStep(r.stepIds, 'setup_new_workers_selection'), isFalse);

      // NO tree of life 0-0-0-4 steps
      expect(
        hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_tree_of_life_add_0004_'),
        ),
        isFalse,
      );

      // Shuffle workers
      expect(hasStep(r.stepIds, 'setup_shuffle_workers'), isTrue);

      // ---- Board Setup ----
      // Starting tiles: plantation + water (watering modifies)
      expect(
        hasStep(r.stepIds, 'setup_initial_tiles_plantation_water'),
        isTrue,
      );
      expect(
        hasStep(r.stepIds, 'setup_initial_tiles_plantation_market'),
        isFalse,
      );

      // Emperor after initial tiles
      expect(hasStep(r.stepIds, 'setup_emperor'), isTrue);
      final initialIdx31 = stepIndex(
        r.stepIds,
        'setup_initial_tiles_plantation_water',
      );
      final emperorIdx31 = stepIndex(r.stepIds, 'setup_emperor');
      expect(emperorIdx31, initialIdx31 + 1);

      // NO 2p sort out steps
      expect(
        hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_jungle_tiles_2p_'),
        ),
        isFalse,
      );

      // NO Big Game 3p removal steps (4 players = ALL tiles)
      expect(
        hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_big_game_3p_'),
        ),
        isFalse,
      );

      // NO module substitution steps
      expect(
        hasStep(r.stepIds, 'setup_watering_remove_single_plantation'),
        isFalse,
      );
      expect(
        hasStep(r.stepIds, 'setup_watering_remove_double_plantation'),
        isFalse,
      );
      expect(hasStep(r.stepIds, 'setup_watering_add_watering_tiles'), isFalse);
      expect(
        hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v1'),
        isFalse,
      );
      expect(
        hasStep(r.stepIds, 'setup_chocolate_remove_gold_mine_v2'),
        isFalse,
      );
      expect(
        hasStep(r.stepIds, 'setup_chocolate_remove_market_selling_3'),
        isFalse,
      );
      expect(hasStep(r.stepIds, 'setup_chocolate_add_kitchen'), isFalse);
      expect(hasStep(r.stepIds, 'setup_chocolate_add_market'), isFalse);
      expect(hasStep(r.stepIds, 'setup_gem_mines_remove_temples'), isFalse);
      expect(hasStep(r.stepIds, 'setup_gem_mines_add_gem_mines'), isFalse);
      expect(hasStep(r.stepIds, 'setup_tree_of_life_add_tiles'), isFalse);

      // Map board + jungle display map
      expect(hasStep(r.stepIds, 'setup_map_board'), isTrue);
      expect(hasStep(r.stepIds, 'setup_jungle_display_map'), isTrue);

      // Huts market
      expect(hasStep(r.stepIds, 'setup_huts_market'), isTrue);

      // ---- Supplies ----
      expect(hasStep(r.stepIds, 'setup_resources_bank'), isTrue);
      expect(hasStep(r.stepIds, 'setup_chocolate_bars'), isTrue);
      expect(hasStep(r.stepIds, 'setup_gem_mines_mine_car'), isTrue);
      expect(hasStep(r.stepIds, 'setup_gem_mines_masks'), isTrue);
      expect(hasStep(r.stepIds, 'setup_gem_mines_rule_reminder'), isTrue);
      expect(hasStep(r.stepIds, 'setup_gem_mines_remove_gems'), isFalse);

      // ---- Jungle tile quantities (NO removals for 4p Big Game) ----
      expect(tileQty(r.tiles, 'base.jungle_single_plantation'), 6);
      expect(tileQty(r.tiles, 'base.jungle_double_plantation'), 2);
      expect(tileQty(r.tiles, 'base.jungle_market_selling_2'), 2);
      expect(tileQty(r.tiles, 'base.jungle_market_selling_3'), 4);
      expect(tileQty(r.tiles, 'base.jungle_market_selling_4'), 1);
      expect(tileQty(r.tiles, 'base.jungle_gold_mine_value_1'), 2);
      expect(tileQty(r.tiles, 'base.jungle_gold_mine_value_2'), 2);
      expect(tileQty(r.tiles, 'base.jungle_water'), 3);
      expect(tileQty(r.tiles, 'base.jungle_sun_worshiping_site'), 2);
      expect(tileQty(r.tiles, 'base.jungle_temple'), 5);
      expect(tileQty(r.tiles, 'chocolatl.jungle_watering'), 3);
      expect(tileQty(r.tiles, 'chocolatl.jungle_chocolate_kitchen'), 3);
      expect(tileQty(r.tiles, 'chocolatl.jungle_chocolate_market'), 3);
      expect(tileQty(r.tiles, 'diamante.jungle_gem_mine'), 5);
      expect(tileQty(r.tiles, 'diamante.jungle_tree_of_life'), 3);

      // ---- Worker quantities (NO removals, all 4 colors) ----
      expect(tileQty(r.tiles, 'base.worker_red_1-1-1-1'), 4);
      expect(tileQty(r.tiles, 'base.worker_red_2-1-0-1'), 5);
      expect(tileQty(r.tiles, 'base.worker_red_3-0-0-1'), 1);
      expect(tileQty(r.tiles, 'base.worker_red_3-1-0-0'), 1);
      expect(tileQty(r.tiles, 'base.worker_purple_1-1-1-1'), 4);
      expect(tileQty(r.tiles, 'base.worker_purple_2-1-0-1'), 5);
      expect(tileQty(r.tiles, 'base.worker_white_1-1-1-1'), 4);
      expect(tileQty(r.tiles, 'base.worker_white_2-1-0-1'), 5);
      expect(tileQty(r.tiles, 'base.worker_yellow_1-1-1-1'), 4);
      expect(tileQty(r.tiles, 'base.worker_yellow_2-1-0-1'), 5);

      // New worker tiles for all 4 colors
      expect(tileQty(r.tiles, 'diamante.worker_red_0-0-0-4'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_red_0-0-2-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_red_0-2-0-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_red_0-1-0-3'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_purple_0-0-0-4'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_purple_0-0-2-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_purple_0-2-0-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_purple_0-1-0-3'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_white_0-0-0-4'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_white_0-0-2-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_white_0-2-0-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_white_0-1-0-3'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_yellow_0-0-0-4'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_yellow_0-0-2-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_yellow_0-2-0-2'), 1);
      expect(tileQty(r.tiles, 'diamante.worker_yellow_0-1-0-3'), 1);

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
      final diamanteExp = createDiamanteExpansion(
        selectedColors: selectedColors(3),
        modules: [newWorkersModule],
      );
      final r = runPipeline(
        players: makePlayers(3),
        selectedColors: selectedColors(3),
        activeModules: [newWorkersModule],
        expansions: [diamanteExp],
        workerSelection: const WorkerSelectionEntity(
          mode: WorkerSelectionMode.preset,
          presetType: WorkerPresetType.addAll,
        ),
      );

      // Selector is authoritative — all base removal steps removed
      expect(
        hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_1_'),
        ),
        isFalse,
      );

      // New workers selection step is present
      expect(hasStep(r.stepIds, 'setup_new_workers_selection'), isTrue);

      // Tile quantities: selector overrides base 3p reduction (4, not 3)
      expect(tileQty(r.tiles, 'base.worker_red_1-1-1-1'), 4);
    });

    test(
      'Test 33 — New Workers 3p replaceWithNew: removes base removal step',
      () {
        final diamanteExp = createDiamanteExpansion(
          selectedColors: selectedColors(3),
          modules: [newWorkersModule],
        );
        final r = runPipeline(
          players: makePlayers(3),
          selectedColors: selectedColors(3),
          activeModules: [newWorkersModule],
          expansions: [diamanteExp],
          workerSelection: const WorkerSelectionEntity(
            mode: WorkerSelectionMode.preset,
            presetType: WorkerPresetType.replaceWithNew,
          ),
        );

        // replaceWithNew sets 1-1-1-1 to 0 (≠ default 4), so removal steps gone
        expect(
          hasAnyStepMatching(
            r.stepIds,
            (id) => id.startsWith('setup_remove_worker_1_'),
          ),
          isFalse,
        );

        // Selection step present
        expect(hasStep(r.stepIds, 'setup_new_workers_selection'), isTrue);

        // Tile: 1-1-1-1 set to 0
        expect(tileQty(r.tiles, 'base.worker_red_1-1-1-1'), 0);

        // New tiles added
        expect(tileQty(r.tiles, 'diamante.worker_red_0-0-0-4'), 1);
        expect(tileQty(r.tiles, 'diamante.worker_red_0-0-2-2'), 1);
      },
    );

    test(
      'Test 34 — New Workers 4p replaceWithNew: removes both removal steps',
      () {
        final diamanteExp = createDiamanteExpansion(
          selectedColors: selectedColors(4),
          modules: [newWorkersModule],
        );
        final r = runPipeline(
          players: makePlayers(4),
          selectedColors: selectedColors(4),
          activeModules: [newWorkersModule],
          expansions: [diamanteExp],
          workerSelection: const WorkerSelectionEntity(
            mode: WorkerSelectionMode.preset,
            presetType: WorkerPresetType.replaceWithNew,
          ),
        );

        // Both removal step types removed (selector is always authoritative)
        expect(
          hasAnyStepMatching(
            r.stepIds,
            (id) => id.startsWith('setup_remove_worker_1_'),
          ),
          isFalse,
        );

        // Selector removes all base removal steps unconditionally
        expect(
          hasAnyStepMatching(
            r.stepIds,
            (id) => id.startsWith('setup_remove_worker_2_'),
          ),
          isFalse,
        );
      },
    );

    test('Test 35 — New Workers 4p manual both changed: removes both', () {
      final diamanteExp = createDiamanteExpansion(
        selectedColors: selectedColors(4),
        modules: [newWorkersModule],
      );
      final r = runPipeline(
        players: makePlayers(4),
        selectedColors: selectedColors(4),
        activeModules: [newWorkersModule],
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
        hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_1_'),
        ),
        isFalse,
      );
      expect(
        hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_2_'),
        ),
        isFalse,
      );

      // Tiles: overridden to manual quantities
      expect(tileQty(r.tiles, 'base.worker_red_1-1-1-1'), 2);
      expect(tileQty(r.tiles, 'base.worker_red_2-1-0-1'), 3);
    });

    test(
      'Test 36 — Tree of Life + New Workers 2p: removes Tree of Life 0-0-0-4 step',
      () {
        final diamanteExp = createDiamanteExpansion(
          selectedColors: selectedColors(2),
          modules: [treeOfLifeModule, newWorkersModule],
        );
        final r = runPipeline(
          players: makePlayers(2),
          selectedColors: selectedColors(2),
          activeModules: [treeOfLifeModule, newWorkersModule],
          expansions: [diamanteExp],
          workerSelection: const WorkerSelectionEntity(
            mode: WorkerSelectionMode.preset,
            presetType: WorkerPresetType.addAll,
          ),
        );

        // Tree of Life's per-player 0-0-0-4 step removed by New Workers handler
        expect(
          hasAnyStepMatching(
            r.stepIds,
            (id) => id.startsWith('setup_tree_of_life_add_0004_'),
          ),
          isFalse,
        );

        // New workers selection step present instead
        expect(hasStep(r.stepIds, 'setup_new_workers_selection'), isTrue);

        // Tree of Life jungle steps still present
        expect(hasStep(r.stepIds, 'setup_tree_of_life_add_tiles'), isTrue);

        // 0-0-0-4 tile still in the pool (handled by selector)
        expect(tileQty(r.tiles, 'diamante.worker_red_0-0-0-4'), 1);
        expect(tileQty(r.tiles, 'diamante.worker_purple_0-0-0-4'), 1);
      },
    );

    test(
      'Test 37 — Tree of Life + New Workers 4p: removes worker_1 if selection changes 1-1-1-1',
      () {
        final diamanteExp = createDiamanteExpansion(
          selectedColors: selectedColors(4),
          modules: [treeOfLifeModule, newWorkersModule],
        );
        final r = runPipeline(
          players: makePlayers(4),
          selectedColors: selectedColors(4),
          activeModules: [treeOfLifeModule, newWorkersModule],
          expansions: [diamanteExp],
          workerSelection: const WorkerSelectionEntity(
            mode: WorkerSelectionMode.preset,
            presetType: WorkerPresetType.replaceWithNew,
          ),
        );

        // New Workers handler removes all base removal steps unconditionally
        expect(
          hasAnyStepMatching(
            r.stepIds,
            (id) => id.startsWith('setup_remove_worker_1_'),
          ),
          isFalse,
        );

        // Both handlers remove setup_remove_worker_2_ (Tree of Life 4p + New Workers)
        expect(
          hasAnyStepMatching(
            r.stepIds,
            (id) => id.startsWith('setup_remove_worker_2_'),
          ),
          isFalse,
        );

        // Selection step present
        expect(hasStep(r.stepIds, 'setup_new_workers_selection'), isTrue);

        // 1-1-1-1 tiles gone
        expect(tileQty(r.tiles, 'base.worker_red_1-1-1-1'), 0);
      },
    );

    test('Test 38 — New Workers 3p baseOnly: removes base removal steps', () {
      final diamanteExp = createDiamanteExpansion(
        selectedColors: selectedColors(3),
        modules: [newWorkersModule],
      );
      final r = runPipeline(
        players: makePlayers(3),
        selectedColors: selectedColors(3),
        activeModules: [newWorkersModule],
        expansions: [diamanteExp],
        workerSelection: const WorkerSelectionEntity(
          mode: WorkerSelectionMode.preset,
          presetType: WorkerPresetType.baseOnly,
        ),
      );

      // Selector is authoritative — all base removal steps removed
      expect(
        hasAnyStepMatching(
          r.stepIds,
          (id) => id.startsWith('setup_remove_worker_1_'),
        ),
        isFalse,
      );

      // No new worker tiles in pool
      expect(tileQty(r.tiles, 'diamante.worker_red_0-0-0-4'), 0);
      expect(tileQty(r.tiles, 'diamante.worker_red_0-0-2-2'), 0);
    });

    test(
      'Test 39 — Toggle order independence: [NW, ToL] 2p addAll same as [ToL, NW]',
      () {
        // User toggled New Workers BEFORE Tree of Life. The pipeline must
        // run handlers in moduleId order (6 before 8) regardless, otherwise
        // the 0-0-0-4 tile gets duplicated and Tree of Life re-inserts the
        // per-player steps that New Workers subsumes.
        final diamanteExp = createDiamanteExpansion(
          selectedColors: selectedColors(2),
          modules: [newWorkersModule, treeOfLifeModule],
        );
        final r = runPipeline(
          players: makePlayers(2),
          selectedColors: selectedColors(2),
          activeModules: [newWorkersModule, treeOfLifeModule],
          expansions: [diamanteExp],
          workerSelection: const WorkerSelectionEntity(
            mode: WorkerSelectionMode.preset,
            presetType: WorkerPresetType.addAll,
          ),
        );

        // Exactly one 0-0-0-4 per player (no duplicate entry from ToL)
        expect(tileQty(r.tiles, 'diamante.worker_red_0-0-0-4'), 1);
        expect(tileQty(r.tiles, 'diamante.worker_purple_0-0-0-4'), 1);

        // Tree of Life's per-player steps stay removed
        expect(
          hasAnyStepMatching(
            r.stepIds,
            (id) => id.startsWith('setup_tree_of_life_add_0004_'),
          ),
          isFalse,
        );
        expect(hasStep(r.stepIds, 'setup_new_workers_selection'), isTrue);
      },
    );

    test(
      'Test 40 — Toggle order independence: [NW, ToL] 3p addAll keeps 1-1-1-1 at 4',
      () {
        // With handlers unsorted, Tree of Life (3p) would "restore" one
        // 1-1-1-1 AFTER the selector already set it to 4, yielding an
        // impossible quantity of 5 (only 4 copies exist per player).
        final diamanteExp = createDiamanteExpansion(
          selectedColors: selectedColors(3),
          modules: [newWorkersModule, treeOfLifeModule],
        );
        final r = runPipeline(
          players: makePlayers(3),
          selectedColors: selectedColors(3),
          activeModules: [newWorkersModule, treeOfLifeModule],
          expansions: [diamanteExp],
          workerSelection: const WorkerSelectionEntity(
            mode: WorkerSelectionMode.preset,
            presetType: WorkerPresetType.addAll,
          ),
        );

        expect(tileQty(r.tiles, 'base.worker_red_1-1-1-1'), 4);
        expect(tileQty(r.tiles, 'base.worker_white_1-1-1-1'), 4);
      },
    );

    test(
      'Test 41 — Tree of Life + New Workers 2p baseOnly: keeps mandatory 0-0-0-4',
      () {
        // Diamante rulebook (p. 3): with Tree of Life at 2 players, each
        // player MUST take their 0-0-0-4 tile from the New Workers module.
        // The baseOnly preset must not drop it.
        final diamanteExp = createDiamanteExpansion(
          selectedColors: selectedColors(2),
          modules: [treeOfLifeModule, newWorkersModule],
        );
        final r = runPipeline(
          players: makePlayers(2),
          selectedColors: selectedColors(2),
          activeModules: [treeOfLifeModule, newWorkersModule],
          expansions: [diamanteExp],
          workerSelection: const WorkerSelectionEntity(
            mode: WorkerSelectionMode.preset,
            presetType: WorkerPresetType.baseOnly,
          ),
        );

        expect(tileQty(r.tiles, 'diamante.worker_red_0-0-0-4'), 1);
        expect(tileQty(r.tiles, 'diamante.worker_purple_0-0-0-4'), 1);

        // Other new worker tiles stay excluded by the preset
        expect(tileQty(r.tiles, 'diamante.worker_red_0-0-2-2'), 0);
        expect(tileQty(r.tiles, 'diamante.worker_red_0-2-0-2'), 0);
        expect(tileQty(r.tiles, 'diamante.worker_red_0-1-0-3'), 0);
      },
    );

    test(
      'Test 42 — New Workers 2p baseWith0004: base tiles plus only 0-0-0-4',
      () {
        final diamanteExp = createDiamanteExpansion(
          selectedColors: selectedColors(2),
          modules: [newWorkersModule],
        );
        final r = runPipeline(
          players: makePlayers(2),
          selectedColors: selectedColors(2),
          activeModules: [newWorkersModule],
          expansions: [diamanteExp],
          workerSelection: const WorkerSelectionEntity(
            mode: WorkerSelectionMode.preset,
            presetType: WorkerPresetType.baseWith0004,
          ),
        );

        // Base tiles at default quantities
        expect(tileQty(r.tiles, 'base.worker_red_1-1-1-1'), 4);
        expect(tileQty(r.tiles, 'base.worker_red_2-1-0-1'), 5);
        expect(tileQty(r.tiles, 'base.worker_red_3-0-0-1'), 1);
        expect(tileQty(r.tiles, 'base.worker_red_3-1-0-0'), 1);

        // Only the 0-0-0-4 new tile added (12 per player total)
        expect(tileQty(r.tiles, 'diamante.worker_red_0-0-0-4'), 1);
        expect(tileQty(r.tiles, 'diamante.worker_red_0-0-2-2'), 0);
        expect(tileQty(r.tiles, 'diamante.worker_red_0-2-0-2'), 0);
        expect(tileQty(r.tiles, 'diamante.worker_red_0-1-0-3'), 0);
      },
    );
  });
}
