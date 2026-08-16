import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_actor.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/table_zone.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/map_module_handler.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/preparation_fixtures.dart';
import '../../../../../support/tile_fixtures.dart';

void main() {
  group('MapModuleHandler', () {
    late MapModuleHandler handler;
    late List<TileEntity> mockTiles;
    late List<PlayerEntity> mockPlayers;
    late List<PreparationEntity> mockPreparationSteps;

    setUp(() {
      handler = MapModuleHandler();

      mockTiles = [
        makeTile(
          id: 'base.jungle_single_plantation',
          name: 'Jungle Single Plantation',
          quantity: 8,
          type: TileType.plantation,
        ),
      ];

      mockPlayers = [
        PlayerEntity(name: 'Player 1', color: 'red'),
        PlayerEntity(name: 'Player 2', color: 'blue'),
      ];

      mockPreparationSteps = [
        makePrepStep(
          id: 'setup_tiles',
          detail: 'Each player takes their tiles.',
          actor: PreparationActor.allPlayers,
          tableZone: TableZone.playerArea,
          phase: PreparationPhase.playerSetup,
        ),
        makePrepStep(
          id: 'setup_jungle_display',
          detail: 'Setup jungle display.',
          tableZone: TableZone.jungleDisplay,
          phase: PreparationPhase.boardSetup,
        ),
      ];
    });

    group('adjustTiles', () {
      test('should not modify tiles', () {
        final result = handler.adjustTiles(mockTiles, 4, activeExpansions: []);

        expect(result, equals(mockTiles));
      });

      test('should have correct moduleId', () {
        expect(MapModuleHandler.moduleId, equals(1));
      });
    });

    group('modifyPreparationSteps', () {
      test('should add a single generalized map tokens step and replace jungle '
          'display', () {
        final result = handler.modifyPreparationSteps(
          mockPlayers,
          mockTiles,
          mockPreparationSteps,
        );

        // Original steps: 2 (setup_tiles, setup_jungle_display)
        // Added map tokens: 1 (single "each player" step)
        // Surplus step (2 players < 4): 1
        // Replaced jungle display with 2 steps: -1 + 2 = +1
        // Total expected: 2 + 1 + 1 + 1 = 5
        expect(result.length, equals(5));

        // Check the single generalized map tokens step
        final mapTokensIndex = result.indexWhere(
          (step) => step.id == 'setup_map_tokens',
        );
        expect(mapTokensIndex, greaterThan(0));
        expect(
          result[mapTokensIndex].phase,
          equals(PreparationPhase.playerSetup),
        );
        expect(result[mapTokensIndex].color, isNull);
        expect(
          result[mapTokensIndex].actor,
          equals(PreparationActor.allPlayers),
        );
        expect(result[mapTokensIndex].groupId, isNull);
        expect(result[mapTokensIndex].quantity, equals(2));

        // Check map tokens detail (generalized "each player" text)
        expect(
          result[mapTokensIndex].detail,
          equals('Each player takes 2 map tiles.'),
        );

        // Check surplus step exists (2 players < 4)
        final surplusIndex = result.indexWhere(
          (step) => step.id == 'setup_map_tokens_surplus',
        );
        expect(surplusIndex, greaterThan(mapTokensIndex));
        expect(
          result[surplusIndex].phase,
          equals(PreparationPhase.playerSetup),
        );
        expect(result[surplusIndex].tableZone, equals(TableZone.box));

        // Check replaced jungle display
        expect(
          result.any((step) => step.id == 'setup_jungle_display'),
          isFalse,
        );

        final mapBoardIndex = result.indexWhere(
          (step) => step.id == 'setup_map_board',
        );
        expect(mapBoardIndex, greaterThan(0));
        expect(
          result[mapBoardIndex].phase,
          equals(PreparationPhase.boardSetup),
        );
        expect(
          result[mapBoardIndex].detail,
          equals('Place the map board directly next to the jungle draw pile.'),
        );

        final jungleDisplayMapIndex = result.indexWhere(
          (step) => step.id == 'setup_jungle_display_map',
        );
        expect(jungleDisplayMapIndex, equals(mapBoardIndex + 1));
        expect(
          result[jungleDisplayMapIndex].phase,
          equals(PreparationPhase.boardSetup),
        );
      });

      test('should handle missing setup_jungle_display gracefully', () {
        final stepsWithoutDisplay = [
          makePrepStep(
            id: 'setup_tiles',
            detail: 'Each player takes their tiles.',
            actor: PreparationActor.allPlayers,
            tableZone: TableZone.playerArea,
            phase: PreparationPhase.playerSetup,
          ),
        ];

        final result = handler.modifyPreparationSteps(
          mockPlayers,
          mockTiles,
          stepsWithoutDisplay,
        );

        // Original: 1
        // Added map tokens: 1
        // Surplus step (2 players < 4): 1
        // Total: 3
        expect(result.length, equals(3));
        expect(result.any((step) => step.id == 'setup_map_board'), isFalse);
      });

      test('should not add surplus step for 4 players', () {
        final fourPlayers = [
          PlayerEntity(name: 'Player 1', color: 'red'),
          PlayerEntity(name: 'Player 2', color: 'blue'),
          PlayerEntity(name: 'Player 3', color: 'white'),
          PlayerEntity(name: 'Player 4', color: 'yellow'),
        ];

        final stepsWithFourPlayers = [
          makePrepStep(
            id: 'setup_tiles',
            detail: 'Each player takes their tiles.',
            actor: PreparationActor.allPlayers,
            tableZone: TableZone.playerArea,
            phase: PreparationPhase.playerSetup,
          ),
          makePrepStep(
            id: 'setup_jungle_display',
            detail: 'Setup jungle display.',
            tableZone: TableZone.jungleDisplay,
            phase: PreparationPhase.boardSetup,
          ),
        ];

        final result = handler.modifyPreparationSteps(
          fourPlayers,
          mockTiles,
          stepsWithFourPlayers,
        );

        // No surplus step for 4 players (8 tiles / 2 per player = 0 surplus)
        expect(
          result.any((step) => step.id == 'setup_map_tokens_surplus'),
          isFalse,
        );

        // Still a single generalized map tokens step regardless of count
        final mapTokenSteps = result
            .where((step) => step.id == 'setup_map_tokens')
            .toList();
        expect(mapTokenSteps.length, equals(1));
      });
    });
  });
}
