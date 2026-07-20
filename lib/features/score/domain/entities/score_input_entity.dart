import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/score/domain/entities/player_score_input_entity.dart';
import 'package:companion_for_cacao/features/score/domain/entities/temple_entry_entity.dart';
import 'package:flutter/foundation.dart';

/// Complete input for a final scoring: the players, which score-relevant
/// modules were in play, the shared temples and each player's own inputs.
class ScoreInputEntity {
  ScoreInputEntity({
    required this.players,
    this.hutModuleActive = false,
    this.gemMinesActive = false,
    this.temples = const [],
    this.inputsByColor = const {},
  });

  final List<PlayerEntity> players;

  /// Chocolatl Hut Module in play: huts step is scored.
  final bool hutModuleActive;

  /// Diamante Gem Mines in play: gem mines replace the temples, so the
  /// temples step is skipped and the gem step is scored.
  final bool gemMinesActive;

  final List<TempleEntryEntity> temples;

  /// Per-player inputs keyed by player color.
  final Map<String, PlayerScoreInputEntity> inputsByColor;

  PlayerScoreInputEntity inputOf(String color) =>
      inputsByColor[color] ?? PlayerScoreInputEntity();

  ScoreInputEntity copyWith({
    List<PlayerEntity>? players,
    bool? hutModuleActive,
    bool? gemMinesActive,
    List<TempleEntryEntity>? temples,
    Map<String, PlayerScoreInputEntity>? inputsByColor,
  }) {
    return ScoreInputEntity(
      players: players ?? this.players,
      hutModuleActive: hutModuleActive ?? this.hutModuleActive,
      gemMinesActive: gemMinesActive ?? this.gemMinesActive,
      temples: temples ?? this.temples,
      inputsByColor: inputsByColor ?? this.inputsByColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ScoreInputEntity &&
        listEquals(other.players, players) &&
        other.hutModuleActive == hutModuleActive &&
        other.gemMinesActive == gemMinesActive &&
        listEquals(other.temples, temples) &&
        mapEquals(other.inputsByColor, inputsByColor);
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
  );
}
