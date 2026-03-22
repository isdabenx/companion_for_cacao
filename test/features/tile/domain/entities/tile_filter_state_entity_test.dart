import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/tile/domain/entities/tile_filter_state_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TileFilterStateEntity.matches', () {
    // Helper function to create dummy tiles
    TileModel createTile({
      String id = 'test_tile_1',
      String name = 'Test Tile',
      int? boardgameId,
      TileType? type,
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

    group('Empty filter', () {
      test('should match all tiles when filter is empty', () {
        const filter = TileFilterStateEntity();

        final tile1 = createTile(name: 'Cacao Plantation');
        final tile2 = createTile(name: 'Gold Mine', boardgameId: 1);
        final tile3 = createTile(name: 'Water', type: TileType.water);

        expect(filter.matches(tile1), isTrue);
        expect(filter.matches(tile2), isTrue);
        expect(filter.matches(tile3), isTrue);
      });
    });

    group('Filter by searchQuery', () {
      test('should match tile with exact name', () {
        const filter = TileFilterStateEntity(searchQuery: 'Cacao Plantation');
        final tile = createTile(name: 'Cacao Plantation');

        expect(filter.matches(tile), isTrue);
      });

      test('should match tile with partial name (case insensitive)', () {
        const filter = TileFilterStateEntity(searchQuery: 'cacao');
        final tile = createTile(name: 'Cacao Plantation');

        expect(filter.matches(tile), isTrue);
      });

      test('should match tile with case insensitive search', () {
        const filter = TileFilterStateEntity(searchQuery: 'CACAO');
        final tile = createTile(name: 'Cacao Plantation');

        expect(filter.matches(tile), isTrue);
      });

      test('should match tile when search is substring', () {
        const filter = TileFilterStateEntity(searchQuery: 'Plant');
        final tile = createTile(name: 'Cacao Plantation');

        expect(filter.matches(tile), isTrue);
      });

      test('should not match tile when search does not match', () {
        const filter = TileFilterStateEntity(searchQuery: 'Gold');
        final tile = createTile(name: 'Cacao Plantation');

        expect(filter.matches(tile), isFalse);
      });

      test('should handle empty string search as matching all', () {
        const filter = TileFilterStateEntity(searchQuery: '');
        final tile = createTile(name: 'Any Tile');

        expect(filter.matches(tile), isTrue);
      });

      test('should match tile with search at start of name', () {
        const filter = TileFilterStateEntity(searchQuery: 'Cacao');
        final tile = createTile(name: 'Cacao Plantation');

        expect(filter.matches(tile), isTrue);
      });

      test('should match tile with search at end of name', () {
        const filter = TileFilterStateEntity(searchQuery: 'Plantation');
        final tile = createTile(name: 'Cacao Plantation');

        expect(filter.matches(tile), isTrue);
      });

      test('should match tile with search in middle of name', () {
        const filter = TileFilterStateEntity(searchQuery: 'cao Pla');
        final tile = createTile(name: 'Cacao Plantation');

        expect(filter.matches(tile), isTrue);
      });
    });

    group('Filter by selectedBoardgameIds', () {
      test('should match tile with single boardgame ID', () {
        const filter = TileFilterStateEntity(selectedBoardgameIds: {1});
        final tile = createTile(boardgameId: 1);

        expect(filter.matches(tile), isTrue);
      });

      test('should match tile with multiple boardgame IDs (first match)', () {
        const filter = TileFilterStateEntity(selectedBoardgameIds: {1, 2, 3});
        final tile = createTile(boardgameId: 1);

        expect(filter.matches(tile), isTrue);
      });

      test('should match tile with multiple boardgame IDs (middle match)', () {
        const filter = TileFilterStateEntity(selectedBoardgameIds: {1, 2, 3});
        final tile = createTile(boardgameId: 2);

        expect(filter.matches(tile), isTrue);
      });

      test('should match tile with multiple boardgame IDs (last match)', () {
        const filter = TileFilterStateEntity(selectedBoardgameIds: {1, 2, 3});
        final tile = createTile(boardgameId: 3);

        expect(filter.matches(tile), isTrue);
      });

      test('should not match tile with non-matching boardgame ID', () {
        const filter = TileFilterStateEntity(selectedBoardgameIds: {1, 2});
        final tile = createTile(boardgameId: 3);

        expect(filter.matches(tile), isFalse);
      });

      test('should not match tile when boardgameId is null', () {
        const filter = TileFilterStateEntity(selectedBoardgameIds: {1});
        final tile = createTile(boardgameId: null);

        expect(filter.matches(tile), isFalse);
      });

      test('should match all when selectedBoardgameIds is empty', () {
        const filter = TileFilterStateEntity(selectedBoardgameIds: {});
        final tile = createTile(boardgameId: 5);

        expect(filter.matches(tile), isTrue);
      });
    });

    group('Filter by selectedTileTypes', () {
      test('should match tile with single type', () {
        const filter = TileFilterStateEntity(selectedTileTypes: {'Market'});
        final tile = createTile(type: TileType.market);

        expect(filter.matches(tile), isTrue);
      });

      test('should match tile with multiple types (first match)', () {
        const filter = TileFilterStateEntity(
          selectedTileTypes: {'Market', 'Plantation', 'Water'},
        );
        final tile = createTile(type: TileType.market);

        expect(filter.matches(tile), isTrue);
      });

      test('should match tile with multiple types (middle match)', () {
        const filter = TileFilterStateEntity(
          selectedTileTypes: {'Market', 'Plantation', 'Water'},
        );
        final tile = createTile(type: TileType.plantation);

        expect(filter.matches(tile), isTrue);
      });

      test('should match tile with multiple types (last match)', () {
        const filter = TileFilterStateEntity(
          selectedTileTypes: {'Market', 'Plantation', 'Water'},
        );
        final tile = createTile(type: TileType.water);

        expect(filter.matches(tile), isTrue);
      });

      test('should not match tile with non-matching type', () {
        const filter = TileFilterStateEntity(
          selectedTileTypes: {'Market', 'Plantation'},
        );
        final tile = createTile(type: TileType.water);

        expect(filter.matches(tile), isFalse);
      });

      test('should match tile with Temple type', () {
        const filter = TileFilterStateEntity(selectedTileTypes: {'Temple'});
        final tile = createTile(type: TileType.temple);

        expect(filter.matches(tile), isTrue);
      });

      test('should match tile with Gold Mine type', () {
        const filter = TileFilterStateEntity(selectedTileTypes: {'Gold Mine'});
        final tile = createTile(type: TileType.goldMine);

        expect(filter.matches(tile), isTrue);
      });

      test('should match tile with Sun-Worshiping Site type', () {
        const filter = TileFilterStateEntity(
          selectedTileTypes: {'Sun-Worshiping Site'},
        );
        final tile = createTile(type: TileType.sunWorshipingSite);

        expect(filter.matches(tile), isTrue);
      });

      test('should match tile with Player type', () {
        const filter = TileFilterStateEntity(selectedTileTypes: {'Player'});
        final tile = createTile(type: TileType.player);

        expect(filter.matches(tile), isTrue);
      });

      test('should not match tile when type is null', () {
        const filter = TileFilterStateEntity(selectedTileTypes: {'Market'});
        final tile = createTile(type: null);

        expect(filter.matches(tile), isFalse);
      });

      test('should match all when selectedTileTypes is empty', () {
        const filter = TileFilterStateEntity(selectedTileTypes: {});
        final tile = createTile(type: TileType.temple);

        expect(filter.matches(tile), isTrue);
      });
    });

    group('Complex filters (multiple criteria)', () {
      test('should match tile matching both searchQuery and boardgameId', () {
        const filter = TileFilterStateEntity(
          searchQuery: 'Cacao',
          selectedBoardgameIds: {1},
        );
        final tile = createTile(name: 'Cacao Plantation', boardgameId: 1);

        expect(filter.matches(tile), isTrue);
      });

      test(
        'should not match tile matching searchQuery but not boardgameId',
        () {
          const filter = TileFilterStateEntity(
            searchQuery: 'Cacao',
            selectedBoardgameIds: {1},
          );
          final tile = createTile(name: 'Cacao Plantation', boardgameId: 2);

          expect(filter.matches(tile), isFalse);
        },
      );

      test(
        'should not match tile matching boardgameId but not searchQuery',
        () {
          const filter = TileFilterStateEntity(
            searchQuery: 'Gold',
            selectedBoardgameIds: {1},
          );
          final tile = createTile(name: 'Cacao Plantation', boardgameId: 1);

          expect(filter.matches(tile), isFalse);
        },
      );

      test('should match tile matching searchQuery and tileType', () {
        const filter = TileFilterStateEntity(
          searchQuery: 'Market',
          selectedTileTypes: {'Market'},
        );
        final tile = createTile(name: 'Market Place', type: TileType.market);

        expect(filter.matches(tile), isTrue);
      });

      test('should not match tile matching searchQuery but not tileType', () {
        const filter = TileFilterStateEntity(
          searchQuery: 'Market',
          selectedTileTypes: {'Plantation'},
        );
        final tile = createTile(name: 'Market Place', type: TileType.market);

        expect(filter.matches(tile), isFalse);
      });

      test('should match tile matching boardgameId and tileType', () {
        const filter = TileFilterStateEntity(
          selectedBoardgameIds: {1},
          selectedTileTypes: {'Water'},
        );
        final tile = createTile(boardgameId: 1, type: TileType.water);

        expect(filter.matches(tile), isTrue);
      });

      test('should not match tile matching boardgameId but not tileType', () {
        const filter = TileFilterStateEntity(
          selectedBoardgameIds: {1},
          selectedTileTypes: {'Water'},
        );
        final tile = createTile(boardgameId: 1, type: TileType.market);

        expect(filter.matches(tile), isFalse);
      });

      test('should match tile matching all three criteria', () {
        const filter = TileFilterStateEntity(
          searchQuery: 'Water',
          selectedBoardgameIds: {2},
          selectedTileTypes: {'Water'},
        );
        final tile = createTile(
          name: 'Water Source',
          boardgameId: 2,
          type: TileType.water,
        );

        expect(filter.matches(tile), isTrue);
      });

      test('should not match tile missing searchQuery from all criteria', () {
        const filter = TileFilterStateEntity(
          searchQuery: 'Gold',
          selectedBoardgameIds: {2},
          selectedTileTypes: {'Water'},
        );
        final tile = createTile(
          name: 'Water Source',
          boardgameId: 2,
          type: TileType.water,
        );

        expect(filter.matches(tile), isFalse);
      });

      test('should not match tile missing boardgameId from all criteria', () {
        const filter = TileFilterStateEntity(
          searchQuery: 'Water',
          selectedBoardgameIds: {1},
          selectedTileTypes: {'Water'},
        );
        final tile = createTile(
          name: 'Water Source',
          boardgameId: 2,
          type: TileType.water,
        );

        expect(filter.matches(tile), isFalse);
      });

      test('should not match tile missing tileType from all criteria', () {
        const filter = TileFilterStateEntity(
          searchQuery: 'Water',
          selectedBoardgameIds: {2},
          selectedTileTypes: {'Market'},
        );
        final tile = createTile(
          name: 'Water Source',
          boardgameId: 2,
          type: TileType.water,
        );

        expect(filter.matches(tile), isFalse);
      });

      test('should match with multiple boardgames and types', () {
        const filter = TileFilterStateEntity(
          selectedBoardgameIds: {1, 2, 3},
          selectedTileTypes: {'Market', 'Plantation', 'Water'},
        );
        final tile1 = createTile(boardgameId: 2, type: TileType.market);
        final tile2 = createTile(boardgameId: 3, type: TileType.plantation);
        final tile3 = createTile(boardgameId: 1, type: TileType.water);

        expect(filter.matches(tile1), isTrue);
        expect(filter.matches(tile2), isTrue);
        expect(filter.matches(tile3), isTrue);
      });

      test('should handle complex real-world scenario', () {
        const filter = TileFilterStateEntity(
          searchQuery: 'gold',
          selectedBoardgameIds: {1, 2},
          selectedTileTypes: {'Gold Mine', 'Temple'},
        );

        // Should match: matches search, boardgame, and type
        final matchingTile = createTile(
          name: 'Gold Mine Site',
          boardgameId: 1,
          type: TileType.goldMine,
        );
        expect(filter.matches(matchingTile), isTrue);

        // Should not match: wrong search
        final wrongSearchTile = createTile(
          name: 'Temple Area',
          boardgameId: 1,
          type: TileType.temple,
        );
        expect(filter.matches(wrongSearchTile), isFalse);

        // Should not match: wrong boardgame
        final wrongBoardgameTile = createTile(
          name: 'Gold Temple',
          boardgameId: 3,
          type: TileType.goldMine,
        );
        expect(filter.matches(wrongBoardgameTile), isFalse);

        // Should not match: wrong type
        final wrongTypeTile = createTile(
          name: 'Gold Market',
          boardgameId: 2,
          type: TileType.market,
        );
        expect(filter.matches(wrongTypeTile), isFalse);
      });
    });
  });
}
