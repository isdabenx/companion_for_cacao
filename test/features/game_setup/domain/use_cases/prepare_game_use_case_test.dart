import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/use_cases/prepare_game_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late PrepareGameUseCase useCase;

  setUp(() {
    useCase = PrepareGameUseCase();
  });

  test('execute should prepare game correctly for 2 players', () {
    final baseGame = BoardgameModel(
      id: 1,
      name: 'Cacao',
      description: 'Base Game',
      filenameImage: 'cacao.png',
      tiles: [
        TileModel(
          id: 1,
          boardgameId: 1,
          name: '1-1-1-1',
          description: 'Worker',
          filenameImage: 'worker.png',
          quantity: 4,
          color: TileColor.red,
        ),
        TileModel(
          id: 2,
          boardgameId: 1,
          name: '1-1-1-1',
          description: 'Worker',
          filenameImage: 'worker.png',
          quantity: 4,
          color: TileColor.white,
        ),
        TileModel(
          id: 3,
          boardgameId: 1,
          name: 'Single Plantation',
          description: 'Jungle',
          filenameImage: 'jungle.png',
          quantity: 4,
        ),
      ],
    );

    final initialState = GameSetupStateEntity(
      players: [
        PlayerEntity(name: 'Player 1', color: 'red', isSelected: true),
        PlayerEntity(name: 'Player 2', color: 'white', isSelected: true),
        PlayerEntity(name: 'Player 3', color: 'purple', isSelected: false),
      ],
      expansions: [baseGame],
      modules: [],
    );

    final result = useCase.execute(initialState);

    expect(result.players.length, 2);
    expect(result.players[0].name, 'Player 1');
    expect(result.players[1].name, 'Player 2');
    expect(result.modules.isEmpty, true);

    // BaseGameHandler logic for 2 players reduces 'Single Plantation' by 2
    final singlePlantationTiles = result.tiles
        .where((t) => t.name == 'Single Plantation')
        .toList();
    expect(singlePlantationTiles.length, 1);
    expect(singlePlantationTiles.first.quantity, 2); // 4 - 2 = 2

    // Check preparation steps
    expect(result.preparation.isNotEmpty, true);
    expect(
      result.preparation.any(
        (p) => p.description.contains('Player red takes the village board'),
      ),
      true,
    );
    expect(
      result.preparation.any(
        (p) => p.description.contains('Player white takes the village board'),
      ),
      true,
    );
  });
}
