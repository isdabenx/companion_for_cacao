import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/core/domain/repositories/boardgame_repository.dart';
import 'package:companion_for_cacao/features/tile/domain/repositories/tile_repository.dart';
import 'package:companion_for_cacao/features/tile/domain/use_cases/get_tiles_with_boardgame_use_case.dart';
import 'package:companion_for_cacao/features/tile/domain/entities/tile_filter_scope.dart';
import 'package:companion_for_cacao/features/tile/presentation/providers/tile_filter_notifier.dart';
import 'package:companion_for_cacao/features/tile/presentation/providers/tile_notifier.dart';
import 'package:companion_for_cacao/features/tile/presentation/providers/tile_use_case_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../support/tile_fixtures.dart';

class MockTileRepository extends Mock implements TileRepository {}

class MockBoardgameRepository extends Mock implements BoardgameRepository {}

void main() {
  group('filteredTilesProvider', () {
    late List<TileEntity> mockTiles;
    late MockTileRepository mockTileRepository;
    late MockBoardgameRepository mockBoardgameRepository;

    setUp(() {
      mockTileRepository = MockTileRepository();
      mockBoardgameRepository = MockBoardgameRepository();

      // Create a diverse set of mock tiles for testing
      mockTiles = [
        makeTile(
          id: 'base.market_2',
          name: 'Market Price 2',
          boardgameId: 1,
          type: TileType.market,
        ),
        makeTile(
          id: 'base.plantation_single',
          name: 'Single Plantation',
          boardgameId: 1,
          type: TileType.plantation,
        ),
        makeTile(
          id: 'base.water',
          name: 'Water',
          boardgameId: 1,
          type: TileType.water,
        ),
        makeTile(
          id: 'chocolatl.hut_chief',
          name: 'Hut Chief',
          boardgameId: 2,
          type: TileType.hut,
        ),
        makeTile(
          id: 'chocolatl.watering',
          name: 'Watering',
          boardgameId: 2,
          type: TileType.watering,
        ),
        makeTile(
          id: 'base.worker_red',
          name: 'Red Worker',
          boardgameId: 1,
          type: TileType.player,
          color: TileColor.red,
        ),
      ];

      // Set up mock responses
      when(
        () => mockTileRepository.getAllTiles(),
      ).thenAnswer((_) async => mockTiles);
      when(
        () => mockBoardgameRepository.getAllModules(),
      ).thenAnswer((_) async => []);
      when(() => mockBoardgameRepository.getAllBoardgames()).thenAnswer(
        (_) async => [
          BoardgameEntity(
            id: 1,
            name: 'Cacao',
            description: 'Base',
            filenameImage: 'cacao.png',
          ),
          BoardgameEntity(
            id: 2,
            name: 'Chocolatl',
            description: 'Exp 1',
            filenameImage: 'chocolatl.png',
          ),
        ],
      );
    });

    test('should return all tiles when no filters are active', () async {
      final container = ProviderContainer(
        overrides: [
          getTilesWithBoardgameUseCaseProvider.overrideWith(
            (ref) => Future.value(
              GetTilesWithBoardgameUseCase(
                mockTileRepository,
                mockBoardgameRepository,
              ),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      final result = await container.read(filteredTilesProvider.future);

      expect(result.length, equals(mockTiles.length));
      expect(result.length, equals(6));
    });

    test('should filter tiles by search query (case-insensitive)', () async {
      final container = ProviderContainer(
        overrides: [
          getTilesWithBoardgameUseCaseProvider.overrideWith(
            (ref) => Future.value(
              GetTilesWithBoardgameUseCase(
                mockTileRepository,
                mockBoardgameRepository,
              ),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      // Wait for initial load
      await container.read(filteredTilesProvider.future);

      // Set search query filter
      container
          .read(tileFilterProvider(TileFilterScope.catalog).notifier)
          .updateSearchQuery('water');

      // Read the filtered result
      final result = await container.read(filteredTilesProvider.future);

      expect(result.length, equals(2)); // "Water" and "Watering"
      expect(result.any((tile) => tile.name == 'Water'), isTrue);
      expect(result.any((tile) => tile.name == 'Watering'), isTrue);
    });

    test('should filter tiles by boardgame ID', () async {
      final container = ProviderContainer(
        overrides: [
          getTilesWithBoardgameUseCaseProvider.overrideWith(
            (ref) => Future.value(
              GetTilesWithBoardgameUseCase(
                mockTileRepository,
                mockBoardgameRepository,
              ),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(filteredTilesProvider.future);

      // Filter by boardgame ID 2 (Chocolatl)
      container
          .read(tileFilterProvider(TileFilterScope.catalog).notifier)
          .toggleBoardgame(2);

      final result = await container.read(filteredTilesProvider.future);

      expect(result.length, equals(2));
      expect(result.every((tile) => tile.boardgameId == 2), isTrue);
    });

    test('should filter tiles by tile type', () async {
      final container = ProviderContainer(
        overrides: [
          getTilesWithBoardgameUseCaseProvider.overrideWith(
            (ref) => Future.value(
              GetTilesWithBoardgameUseCase(
                mockTileRepository,
                mockBoardgameRepository,
              ),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(filteredTilesProvider.future);

      // Filter by market type
      container
          .read(tileFilterProvider(TileFilterScope.catalog).notifier)
          .toggleTileType('Market');

      final result = await container.read(filteredTilesProvider.future);

      expect(result.length, equals(1));
      expect(result.first.type, equals(TileType.market));
    });

    test('should apply multiple filters simultaneously (AND logic)', () async {
      final container = ProviderContainer(
        overrides: [
          getTilesWithBoardgameUseCaseProvider.overrideWith(
            (ref) => Future.value(
              GetTilesWithBoardgameUseCase(
                mockTileRepository,
                mockBoardgameRepository,
              ),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(filteredTilesProvider.future);

      // Filter by boardgame ID 2 AND search query "hut"
      container
          .read(tileFilterProvider(TileFilterScope.catalog).notifier)
          .toggleBoardgame(2);
      container
          .read(tileFilterProvider(TileFilterScope.catalog).notifier)
          .updateSearchQuery('hut');

      final result = await container.read(filteredTilesProvider.future);

      expect(result.length, equals(1));
      expect(result.first.name, equals('Hut Chief'));
      expect(result.first.boardgameId, equals(2));
    });

    test('should return empty list when no tiles match filters', () async {
      final container = ProviderContainer(
        overrides: [
          getTilesWithBoardgameUseCaseProvider.overrideWith(
            (ref) => Future.value(
              GetTilesWithBoardgameUseCase(
                mockTileRepository,
                mockBoardgameRepository,
              ),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(filteredTilesProvider.future);

      // Search for non-existent tile
      container
          .read(tileFilterProvider(TileFilterScope.catalog).notifier)
          .updateSearchQuery('nonexistent');

      final result = await container.read(filteredTilesProvider.future);

      expect(result, isEmpty);
    });

    test('should reset to all tiles when filters are cleared', () async {
      final container = ProviderContainer(
        overrides: [
          getTilesWithBoardgameUseCaseProvider.overrideWith(
            (ref) => Future.value(
              GetTilesWithBoardgameUseCase(
                mockTileRepository,
                mockBoardgameRepository,
              ),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(filteredTilesProvider.future);

      // Apply filters
      container
          .read(tileFilterProvider(TileFilterScope.catalog).notifier)
          .updateSearchQuery('water');
      container
          .read(tileFilterProvider(TileFilterScope.catalog).notifier)
          .toggleBoardgame(1);

      var result = await container.read(filteredTilesProvider.future);
      expect(result.length, equals(1)); // Only "Water" from boardgame 1

      // Clear filters
      container
          .read(tileFilterProvider(TileFilterScope.catalog).notifier)
          .clearFilters();

      result = await container.read(filteredTilesProvider.future);
      expect(result.length, equals(mockTiles.length));
    });

    test('should filter by multiple boardgame IDs (OR logic)', () async {
      final container = ProviderContainer(
        overrides: [
          getTilesWithBoardgameUseCaseProvider.overrideWith(
            (ref) => Future.value(
              GetTilesWithBoardgameUseCase(
                mockTileRepository,
                mockBoardgameRepository,
              ),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(filteredTilesProvider.future);

      // Filter by both boardgame IDs
      container
          .read(tileFilterProvider(TileFilterScope.catalog).notifier)
          .toggleBoardgame(1);
      container
          .read(tileFilterProvider(TileFilterScope.catalog).notifier)
          .toggleBoardgame(2);

      final result = await container.read(filteredTilesProvider.future);

      // Should include tiles from both boardgames
      expect(result.length, equals(mockTiles.length));
      expect(result.any((tile) => tile.boardgameId == 1), isTrue);
      expect(result.any((tile) => tile.boardgameId == 2), isTrue);
    });

    test('should filter by multiple tile types (OR logic)', () async {
      final container = ProviderContainer(
        overrides: [
          getTilesWithBoardgameUseCaseProvider.overrideWith(
            (ref) => Future.value(
              GetTilesWithBoardgameUseCase(
                mockTileRepository,
                mockBoardgameRepository,
              ),
            ),
          ),
        ],
      );
      addTearDown(container.dispose);

      await container.read(filteredTilesProvider.future);

      // Filter by market and plantation types
      container
          .read(tileFilterProvider(TileFilterScope.catalog).notifier)
          .toggleTileType('Market');
      container
          .read(tileFilterProvider(TileFilterScope.catalog).notifier)
          .toggleTileType('Plantation');

      final result = await container.read(filteredTilesProvider.future);

      expect(result.length, equals(2));
      expect(result.any((tile) => tile.type == TileType.market), isTrue);
      expect(result.any((tile) => tile.type == TileType.plantation), isTrue);
    });

    test(
      'in-play filter scope is independent from the catalog scope',
      () async {
        final container = ProviderContainer(
          overrides: [
            getTilesWithBoardgameUseCaseProvider.overrideWith(
              (ref) => Future.value(
                GetTilesWithBoardgameUseCase(
                  mockTileRepository,
                  mockBoardgameRepository,
                ),
              ),
            ),
          ],
        );
        addTearDown(container.dispose);

        await container.read(filteredTilesProvider.future);

        // Filtering the IN-PLAY scope must not affect the catalog results
        container
            .read(tileFilterProvider(TileFilterScope.inPlay).notifier)
            .updateSearchQuery('water');

        final catalogResult = await container.read(
          filteredTilesProvider.future,
        );
        expect(catalogResult.length, equals(mockTiles.length));

        final inPlayFilter = container.read(
          tileFilterProvider(TileFilterScope.inPlay),
        );
        final catalogFilter = container.read(
          tileFilterProvider(TileFilterScope.catalog),
        );
        expect(inPlayFilter.hasActiveFilters, isTrue);
        expect(catalogFilter.hasActiveFilters, isFalse);
      },
    );
  });
}

// Helper function to create mock tiles
