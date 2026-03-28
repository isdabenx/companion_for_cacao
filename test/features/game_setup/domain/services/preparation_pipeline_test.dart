import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/module_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/base_game_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/module_preparation_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/preparation_pipeline.dart';
import 'package:flutter_test/flutter_test.dart';

class MockBaseGameHandler implements BaseGameHandler {
  @override
  List<BoardgameModel> get activeExpansions => [];

  @override
  BoardgameModel get baseGame => BoardgameModel(
    id: 1,
    name: 'Base',
    description: '',
    filenameImage: '',
    tiles: [],
  );

  @override
  List<String> get selectedColors => [];

  @override
  List<TileModel> adjustTiles(
    List<TileModel> tiles,
    int playerCount, {
    required List<BoardgameModel> activeExpansions,
  }) {
    return [
      _createTile(id: 'tile_1', quantity: 2),
      _createTile(id: 'tile_2', quantity: 1),
    ];
  }

  @override
  List<PreparationEntity> modifyPreparationSteps(
    List<PlayerEntity> players,
    List<TileModel> tiles,
    List<PreparationEntity> currentSteps,
  ) {
    return [
      const PreparationEntity(
        id: 'base_step',
        description: 'Base step',
        phase: PreparationPhase.boardSetup,
      ),
    ];
  }
}

class MockModuleHandler implements ModulePreparationHandler {
  @override
  List<TileModel> adjustTiles(
    List<TileModel> tiles,
    int playerCount, {
    required List<BoardgameModel> activeExpansions,
  }) {
    return tiles.map((t) {
      if (t.id == 'tile_1') {
        return t.copyWith(quantity: 0); // Set quantity to 0 to test filtering
      }
      return t;
    }).toList()..add(_createTile(id: 'module_tile', quantity: 3));
  }

  @override
  List<PreparationEntity> modifyPreparationSteps(
    List<PlayerEntity> players,
    List<TileModel> tiles,
    List<PreparationEntity> currentSteps,
  ) {
    return [
      ...currentSteps,
      const PreparationEntity(
        id: 'module_step',
        description: 'Module step',
        phase: PreparationPhase.boardSetup,
      ),
    ];
  }
}

void main() {
  group('PreparationPipeline', () {
    late PreparationPipeline pipeline;
    late MockBaseGameHandler baseHandler;
    late MockModuleHandler moduleHandler;

    setUp(() {
      baseHandler = MockBaseGameHandler();
      moduleHandler = MockModuleHandler();
      pipeline = PreparationPipeline(
        baseHandler: baseHandler,
        moduleHandlers: {1: moduleHandler},
      );
    });

    test(
      'should execute base handler and filter out tiles with quantity 0',
      () {
        final state = GameSetupStateEntity(
          players: [PlayerEntity(name: 'P1', color: 'red')],
          expansions: [],
          modules: [],
        );

        final result = pipeline.execute(state);

        expect(result.tiles.length, 2);
        expect(result.tiles.any((t) => t.id == 'tile_1'), isTrue);
        expect(result.tiles.any((t) => t.id == 'tile_2'), isTrue);
        expect(result.preparation.length, 1);
        expect(result.preparation.first.id, 'base_step');
      },
    );

    test(
      'should execute module handlers and filter out tiles with quantity 0',
      () {
        final state = GameSetupStateEntity(
          players: [PlayerEntity(name: 'P1', color: 'red')],
          expansions: [],
          modules: [
            ModuleModel(
              id: 1,
              name: 'Module 1',
              description: '',
              boardgameId: 1,
            ),
          ],
        );

        final result = pipeline.execute(state);

        // tile_1 should be filtered out because its quantity was set to 0 by the module handler
        expect(result.tiles.length, 2);
        expect(result.tiles.any((t) => t.id == 'tile_1'), isFalse);
        expect(result.tiles.any((t) => t.id == 'tile_2'), isTrue);
        expect(result.tiles.any((t) => t.id == 'module_tile'), isTrue);

        expect(result.preparation.length, 2);
        expect(result.preparation[0].id, 'base_step');
        expect(result.preparation[1].id, 'module_step');
      },
    );

    test('should ignore unknown modules', () {
      final state = GameSetupStateEntity(
        players: [PlayerEntity(name: 'P1', color: 'red')],
        expansions: [],
        modules: [
          ModuleModel(
            id: 99,
            name: 'Unknown Module',
            description: '',
            boardgameId: 1,
          ),
        ],
      );

      final result = pipeline.execute(state);

      expect(result.tiles.length, 2);
      expect(result.preparation.length, 1);
    });
  });
}

TileModel _createTile({required String id, required int quantity}) {
  return TileModel(
    id: id,
    name: 'Test Tile',
    description: 'Test',
    filenameImage: 'test.png',
    quantity: quantity,
    type: TileType.plantation,
    boardgameId: 1,
  );
}
