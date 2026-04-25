import 'dart:async';

import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/tile/domain/use_cases/get_tiles_with_boardgame_use_case.dart';
import 'package:companion_for_cacao/features/tile/presentation/providers/tile_filter_notifier.dart';
import 'package:companion_for_cacao/features/tile/presentation/providers/tile_notifier.dart';
import 'package:companion_for_cacao/features/tile/presentation/providers/tile_use_case_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetTilesWithBoardgameUseCase extends Mock
    implements GetTilesWithBoardgameUseCase {}

class TestException implements Exception {
  const TestException(this.message);

  final String message;

  @override
  String toString() => 'TestException($message)';
}

void main() {
  setUpAll(() {
    registerFallbackValue(<String>[]);
  });

  late MockGetTilesWithBoardgameUseCase mockUseCase;
  late List<TileModel> mockTiles;

  ProviderContainer createContainer() {
    final container = ProviderContainer(
      retry: (_, _) => null,
      overrides: [
        getTilesWithBoardgameUseCaseProvider.overrideWith(
          (ref) => Future.value(mockUseCase),
        ),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUp(() {
    mockUseCase = MockGetTilesWithBoardgameUseCase();
    mockTiles = [
      _createTile(
        id: 'base.market_2',
        name: 'Market Price 2',
        boardgameId: 1,
        type: TileType.market,
      ),
      _createTile(
        id: 'base.water',
        name: 'Water',
        boardgameId: 1,
        type: TileType.water,
      ),
      _createTile(
        id: 'chocolatl.watering',
        name: 'Watering',
        boardgameId: 2,
        type: TileType.watering,
      ),
      _createTile(
        id: 'chocolatl.hut_chief',
        name: 'Hut Chief',
        boardgameId: 2,
        type: TileType.hut,
      ),
    ];
  });

  group('AllTiles', () {
    test('build fetches tiles via use case', () async {
      when(() => mockUseCase.execute()).thenAnswer((_) async => mockTiles);

      final container = createContainer();

      final result = await container.read(allTilesProvider.future);

      expect(result, same(mockTiles));
      verify(() => mockUseCase.execute()).called(1);
    });

    test('filterByIds updates state with filtered tiles', () async {
      final filteredTilesResult = [mockTiles[1], mockTiles[2]];

      when(() => mockUseCase.execute()).thenAnswer((_) async => mockTiles);
      when(
        () => mockUseCase.execute(idsList: any(named: 'idsList')),
      ).thenAnswer((_) async => filteredTilesResult);

      final container = createContainer();

      await container.read(allTilesProvider.future);

      await container.read(allTilesProvider.notifier).filterByIds([
        'base.water',
        'chocolatl.watering',
      ]);

      final state = container.read(allTilesProvider);

      expect(state.hasValue, isTrue);
      expect(state.requireValue, same(filteredTilesResult));
      verify(() => mockUseCase.execute()).called(1);
      verify(
        () =>
            mockUseCase.execute(idsList: ['base.water', 'chocolatl.watering']),
      ).called(1);
    });

    test('returns error state when build use case throws', () async {
      const exception = TestException('build failed');
      when(
        () => mockUseCase.execute(),
      ).thenAnswer((_) => Future<List<TileModel>>.error(exception));

      final container = createContainer();

      await expectLater(
        container.read(allTilesProvider.future),
        throwsA(same(exception)),
      );

      final state = container.read(allTilesProvider);
      expect(state.hasError, isTrue);
      expect(state.asError?.error, same(exception));
      verify(() => mockUseCase.execute()).called(1);
    });

    test('emits loading then data during initial build', () async {
      final completer = Completer<List<TileModel>>();
      when(() => mockUseCase.execute()).thenAnswer((_) => completer.future);

      final container = createContainer();
      final states = <AsyncValue<List<TileModel>>>[];
      final subscription = container.listen<AsyncValue<List<TileModel>>>(
        allTilesProvider,
        (_, next) => states.add(next),
        fireImmediately: true,
      );
      addTearDown(subscription.close);

      expect(states, hasLength(1));
      expect(states.first.isLoading, isTrue);

      completer.complete(mockTiles);
      final result = await container.read(allTilesProvider.future);

      expect(result, same(mockTiles));
      expect(states.last.hasValue, isTrue);
      expect(states.last.requireValue, same(mockTiles));
    });

    test('emits loading then error when filterByIds fails', () async {
      const exception = TestException('filter failed');

      when(() => mockUseCase.execute()).thenAnswer((_) async => mockTiles);
      when(
        () => mockUseCase.execute(idsList: ['unknown.tile']),
      ).thenThrow(exception);

      final container = createContainer();
      await container.read(allTilesProvider.future);

      final states = <AsyncValue<List<TileModel>>>[];
      final subscription = container.listen<AsyncValue<List<TileModel>>>(
        allTilesProvider,
        (_, next) => states.add(next),
        fireImmediately: true,
      );
      addTearDown(subscription.close);

      await container.read(allTilesProvider.notifier).filterByIds([
        'unknown.tile',
      ]);

      expect(states[0].hasValue, isTrue);
      expect(states[1].isLoading, isTrue);
      expect(states.last.hasError, isTrue);
      expect(states.last.asError?.error, same(exception));
    });
  });

  group('filteredTilesProvider', () {
    test('applies TileFilterStateEntity rules to derived tiles', () async {
      when(() => mockUseCase.execute()).thenAnswer((_) async => mockTiles);

      final container = createContainer();

      await container.read(filteredTilesProvider.future);

      container.read(tileFilterProvider.notifier).updateSearchQuery('water');
      container.read(tileFilterProvider.notifier).toggleBoardgame(2);
      container.read(tileFilterProvider.notifier).toggleTileType('Watering');

      final result = await container.read(filteredTilesProvider.future);

      expect(result, hasLength(1));
      expect(result.single.id, equals('chocolatl.watering'));
      expect(result.single.name, equals('Watering'));
    });
  });
}

TileModel _createTile({
  required String id,
  required String name,
  required int boardgameId,
  required TileType type,
}) {
  return TileModel(
    id: id,
    name: name,
    description: 'Test description',
    filenameImage: 'test.png',
    quantity: 1,
    type: type,
    boardgameId: boardgameId,
  );
}
