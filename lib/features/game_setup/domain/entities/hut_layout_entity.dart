import 'package:companion_for_cacao/core/domain/entities/hut_type.dart';
import 'package:companion_for_cacao/core/domain/services/hut_tile_supply.dart';
import 'package:flutter/foundation.dart';

/// Registered result of throwing the 12 hut tiles during setup: which side
/// of each physical tile landed face up.
///
/// [faceUp] is aligned with [HutTileSupply.tiles]; every entry must be one
/// of that tile's two sides. With a layout registered, the exact hut supply
/// of the game is known.
class HutLayoutEntity {
  HutLayoutEntity({required this.faceUp})
    : assert(
        faceUp.length == HutTileSupply.tiles.length,
        'One face-up side per physical tile',
      ),
      assert(() {
        for (var i = 0; i < faceUp.length; i++) {
          final (sideA, sideB) = HutTileSupply.tiles[i];
          if (faceUp[i] != sideA && faceUp[i] != sideB) return false;
        }
        return true;
      }(), 'Each face-up side must belong to its tile');

  final List<HutType> faceUp;

  /// How many copies of each hut function are actually in this game's
  /// supply (0 when a function landed face down on all its tiles).
  Map<HutType, int> get availableCounts {
    final counts = <HutType, int>{};
    for (final hut in faceUp) {
      counts[hut] = (counts[hut] ?? 0) + 1;
    }
    return counts;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HutLayoutEntity && listEquals(other.faceUp, faceUp);
  }

  @override
  int get hashCode => Object.hashAll(faceUp);
}
