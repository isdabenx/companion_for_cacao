import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/map_module_handler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MapModuleHandler', () {
    late MapModuleHandler handler;
    late List<TileModel> mockTiles;
    late List<PlayerEntity> mockPlayers;
    late List<PreparationEntity> mockPreparationSteps;

    setUp(() {
      handler = MapModuleHandler();

      mockTiles = [
        _createTile(
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
          // Replaced jungle display with 2 steps: -1 + 2 = +1
          // Total expected: 3 + 2 + 1 = 6
          expect(result.length, equals(6));

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
        // Total: 2
        expect(result.length, equals(2));
        expect(result.any((step) => step.id == 'setup_map_board'), isFalse);
      });
    });
  });
}

// Helper function to create mock tiles
TileModel _createTile({
  required String id,
  required String name,
  required int quantity,
  required TileType type,
}) {
  return TileModel(
    id: id,
    name: name,
    description: 'Test description',
    filenameImage: 'test.png',
    quantity: quantity,
    type: type,
    boardgameId: 1,
  );
}
