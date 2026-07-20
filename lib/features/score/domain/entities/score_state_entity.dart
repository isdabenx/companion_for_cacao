import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/hut_type.dart';
import 'package:companion_for_cacao/features/score/domain/entities/player_score_input_entity.dart';
import 'package:companion_for_cacao/features/score/domain/entities/score_input_entity.dart';
import 'package:companion_for_cacao/features/score/domain/entities/temple_entry_entity.dart';
import 'package:companion_for_cacao/core/domain/services/hut_tile_supply.dart';
import 'package:companion_for_cacao/features/score/domain/services/score_calculator_service.dart';
import 'package:flutter/foundation.dart';

/// One page of the score calculator flow.
enum ScoreStep {
  setup('Players & Modules'),
  accumulatedGold('Accumulated Gold'),
  waterTrack('Water Track'),
  temples('Temples'),
  sunTokens('Sun Tokens'),
  cacaoFruits('Leftover Cacao'),
  huts('Huts'),
  gemMines('Gem Mines');

  const ScoreStep(this.label);

  final String label;
}

/// Full state of an in-progress final scoring session.
class ScoreStateEntity {
  ScoreStateEntity({
    this.players = const [],
    this.hutModuleActive = false,
    this.gemMinesActive = false,
    this.temples = const [],
    this.inputsByColor = const {},
    this.maskOwners = const [null, null, null, null, null, null, null],
    this.currentStepIndex = 0,
    this.availableHutCounts,
  });

  final List<PlayerEntity> players;
  final bool hutModuleActive;
  final bool gemMinesActive;
  final List<TempleEntryEntity> temples;
  final Map<String, PlayerScoreInputEntity> inputsByColor;

  /// Exact hut supply when the throw was registered during preparation
  /// (function -> face-up copies). Null when unknown: availability then
  /// falls back to [HutTileSupply.isRealizable].
  final Map<HutType, int>? availableHutCounts;

  /// Owner color (or null) of each of the 7 Gem Mines mask tiles, aligned
  /// with [ScoreCalculatorService.maskValues]. A physical mask tile can only
  /// belong to one player, so ownership is tracked globally.
  final List<String?> maskOwners;

  final int currentStepIndex;

  /// The visible steps given the active modules. Temples are replaced by
  /// gem mines when the Gem Mines module is in play.
  List<ScoreStep> get steps => [
    ScoreStep.setup,
    ScoreStep.accumulatedGold,
    ScoreStep.waterTrack,
    if (!gemMinesActive) ScoreStep.temples,
    ScoreStep.sunTokens,
    ScoreStep.cacaoFruits,
    if (hutModuleActive) ScoreStep.huts,
    if (gemMinesActive) ScoreStep.gemMines,
  ];

  ScoreStep get currentStep => steps[currentStepIndex];

  bool get isLastStep => currentStepIndex == steps.length - 1;

  /// Scoring needs at least 2 players (the game minimum).
  bool get canCalculate => players.length >= 2;

  PlayerScoreInputEntity inputOf(String color) =>
      inputsByColor[color] ?? PlayerScoreInputEntity();

  /// Every hut built by any player, duplicates included (some functions
  /// exist on two physical tiles, so two players can hold the same one).
  List<HutType> get allBuiltHuts => [
    for (final player in players) ...inputOf(player.color).huts,
  ];

  /// Colors of the players holding [hut] (0, 1 or 2 owners).
  List<String> hutOwners(HutType hut) => [
    for (final player in players)
      if (inputOf(player.color).huts.contains(hut)) player.color,
  ];

  /// Whether [color] can still build [hut]: not already owned by them, and
  /// there must be a physical tile left providing it — checked against the
  /// registered throw when available, or [HutTileSupply.isRealizable]
  /// otherwise.
  bool canBuildHut(String color, HutType hut) {
    if (inputOf(color).huts.contains(hut)) return false;
    final counts = availableHutCounts;
    if (counts != null) {
      final built = allBuiltHuts.where((h) => h == hut).length;
      return built < (counts[hut] ?? 0);
    }
    return HutTileSupply.isRealizable([...allBuiltHuts, hut]);
  }

  /// Builds the pure-domain input for [ScoreCalculatorService], injecting
  /// each player's mask values from the global mask ownership.
  ScoreInputEntity toServiceInput() {
    final inputs = <String, PlayerScoreInputEntity>{};
    for (final player in players) {
      final maskValues = <int>[
        for (var i = 0; i < maskOwners.length; i++)
          if (maskOwners[i] == player.color)
            ScoreCalculatorService.maskValues[i],
      ];
      inputs[player.color] = inputOf(
        player.color,
      ).copyWith(maskValues: maskValues);
    }
    return ScoreInputEntity(
      players: players,
      hutModuleActive: hutModuleActive,
      gemMinesActive: gemMinesActive,
      temples: temples,
      inputsByColor: inputs,
    );
  }

  ScoreStateEntity copyWith({
    List<PlayerEntity>? players,
    bool? hutModuleActive,
    bool? gemMinesActive,
    List<TempleEntryEntity>? temples,
    Map<String, PlayerScoreInputEntity>? inputsByColor,
    List<String?>? maskOwners,
    int? currentStepIndex,
    Map<HutType, int>? availableHutCounts,
  }) {
    return ScoreStateEntity(
      players: players ?? this.players,
      hutModuleActive: hutModuleActive ?? this.hutModuleActive,
      gemMinesActive: gemMinesActive ?? this.gemMinesActive,
      temples: temples ?? this.temples,
      inputsByColor: inputsByColor ?? this.inputsByColor,
      maskOwners: maskOwners ?? this.maskOwners,
      currentStepIndex: currentStepIndex ?? this.currentStepIndex,
      availableHutCounts: availableHutCounts ?? this.availableHutCounts,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScoreStateEntity &&
        listEquals(other.players, players) &&
        other.hutModuleActive == hutModuleActive &&
        other.gemMinesActive == gemMinesActive &&
        listEquals(other.temples, temples) &&
        mapEquals(other.inputsByColor, inputsByColor) &&
        listEquals(other.maskOwners, maskOwners) &&
        other.currentStepIndex == currentStepIndex &&
        mapEquals(other.availableHutCounts, availableHutCounts);
  }

  @override
  int get hashCode => Object.hash(
    Object.hashAll(players),
    hutModuleActive,
    gemMinesActive,
    Object.hashAll(temples),
    Object.hashAllUnordered(
      inputsByColor.entries.map((e) => Object.hash(e.key, e.value)),
    ),
    Object.hashAll(maskOwners),
    currentStepIndex,
    availableHutCounts == null
        ? null
        : Object.hashAllUnordered(
            availableHutCounts!.entries.map((e) => Object.hash(e.key, e.value)),
          ),
  );
}
