import 'package:companion_for_cacao/core/domain/entities/hut_type.dart';

/// The 12 physical double-sided hut tiles of the Chocolatl Hut Module,
/// transcribed from the real components (front photo / back photo, tiles
/// flipped in place). Each game only the face-up side of each tile exists.
///
/// Ten functions appear on two different tiles (so two players CAN both
/// own e.g. a Market Crier when both copies landed face up); the Chief
/// family (Daughter, Son, Wife, Chief) exists on a single tile each.
/// Tiles 1 and 3 are two copies of the same Market Crier / Hermit tile.
class HutTileSupply {
  HutTileSupply._();

  /// (side A, side B) of each physical tile.
  static const List<(HutType, HutType)> tiles = [
    (HutType.marketCrier, HutType.hermit),
    (HutType.trader, HutType.farmer),
    (HutType.hermit, HutType.marketCrier),
    (HutType.roadWorker, HutType.shaman),
    (HutType.shaman, HutType.masterBuilder),
    (HutType.farmer, HutType.monk),
    (HutType.masterBuilder, HutType.chiefsSon),
    (HutType.monk, HutType.chiefsDaughter),
    (HutType.foreman, HutType.roadWorker),
    (HutType.fountainMaster, HutType.trader),
    (HutType.chiefsWife, HutType.fountainMaster),
    (HutType.chief, HutType.foreman),
  ];

  /// Whether [builtHuts] (all players' huts together, duplicates included)
  /// can be laid out with real tiles: every built hut must come from a
  /// distinct physical tile showing that function face up.
  ///
  /// Solved as a tiny assignment problem by backtracking — 12 tiles and at
  /// most 12 built huts, so exhaustive search is instant.
  static bool isRealizable(List<HutType> builtHuts) {
    if (builtHuts.length > tiles.length) return false;
    final used = List<bool>.filled(tiles.length, false);

    bool assign(int hutIndex) {
      if (hutIndex == builtHuts.length) return true;
      final hut = builtHuts[hutIndex];
      for (var t = 0; t < tiles.length; t++) {
        if (used[t]) continue;
        final (sideA, sideB) = tiles[t];
        if (sideA != hut && sideB != hut) continue;
        used[t] = true;
        if (assign(hutIndex + 1)) return true;
        used[t] = false;
      }
      return false;
    }

    return assign(0);
  }
}
