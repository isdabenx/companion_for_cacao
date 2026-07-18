import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/emperor_favor_module_handler.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../../support/tile_fixtures.dart';

void main() {
  group('EmperorFavorModuleHandler', () {
    late EmperorFavorModuleHandler handler;
    late List<TileEntity> mockTiles;
    late List<PlayerEntity> mockPlayers;

    setUp(() {
      handler = EmperorFavorModuleHandler();

      mockTiles = [
        makeTile(
          id: 'base.jungle_single_plantation',
          name: 'Single Plantation',
          quantity: 6,
          type: TileType.plantation,
        ),
        makeTile(
          id: 'base.jungle_market_selling_2',
          name: 'Selling price 2',
          quantity: 2,
          type: TileType.market,
        ),
      ];

      mockPlayers = [
        PlayerEntity(name: 'Player 1', color: 'red'),
        PlayerEntity(name: 'Player 2', color: 'purple'),
      ];
    });

    group('adjustTiles', () {
      test('should have correct moduleId', () {
        expect(EmperorFavorModuleHandler.moduleId, equals(7));
      });

      test('returns tiles unchanged (pass-through)', () {
        final result = handler.adjustTiles(
          mockTiles,
          2,
          activeExpansions: [makeBoardgame(id: 2, name: 'Chocolatl')],
        );

        expect(result, same(mockTiles));
      });

      test('returns tiles unchanged for Big Game', () {
        final result = handler.adjustTiles(
          mockTiles,
          4,
          activeExpansions: [makeBoardgame(id: 2, name: 'Chocolatl')],
          isBigGame: true,
        );

        expect(result, same(mockTiles));
      });
    });

    group('modifyPreparationSteps', () {
      test('inserts emperor step right after the market initial tiles step '
          'when Watering is not active', () {
        final steps = [
          const PreparationEntity(
            id: 'setup_initial_tiles_plantation_market',
            description: 'Lay out plantation and market',
            phase: PreparationPhase.boardSetup,
          ),
          const PreparationEntity(
            id: 'setup_jungle_draw_pile',
            description: 'Mix remaining jungle tiles',
            phase: PreparationPhase.boardSetup,
          ),
        ];

        final result = handler.modifyPreparationSteps(
          mockPlayers,
          mockTiles,
          steps,
        );

        expect(result, hasLength(3));
        final emperorIndex = result.indexWhere((s) => s.id == 'setup_emperor');
        final initialIndex = result.indexWhere(
          (s) => s.id == 'setup_initial_tiles_plantation_market',
        );
        expect(emperorIndex, initialIndex + 1);

        final emperorStep = result[emperorIndex];
        expect(emperorStep.description, contains('market, selling price 2'));
        expect(emperorStep.phase, PreparationPhase.boardSetup);
        expect(emperorStep.imageKey, 'emperor_figure');
      });

      test('places emperor on the water tile when Watering module '
          'is active', () {
        final steps = [
          const PreparationEntity(
            id: 'setup_initial_tiles_plantation_water',
            description: 'Lay out plantation and water',
            phase: PreparationPhase.boardSetup,
          ),
          const PreparationEntity(
            id: 'setup_jungle_draw_pile',
            description: 'Mix remaining jungle tiles',
            phase: PreparationPhase.boardSetup,
          ),
        ];

        final result = handler.modifyPreparationSteps(
          mockPlayers,
          mockTiles,
          steps,
        );

        final emperorIndex = result.indexWhere((s) => s.id == 'setup_emperor');
        final initialIndex = result.indexWhere(
          (s) => s.id == 'setup_initial_tiles_plantation_water',
        );
        expect(emperorIndex, initialIndex + 1);
        expect(result[emperorIndex].description, contains('water tile'));
      });

      test('appends emperor step when no initial tiles step exists', () {
        final steps = [
          const PreparationEntity(
            id: 'setup_jungle_draw_pile',
            description: 'Mix remaining jungle tiles',
            phase: PreparationPhase.boardSetup,
          ),
        ];

        final result = handler.modifyPreparationSteps(
          mockPlayers,
          mockTiles,
          steps,
        );

        expect(result.last.id, 'setup_emperor');
        expect(result.last.description, contains('market, selling price 2'));
      });

      test('does not modify the original steps list content', () {
        final steps = [
          const PreparationEntity(
            id: 'setup_initial_tiles_plantation_market',
            description: 'Lay out plantation and market',
            phase: PreparationPhase.boardSetup,
          ),
        ];

        handler.modifyPreparationSteps(mockPlayers, mockTiles, steps);

        expect(steps, hasLength(1));
      });
    });
  });
}
