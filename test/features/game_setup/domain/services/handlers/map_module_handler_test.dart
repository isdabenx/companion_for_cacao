import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/map_module_handler.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/tile_fixtures.dart';

void main() {
  group('MapModuleHandler', () {
    late MapModuleHandler handler;
    late List<TileModel> mockTiles;
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
        const PreparationEntity(
          id: 'setup_tiles_red',
          description: 'Setup tiles for red',
          phase: PreparationPhase.playerSetup,
          color: 'red',
        ),
        const PreparationEntity(
          id: 'setup_tiles_blue',
          description: 'Setup tiles for blue',
          phase: PreparationPhase.playerSetup,
          color: 'blue',
        ),
        const PreparationEntity(
          id: 'setup_jungle_display',
          description: 'Setup jungle display',
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
      test(
        'should add map tokens for each player and replace jungle display',
        () {
          final result = handler.modifyPreparationSteps(
            mockPlayers,
            mockTiles,
            mockPreparationSteps,
          );

          // Original steps: 3
          // Added map tokens: 2
          // Surplus step (2 players < 4): 1
          // Replaced jungle display with 2 steps: -1 + 2 = +1
          // Total expected: 3 + 2 + 1 + 1 = 7
          expect(result.length, equals(7));

          // Check map tokens for red
          final mapTokensRedIndex = result.indexWhere(
            (step) => step.id == 'setup_map_tokens_red',
          );
          expect(mapTokensRedIndex, greaterThan(0));
          expect(
            result[mapTokensRedIndex].phase,
            equals(PreparationPhase.playerSetup),
          );
          expect(result[mapTokensRedIndex].color, equals('red'));

          // Check map tokens description (individual, no surplus text)
          expect(
            result[mapTokensRedIndex].description,
            equals('Player red takes 2 map tiles.'),
          );

          // Check map tokens for blue
          final mapTokensBlueIndex = result.indexWhere(
            (step) => step.id == 'setup_map_tokens_blue',
          );
          expect(mapTokensBlueIndex, greaterThan(0));
          expect(
            result[mapTokensBlueIndex].phase,
            equals(PreparationPhase.playerSetup),
          );
          expect(result[mapTokensBlueIndex].color, equals('blue'));

          // Check surplus step exists (2 players < 4)
          final surplusIndex = result.indexWhere(
            (step) => step.id == 'setup_map_tokens_surplus',
          );
          expect(surplusIndex, greaterThan(mapTokensBlueIndex));
          expect(
            result[surplusIndex].phase,
            equals(PreparationPhase.playerSetup),
          );

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

          final jungleDisplayMapIndex = result.indexWhere(
            (step) => step.id == 'setup_jungle_display_map',
          );
          expect(jungleDisplayMapIndex, equals(mapBoardIndex + 1));
          expect(
            result[jungleDisplayMapIndex].phase,
            equals(PreparationPhase.boardSetup),
          );
        },
      );

      test('should handle missing setup_jungle_display gracefully', () {
        final stepsWithoutDisplay = [
          const PreparationEntity(
            id: 'setup_tiles_red',
            description: 'Setup tiles for red',
            phase: PreparationPhase.playerSetup,
            color: 'red',
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
          const PreparationEntity(
            id: 'setup_tiles_red',
            description: 'Setup tiles for red',
            phase: PreparationPhase.playerSetup,
            color: 'red',
          ),
          const PreparationEntity(
            id: 'setup_tiles_blue',
            description: 'Setup tiles for blue',
            phase: PreparationPhase.playerSetup,
            color: 'blue',
          ),
          const PreparationEntity(
            id: 'setup_tiles_white',
            description: 'Setup tiles for white',
            phase: PreparationPhase.playerSetup,
            color: 'white',
          ),
          const PreparationEntity(
            id: 'setup_tiles_yellow',
            description: 'Setup tiles for yellow',
            phase: PreparationPhase.playerSetup,
            color: 'yellow',
          ),
          const PreparationEntity(
            id: 'setup_jungle_display',
            description: 'Setup jungle display',
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

        // Should have 4 map token steps
        final mapTokenSteps = result
            .where(
              (step) =>
                  step.id.startsWith('setup_map_tokens_') &&
                  step.id != 'setup_map_tokens_surplus',
            )
            .toList();
        expect(mapTokenSteps.length, equals(4));
      });
    });
  });
}
