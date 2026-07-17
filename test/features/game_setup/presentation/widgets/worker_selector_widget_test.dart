import 'dart:async';

import 'package:companion_for_cacao/config/providers/repository_providers.dart';
import 'package:companion_for_cacao/core/data/models/module_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/worker_selection_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/repositories/custom_preset_repository.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/worker_selector_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class FakeGameSetupNotifier extends GameSetupNotifier {
  FakeGameSetupNotifier(this.initial);

  final GameSetupStateEntity initial;

  @override
  FutureOr<GameSetupStateEntity> build() => initial;
}

class MockCustomPresetRepository extends Mock
    implements CustomPresetRepository {}

void main() {
  late MockCustomPresetRepository mockPresetRepository;

  final treeOfLifeModule = ModuleModel(
    id: 6,
    name: 'Tree of Life',
    description: '',
    boardgameId: 2,
  );
  final newWorkersModule = ModuleModel(
    id: 8,
    name: 'The New Workers',
    description: '',
    boardgameId: 2,
  );

  GameSetupStateEntity buildState({
    int playerCount = 2,
    List<ModuleModel> modules = const [],
    WorkerSelectionEntity? workerSelection,
  }) {
    const colors = ['red', 'purple', 'white', 'yellow'];
    return GameSetupStateEntity(
      players: [
        for (var i = 0; i < playerCount; i++)
          PlayerEntity(name: 'Player $i', color: colors[i], isSelected: true),
      ],
      modules: modules,
      isStarted: true,
      workerSelection: workerSelection,
    );
  }

  Widget buildTestApp(GameSetupStateEntity state) {
    return ProviderScope(
      overrides: [
        gameSetupProvider.overrideWith(() => FakeGameSetupNotifier(state)),
        customPresetRepositoryProvider.overrideWithValue(mockPresetRepository),
      ],
      child: const MaterialApp(home: Scaffold(body: WorkerSelectorWidget())),
    );
  }

  Future<void> openEditor(WidgetTester tester) async {
    await tester.tap(find.byType(InkWell).first);
    await tester.pumpAndSettle();
  }

  setUp(() {
    mockPresetRepository = MockCustomPresetRepository();
    when(() => mockPresetRepository.getPresets()).thenAnswer((_) async => []);
    when(
      () => mockPresetRepository.savePresets(any()),
    ).thenAnswer((_) async {});
  });

  setUpAll(() {
    registerFallbackValue(<Never>[]);
  });

  group('WorkerSelectorWidget summary row', () {
    testWidgets('shows default label when no selection applied', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(buildState(modules: [newWorkersModule])),
      );
      await tester.pumpAndSettle();

      expect(find.text('The New Workers'), findsOneWidget);
      expect(find.text('Add all (default) · 15 tiles/player'), findsOneWidget);
    });

    testWidgets('shows preset label for an applied preset', (tester) async {
      await tester.pumpWidget(
        buildTestApp(
          buildState(
            modules: [newWorkersModule],
            workerSelection: const WorkerSelectionEntity(
              presetType: WorkerPresetType.baseWith0004,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Base + 0-0-0-4 · 12 tiles/player'), findsOneWidget);
    });

    testWidgets('shows Surprise label for a surprise selection', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          buildState(
            modules: [newWorkersModule],
            workerSelection: const WorkerSelectionEntity(
              mode: WorkerSelectionMode.manual,
              tileQuantities: {
                '1-1-1-1': 4,
                '2-1-0-1': 5,
                '3-0-0-1': 1,
                '3-1-0-0': 1,
                '0-0-0-4': 1,
                '0-0-2-2': 1,
              },
              isSurprise: true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Surprise · 13 tiles/player'), findsOneWidget);
    });
  });

  group('WorkerSelectorWidget editor sheet', () {
    testWidgets('shows all preset chips and the Surprise action', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(buildState(playerCount: 3, modules: [newWorkersModule])),
      );
      await tester.pumpAndSettle();
      await openEditor(tester);

      expect(find.text('Base only'), findsOneWidget);
      expect(find.text('Replace'), findsOneWidget);
      expect(find.text('Base + 0-0-0-4'), findsOneWidget);
      expect(find.text('Add all'), findsOneWidget);
      expect(find.text('Surprise +2'), findsOneWidget);
    });

    testWidgets(
      'hides Base only with Tree of Life at 2 players (0-0-0-4 mandatory)',
      (tester) async {
        await tester.pumpWidget(
          buildTestApp(
            buildState(modules: [treeOfLifeModule, newWorkersModule]),
          ),
        );
        await tester.pumpAndSettle();
        await openEditor(tester);

        expect(find.text('Base only'), findsNothing);
        expect(find.text('Base + 0-0-0-4'), findsOneWidget);
      },
    );

    testWidgets('keeps Base only with Tree of Life at 3 players', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(
          buildState(
            playerCount: 3,
            modules: [treeOfLifeModule, newWorkersModule],
          ),
        ),
      );
      await tester.pumpAndSettle();
      await openEditor(tester);

      expect(find.text('Base only'), findsOneWidget);
    });

    testWidgets('Apply stays enabled when balance is out of range', (
      tester,
    ) async {
      // Empty tile pool → 0 jungle tiles → addAll is far out of range
      await tester.pumpWidget(
        buildTestApp(buildState(modules: [newWorkersModule])),
      );
      await tester.pumpAndSettle();
      await openEditor(tester);

      expect(find.text('Outside recommended range'), findsOneWidget);

      final applyButton = tester.widget<FilledButton>(
        find.ancestor(
          of: find.text('Apply'),
          matching: find.byType(FilledButton),
        ),
      );
      expect(applyButton.onPressed, isNotNull);
    });

    testWidgets('Surprise generates base tiles plus exactly 2 new ones', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildTestApp(buildState(playerCount: 3, modules: [newWorkersModule])),
      );
      await tester.pumpAndSettle();
      await openEditor(tester);

      await tester.tap(find.text('Surprise +2'));
      await tester.pumpAndSettle();

      // 11 base + 2 random new = 13 per player
      expect(find.text('Tiles per player: 13'), findsOneWidget);
      expect(
        find.textContaining('Surprise: base tiles + 2 new Diamante tiles'),
        findsOneWidget,
      );
    });
  });
}
