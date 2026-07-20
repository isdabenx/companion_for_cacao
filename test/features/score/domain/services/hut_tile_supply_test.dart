import 'package:companion_for_cacao/features/score/domain/entities/hut_type.dart';
import 'package:companion_for_cacao/features/score/domain/services/hut_tile_supply.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HutTileSupply.tiles', () {
    test('models the 12 physical tiles with 24 sides', () {
      expect(HutTileSupply.tiles, hasLength(12));

      final sideCount = <HutType, int>{};
      for (final (a, b) in HutTileSupply.tiles) {
        sideCount[a] = (sideCount[a] ?? 0) + 1;
        sideCount[b] = (sideCount[b] ?? 0) + 1;
      }
      // The Chief family exists on a single tile side each...
      expect(sideCount[HutType.chiefsDaughter], 1);
      expect(sideCount[HutType.chiefsSon], 1);
      expect(sideCount[HutType.chiefsWife], 1);
      expect(sideCount[HutType.chief], 1);
      // ...and every other function on exactly two.
      for (final hut in HutType.values) {
        if (sideCount[hut] != 1) expect(sideCount[hut], 2, reason: '$hut');
      }
    });
  });

  group('HutTileSupply.isRealizable', () {
    test('empty and single huts are always realizable', () {
      expect(HutTileSupply.isRealizable(const []), isTrue);
      for (final hut in HutType.values) {
        expect(HutTileSupply.isRealizable([hut]), isTrue, reason: '$hut');
      }
    });

    test('two copies of a duplicated function are allowed', () {
      expect(
        HutTileSupply.isRealizable(const [
          HutType.marketCrier,
          HutType.marketCrier,
        ]),
        isTrue,
      );
    });

    test('both sides of the duplicated tile pair max out at two total', () {
      // Market Crier / Hermit share the same two physical tiles.
      expect(
        HutTileSupply.isRealizable(const [HutType.marketCrier, HutType.hermit]),
        isTrue,
      );
      expect(
        HutTileSupply.isRealizable(const [
          HutType.marketCrier,
          HutType.marketCrier,
          HutType.hermit,
        ]),
        isFalse,
      );
    });

    test('a Chief-family hut consumes one copy of its tile partner', () {
      // Master Builder lives on two tiles, but one of them backs
      // Chief's Son: with the Son in play only one Master Builder remains.
      expect(
        HutTileSupply.isRealizable(const [
          HutType.chiefsSon,
          HutType.masterBuilder,
        ]),
        isTrue,
      );
      expect(
        HutTileSupply.isRealizable(const [
          HutType.chiefsSon,
          HutType.masterBuilder,
          HutType.masterBuilder,
        ]),
        isFalse,
      );
    });

    test('chained tile conflicts are detected', () {
      // Fountain Master is on tiles 10 (with Trader) and 11 (with Wife).
      expect(
        HutTileSupply.isRealizable(const [
          HutType.chiefsWife,
          HutType.fountainMaster,
        ]),
        isTrue,
      );
      expect(
        HutTileSupply.isRealizable(const [
          HutType.chiefsWife,
          HutType.fountainMaster,
          HutType.fountainMaster,
        ]),
        isFalse,
      );
      // Chief (tile 12, backs Foreman) + both Foremen is impossible.
      expect(
        HutTileSupply.isRealizable(const [
          HutType.chief,
          HutType.foreman,
          HutType.foreman,
        ]),
        isFalse,
      );
    });

    test('the whole Chief family can coexist', () {
      expect(
        HutTileSupply.isRealizable(const [
          HutType.chiefsDaughter,
          HutType.chiefsSon,
          HutType.chiefsWife,
          HutType.chief,
        ]),
        isTrue,
      );
    });

    test('more built huts than physical tiles is impossible', () {
      expect(HutTileSupply.isRealizable(HutType.values), isFalse);
    });
  });
}
