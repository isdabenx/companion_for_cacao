import 'package:companion_for_cacao/features/game_setup/domain/entities/worker_selection_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WorkerSelectionEntity.effectiveQuantities', () {
    test('baseOnly returns only the 11 base tiles', () {
      const selection = WorkerSelectionEntity(
        presetType: WorkerPresetType.baseOnly,
      );
      expect(selection.effectiveQuantities, {
        '1-1-1-1': 4,
        '2-1-0-1': 5,
        '3-0-0-1': 1,
        '3-1-0-0': 1,
      });
      expect(selection.tilesPerPlayer, 11);
    });

    test('replaceWithNew swaps 4x 1-1-1-1 for the 4 new tiles', () {
      const selection = WorkerSelectionEntity(
        presetType: WorkerPresetType.replaceWithNew,
      );
      final quantities = selection.effectiveQuantities;
      expect(quantities['1-1-1-1'], 0);
      expect(quantities['0-0-0-4'], 1);
      expect(quantities['0-0-2-2'], 1);
      expect(quantities['0-2-0-2'], 1);
      expect(quantities['0-1-0-3'], 1);
      expect(selection.tilesPerPlayer, 11);
    });

    test('baseWith0004 adds only the 0-0-0-4 tile to the base set', () {
      const selection = WorkerSelectionEntity(
        presetType: WorkerPresetType.baseWith0004,
      );
      final quantities = selection.effectiveQuantities;
      expect(quantities['0-0-0-4'], 1);
      expect(quantities.containsKey('0-0-2-2'), isFalse);
      expect(quantities.containsKey('0-2-0-2'), isFalse);
      expect(quantities.containsKey('0-1-0-3'), isFalse);
      expect(selection.tilesPerPlayer, 12);
    });

    test('addAll includes all base and new tiles', () {
      const selection = WorkerSelectionEntity();
      final quantities = selection.effectiveQuantities;
      expect(quantities.length, 8);
      expect(selection.tilesPerPlayer, 15);
    });

    test('manual mode returns tileQuantities verbatim', () {
      const selection = WorkerSelectionEntity(
        mode: WorkerSelectionMode.manual,
        tileQuantities: {'1-1-1-1': 2, '0-0-0-4': 1},
      );
      expect(selection.effectiveQuantities, {'1-1-1-1': 2, '0-0-0-4': 1});
      expect(selection.tilesPerPlayer, 3);
    });
  });

  group('WorkerSelectionEntity equality', () {
    test('equal when all fields match', () {
      const a = WorkerSelectionEntity(
        mode: WorkerSelectionMode.manual,
        tileQuantities: {'1-1-1-1': 4},
      );
      const b = WorkerSelectionEntity(
        mode: WorkerSelectionMode.manual,
        tileQuantities: {'1-1-1-1': 4},
      );
      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('not equal when isSurprise differs', () {
      const a = WorkerSelectionEntity(
        mode: WorkerSelectionMode.manual,
        tileQuantities: {'1-1-1-1': 4},
      );
      const b = WorkerSelectionEntity(
        mode: WorkerSelectionMode.manual,
        tileQuantities: {'1-1-1-1': 4},
        isSurprise: true,
      );
      expect(a, isNot(b));
    });

    test('not equal when quantities differ', () {
      const a = WorkerSelectionEntity(
        mode: WorkerSelectionMode.manual,
        tileQuantities: {'1-1-1-1': 4},
      );
      const b = WorkerSelectionEntity(
        mode: WorkerSelectionMode.manual,
        tileQuantities: {'1-1-1-1': 3},
      );
      expect(a, isNot(b));
    });

    test('copyWith preserves unset fields and overrides set ones', () {
      const original = WorkerSelectionEntity(
        mode: WorkerSelectionMode.manual,
        tileQuantities: {'1-1-1-1': 4},
        isSurprise: true,
      );
      final copy = original.copyWith(isSurprise: false);
      expect(copy.mode, WorkerSelectionMode.manual);
      expect(copy.tileQuantities, {'1-1-1-1': 4});
      expect(copy.isSurprise, isFalse);
    });
  });
}
