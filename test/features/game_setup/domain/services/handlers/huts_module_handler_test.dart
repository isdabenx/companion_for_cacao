import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/huts_module_handler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HutsModuleHandler', () {
    late HutsModuleHandler handler;
    late List<TileModel> mockTiles;
    late List<PlayerEntity> mockPlayers;
    late List<PreparationEntity> mockPreparationSteps;

    setUp(() {
      handler = HutsModuleHandler();

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
          id: 'setup_board_1',
          description: 'Board setup step 1',
          phase: PreparationPhase.boardSetup,
        ),
        const PreparationEntity(
          id: 'setup_board_2',
          description: 'Board setup step 2',
          phase: PreparationPhase.boardSetup,
        ),
        const PreparationEntity(
          id: 'setup_player_1',
          description: 'Player setup step 1',
          phase: PreparationPhase.playerSetup,
        ),
      ];
    });

    group('adjustTiles', () {
      test('should not modify tiles', () {
        final result = handler.adjustTiles(mockTiles, 4, activeExpansions: []);

        expect(result, equals(mockTiles));
      });

      test('should have correct moduleId', () {
        expect(HutsModuleHandler.moduleId, equals(4));
      });
    });

    group('modifyPreparationSteps', () {
      test(
        'should insert setup_huts_market at the end of boardSetup phase',
        () {
          final result = handler.modifyPreparationSteps(
            mockPlayers,
            mockTiles,
            mockPreparationSteps,
          );

          expect(result.length, equals(mockPreparationSteps.length + 1));

          final hutsMarketIndex = result.indexWhere(
            (step) => step.id == 'setup_huts_market',
          );
          expect(hutsMarketIndex, equals(2)); // After setup_board_2 (index 1)
          expect(
            result[hutsMarketIndex].phase,
            equals(PreparationPhase.boardSetup),
          );
        },
      );

      test(
        'should not insert setup_huts_market if no boardSetup phase exists',
        () {
          final stepsWithoutBoardSetup = [
            const PreparationEntity(
              id: 'setup_player_1',
              description: 'Player setup step 1',
              phase: PreparationPhase.playerSetup,
            ),
          ];

          final result = handler.modifyPreparationSteps(
            mockPlayers,
            mockTiles,
            stepsWithoutBoardSetup,
          );

          expect(result.length, equals(stepsWithoutBoardSetup.length));
          expect(result.any((step) => step.id == 'setup_huts_market'), isFalse);
        },
      );
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
