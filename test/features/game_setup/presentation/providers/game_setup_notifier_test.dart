import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/module_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/worker_selection_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/use_cases/prepare_game_use_case.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_use_case_providers.dart';
import 'package:companion_for_cacao/features/tile/tile_public_api.dart';
import 'package:companion_for_cacao/shared/providers/boardgame_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../support/fakes.dart';

class MockPrepareGameUseCase extends Mock implements PrepareGameUseCase {}

class FakeGameSetupStateEntity extends Fake implements GameSetupStateEntity {}

void main() {
  late BoardgameModel baseGame;
  late BoardgameModel chocolatl;
  late ModuleModel mapModule;
  late List<ModuleModel> allModules;
  late MockPrepareGameUseCase mockPrepareGameUseCase;

  ProviderContainer createContainer({
    List<BoardgameModel>? boardgames,
    PrepareGameUseCase? prepareGameUseCase,
  }) {
    return ProviderContainer(
      overrides: [
        boardgameProvider.overrideWith(
          () => FakeBoardgameNotifier(boardgames ?? [baseGame, chocolatl]),
        ),
        if (prepareGameUseCase != null)
          prepareGameUseCaseProvider.overrideWithValue(prepareGameUseCase),
      ],
    );
  }

  setUpAll(() {
    registerFallbackValue(FakeGameSetupStateEntity());
  });

  setUp(() {
    baseGame = BoardgameModel(
      id: 1,
      name: 'Cacao',
      description: 'Base Game',
      filenameImage: 'cacao.png',
    );
    mapModule = ModuleModel(
      id: 1,
      name: 'Map',
      description: 'Map module',
      boardgameId: 2,
    );
    allModules = List.generate(
      8,
      (index) => ModuleModel(
        id: index + 1,
        name: 'Module ${index + 1}',
        description: 'Module ${index + 1} description',
        boardgameId: 2,
      ),
    );
    chocolatl = BoardgameModel(
      id: 2,
      name: 'Chocolatl',
      description: 'Expansion',
      filenameImage: 'chocolatl.png',
      modules: allModules,
    );
    mockPrepareGameUseCase = MockPrepareGameUseCase();
  });

  group('GameSetupNotifier', () {
    test('build returns initial state with base game expansion', () async {
      final container = createContainer();
      addTearDown(container.dispose);

      final state = await container.read(gameSetupProvider.future);

      expect(state.players, isEmpty);
      expect(state.modules, isEmpty);
      expect(state.expansions.length, 1);
      expect(state.expansions.first.id, 1);
      expect(state.expansions.first.name, 'Cacao');
      expect(state.isStarted, isFalse);
      expect(state.isBigGame, isFalse);
    });

    test('addPlayer adds player to state', () async {
      final container = createContainer();
      addTearDown(container.dispose);
      await container.read(gameSetupProvider.future);

      final notifier = container.read(gameSetupProvider.notifier);
      notifier.addPlayer('Alice', 'red');

      final state = await container.read(gameSetupProvider.future);

      expect(state.players.length, 1);
      expect(state.players.first.name, 'Alice');
      expect(state.players.first.color, 'red');
      expect(state.players.first.isSelected, isTrue);
    });

    test('removePlayer removes player by color', () async {
      final container = createContainer();
      addTearDown(container.dispose);
      await container.read(gameSetupProvider.future);

      final notifier = container.read(gameSetupProvider.notifier);
      notifier.addPlayer('Alice', 'red');
      notifier.addPlayer('Bob', 'yellow');
      notifier.removePlayer('red');

      final state = await container.read(gameSetupProvider.future);

      expect(state.players.length, 1);
      expect(state.players.first.name, 'Bob');
      expect(state.players.first.color, 'yellow');
    });

    test('reorderPlayers reorders player list', () async {
      final container = createContainer();
      addTearDown(container.dispose);
      await container.read(gameSetupProvider.future);

      final notifier = container.read(gameSetupProvider.notifier);
      notifier.addPlayer('Alice', 'red');
      notifier.addPlayer('Bob', 'yellow');
      notifier.addPlayer('Carla', 'white');
      notifier.reorderPlayers(0, 2);

      final state = await container.read(gameSetupProvider.future);

      expect(state.players.map((player) => player.name).toList(), [
        'Bob',
        'Alice',
        'Carla',
      ]);
    });

    test('updatePlayerSelection toggles player selection', () async {
      final container = createContainer();
      addTearDown(container.dispose);
      await container.read(gameSetupProvider.future);

      final notifier = container.read(gameSetupProvider.notifier);
      notifier.addPlayer('Alice', 'red');
      notifier.updatePlayerSelection('red', isSelected: false);

      final state = await container.read(gameSetupProvider.future);

      expect(state.players.length, 1);
      expect(state.players.first.isSelected, isFalse);
    });

    test('toggleExpansion adds and removes expansions', () async {
      final container = createContainer();
      addTearDown(container.dispose);
      await container.read(gameSetupProvider.future);

      final notifier = container.read(gameSetupProvider.notifier);
      notifier.toggleExpansion(chocolatl);

      var state = await container.read(gameSetupProvider.future);
      expect(state.expansions.map((expansion) => expansion.id).toList(), [
        1,
        2,
      ]);

      notifier.toggleExpansion(chocolatl);
      state = await container.read(gameSetupProvider.future);

      expect(state.expansions.map((expansion) => expansion.id).toList(), [1]);
    });

    test('toggleModule adds and removes modules', () async {
      final container = createContainer();
      addTearDown(container.dispose);
      await container.read(gameSetupProvider.future);

      final notifier = container.read(gameSetupProvider.notifier);
      notifier.toggleModule(mapModule);

      var state = await container.read(gameSetupProvider.future);
      expect(state.modules.map((module) => module.id).toList(), [1]);

      notifier.toggleModule(mapModule);
      state = await container.read(gameSetupProvider.future);

      expect(state.modules, isEmpty);
    });

    test('setBigGame sets big game flag', () async {
      final container = createContainer();
      addTearDown(container.dispose);
      await container.read(gameSetupProvider.future);

      final notifier = container.read(gameSetupProvider.notifier);
      notifier.setBigGame(true);

      final state = await container.read(gameSetupProvider.future);

      expect(state.isBigGame, isTrue);
    });

    test(
      '_resetBigGameIfInvalid resets bigGame when a module is removed',
      () async {
        final container = createContainer();
        addTearDown(container.dispose);
        await container.read(gameSetupProvider.future);

        final notifier = container.read(gameSetupProvider.notifier);
        notifier.addPlayer('Alice', 'red');
        notifier.addPlayer('Bob', 'yellow');
        notifier.addPlayer('Carla', 'white');
        for (final module in allModules) {
          notifier.toggleModule(module);
        }
        notifier.setBigGame(true);

        notifier.toggleModule(allModules.first);

        final state = await container.read(gameSetupProvider.future);

        expect(state.modules.length, 7);
        expect(state.isBigGame, isFalse);
      },
    );

    test(
      '_resetBigGameIfInvalid resets bigGame when player count is invalid',
      () async {
        final container = createContainer();
        addTearDown(container.dispose);
        await container.read(gameSetupProvider.future);

        final notifier = container.read(gameSetupProvider.notifier);
        notifier.addPlayer('Alice', 'red');
        notifier.addPlayer('Bob', 'yellow');
        notifier.addPlayer('Carla', 'white');
        for (final module in allModules) {
          notifier.toggleModule(module);
        }
        notifier.setBigGame(true);

        notifier.removePlayer('white');

        final state = await container.read(gameSetupProvider.future);

        expect(state.players.length, 2);
        expect(state.isBigGame, isFalse);
      },
    );

    test(
      'startGame calls PrepareGameUseCase and sets isStarted to true',
      () async {
        final preparedTile = TileModel(
          id: 'prepared_tile',
          name: 'Prepared Tile',
          description: 'Prepared tile description',
          filenameImage: 'prepared.png',
          quantity: 1,
        );
        final preparedStep = PreparationEntity(
          id: 'prep-1',
          description: 'Prepare the board',
          phase: PreparationPhase.boardSetup,
        );
        final preparedState = GameSetupStateEntity(
          players: [
            PlayerEntity(name: 'Alice', color: 'red', isSelected: true),
            PlayerEntity(name: 'Bob', color: 'yellow', isSelected: true),
          ],
          expansions: [baseGame],
          tiles: [preparedTile],
          preparation: [preparedStep],
        );
        when(
          () => mockPrepareGameUseCase.execute(any()),
        ).thenReturn(preparedState);

        final container = createContainer(
          prepareGameUseCase: mockPrepareGameUseCase,
        );
        addTearDown(container.dispose);
        await container.read(gameSetupProvider.future);

        final notifier = container.read(gameSetupProvider.notifier);
        notifier.addPlayer('Alice', 'red');
        notifier.addPlayer('Bob', 'yellow');
        notifier.startGame();

        final state = await container.read(gameSetupProvider.future);

        verify(() => mockPrepareGameUseCase.execute(any())).called(1);
        expect(state.tiles.length, 1);
        expect(state.tiles.first.id, 'prepared_tile');
        expect(state.preparation.length, 1);
        expect(state.preparation.first.id, 'prep-1');
        expect(state.isStarted, isTrue);
      },
    );

    test(
      'resetGame clears preparation and tiles and sets isStarted to false',
      () async {
        final preparedTile = TileModel(
          id: 'prepared_tile',
          name: 'Prepared Tile',
          description: 'Prepared tile description',
          filenameImage: 'prepared.png',
          quantity: 1,
        );
        final preparedStep = PreparationEntity(
          id: 'prep-1',
          description: 'Prepare the board',
          phase: PreparationPhase.boardSetup,
        );
        final preparedState = GameSetupStateEntity(
          players: [
            PlayerEntity(name: 'Alice', color: 'red', isSelected: true),
            PlayerEntity(name: 'Bob', color: 'yellow', isSelected: true),
          ],
          expansions: [baseGame],
          tiles: [preparedTile],
          preparation: [preparedStep],
        );
        when(
          () => mockPrepareGameUseCase.execute(any()),
        ).thenReturn(preparedState);

        final container = createContainer(
          prepareGameUseCase: mockPrepareGameUseCase,
        );
        addTearDown(container.dispose);
        await container.read(gameSetupProvider.future);

        final notifier = container.read(gameSetupProvider.notifier);
        notifier.addPlayer('Alice', 'red');
        notifier.addPlayer('Bob', 'yellow');
        notifier.startGame();
        notifier.resetGame();

        final state = await container.read(gameSetupProvider.future);

        expect(state.players.length, 2);
        expect(state.tiles, isEmpty);
        expect(state.preparation, isEmpty);
        expect(state.isStarted, isFalse);
      },
    );

    test(
      'applyWorkerSelection stores selection and re-runs pipeline',
      () async {
        when(() => mockPrepareGameUseCase.execute(any())).thenAnswer(
          (inv) => inv.positionalArguments.first as GameSetupStateEntity,
        );

        final container = createContainer(
          prepareGameUseCase: mockPrepareGameUseCase,
        );
        addTearDown(container.dispose);
        await container.read(gameSetupProvider.future);

        final notifier = container.read(gameSetupProvider.notifier);
        notifier.addPlayer('Alice', 'red');
        notifier.startGame();

        const selection = WorkerSelectionEntity(
          mode: WorkerSelectionMode.preset,
          presetType: WorkerPresetType.baseOnly,
        );
        notifier.applyWorkerSelection(selection);

        final state = await container.read(gameSetupProvider.future);

        expect(state.workerSelection, selection);
        expect(state.isStarted, isTrue);
        // Once for startGame, once for applyWorkerSelection
        verify(() => mockPrepareGameUseCase.execute(any())).called(2);
      },
    );

    test(
      'startGame does not reuse a worker selection from a previous game',
      () async {
        when(() => mockPrepareGameUseCase.execute(any())).thenAnswer(
          (inv) => inv.positionalArguments.first as GameSetupStateEntity,
        );

        final container = createContainer(
          prepareGameUseCase: mockPrepareGameUseCase,
        );
        addTearDown(container.dispose);
        await container.read(gameSetupProvider.future);

        final notifier = container.read(gameSetupProvider.notifier);
        notifier.addPlayer('Alice', 'red');
        notifier.startGame();
        notifier.applyWorkerSelection(
          const WorkerSelectionEntity(
            mode: WorkerSelectionMode.manual,
            tileQuantities: {'1-1-1-1': 4, '0-0-0-4': 1},
          ),
        );

        // Starting a new game must begin from the default selection
        notifier.startGame();

        final state = await container.read(gameSetupProvider.future);
        expect(state.workerSelection, isNull);

        // The setup passed to the pipeline on the last call had no selection
        final captured = verify(
          () => mockPrepareGameUseCase.execute(captureAny()),
        ).captured;
        final lastSetup = captured.last as GameSetupStateEntity;
        expect(lastSetup.workerSelection, isNull);
      },
    );

    test(
      'toggleModule removing Module D (id 8) clears the worker selection',
      () async {
        when(() => mockPrepareGameUseCase.execute(any())).thenAnswer(
          (inv) => inv.positionalArguments.first as GameSetupStateEntity,
        );

        final container = createContainer(
          prepareGameUseCase: mockPrepareGameUseCase,
        );
        addTearDown(container.dispose);
        await container.read(gameSetupProvider.future);

        final notifier = container.read(gameSetupProvider.notifier);
        final moduleD = allModules.firstWhere((m) => m.id == 8);
        notifier.addPlayer('Alice', 'red');
        notifier.toggleModule(moduleD);
        notifier.startGame();
        notifier.applyWorkerSelection(const WorkerSelectionEntity());

        notifier.toggleModule(moduleD); // removes Module D

        final state = await container.read(gameSetupProvider.future);
        expect(state.modules.any((m) => m.id == 8), isFalse);
        expect(state.workerSelection, isNull);
      },
    );

    test('startGame clears the in-play tile filter', () async {
      when(() => mockPrepareGameUseCase.execute(any())).thenAnswer(
        (inv) => inv.positionalArguments.first as GameSetupStateEntity,
      );

      final container = createContainer(
        prepareGameUseCase: mockPrepareGameUseCase,
      );
      addTearDown(container.dispose);
      await container.read(gameSetupProvider.future);

      // Leftover filter from a previous game's Tiles in Play screen
      container
          .read(tileFilterProvider(TileFilterScope.inPlay).notifier)
          .updateSearchQuery('water');
      expect(
        container
            .read(tileFilterProvider(TileFilterScope.inPlay))
            .hasActiveFilters,
        isTrue,
      );

      container.read(gameSetupProvider.notifier)
        ..addPlayer('Alice', 'red')
        ..startGame();

      expect(
        container
            .read(tileFilterProvider(TileFilterScope.inPlay))
            .hasActiveFilters,
        isFalse,
      );
    });

    test('resetGame clears the worker selection', () async {
      when(() => mockPrepareGameUseCase.execute(any())).thenAnswer(
        (inv) => inv.positionalArguments.first as GameSetupStateEntity,
      );

      final container = createContainer(
        prepareGameUseCase: mockPrepareGameUseCase,
      );
      addTearDown(container.dispose);
      await container.read(gameSetupProvider.future);

      final notifier = container.read(gameSetupProvider.notifier);
      notifier.addPlayer('Alice', 'red');
      notifier.startGame();
      notifier.applyWorkerSelection(const WorkerSelectionEntity());
      notifier.resetGame();

      final state = await container.read(gameSetupProvider.future);
      expect(state.workerSelection, isNull);
      expect(state.isStarted, isFalse);
    });

    test('clearAll resets to initial state', () async {
      final container = createContainer();
      addTearDown(container.dispose);
      await container.read(gameSetupProvider.future);

      final notifier = container.read(gameSetupProvider.notifier);
      notifier.addPlayer('Alice', 'red');
      notifier.toggleExpansion(chocolatl);
      notifier.toggleModule(mapModule);
      notifier.setBigGame(true);
      await notifier.clearAll();

      final state = await container.read(gameSetupProvider.future);

      expect(state.players, isEmpty);
      expect(state.modules, isEmpty);
      expect(state.tiles, isEmpty);
      expect(state.preparation, isEmpty);
      expect(state.expansions.length, 1);
      expect(state.expansions.first.id, 1);
      expect(state.colorOrder, ['white', 'red', 'purple', 'yellow']);
      expect(state.isStarted, isFalse);
      expect(state.isBigGame, isFalse);
    });

    test('updatePlayerName keeps player order and Big Game state', () async {
      final container = createContainer();
      addTearDown(container.dispose);
      await container.read(gameSetupProvider.future);

      final notifier = container.read(gameSetupProvider.notifier);
      notifier.addPlayer('Alice', 'red');
      notifier.addPlayer('Bob', 'yellow');
      notifier.addPlayer('Carla', 'white');
      for (final module in allModules) {
        notifier.toggleModule(module);
      }
      notifier.setBigGame(true);

      // Renaming (as the name field does per keystroke) must not disturb
      // player order nor invalidate Big Game via player-count checks.
      notifier.updatePlayerName('red', 'Alicia');

      final state = await container.read(gameSetupProvider.future);
      expect(state.players.map((p) => p.name).toList(), [
        'Alicia',
        'Bob',
        'Carla',
      ]);
      expect(state.isBigGame, isTrue);
    });

    test('reorderColorOrder reorders color list', () async {
      final container = createContainer();
      addTearDown(container.dispose);
      await container.read(gameSetupProvider.future);

      final notifier = container.read(gameSetupProvider.notifier);
      notifier.reorderColorOrder(0, 2);

      final state = await container.read(gameSetupProvider.future);

      expect(state.colorOrder, ['red', 'purple', 'white', 'yellow']);
    });

    test('updatePlayerName updates player name', () async {
      final container = createContainer();
      addTearDown(container.dispose);
      await container.read(gameSetupProvider.future);

      final notifier = container.read(gameSetupProvider.notifier);
      notifier.addPlayer('Alice', 'red');
      notifier.updatePlayerName('red', 'Alicia');

      final state = await container.read(gameSetupProvider.future);

      expect(state.players.length, 1);
      expect(state.players.first.name, 'Alicia');
    });

    test(
      'togglePreparationCompletion toggles preparation item completion',
      () async {
        final preparedState = GameSetupStateEntity(
          players: [
            PlayerEntity(name: 'Alice', color: 'red', isSelected: true),
            PlayerEntity(name: 'Bob', color: 'yellow', isSelected: true),
          ],
          expansions: [baseGame],
          preparation: const [
            PreparationEntity(
              id: 'prep-1',
              description: 'Prepare the board',
              phase: PreparationPhase.boardSetup,
            ),
            PreparationEntity(
              id: 'prep-2',
              description: 'Give players their pieces',
              phase: PreparationPhase.playerSetup,
              isCompleted: true,
            ),
          ],
        );
        when(
          () => mockPrepareGameUseCase.execute(any()),
        ).thenReturn(preparedState);

        final container = createContainer(
          prepareGameUseCase: mockPrepareGameUseCase,
        );
        addTearDown(container.dispose);
        await container.read(gameSetupProvider.future);

        final notifier = container.read(gameSetupProvider.notifier);
        notifier.addPlayer('Alice', 'red');
        notifier.addPlayer('Bob', 'yellow');
        notifier.startGame();
        notifier.togglePreparationCompletion('prep-1');

        final state = await container.read(gameSetupProvider.future);

        expect(state.preparation.length, 2);
        expect(state.preparation.first.isCompleted, isTrue);
        expect(state.preparation.last.isCompleted, isTrue);
      },
    );
  });
}
