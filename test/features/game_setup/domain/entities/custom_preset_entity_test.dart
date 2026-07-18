import 'package:companion_for_cacao/features/game_setup/domain/entities/custom_preset_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CustomPresetEntity', () {
    group('fromJson / toJson', () {
      test('should correctly serialize and deserialize', () {
        final json = {
          'id': 'preset_123456',
          'name': 'My Custom Preset',
          'tileQuantities': {'1-1-1-1': 3, '2-1-0-1': 4, '0-0-0-4': 1},
        };

        final entity = CustomPresetEntity.fromJson(json);

        expect(entity.id, equals('preset_123456'));
        expect(entity.name, equals('My Custom Preset'));
        expect(
          entity.tileQuantities,
          equals({'1-1-1-1': 3, '2-1-0-1': 4, '0-0-0-4': 1}),
        );
      });

      test('should perform round-trip conversion without data loss', () {
        const original = CustomPresetEntity(
          id: 'preset_789',
          name: 'Test Preset',
          tileQuantities: {'1-1-1-1': 2, '2-2-0-0': 5, '0-0-0-4': 1},
        );

        final json = original.toJson();
        final restored = CustomPresetEntity.fromJson(json);

        expect(restored, equals(original));
        expect(restored.id, equals(original.id));
        expect(restored.name, equals(original.name));
        expect(restored.tileQuantities, equals(original.tileQuantities));
      });

      test('should handle empty tileQuantities map', () {
        final json = {
          'id': 'preset_empty',
          'name': 'Empty Preset',
          'tileQuantities': <String, int>{},
        };

        final entity = CustomPresetEntity.fromJson(json);

        expect(entity.tileQuantities, isEmpty);
        expect(entity.toJson()['tileQuantities'], isEmpty);
      });

      test('should handle special characters in name', () {
        final json = {
          'id': 'preset_special',
          'name': "Juan's Preset (2-4 players)",
          'tileQuantities': {'1-1-1-1': 1},
        };

        final entity = CustomPresetEntity.fromJson(json);

        expect(entity.name, equals("Juan's Preset (2-4 players)"));
        expect(entity.toJson()['name'], equals("Juan's Preset (2-4 players)"));
      });
    });

    group('tilesPerPlayer', () {
      test('should calculate total tiles correctly', () {
        const entity = CustomPresetEntity(
          id: 'preset_1',
          name: 'Test',
          tileQuantities: {'1-1-1-1': 3, '2-1-0-1': 4, '0-0-0-4': 2},
        );

        expect(entity.tilesPerPlayer, equals(9));
      });

      test('should return 0 for empty tileQuantities', () {
        const entity = CustomPresetEntity(
          id: 'preset_2',
          name: 'Empty',
          tileQuantities: {},
        );

        expect(entity.tilesPerPlayer, equals(0));
      });

      test('should handle single tile type', () {
        const entity = CustomPresetEntity(
          id: 'preset_3',
          name: 'Single',
          tileQuantities: {'1-1-1-1': 10},
        );

        expect(entity.tilesPerPlayer, equals(10));
      });

      test('should handle large quantities', () {
        const entity = CustomPresetEntity(
          id: 'preset_4',
          name: 'Large',
          tileQuantities: {'1-1-1-1': 100, '2-2-0-0': 50, '0-0-0-4': 25},
        );

        expect(entity.tilesPerPlayer, equals(175));
      });
    });

    group('generateId', () {
      test('generates unique IDs even within the same millisecond', () {
        final ids = List.generate(100, (_) => CustomPresetEntity.generateId());
        expect(ids.toSet().length, ids.length);
      });

      test('generates IDs with the expected format', () {
        final id = CustomPresetEntity.generateId();
        expect(id, matches(RegExp(r'^preset_\d+_\d+$')));
      });
    });

    group('copyWith', () {
      const original = CustomPresetEntity(
        id: 'preset_original',
        name: 'Original Name',
        tileQuantities: {'1-1-1-1': 3, '2-1-0-1': 4},
      );

      test('should create copy with updated id', () {
        final updated = original.copyWith(id: 'preset_new');

        expect(updated.id, equals('preset_new'));
        expect(updated.name, equals(original.name));
        expect(updated.tileQuantities, equals(original.tileQuantities));
      });

      test('should create copy with updated name', () {
        final updated = original.copyWith(name: 'New Name');

        expect(updated.id, equals(original.id));
        expect(updated.name, equals('New Name'));
        expect(updated.tileQuantities, equals(original.tileQuantities));
      });

      test('should create copy with updated tileQuantities', () {
        final newQuantities = {'2-2-0-0': 5};
        final updated = original.copyWith(tileQuantities: newQuantities);

        expect(updated.id, equals(original.id));
        expect(updated.name, equals(original.name));
        expect(updated.tileQuantities, equals(newQuantities));
      });

      test('should create copy with multiple updated fields', () {
        final updated = original.copyWith(
          id: 'preset_multi',
          name: 'Multi Update',
        );

        expect(updated.id, equals('preset_multi'));
        expect(updated.name, equals('Multi Update'));
        expect(updated.tileQuantities, equals(original.tileQuantities));
      });

      test('should preserve all fields when no parameters provided', () {
        final updated = original.copyWith();

        expect(updated.id, equals(original.id));
        expect(updated.name, equals(original.name));
        expect(updated.tileQuantities, equals(original.tileQuantities));
      });

      test('should not mutate original instance', () {
        final updated = original.copyWith(name: 'Modified');

        expect(original.name, equals('Original Name'));
        expect(updated.name, equals('Modified'));
      });
    });

    group('equality and hashCode', () {
      test('should be equal when all properties match', () {
        final json = {
          'id': 'preset_1',
          'name': 'Test Preset',
          'tileQuantities': {'1-1-1-1': 3, '2-1-0-1': 4},
        };
        final preset1 = CustomPresetEntity.fromJson(json);
        final preset2 = CustomPresetEntity.fromJson(json);

        expect(preset1, equals(preset2));
      });

      test('should not be equal when id differs', () {
        const preset1 = CustomPresetEntity(
          id: 'preset_1',
          name: 'Test',
          tileQuantities: {'1-1-1-1': 3},
        );
        const preset2 = CustomPresetEntity(
          id: 'preset_2',
          name: 'Test',
          tileQuantities: {'1-1-1-1': 3},
        );

        expect(preset1, isNot(equals(preset2)));
      });

      test('should not be equal when name differs', () {
        const preset1 = CustomPresetEntity(
          id: 'preset_1',
          name: 'Name A',
          tileQuantities: {'1-1-1-1': 3},
        );
        const preset2 = CustomPresetEntity(
          id: 'preset_1',
          name: 'Name B',
          tileQuantities: {'1-1-1-1': 3},
        );

        expect(preset1, isNot(equals(preset2)));
      });

      test('should not be equal when tileQuantities differs', () {
        const preset1 = CustomPresetEntity(
          id: 'preset_1',
          name: 'Test',
          tileQuantities: {'1-1-1-1': 3},
        );
        const preset2 = CustomPresetEntity(
          id: 'preset_1',
          name: 'Test',
          tileQuantities: {'1-1-1-1': 4},
        );

        expect(preset1, isNot(equals(preset2)));
      });

      test('should handle empty tileQuantities in equality', () {
        final json = {
          'id': 'preset_1',
          'name': 'Empty',
          'tileQuantities': <String, int>{},
        };
        final preset1 = CustomPresetEntity.fromJson(json);
        final preset2 = CustomPresetEntity.fromJson(json);

        expect(preset1, equals(preset2));
      });

      test('should be identical when same instance', () {
        const preset = CustomPresetEntity(
          id: 'preset_1',
          name: 'Test',
          tileQuantities: {'1-1-1-1': 3},
        );

        expect(identical(preset, preset), isTrue);
        expect(preset, equals(preset));
      });

      test('should not be equal to different type', () {
        const preset = CustomPresetEntity(
          id: 'preset_1',
          name: 'Test',
          tileQuantities: {'1-1-1-1': 3},
        );

        expect(preset, isNot(equals('preset_1')));
        expect(preset, isNot(equals(123)));
      });

      test('should handle map equality with different key orders', () {
        const preset1 = CustomPresetEntity(
          id: 'preset_1',
          name: 'Test',
          tileQuantities: {'1-1-1-1': 3, '2-1-0-1': 4},
        );
        const preset2 = CustomPresetEntity(
          id: 'preset_1',
          name: 'Test',
          tileQuantities: {'2-1-0-1': 4, '1-1-1-1': 3},
        );

        // Maps with same entries should be equal regardless of order
        expect(preset1, equals(preset2));
      });
    });
  });
}
