import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/base_game_handler.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/tile_fixtures.dart';

void main() {
  group('BaseGameHandler', () {
    late BaseGameHandler handler;
    late BoardgameModel baseGame;
    late List<TileModel> allTiles;

    setUp(() {
      // Mock Data using string IDs
      allTiles = [
        // Jungle Tiles
        makeTile(
          id: 'base.jungle_single_plantation',
          name: 'Single Plantation',
          quantity: 8,
        ),
        makeTile(
          id: 'base.jungle_market_selling_3',
          name: 'Selling price 3',
          quantity: 2,
        ),
        makeTile(id: 'base.jungle_water', name: 'Water', quantity: 3),
        // Player Tiles (Red)
        makeTile(
          id: 'base.worker_red_1-1-1-1',
          name: '1-1-1-1',
          quantity: 4,
          color: TileColor.red,
        ),
        makeTile(
          id: 'base.worker_red_2-1-0-1',
          name: '2-1-0-1',
          quantity: 5,
          color: TileColor.red,
        ),
      ];

      baseGame = BoardgameModel(
        id: 1,
        name: 'Cacao',
        description: 'Base',
        filenameImage: '',
        tiles: allTiles,
      );
    });

    test(
      'adjustTiles should return only selected color tiles and jungle tiles',
      () {
        handler = BaseGameHandler(
          baseGame: baseGame,
          activeExpansions: [
            baseGame,
          ], // Simulating base game as expansion source too
          selectedColors: ['red'],
        );

        final result = handler.adjustTiles(
          allTiles,
          4,
          activeExpansions: [baseGame],
        );

        // Should contain Red tiles and Jungle tiles
        expect(result.any((t) => t.color.toString().contains('red')), isTrue);
        expect(result.any((t) => t.color == null), isTrue);
      },
    );

    test('adjustTiles should reduce jungle tiles for 2 players', () {
      handler = BaseGameHandler(
        baseGame: baseGame,
        activeExpansions: [baseGame],
        selectedColors: ['red', 'purple'],
      );

      // 2 Players -> reduce specific tiles
      final result = handler.adjustTiles(
        allTiles,
        2,
        activeExpansions: [baseGame],
      );

      // 'Single Plantation' starts with 8. 2-player rule reduces by 2. Expect 6.
      final plantation = result.firstWhere(
        (t) => t.id == TileIds.singlePlantation,
      );
      expect(plantation.quantity, 6);

      // 'Selling price 3' starts with 2. 2-player rule reduces by 1. Expect 1.
      final market = result.firstWhere((t) => t.id == TileIds.marketSelling3);
      expect(market.quantity, 1);
    });

    test('adjustTiles should reduce player tiles for >2 players', () {
      handler = BaseGameHandler(
        baseGame: baseGame,
        activeExpansions: [baseGame],
        selectedColors: ['red', 'purple', 'white'],
      );

      // 3 Players -> '1-1-1-1' reduced by 1
      final result = handler.adjustTiles(
        allTiles,
        3,
        activeExpansions: [baseGame],
      );

      final tile1111 = result.firstWhere(
        (t) => t.id == TileIds.workerTile('red', '1-1-1-1'),
      );
      // Original 4. Reduced by 1 -> 3.
      expect(tile1111.quantity, 3);
    });

    group('modifyPreparationSteps', () {
      test('should generate all base preparation steps for 2 players', () {
        handler = BaseGameHandler(
          baseGame: baseGame,
          activeExpansions: [baseGame],
          selectedColors: ['red', 'purple'],
        );

        final players = [
          PlayerEntity(name: 'Player 1', color: 'red'),
          PlayerEntity(name: 'Player 2', color: 'purple'),
        ];

        final result = handler.modifyPreparationSteps(players, allTiles, []);

        // Player setup steps: 4 per player (village board, water carrier, water field, tiles)
        final playerSetupSteps = result
            .where((s) => s.phase == PreparationPhase.playerSetup)
            .toList();
        // 4 steps per player + 1 shuffle step = 9
        expect(playerSetupSteps.length, 9);

        // Board setup steps: initial tiles + 6 individual 2p removal + jungle draw pile + jungle display = 9
        final boardSetupSteps = result
            .where((s) => s.phase == PreparationPhase.boardSetup)
            .toList();
        expect(boardSetupSteps.length, 9);

        // Supply steps: 1 (resources bank)
        final supplySteps = result
            .where((s) => s.phase == PreparationPhase.supplies)
            .toList();
        expect(supplySteps.length, 1);
      });

      test(
        'should include individual jungle tile removal steps for 2 players',
        () {
          handler = BaseGameHandler(
            baseGame: baseGame,
            activeExpansions: [baseGame],
            selectedColors: ['red', 'purple'],
          );

          final players = [
            PlayerEntity(name: 'Player 1', color: 'red'),
            PlayerEntity(name: 'Player 2', color: 'purple'),
          ];

          final result = handler.modifyPreparationSteps(players, allTiles, []);

          final removalSteps = result
              .where((s) => s.id.startsWith('setup_jungle_tiles_2p_removal_'))
              .toList();
          expect(removalSteps.length, 6);

          // Verify each tile has its own step with correct imageKey
          expect(
            removalSteps[0].id,
            'setup_jungle_tiles_2p_removal_single_plantation',
          );
          expect(removalSteps[0].description, contains('2x Single Plantation'));
          expect(removalSteps[0].imageKey, 'jungle_single_plantation');

          expect(
            removalSteps[1].id,
            'setup_jungle_tiles_2p_removal_market_selling_3',
          );
          expect(
            removalSteps[1].description,
            contains('Market, selling price 3'),
          );

          expect(
            removalSteps[2].id,
            'setup_jungle_tiles_2p_removal_gold_mine_value_1',
          );
          expect(removalSteps[2].description, contains('Gold Mine, value 1'));

          expect(removalSteps[3].id, 'setup_jungle_tiles_2p_removal_water');
          expect(removalSteps[3].description, contains('Water'));

          expect(
            removalSteps[4].id,
            'setup_jungle_tiles_2p_removal_sun_worshiping_site',
          );
          expect(removalSteps[4].description, contains('Sun-Worshiping Site'));

          expect(removalSteps[5].id, 'setup_jungle_tiles_2p_removal_temple');
          expect(removalSteps[5].description, contains('Temple'));

          // All should be in boardSetup phase
          for (final step in removalSteps) {
            expect(step.phase, PreparationPhase.boardSetup);
          }
        },
      );

      test(
        'should place jungle tile removal steps before jungle draw pile step',
        () {
          handler = BaseGameHandler(
            baseGame: baseGame,
            activeExpansions: [baseGame],
            selectedColors: ['red', 'purple'],
          );

          final players = [
            PlayerEntity(name: 'Player 1', color: 'red'),
            PlayerEntity(name: 'Player 2', color: 'purple'),
          ];

          final result = handler.modifyPreparationSteps(players, allTiles, []);

          final lastRemovalIndex = result.lastIndexWhere(
            (s) => s.id.startsWith('setup_jungle_tiles_2p_removal_'),
          );
          final drawPileIndex = result.indexWhere(
            (s) => s.id == 'setup_jungle_draw_pile',
          );
          expect(lastRemovalIndex, lessThan(drawPileIndex));
        },
      );

      test('should NOT include jungle tile removal steps for 3 players', () {
        handler = BaseGameHandler(
          baseGame: baseGame,
          activeExpansions: [baseGame],
          selectedColors: ['red', 'purple', 'white'],
        );

        final players = [
          PlayerEntity(name: 'Player 1', color: 'red'),
          PlayerEntity(name: 'Player 2', color: 'purple'),
          PlayerEntity(name: 'Player 3', color: 'white'),
        ];

        final result = handler.modifyPreparationSteps(players, allTiles, []);

        final removalStep = result.where(
          (s) => s.id.startsWith('setup_jungle_tiles_2p_removal_'),
        );
        expect(removalStep.length, 0);
      });

      test('should NOT include jungle tile removal step for 4 players', () {
        handler = BaseGameHandler(
          baseGame: baseGame,
          activeExpansions: [baseGame],
          selectedColors: ['red', 'purple', 'white', 'yellow'],
        );

        final players = [
          PlayerEntity(name: 'Player 1', color: 'red'),
          PlayerEntity(name: 'Player 2', color: 'purple'),
          PlayerEntity(name: 'Player 3', color: 'white'),
          PlayerEntity(name: 'Player 4', color: 'yellow'),
        ];

        final result = handler.modifyPreparationSteps(players, allTiles, []);

        final removalStep = result.where(
          (s) => s.id.startsWith('setup_jungle_tiles_2p_removal_'),
        );
        expect(removalStep.length, 0);
      });

      test('should include worker tile removal steps for 3 players', () {
        handler = BaseGameHandler(
          baseGame: baseGame,
          activeExpansions: [baseGame],
          selectedColors: ['red', 'purple', 'white'],
        );

        final players = [
          PlayerEntity(name: 'Player 1', color: 'red'),
          PlayerEntity(name: 'Player 2', color: 'purple'),
          PlayerEntity(name: 'Player 3', color: 'white'),
        ];

        final result = handler.modifyPreparationSteps(players, allTiles, []);

        // Should have removal steps for 1-1-1-1 for each player with matching tiles
        final removalSteps = result.where(
          (s) => s.id.startsWith('setup_remove_worker_1_'),
        );
        // Only red has tiles in our mock data
        expect(removalSteps.length, 1);
        expect(removalSteps.first.id, 'setup_remove_worker_1_red');
      });

      test('should NOT include worker tile removal steps for 2 players', () {
        handler = BaseGameHandler(
          baseGame: baseGame,
          activeExpansions: [baseGame],
          selectedColors: ['red', 'purple'],
        );

        final players = [
          PlayerEntity(name: 'Player 1', color: 'red'),
          PlayerEntity(name: 'Player 2', color: 'purple'),
        ];

        final result = handler.modifyPreparationSteps(players, allTiles, []);

        final removalSteps = result.where(
          (s) => s.id.startsWith('setup_remove_worker_'),
        );
        expect(removalSteps.length, 0);
      });
    });
  });
}
