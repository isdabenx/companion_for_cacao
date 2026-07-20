import 'package:flutter/foundation.dart';

/// One temple on the board: how many workers each player (keyed by player
/// color) has adjacent to it at the end of the game.
class TempleEntryEntity {
  TempleEntryEntity({required this.id, this.workersByColor = const {}});

  /// Stable identifier so temples can be edited/removed from a list.
  final int id;

  /// Adjacent worker count per player color. Missing color counts as 0.
  final Map<String, int> workersByColor;

  int workersOf(String color) => workersByColor[color] ?? 0;

  TempleEntryEntity copyWith({Map<String, int>? workersByColor}) {
    return TempleEntryEntity(
      id: id,
      workersByColor: workersByColor ?? this.workersByColor,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TempleEntryEntity &&
        other.id == id &&
        mapEquals(other.workersByColor, workersByColor);
  }

  @override
  int get hashCode => Object.hash(
    id,
    Object.hashAllUnordered(
      workersByColor.entries.map((e) => Object.hash(e.key, e.value)),
    ),
  );
}
