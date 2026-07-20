import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/score/domain/entities/score_category.dart';
import 'package:flutter/foundation.dart';

/// Final score of a single player: gold per category plus ranking info.
class PlayerScoreEntity {
  PlayerScoreEntity({
    required this.player,
    required this.breakdown,
    required this.cacaoFruits,
    this.rank = 0,
  });

  final PlayerEntity player;

  /// Gold per category. Categories not in play are simply absent.
  final Map<ScoreCategory, int> breakdown;

  /// Leftover cacao fruits — the official tiebreaker (worth no gold).
  final int cacaoFruits;

  /// 1-based rank using competition ranking: players tied on gold and cacao
  /// share the same rank.
  final int rank;

  int get total => breakdown.values.fold(0, (sum, gold) => sum + gold);

  bool get isWinner => rank == 1;

  PlayerScoreEntity copyWith({int? rank}) {
    return PlayerScoreEntity(
      player: player,
      breakdown: breakdown,
      cacaoFruits: cacaoFruits,
      rank: rank ?? this.rank,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlayerScoreEntity &&
        other.player == player &&
        mapEquals(other.breakdown, breakdown) &&
        other.cacaoFruits == cacaoFruits &&
        other.rank == rank;
  }

  @override
  int get hashCode => Object.hash(
    player,
    Object.hashAllUnordered(
      breakdown.entries.map((e) => Object.hash(e.key, e.value)),
    ),
    cacaoFruits,
    rank,
  );
}

/// Result of a final scoring: standings sorted by rank, plus how ties at the
/// top were resolved (official rules: most leftover cacao fruits, then the
/// win is shared).
class ScoreResultEntity {
  ScoreResultEntity({
    required this.standings,
    this.tiebreakByCacaoApplied = false,
    this.sharedWin = false,
  });

  /// Sorted best to worst.
  final List<PlayerScoreEntity> standings;

  /// True when first place was tied on gold and leftover cacao decided it.
  final bool tiebreakByCacaoApplied;

  /// True when first place is shared (tied on gold and on cacao).
  final bool sharedWin;

  List<PlayerScoreEntity> get winners =>
      standings.where((s) => s.isWinner).toList();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScoreResultEntity &&
        listEquals(other.standings, standings) &&
        other.tiebreakByCacaoApplied == tiebreakByCacaoApplied &&
        other.sharedWin == sharedWin;
  }

  @override
  int get hashCode =>
      Object.hash(Object.hashAll(standings), tiebreakByCacaoApplied, sharedWin);
}
