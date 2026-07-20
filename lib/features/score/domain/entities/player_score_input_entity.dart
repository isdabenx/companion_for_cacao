import 'package:companion_for_cacao/features/score/domain/entities/hut_type.dart';
import 'package:flutter/foundation.dart';

/// Everything a single player enters into the score calculator, except
/// temples (temples are shared between players, see TempleEntryEntity).
class PlayerScoreInputEntity {
  PlayerScoreInputEntity({
    this.accumulatedGold = 0,
    this.waterFieldIndex = 0,
    this.sunTokens = 0,
    this.cacaoFruits = 0,
    this.huts = const {},
    this.hermitWorkers = 0,
    this.roadWorkerTiles = 0,
    this.maskValues = const [],
    this.leftoverGems = 0,
  });

  /// Gold coins collected during the game.
  final int accumulatedGold;

  /// Index into ScoreCalculatorService.waterTrackValues (0 = start field).
  final int waterFieldIndex;

  /// Unused sun tokens (0-3), worth 1 gold each.
  final int sunTokens;

  /// Leftover cacao fruits (0-5). Worth no gold, but they are the official
  /// tiebreaker and feed the Trader hut bonus.
  final int cacaoFruits;

  /// Huts built by this player (Hut Module only, each function at most once).
  final Set<HutType> huts;

  /// Manual count for the Hermit hut: own workers with no adjacent jungle
  /// tile. Ignored when the Hermit hut is not owned.
  final int hermitWorkers;

  /// Manual count for the Road Worker hut: own worker tiles in the row or
  /// column with most of them. Ignored when the Road Worker hut is not owned.
  final int roadWorkerTiles;

  /// Values of the mask tiles owned (Gem Mines only), e.g. [8, 10].
  final List<int> maskValues;

  /// Gems left next to the village board (Gem Mines only), 1 gold each.
  final int leftoverGems;

  PlayerScoreInputEntity copyWith({
    int? accumulatedGold,
    int? waterFieldIndex,
    int? sunTokens,
    int? cacaoFruits,
    Set<HutType>? huts,
    int? hermitWorkers,
    int? roadWorkerTiles,
    List<int>? maskValues,
    int? leftoverGems,
  }) {
    return PlayerScoreInputEntity(
      accumulatedGold: accumulatedGold ?? this.accumulatedGold,
      waterFieldIndex: waterFieldIndex ?? this.waterFieldIndex,
      sunTokens: sunTokens ?? this.sunTokens,
      cacaoFruits: cacaoFruits ?? this.cacaoFruits,
      huts: huts ?? this.huts,
      hermitWorkers: hermitWorkers ?? this.hermitWorkers,
      roadWorkerTiles: roadWorkerTiles ?? this.roadWorkerTiles,
      maskValues: maskValues ?? this.maskValues,
      leftoverGems: leftoverGems ?? this.leftoverGems,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PlayerScoreInputEntity &&
        other.accumulatedGold == accumulatedGold &&
        other.waterFieldIndex == waterFieldIndex &&
        other.sunTokens == sunTokens &&
        other.cacaoFruits == cacaoFruits &&
        setEquals(other.huts, huts) &&
        other.hermitWorkers == hermitWorkers &&
        other.roadWorkerTiles == roadWorkerTiles &&
        listEquals(other.maskValues, maskValues) &&
        other.leftoverGems == leftoverGems;
  }

  @override
  int get hashCode => Object.hash(
    accumulatedGold,
    waterFieldIndex,
    sunTokens,
    cacaoFruits,
    Object.hashAllUnordered(huts),
    hermitWorkers,
    roadWorkerTiles,
    Object.hashAll(maskValues),
    leftoverGems,
  );
}
