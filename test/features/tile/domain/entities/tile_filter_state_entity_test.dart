import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/tile/domain/entities/tile_filter_state_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TileFilterStateEntity.hasActiveFilters', () {
    test('should return false when all filters are empty', () {
      const filter = TileFilterStateEntity();
      expect(filter.hasActiveFilters, isFalse);
    });

    test('should return true when searchQuery is set', () {
      const filter = TileFilterStateEntity(searchQuery: 'test');
      expect(filter.hasActiveFilters, isTrue);
    });

    test('should return true when selectedBoardgameIds is not empty', () {
      const filter = TileFilterStateEntity(selectedBoardgameIds: {1});
      expect(filter.hasActiveFilters, isTrue);
    });

    test('should return true when selectedTileTypes is not empty', () {
      const filter = TileFilterStateEntity(selectedTileTypes: {'Market'});
      expect(filter.hasActiveFilters, isTrue);
    });

    test('should return true when multiple filters are set', () {
      const filter = TileFilterStateEntity(
        searchQuery: 'test',
        selectedBoardgameIds: {1, 2},
        selectedTileTypes: {'Market', 'Plantation'},
      );
      expect(filter.hasActiveFilters, isTrue);
    });
  });

  group('TileFilterStateEntity.activeFilterCount', () {
    test('should return 0 when no filters are active', () {
      const filter = TileFilterStateEntity();
      expect(filter.activeFilterCount, 0);
    });

    test('should count searchQuery as 1', () {
      const filter = TileFilterStateEntity(searchQuery: 'test');
      expect(filter.activeFilterCount, 1);
    });

    test('should count each boardgameId separately', () {
      const filter = TileFilterStateEntity(selectedBoardgameIds: {1, 2, 3});
      expect(filter.activeFilterCount, 3);
    });

    test('should count each tileType separately', () {
      const filter = TileFilterStateEntity(
        selectedTileTypes: {'Market', 'Plantation', 'Water'},
      );
      expect(filter.activeFilterCount, 3);
    });

    test('should sum all active filters correctly', () {
      // searchQuery (1) + boardgameIds (2) + tileTypes (2) = 5
      const filter = TileFilterStateEntity(
        searchQuery: 'test',
        selectedBoardgameIds: {1, 2},
        selectedTileTypes: {'Market', 'Plantation'},
      );
      expect(filter.activeFilterCount, 5);
    });
  });

  group('TileFilterStateEntity.matches', () {
    late TileModel marketTile;
    late TileModel plantationTile;
    late TileModel waterTile;
    late TileModel chocolatlTile;

    setUp(() {
      marketTile = _createTile(
        id: 'base.market_2',
        name: 'Market Price 2',
        boardgameId: 1,
        type: TileType.market,
      );

      plantationTile = _createTile(
        id: 'base.plantation',
        name: 'Single Plantation',
        boardgameId: 1,
        type: TileType.plantation,
      );

      waterTile = _createTile(
        id: 'base.water',
        name: 'Water Source',
        boardgameId: 1,
        type: TileType.water,
      );

      chocolatlTile = _createTile(
        id: 'chocolatl.hut',
        name: 'Chief Hut',
        boardgameId: 2,
        type: TileType.hut,
      );
    });

    test('should match all tiles when no filters are active', () {
      const filter = TileFilterStateEntity();

      expect(filter.matches(marketTile), isTrue);
      expect(filter.matches(plantationTile), isTrue);
      expect(filter.matches(waterTile), isTrue);
      expect(filter.matches(chocolatlTile), isTrue);
    });

    group('searchQuery filter', () {
      test('should match tiles by name (case-insensitive)', () {
        const filter = TileFilterStateEntity(searchQuery: 'market');

        expect(filter.matches(marketTile), isTrue);
        expect(filter.matches(plantationTile), isFalse);
      });

      test('should match tiles with partial name match', () {
        const filter = TileFilterStateEntity(searchQuery: 'price');

        expect(filter.matches(marketTile), isTrue);
        expect(filter.matches(waterTile), isFalse);
      });

      test('should be case-insensitive', () {
        const filter = TileFilterStateEntity(searchQuery: 'MARKET');

        expect(filter.matches(marketTile), isTrue);
      });

      test('should not match tiles without query in name', () {
        const filter = TileFilterStateEntity(searchQuery: 'gold');

        expect(filter.matches(marketTile), isFalse);
        expect(filter.matches(plantationTile), isFalse);
        expect(filter.matches(waterTile), isFalse);
      });
    });

    group('selectedBoardgameIds filter', () {
      test('should match tiles from selected boardgame', () {
        const filter = TileFilterStateEntity(selectedBoardgameIds: {1});

        expect(filter.matches(marketTile), isTrue);
        expect(filter.matches(plantationTile), isTrue);
        expect(filter.matches(chocolatlTile), isFalse);
      });

      test('should match tiles from multiple selected boardgames', () {
        const filter = TileFilterStateEntity(selectedBoardgameIds: {1, 2});

        expect(filter.matches(marketTile), isTrue);
        expect(filter.matches(chocolatlTile), isTrue);
      });

      test('should not match tiles from unselected boardgames', () {
        const filter = TileFilterStateEntity(selectedBoardgameIds: {3});

        expect(filter.matches(marketTile), isFalse);
        expect(filter.matches(chocolatlTile), isFalse);
      });
    });

    group('selectedTileTypes filter', () {
      test('should match tiles of selected type', () {
        const filter = TileFilterStateEntity(selectedTileTypes: {'Market'});

        expect(filter.matches(marketTile), isTrue);
        expect(filter.matches(plantationTile), isFalse);
      });

      test('should match tiles of multiple selected types', () {
        const filter = TileFilterStateEntity(
          selectedTileTypes: {'Market', 'Plantation'},
        );

        expect(filter.matches(marketTile), isTrue);
        expect(filter.matches(plantationTile), isTrue);
        expect(filter.matches(waterTile), isFalse);
      });

      test('should not match tiles of unselected types', () {
        const filter = TileFilterStateEntity(selectedTileTypes: {'Temple'});

        expect(filter.matches(marketTile), isFalse);
        expect(filter.matches(waterTile), isFalse);
      });
    });

    group('combined filters (AND logic)', () {
      test('should match only tiles that satisfy all filters', () {
        const filter = TileFilterStateEntity(
          searchQuery: 'market',
          selectedBoardgameIds: {1},
          selectedTileTypes: {'Market'},
        );

        expect(filter.matches(marketTile), isTrue);
        expect(filter.matches(plantationTile), isFalse); // Wrong type
        expect(filter.matches(waterTile), isFalse); // Wrong name and type
        expect(filter.matches(chocolatlTile), isFalse); // Wrong boardgame
      });

      test('should not match if search query fails', () {
        const filter = TileFilterStateEntity(
          searchQuery: 'nonexistent',
          selectedBoardgameIds: {1},
          selectedTileTypes: {'Market'},
        );

        expect(filter.matches(marketTile), isFalse);
      });

      test('should not match if boardgame filter fails', () {
        const filter = TileFilterStateEntity(
          searchQuery: 'market',
          selectedBoardgameIds: {2},
          selectedTileTypes: {'Market'},
        );

        expect(filter.matches(marketTile), isFalse);
      });

      test('should not match if tile type filter fails', () {
        const filter = TileFilterStateEntity(
          searchQuery: 'market',
          selectedBoardgameIds: {1},
          selectedTileTypes: {'Plantation'},
        );

        expect(filter.matches(marketTile), isFalse);
      });
    });

    group('edge cases', () {
      test('should handle empty search query as no filter', () {
        const filter = TileFilterStateEntity(searchQuery: '');

        expect(filter.matches(marketTile), isTrue);
        expect(filter.matches(plantationTile), isTrue);
      });

      test('should handle tiles with special characters in names', () {
        final specialTile = _createTile(
          id: 'test.special',
          name: "Chief's Hut",
          boardgameId: 1,
          type: TileType.hut,
        );

        const filter = TileFilterStateEntity(searchQuery: 'chief');

        expect(filter.matches(specialTile), isTrue);
      });

      test('should handle tiles with null type', () {
        final nullTypeTile = TileModel(
          id: 'test.null',
          name: 'Null Type Tile',
          description: 'Test',
          filenameImage: 'test.png',
          quantity: 1,
          boardgameId: 1,
          type: null,
        );

        const filter = TileFilterStateEntity(selectedTileTypes: {'Market'});

        // Should not match since type is null
        expect(filter.matches(nullTypeTile), isFalse);
      });
    });
  });

  group('TileFilterStateEntity.copyWith', () {
    test('should create a new instance with updated searchQuery', () {
      const original = TileFilterStateEntity();
      final updated = original.copyWith(searchQuery: 'test');

      expect(updated.searchQuery, equals('test'));
      expect(
        updated.selectedBoardgameIds,
        equals(original.selectedBoardgameIds),
      );
      expect(updated.selectedTileTypes, equals(original.selectedTileTypes));
    });

    test('should create a new instance with updated selectedBoardgameIds', () {
      const original = TileFilterStateEntity();
      final updated = original.copyWith(selectedBoardgameIds: {1, 2});

      expect(updated.selectedBoardgameIds, equals({1, 2}));
      expect(updated.searchQuery, equals(original.searchQuery));
      expect(updated.selectedTileTypes, equals(original.selectedTileTypes));
    });

    test('should create a new instance with updated selectedTileTypes', () {
      const original = TileFilterStateEntity();
      final updated = original.copyWith(selectedTileTypes: {'Market'});

      expect(updated.selectedTileTypes, equals({'Market'}));
      expect(updated.searchQuery, equals(original.searchQuery));
      expect(
        updated.selectedBoardgameIds,
        equals(original.selectedBoardgameIds),
      );
    });

    test('should preserve original values when null is passed', () {
      const original = TileFilterStateEntity(
        searchQuery: 'test',
        selectedBoardgameIds: {1},
        selectedTileTypes: {'Market'},
      );
      final updated = original.copyWith();

      expect(updated.searchQuery, equals(original.searchQuery));
      expect(
        updated.selectedBoardgameIds,
        equals(original.selectedBoardgameIds),
      );
      expect(updated.selectedTileTypes, equals(original.selectedTileTypes));
    });
  });

  group('TileFilterStateEntity.equality', () {
    test('should be equal when all properties match', () {
      const filter1 = TileFilterStateEntity(
        searchQuery: 'test',
        selectedBoardgameIds: {1, 2},
        selectedTileTypes: {'Market'},
      );
      const filter2 = TileFilterStateEntity(
        searchQuery: 'test',
        selectedBoardgameIds: {1, 2},
        selectedTileTypes: {'Market'},
      );

      expect(filter1, equals(filter2));
      expect(filter1.hashCode, equals(filter2.hashCode));
    });

    test('should not be equal when searchQuery differs', () {
      const filter1 = TileFilterStateEntity(searchQuery: 'test1');
      const filter2 = TileFilterStateEntity(searchQuery: 'test2');

      expect(filter1, isNot(equals(filter2)));
    });

    test('should not be equal when selectedBoardgameIds differs', () {
      const filter1 = TileFilterStateEntity(selectedBoardgameIds: {1});
      const filter2 = TileFilterStateEntity(selectedBoardgameIds: {2});

      expect(filter1, isNot(equals(filter2)));
    });

    test('should not be equal when selectedTileTypes differs', () {
      const filter1 = TileFilterStateEntity(selectedTileTypes: {'Market'});
      const filter2 = TileFilterStateEntity(selectedTileTypes: {'Plantation'});

      expect(filter1, isNot(equals(filter2)));
    });
  });
}

// Helper function to create test tiles
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
