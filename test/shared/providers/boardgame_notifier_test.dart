import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/shared/domain/use_cases/load_boardgames_use_case.dart';
import 'package:companion_for_cacao/shared/providers/boardgame_notifier.dart';
import 'package:companion_for_cacao/shared/providers/boardgame_use_case_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoadBoardgamesUseCase extends Mock implements LoadBoardgamesUseCase {}

class TestException implements Exception {
  const TestException(this.message);

  final String message;

  @override
  String toString() => 'TestException($message)';
}

void main() {
  late MockLoadBoardgamesUseCase mockUseCase;
  late List<BoardgameModel> mockBoardgames;

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      retry: (_, __) => null,
      overrides: [
        loadBoardgamesUseCaseProvider.overrideWith(
          (ref) => Future.value(mockUseCase),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    mockUseCase = MockLoadBoardgamesUseCase();
    mockBoardgames = [
      BoardgameModel(
        id: 1,
        name: 'Cacao',
        description: 'Base game',
        filenameImage: 'cacao.png',
      ),
      BoardgameModel(
        id: 2,
        name: 'Chocolatl',
        description: 'Expansion',
        filenameImage: 'chocolatl.png',
      ),
    ];
  });

  group('BoardgameNotifier', () {
    test('build fetches boardgames via use case', () async {
      when(() => mockUseCase.execute()).thenAnswer((_) async => mockBoardgames);

      final container = createContainer();

      final result = await container.read(boardgameProvider.future);

      expect(result, same(mockBoardgames));
      verify(() => mockUseCase.execute()).called(1);
    });

    test('boardgameById returns matching boardgame', () async {
      when(() => mockUseCase.execute()).thenAnswer((_) async => mockBoardgames);

      final container = createContainer();
      await container.read(boardgameProvider.future);

      final notifier = container.read(boardgameProvider.notifier);
      final result = notifier.boardgameById(2);

      expect(result.id, 2);
      expect(result.name, 'Chocolatl');
      expect(result.description, 'Expansion');
      expect(result.filenameImage, 'chocolatl.png');
    });

    test('boardgameById returns unknown fallback when not found', () async {
      when(() => mockUseCase.execute()).thenAnswer((_) async => mockBoardgames);

      final container = createContainer();
      await container.read(boardgameProvider.future);

      final notifier = container.read(boardgameProvider.notifier);
      final result = notifier.boardgameById(999);

      expect(result.id, 0);
      expect(result.name, 'Unknown');
      expect(result.description, 'Unknown');
      expect(result.filenameImage, '');
    });

    test('returns error state when use case throws', () async {
      const exception = TestException('load failed');
      when(
        () => mockUseCase.execute(),
      ).thenAnswer((_) => Future<List<BoardgameModel>>.error(exception));

      final container = createContainer();

      await expectLater(
        container.read(boardgameProvider.future),
        throwsA(same(exception)),
      );

      final state = container.read(boardgameProvider);
      expect(state.hasError, isTrue);
      expect(state.asError?.error, same(exception));
      verify(() => mockUseCase.execute()).called(1);
    });
  });
}
