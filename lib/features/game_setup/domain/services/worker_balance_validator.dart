import 'package:companion_for_cacao/core/data/models/tile_model.dart';

/// Result of a worker-jungle balance validation.
class WorkerBalanceResult {
  const WorkerBalanceResult({
    required this.isValid,
    required this.totalWorkers,
    required this.totalJungle,
    required this.difference,
    required this.minDifference,
    required this.maxDifference,
  });

  final bool isValid;

  /// Total number of worker tiles across all players.
  final int totalWorkers;

  /// Total number of jungle tiles in the game.
  final int totalJungle;

  /// Actual difference: totalWorkers - totalJungle.
  final int difference;

  /// Minimum allowed difference for this player count.
  final int minDifference;

  /// Maximum allowed difference for this player count.
  final int maxDifference;
}

/// Pure validation logic for worker-jungle tile balance.
///
/// The balance rule from Cacao Diamante Module D states that the difference
/// between total worker tiles and total jungle tiles must fall within a
/// range determined by the player count:
/// - 2 players: 1–8
/// - 3 players: 2–12
/// - 4 players: 3–16
class WorkerBalanceValidator {
  const WorkerBalanceValidator._();

  /// Validates the balance between worker tiles and jungle tiles.
  ///
  /// [playerCount] — number of active players (2–4).
  /// [workerTilesPerPlayer] — total worker tiles each player will have.
  /// [jungleTileCount] — total jungle tiles in the game.
  static WorkerBalanceResult validate({
    required int playerCount,
    required int workerTilesPerPlayer,
    required int jungleTileCount,
  }) {
    final totalWorkers = workerTilesPerPlayer * playerCount;
    final difference = totalWorkers - jungleTileCount;
    final (min, max) = balanceRange(playerCount);

    return WorkerBalanceResult(
      isValid: difference >= min && difference <= max,
      totalWorkers: totalWorkers,
      totalJungle: jungleTileCount,
      difference: difference,
      minDifference: min,
      maxDifference: max,
    );
  }

  /// Returns the valid (min, max) difference range for the given player count.
  static (int, int) balanceRange(int playerCount) {
    return switch (playerCount) {
      2 => (1, 8),
      3 => (2, 12),
      _ => (3, 16),
    };
  }

  /// Counts the total number of jungle tiles from a tile list.
  ///
  /// Jungle tiles are all non-player tiles that go into the central
  /// jungle area. Huts and map tiles are excluded as they have
  /// separate placement rules.
  static int countJungleTiles(List<TileModel> tiles) {
    return tiles
        .where((t) => _jungleTileTypes.contains(t.type))
        .fold(0, (sum, t) => sum + t.quantity);
  }

  static const _jungleTileTypes = {
    TileType.market,
    TileType.plantation,
    TileType.goldMine,
    TileType.water,
    TileType.temple,
    TileType.sunWorshipingSite,
    TileType.watering,
    TileType.chocolateKitchen,
    TileType.chocolateMarket,
    TileType.gemMine,
    TileType.treeOfLife,
  };
}
