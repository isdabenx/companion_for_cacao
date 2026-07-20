import 'package:companion_for_cacao/features/score/domain/entities/hut_type.dart';
import 'package:companion_for_cacao/features/score/domain/entities/player_score_input_entity.dart';
import 'package:companion_for_cacao/features/score/domain/entities/score_category.dart';
import 'package:companion_for_cacao/features/score/domain/entities/score_input_entity.dart';
import 'package:companion_for_cacao/features/score/domain/entities/score_result_entity.dart';
import 'package:companion_for_cacao/features/score/domain/entities/temple_entry_entity.dart';

/// Pure final-scoring engine implementing the official Cacao rules
/// (base game + Chocolatl Hut Module + Diamante Gem Mines).
///
/// No Flutter or persistence dependencies: everything is computable from a
/// [ScoreInputEntity], which makes the tie rules fully unit-testable.
class ScoreCalculatorService {
  const ScoreCalculatorService();

  /// Water track fields on the village board, in order. The carrier starts
  /// on -10; the final field is worth its value in gold (negative included).
  static const List<int> waterTrackValues = [-10, -4, -1, 0, 2, 4, 7, 11, 16];

  /// Index of the water field required by the Fountain Master hut bonus.
  static const int _topWaterFieldIndex = 8;

  /// Mask tile values available in the Gem Mines module (7 tiles).
  static const List<int> maskValues = [8, 8, 9, 9, 10, 10, 12];

  /// Gold for the player with the most workers adjacent to a temple.
  static const int templeFirstGold = 6;

  /// Gold for the player with the second-most workers adjacent to a temple.
  static const int templeSecondGold = 3;

  ScoreResultEntity calculate(ScoreInputEntity input) {
    final templeGoldByColor = <String, int>{};
    if (!input.gemMinesActive) {
      for (final temple in input.temples) {
        scoreTemple(temple).forEach((color, gold) {
          templeGoldByColor[color] = (templeGoldByColor[color] ?? 0) + gold;
        });
      }
    }

    final scores = input.players.map((player) {
      final playerInput = input.inputOf(player.color);
      final breakdown = <ScoreCategory, int>{
        ScoreCategory.accumulatedGold: playerInput.accumulatedGold,
        ScoreCategory.waterTrack: waterTrackValues[playerInput.waterFieldIndex],
        if (!input.gemMinesActive)
          ScoreCategory.temples: templeGoldByColor[player.color] ?? 0,
        ScoreCategory.sunTokens: playerInput.sunTokens,
        if (input.hutModuleActive)
          ScoreCategory.huts: scoreHuts(
            playerInput,
            templesWithPresence: input.gemMinesActive
                ? 0
                : _templesWithPresence(input.temples, player.color),
          ),
        if (input.gemMinesActive)
          ScoreCategory.gemMines:
              playerInput.maskValues.fold(0, (sum, v) => sum + v) +
              playerInput.leftoverGems,
      };
      return PlayerScoreEntity(
        player: player,
        breakdown: breakdown,
        cacaoFruits: playerInput.cacaoFruits,
      );
    }).toList();

    return _rank(scores);
  }

  /// Scores a single temple, returning the gold earned per player color.
  ///
  /// Official rules: most adjacent workers 6 gold, second-most 3 gold.
  /// A tie for first splits 6 gold rounded down and second place is not
  /// awarded; a clear first with a tie for second splits 3 gold rounded
  /// down. At least 1 adjacent worker is required to score at all.
  Map<String, int> scoreTemple(TempleEntryEntity temple) {
    final contenders = temple.workersByColor.entries
        .where((e) => e.value > 0)
        .toList();
    if (contenders.isEmpty) return const {};

    final maxWorkers = contenders
        .map((e) => e.value)
        .reduce((a, b) => a > b ? a : b);
    final first = contenders.where((e) => e.value == maxWorkers).toList();

    if (first.length > 1) {
      final share = templeFirstGold ~/ first.length;
      return {for (final e in first) e.key: share};
    }

    final gold = {first.single.key: templeFirstGold};
    final rest = contenders.where((e) => e.value != maxWorkers).toList();
    if (rest.isEmpty) return gold;

    final secondWorkers = rest
        .map((e) => e.value)
        .reduce((a, b) => a > b ? a : b);
    final second = rest.where((e) => e.value == secondWorkers).toList();
    final share = templeSecondGold ~/ second.length;
    for (final e in second) {
      gold[e.key] = share;
    }
    return gold;
  }

  /// Scores the Hut Module for one player: cost refund plus end-game
  /// bonuses. Derived bonuses reuse other calculator inputs; Hermit and
  /// Road Worker use the player's manual counts.
  int scoreHuts(
    PlayerScoreInputEntity input, {
    required int templesWithPresence,
  }) {
    var gold = 0;
    for (final hut in input.huts) {
      gold += hut.cost + hut.fixedBonus;
      switch (hut) {
        case HutType.fountainMaster:
          if (input.waterFieldIndex == _topWaterFieldIndex) gold += 4;
        case HutType.trader:
          gold += input.cacaoFruits;
        case HutType.monk:
          gold += templesWithPresence;
        case HutType.masterBuilder:
          gold += input.huts.length - 1;
        case HutType.hermit:
          gold += input.hermitWorkers;
        case HutType.roadWorker:
          gold += input.roadWorkerTiles;
        default:
          break;
      }
    }
    return gold;
  }

  int _templesWithPresence(List<TempleEntryEntity> temples, String color) {
    return temples.where((t) => t.workersOf(color) > 0).length;
  }

  /// Sorts by total gold, breaking ties with leftover cacao fruits; players
  /// still tied share the rank (competition ranking: 1, 1, 3...).
  ScoreResultEntity _rank(List<PlayerScoreEntity> scores) {
    final sorted = List<PlayerScoreEntity>.from(scores)
      ..sort((a, b) {
        final byGold = b.total.compareTo(a.total);
        if (byGold != 0) return byGold;
        return b.cacaoFruits.compareTo(a.cacaoFruits);
      });

    final ranked = <PlayerScoreEntity>[];
    for (var i = 0; i < sorted.length; i++) {
      final tiedWithPrevious =
          i > 0 &&
          sorted[i].total == sorted[i - 1].total &&
          sorted[i].cacaoFruits == sorted[i - 1].cacaoFruits;
      final rank = tiedWithPrevious ? ranked[i - 1].rank : i + 1;
      ranked.add(sorted[i].copyWith(rank: rank));
    }

    final winners = ranked.where((s) => s.rank == 1).toList();
    final goldTiedAtTop = ranked
        .where((s) => s.total == ranked.first.total)
        .toList();

    return ScoreResultEntity(
      standings: ranked,
      tiebreakByCacaoApplied:
          goldTiedAtTop.length > 1 && winners.length < goldTiedAtTop.length,
      sharedWin: winners.length > 1,
    );
  }
}
