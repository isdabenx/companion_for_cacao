import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/base_game_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/use_cases/prepare_game_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late PrepareGameUseCase useCase;

  setUp(() {
    useCase = PrepareGameUseCase();
  });

  test('execute should prepare game correctly for 2 players', () {
    final baseGame = BoardgameEntity(
      id: 1,
      name: 'Cacao',
      description: 'Base Game',
      filenameImage: 'cacao.png',
      tiles: [
        TileEntity(
          id: TileIds.workerTile('red', '1-1-1-1'),
          boardgameId: 1,
          name: '1-1-1-1',
          description: 'Worker',
          filenameImage: 'worker.png',
          quantity: 4,
          color: TileColor.red,
        ),
        TileEntity(
          id: TileIds.workerTile('white', '1-1-1-1'),
          boardgameId: 1,
          name: '1-1-1-1',
          description: 'Worker',
          filenameImage: 'worker.png',
          quantity: 4,
          color: TileColor.white,
        ),
        TileEntity(
          id: TileIds.singlePlantation,
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
        .where((t) => t.id == TileIds.singlePlantation)
        .toList();
    expect(singlePlantationTiles.length, 1);
    expect(singlePlantationTiles.first.quantity, 2); // 4 - 2 = 2

    // Check preparation steps: a single generalized "each player takes the
    // village board of their colour" step (no per-colour steps).
    expect(result.preparation.isNotEmpty, true);
    final villageBoardSteps = result.preparation
        .where((p) => p.id == 'setup_village_board')
        .toList();
    expect(villageBoardSteps.length, 1);
    expect(
      villageBoardSteps.first.detail.contains('village board of their colour'),
      true,
    );
  });

  test('base-only game adds mixed-storage notes for every expansion', () {
    final baseGame = BoardgameEntity(
      id: 1,
      name: 'Cacao',
      description: 'Base Game',
      filenameImage: 'cacao.png',
      tiles: [
        TileEntity(
          id: TileIds.workerTile('red', '1-1-1-1'),
          boardgameId: 1,
          name: '1-1-1-1',
          description: 'Worker',
          filenameImage: 'worker.png',
          quantity: 4,
          color: TileColor.red,
        ),
        TileEntity(
          id: TileIds.workerTile('white', '1-1-1-1'),
          boardgameId: 1,
          name: '1-1-1-1',
          description: 'Worker',
          filenameImage: 'worker.png',
          quantity: 4,
          color: TileColor.white,
        ),
        TileEntity(
          id: TileIds.singlePlantation,
          boardgameId: 1,
          name: 'Single Plantation',
          description: 'Jungle',
          filenameImage: 'jungle.png',
          quantity: 4,
        ),
      ],
    );

    final result = useCase.execute(
      GameSetupStateEntity(
        players: [
          PlayerEntity(name: 'P1', color: 'red', isSelected: true),
          PlayerEntity(name: 'P2', color: 'white', isSelected: true),
        ],
        expansions: [baseGame],
        modules: [],
      ),
    );

    final notes = result.preparation
        .where((p) => p.id.startsWith('setup_jungle_purge_'))
        .toList();
    // One note per expansion with unused jungle tiles (Xocolatl + Diamante).
    expect(notes.length, 2);
    for (final note in notes) {
      expect(note.informational, isTrue);
      // Pre-completed so it never blocks progress or the celebration.
      expect(note.isCompleted, isTrue);
      expect(note.groupId, 'group_jungle');
    }
    expect(notes.any((n) => n.id == 'setup_jungle_purge_xocolatl'), isTrue);
    expect(notes.any((n) => n.id == 'setup_jungle_purge_diamante'), isTrue);
  });
}
