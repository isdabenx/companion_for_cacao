import 'dart:async';

import 'package:companion_for_cacao/config/providers/initialization_provider.dart';
import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/features/splash/domain/repositories/initialization_repository.dart';
import 'package:companion_for_cacao/features/splash/domain/use_cases/initialize_app_use_case.dart';
import 'package:companion_for_cacao/features/splash/presentation/providers/splash_provider.dart';
import 'package:companion_for_cacao/shared/providers/boardgame_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockInitializationRepository extends Mock
    implements InitializationRepository {}

class MockInitializeAppUseCase extends Mock implements InitializeAppUseCase {}

class FakeBoardgameNotifier extends BoardgameNotifier {
  FakeBoardgameNotifier(this.boardgamesFuture, {this.onBuild});

  final Future<List<BoardgameEntity>> boardgamesFuture;
  final void Function()? onBuild;

  @override
  Future<List<BoardgameEntity>> build() {
    onBuild?.call();
    return boardgamesFuture;
  }
}

class TestException implements Exception {
  const TestException(this.message);

  final String message;

  @override
  String toString() => 'TestException($message)';
}

void main() {
  late MockInitializationRepository mockRepository;
  late MockInitializeAppUseCase mockUseCase;

  ProviderContainer createContainer({List<dynamic> overrides = const []}) {
    final container = ProviderContainer(
      retry: (_, _) => null,
      overrides: overrides.cast(),
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    mockRepository = MockInitializationRepository();
    mockUseCase = MockInitializeAppUseCase();
  });

  group('initializeAppUseCaseProvider', () {
    test('returns InitializeAppUseCase with repository', () {
      final container = createContainer(
        overrides: [
          initializationRepositoryProvider.overrideWithValue(mockRepository),
        ],
      );

      final useCase = container.read(initializeAppUseCaseProvider);

      expect(useCase, isA<InitializeAppUseCase>());
      expect(useCase.repository, same(mockRepository));
    });
  });

  group('splashScreenProvider', () {
    test('calls initialize and waits for boardgames', () async {
      final boardgamesCompleter = Completer<List<BoardgameEntity>>();
      var boardgameBuildCalls = 0;

      when(() => mockUseCase.initialize()).thenAnswer((_) async {});

      final container = createContainer(
        overrides: [
          initializeAppUseCaseProvider.overrideWithValue(mockUseCase),
          boardgameProvider.overrideWith(
            () => FakeBoardgameNotifier(
              boardgamesCompleter.future,
              onBuild: () => boardgameBuildCalls++,
            ),
          ),
        ],
      );

      var completed = false;
      final future = container.read(splashProvider.future);
      future.then((_) => completed = true);

      await Future<void>.delayed(Duration.zero);

      verify(() => mockUseCase.initialize()).called(1);
      expect(boardgameBuildCalls, 1);
      expect(completed, isFalse);

      boardgamesCompleter.complete([
        BoardgameEntity(
          id: 1,
          name: 'Cacao',
          description: 'Base game',
          filenameImage: 'cacao.png',
        ),
      ]);

      await future;

      expect(completed, isTrue);
    });

    test('propagates error when initialization fails', () async {
      const exception = TestException('initialization failed');
      when(() => mockUseCase.initialize()).thenThrow(exception);

      final container = createContainer(
        overrides: [
          initializeAppUseCaseProvider.overrideWithValue(mockUseCase),
          boardgameProvider.overrideWith(
            () => FakeBoardgameNotifier(Future.value(const [])),
          ),
        ],
      );

      await expectLater(
        container.read(splashProvider.future),
        throwsA(same(exception)),
      );

      final state = container.read(splashProvider);
      expect(state.hasError, isTrue);
      expect(state.asError?.error, same(exception));
      verify(() => mockUseCase.initialize()).called(1);
    });
  });
}
