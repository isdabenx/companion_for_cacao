import 'package:companion_for_cacao/core/domain/entities/hut_type.dart';
import 'package:companion_for_cacao/core/domain/services/hut_tile_supply.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/hut_layout_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// A valid throw: side A of every tile face up.
  List<HutType> allSideA() => [
    for (final (sideA, _) in HutTileSupply.tiles) sideA,
  ];

  group('HutLayoutEntity', () {
    test('availableCounts counts face-up copies per function', () {
      final layout = HutLayoutEntity(faceUp: allSideA());

      // Side A twice: Market Crier (tile 1) and its copy's flip side is
      // face up as Hermit (tile 3 side A).
      expect(layout.availableCounts[HutType.marketCrier], 1);
      expect(layout.availableCounts[HutType.hermit], 1);
      // Chief family only exists on side A of tiles 11 and 12.
      expect(layout.availableCounts[HutType.chiefsWife], 1);
      expect(layout.availableCounts[HutType.chief], 1);
      // Sides that never landed face up are absent.
      expect(layout.availableCounts[HutType.chiefsSon], isNull);
    });

    test('rejects a side that does not belong to its tile', () {
      final faceUp = allSideA();
      // Tile 1 is Market Crier / Hermit: the Chief is not one of its sides.
      faceUp[0] = HutType.chief;
      expect(
        () => HutLayoutEntity(faceUp: faceUp),
        throwsA(isA<AssertionError>()),
      );
    });

    test('rejects an incomplete throw', () {
      expect(
        () => HutLayoutEntity(faceUp: allSideA().sublist(0, 5)),
        throwsA(isA<AssertionError>()),
      );
    });

    test('value equality', () {
      expect(
        HutLayoutEntity(faceUp: allSideA()),
        HutLayoutEntity(faceUp: allSideA()),
      );
    });
  });
}
