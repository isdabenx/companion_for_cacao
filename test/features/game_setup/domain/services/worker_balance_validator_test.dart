import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/worker_balance_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WorkerBalanceValidator.balanceRange', () {
    test('returns 1-8 for 2 players', () {
      expect(WorkerBalanceValidator.balanceRange(2), (1, 8));
    });

    test('returns 2-12 for 3 players', () {
      expect(WorkerBalanceValidator.balanceRange(3), (2, 12));
    });

    test('returns 3-16 for 4 players', () {
      expect(WorkerBalanceValidator.balanceRange(4), (3, 16));
    });
  });

  group('WorkerBalanceValidator.validate', () {
    test('base game 2p configuration is valid at range minimum', () {
      // 11 tiles × 2 players = 22 workers; 28 − 7 removed = 21 jungle
      final result = WorkerBalanceValidator.validate(
        playerCount: 2,
        workerTilesPerPlayer: 11,
        jungleTileCount: 21,
      );
      expect(result.totalWorkers, 22);
      expect(result.difference, 1);
      expect(result.isValid, isTrue);
    });

    test('base game 3p configuration is valid at range minimum', () {
      // 10 tiles × 3 players = 30 workers; 28 jungle
      final result = WorkerBalanceValidator.validate(
        playerCount: 3,
        workerTilesPerPlayer: 10,
        jungleTileCount: 28,
      );
      expect(result.difference, 2);
      expect(result.isValid, isTrue);
    });

    test('base game 4p configuration is valid', () {
      // 9 tiles × 4 players = 36 workers; 28 jungle
      final result = WorkerBalanceValidator.validate(
        playerCount: 4,
        workerTilesPerPlayer: 9,
        jungleTileCount: 28,
      );
      expect(result.difference, 8);
      expect(result.isValid, isTrue);
    });

    test('difference below minimum is invalid', () {
      final result = WorkerBalanceValidator.validate(
        playerCount: 2,
        workerTilesPerPlayer: 10,
        jungleTileCount: 21,
      );
      expect(result.difference, -1);
      expect(result.isValid, isFalse);
    });

    test('difference above maximum is invalid', () {
      // addAll at 4p base game: 15 × 4 = 60 workers; 28 jungle → 32 > 16
      final result = WorkerBalanceValidator.validate(
        playerCount: 4,
        workerTilesPerPlayer: 15,
        jungleTileCount: 28,
      );
      expect(result.difference, 32);
      expect(result.isValid, isFalse);
    });

    test('difference exactly at maximum is valid', () {
      // 11 × 4 = 44 workers; 28 jungle → 16 == max for 4p
      final result = WorkerBalanceValidator.validate(
        playerCount: 4,
        workerTilesPerPlayer: 11,
        jungleTileCount: 28,
      );
      expect(result.difference, 16);
      expect(result.isValid, isTrue);
    });

    test('exposes min and max for the player count', () {
      final result = WorkerBalanceValidator.validate(
        playerCount: 3,
        workerTilesPerPlayer: 11,
        jungleTileCount: 28,
      );
      expect(result.minDifference, 2);
      expect(result.maxDifference, 12);
      expect(result.totalJungle, 28);
    });
  });

  group('WorkerBalanceValidator.countJungleTiles', () {
    TileModel jungleTile(String id, TileType type, int quantity) => TileModel(
      id: id,
      name: id,
      description: '',
      filenameImage: '',
      type: type,
      quantity: quantity,
    );

    test('sums quantities of jungle tile types only', () {
      final tiles = [
        jungleTile('market', TileType.market, 7),
        jungleTile('plantation', TileType.plantation, 8),
        jungleTile('temple', TileType.temple, 5),
        TileModel(
          id: 'worker',
          name: '1-1-1-1',
          description: '',
          filenameImage: '',
          type: TileType.player,
          color: TileColor.red,
          quantity: 4,
        ),
      ];
      expect(WorkerBalanceValidator.countJungleTiles(tiles), 20);
    });

    test('includes expansion jungle types (gem mine, tree of life)', () {
      final tiles = [
        jungleTile('gem_mine', TileType.gemMine, 5),
        jungleTile('tree_of_life', TileType.treeOfLife, 3),
        jungleTile('watering', TileType.watering, 2),
      ];
      expect(WorkerBalanceValidator.countJungleTiles(tiles), 10);
    });

    test('returns 0 for an empty list', () {
      expect(WorkerBalanceValidator.countJungleTiles([]), 0);
    });
  });
}
