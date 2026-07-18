import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/watering_module_handler.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/tile_fixtures.dart';

void main() {
  group('WateringModuleHandler', () {
    late WateringModuleHandler handler;
    late List<TileModel> mockTiles;
    late List<PlayerEntity> mockPlayers;
    late List<PreparationEntity> mockPreparationSteps;

    setUp(() {
      handler = WateringModuleHandler();

      // Create mock tiles including plantation tiles that should be replaced
      mockTiles = [
        makeTile(
          id: 'base.jungle_single_plantation',
          name: 'Jungle Single Plantation',
          quantity: 8,
          type: TileType.plantation,
        ),
        makeTile(
          id: 'base.jungle_double_plantation',
          name: 'Jungle Double Plantation',
          quantity: 4,
          type: TileType.plantation,
        ),
        makeTile(
          id: 'base.market_2',
          name: 'Market Price 2',
          quantity: 5,
          type: TileType.market,
        ),
        makeTile(
          id: 'chocolatl.jungle_watering',
          name: 'Jungle Watering',
          quantity: 3,
          type: TileType.watering,
        ),
      ];

      mockPlayers = [
        PlayerEntity(name: 'Player 1', color: 'red'),
        PlayerEntity(name: 'Player 2', color: 'blue'),
      ];

      mockPreparationSteps = [
        const PreparationEntity(
          id: 'setup_initial_tiles_plantation_market',
          description: 'Initial step with plantation and market',
          phase: PreparationPhase.tilePool,
        ),
        const PreparationEntity(
          id: 'step_1',
          description: 'Another step',
          phase: PreparationPhase.tilePool,
        ),
      ];
    });

    group('adjustTiles', () {
      test('should remove plantations and add watering tiles for 4 players', () {
        final result = handler.adjustTiles(
          mockTiles,
          4,
          activeExpansions: [_createMockExpansion()],
        );

        // For 4 players (3+ players): remove 1 single plantation + 2 double plantations
        final singlePlantation = result.firstWhere(
          (t) => t.id == 'base.jungle_single_plantation',
        );
        final doublePlantation = result.firstWhere(
          (t) => t.id == 'base.jungle_double_plantation',
        );
        final wateringTile = result.firstWhere(
          (t) => t.id == 'chocolatl.jungle_watering',
        );

        // Single plantation: 8 - 1 = 7
        expect(singlePlantation.quantity, equals(7));
        // Double plantation: 4 - 2 = 2
        expect(doublePlantation.quantity, equals(2));
        // Watering tiles: 3 + 3 = 6
        expect(wateringTile.quantity, equals(6));
      });

      test('should have correct moduleId', () {
        expect(WateringModuleHandler.moduleId, equals(2));
      });

      test(
        'should remove 2 double plantations and add watering tiles for 2 players',
        () {
          final result = handler.adjustTiles(
            mockTiles,
            2,
            activeExpansions: [_createMockExpansion()],
          );

          final doublePlantation = result.firstWhere(
            (t) => t.id == 'base.jungle_double_plantation',
          );
          final wateringTile = result.firstWhere(
            (t) => t.id == 'chocolatl.jungle_watering',
          );

          // Double plantation: 4 - 2 = 2
          expect(doublePlantation.quantity, equals(2));
          // Watering tiles: 3 + 2 = 5
          expect(wateringTile.quantity, equals(5));
        },
      );
    });

    group('modifyPreparationSteps', () {
      test(
        'should replace setup_initial_tiles_plantation_market with setup_initial_tiles_plantation_water',
        () {
          final result = handler.modifyPreparationSteps(
            mockPlayers,
            mockTiles,
            mockPreparationSteps,
          );

          // Find the modified step
          final modifiedStep = result.firstWhere(
            (step) => step.id == 'setup_initial_tiles_plantation_water',
          );

          // Verify the step was modified with correct ID and description
          expect(
            modifiedStep.id,
            equals('setup_initial_tiles_plantation_water'),
          );
          expect(modifiedStep.description.contains('"water"'), isTrue);
          expect(
            modifiedStep.description.contains('single plantation'),
            isTrue,
          );
        },
      );

      group('tile substitution steps', () {
        late List<PreparationEntity> stepsWithDrawPile;

        setUp(() {
          stepsWithDrawPile = [
            const PreparationEntity(
              id: 'setup_initial_tiles_plantation_market',
              description: 'Initial step',
              phase: PreparationPhase.boardSetup,
            ),
            const PreparationEntity(
              id: 'setup_jungle_draw_pile',
              description: 'Mix remaining jungle tiles',
              phase: PreparationPhase.boardSetup,
            ),
          ];
        });

        test('should add 2 substitution steps for 2 players', () {
          final result = handler.modifyPreparationSteps(
            mockPlayers,
            mockTiles,
            stepsWithDrawPile,
          );

          final removeDoublePlantation = result.where(
            (s) => s.id == 'setup_watering_remove_double_plantation',
          );
          final addWatering = result.where(
            (s) => s.id == 'setup_watering_add_watering_tiles',
          );

          expect(removeDoublePlantation, hasLength(1));
          expect(addWatering, hasLength(1));
          expect(
            removeDoublePlantation.first.description,
            contains('2x Double Plantation'),
          );
          expect(addWatering.first.description, contains('2x Watering'));
          expect(
            removeDoublePlantation.first.imageKey,
            equals('jungle_double_plantation'),
          );
          expect(addWatering.first.imageKey, equals('jungle_watering'));
        });

        test('should add 3 substitution steps for 3+ players', () {
          final players3 = [
            PlayerEntity(name: 'Player 1', color: 'red'),
            PlayerEntity(name: 'Player 2', color: 'blue'),
            PlayerEntity(name: 'Player 3', color: 'white'),
          ];

          final result = handler.modifyPreparationSteps(
            players3,
            mockTiles,
            stepsWithDrawPile,
          );

          final removeSinglePlantation = result.where(
            (s) => s.id == 'setup_watering_remove_single_plantation',
          );
          final removeDoublePlantation = result.where(
            (s) => s.id == 'setup_watering_remove_double_plantation',
          );
          final addWatering = result.where(
            (s) => s.id == 'setup_watering_add_watering_tiles',
          );

          expect(removeSinglePlantation, hasLength(1));
          expect(removeDoublePlantation, hasLength(1));
          expect(addWatering, hasLength(1));
          expect(
            removeSinglePlantation.first.description,
            contains('1x Single Plantation'),
          );
          expect(addWatering.first.description, contains('3x Watering'));
        });

        test(
          'should insert substitution steps before setup_jungle_draw_pile',
          () {
            final result = handler.modifyPreparationSteps(
              mockPlayers,
              mockTiles,
              stepsWithDrawPile,
            );

            final drawPileIndex = result.indexWhere(
              (s) => s.id == 'setup_jungle_draw_pile',
            );
            final removeIndex = result.indexWhere(
              (s) => s.id == 'setup_watering_remove_double_plantation',
            );
            final addIndex = result.indexWhere(
              (s) => s.id == 'setup_watering_add_watering_tiles',
            );

            expect(removeIndex, lessThan(drawPileIndex));
            expect(addIndex, lessThan(drawPileIndex));
            expect(removeIndex, lessThan(addIndex));
          },
        );
      });
    });

    group('interface compliance', () {
      test('should implement ModulePreparationHandler interface', () {
        // Verify that the handler properly implements the interface
        expect(
          handler.adjustTiles(
            mockTiles,
            4,
            activeExpansions: [_createMockExpansion()],
          ),
          isA<List<TileModel>>(),
        );
        expect(
          handler.modifyPreparationSteps(
            mockPlayers,
            mockTiles,
            mockPreparationSteps,
          ),
          isA<List<PreparationEntity>>(),
        );
      });

      test('should handle empty tile list gracefully', () {
        final result = handler.adjustTiles(
          [],
          4,
          activeExpansions: [_createMockExpansion()],
        );
        // Empty list might gain watering tile if handler creates it
        expect(result, isA<List<TileModel>>());
      });

      test('should handle empty preparation steps gracefully', () {
        final result = handler.modifyPreparationSteps(
          mockPlayers,
          mockTiles,
          [],
        );
        // With no initial tiles step to replace and no draw pile to insert
        // before, substitution steps are appended
        expect(
          result.any((s) => s.id == 'setup_watering_remove_double_plantation'),
          isTrue,
        );
      });

      test('should handle various player counts', () {
        for (var playerCount = 2; playerCount <= 4; playerCount++) {
          final result = handler.adjustTiles(
            mockTiles,
            playerCount,
            activeExpansions: [_createMockExpansion()],
          );
          expect(result, isA<List<TileModel>>());
        }
      });
    });

    group('edge cases', () {
      test('should handle tiles with no plantations', () {
        final tilesWithoutPlantations = [
          makeTile(
            id: 'base.market_2',
            name: 'Market Price 2',
            quantity: 5,
            type: TileType.market,
          ),
        ];

        final result = handler.adjustTiles(
          tilesWithoutPlantations,
          4,
          activeExpansions: [_createMockExpansion()],
        );
        // Should still have the market tile plus possibly watering tile added
        expect(result.length, greaterThanOrEqualTo(1));
      });

      test('should handle minimum player count (2)', () {
        final result = handler.adjustTiles(
          mockTiles,
          2,
          activeExpansions: [_createMockExpansion()],
        );
        expect(result, isNotEmpty);
      });

      test('should handle maximum player count (4)', () {
        final result = handler.adjustTiles(
          mockTiles,
          4,
          activeExpansions: [_createMockExpansion()],
        );
        expect(result, isNotEmpty);
      });
    });
  });
}

// Helper to create mock expansions with watering tile
BoardgameModel _createMockExpansion() {
  return makeBoardgame(
    id: 2,
    name: 'Chocolatl',
    tiles: [
      makeTile(
        id: 'chocolatl.jungle_watering',
        name: 'Jungle Watering',
        quantity: 10,
        type: TileType.watering,
        boardgameId: 2,
        moduleId: WateringModuleHandler.moduleId,
      ),
    ],
  );
}
