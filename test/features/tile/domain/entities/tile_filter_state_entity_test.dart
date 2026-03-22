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
}
