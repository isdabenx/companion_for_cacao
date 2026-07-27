import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_actor.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/table_zone.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/base_game_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/preparation_steps.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/tile_fixtures.dart';

void main() {
  group('BaseGameHandler', () {
    late BaseGameHandler handler;
    late BoardgameEntity baseGame;
    late List<TileEntity> allTiles;

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

      baseGame = BoardgameEntity(
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

        // Personal setup is stated once for all players (village board,
        // water carrier fused with its field, tiles) + 1 shuffle step = 4.
        final playerSetupSteps = result
            .where((s) => s.phase == PreparationPhase.playerSetup)
            .toList();
        expect(playerSetupSteps.length, 4);

        // Board setup steps: initial tiles + gather jungle + 6 individual 2p
        // removals + jungle draw pile + jungle display = 10
        final boardSetupSteps = result
            .where((s) => s.phase == PreparationPhase.boardSetup)
            .toList();
        expect(boardSetupSteps.length, 10);

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
          expect(removalSteps[0].detail, contains('2x Single Plantation'));
          expect(removalSteps[0].imageKey, 'jungle_single_plantation');

          expect(
            removalSteps[1].id,
            'setup_jungle_tiles_2p_removal_market_selling_3',
          );
          expect(removalSteps[1].detail, contains('Market, selling price 3'));

          expect(
            removalSteps[2].id,
            'setup_jungle_tiles_2p_removal_gold_mine_value_1',
          );
          expect(removalSteps[2].detail, contains('Gold Mine, value 1'));

          expect(removalSteps[3].id, 'setup_jungle_tiles_2p_removal_water');
          expect(removalSteps[3].detail, contains('Water'));

          expect(
            removalSteps[4].id,
            'setup_jungle_tiles_2p_removal_sun_worshiping_site',
          );
          expect(removalSteps[4].detail, contains('Sun-Worshiping Site'));

          expect(removalSteps[5].id, 'setup_jungle_tiles_2p_removal_temple');
          expect(removalSteps[5].detail, contains('Temple'));

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

        // A single generalized "each player returns their 1-1-1-1" step.
        final removalSteps = result.where(
          (s) => s.id.startsWith('setup_remove_worker_1'),
        );
        expect(removalSteps.length, 1);
        expect(removalSteps.first.id, 'setup_remove_worker_1');
        expect(removalSteps.first.actor, PreparationActor.allPlayers);
        expect(removalSteps.first.groupId, isNull);
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
          (s) => s.id.startsWith('setup_remove_worker'),
        );
        expect(removalSteps.length, 0);
      });
    });

    // Structured fields introduced by Fase UX-1 (docs/spec-fase-ux1.md).
    group('structured preparation steps (UX-1)', () {
      List<PreparationEntity> stepsFor(List<String> colors) {
        handler = BaseGameHandler(
          baseGame: baseGame,
          activeExpansions: [baseGame],
          selectedColors: colors,
        );
        final players = [
          for (final (i, color) in colors.indexed)
            PlayerEntity(name: 'Player ${i + 1}', color: color),
        ];
        return handler.modifyPreparationSteps(players, allTiles, []);
      }

      test('fuses the water carrier and water field steps into one', () {
        final result = stepsFor(['red', 'purple']);

        expect(result.any((s) => s.id == 'setup_water_carrier'), isTrue);
        expect(
          result.any((s) => s.id.startsWith('setup_water_field_')),
          isFalse,
        );
        final carrier = result.firstWhere((s) => s.id == 'setup_water_carrier');
        expect(carrier.detail, contains('"-10"'));
      });

      test('states each personal step once for all players', () {
        final result = stepsFor(['red', 'purple']);

        // Identical per-player actions are a single "each player…" step now,
        // not one per colour — so no per-colour ids and no player group.
        for (final id in const [
          'setup_village_board',
          'setup_water_carrier',
          'setup_tiles',
        ]) {
          final matches = result.where((s) => s.id == id).toList();
          expect(matches, hasLength(1), reason: id);
          expect(matches.single.actor, PreparationActor.allPlayers);
          expect(matches.single.groupId, isNull);
          expect(matches.single.color, isNull);
        }
      });

      test('collects 2p jungle removals into the jungle group '
          'with quantities and box zone', () {
        final result = stepsFor(['red', 'purple']);

        final removals = result.where(
          (s) => s.id.startsWith('setup_jungle_tiles_2p_removal_'),
        );
        expect(removals.length, 6);
        for (final step in removals) {
          expect(step.groupId, PreparationGroups.jungle);
          expect(step.tableZone, TableZone.box);
          expect(step.quantity, isNotNull);
          expect(step.rationale, isNotNull);
        }
        final plantation = removals.firstWhere(
          (s) => s.id == 'setup_jungle_tiles_2p_removal_single_plantation',
        );
        expect(plantation.quantity, 2);
      });

      test('assigns actors and zones to the shared table steps', () {
        final result = stepsFor(['red', 'purple']);

        final shuffle = result.firstWhere(
          (s) => s.id == 'setup_shuffle_workers',
        );
        expect(shuffle.actor, PreparationActor.allPlayers);
        expect(shuffle.tableZone, TableZone.playerArea);

        final initial = result.firstWhere(
          (s) => s.id == 'setup_initial_tiles_plantation_market',
        );
        expect(initial.tableZone, TableZone.startingArea);

        final pile = result.firstWhere((s) => s.id == 'setup_jungle_draw_pile');
        expect(pile.tableZone, TableZone.junglePile);

        final bank = result.firstWhere((s) => s.id == 'setup_resources_bank');
        expect(bank.tableZone, TableZone.supplies);
      });

      test('every step provides a non-empty label and detail', () {
        final result = stepsFor(['red', 'purple', 'yellow']);

        for (final step in result) {
          expect(step.label, isNotEmpty, reason: step.id);
          expect(step.detail, isNotEmpty, reason: step.id);
        }
      });
    });
  });
}
