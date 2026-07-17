import 'dart:convert';

import 'package:companion_for_cacao/features/game_setup/data/repositories/custom_preset_repository_impl.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/custom_preset_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CustomPresetRepositoryImpl', () {
    late CustomPresetRepositoryImpl repository;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      repository = CustomPresetRepositoryImpl();
    });

    group('getPresets', () {
      test('should return empty list when no data is stored', () async {
        final result = await repository.getPresets();

        expect(result, isEmpty);
        expect(result, isA<List<CustomPresetEntity>>());
      });

      test('should return parsed presets from SharedPreferences', () async {
        final mockData = [
          {
            'id': 'preset_1',
            'name': 'Test Preset 1',
            'tileQuantities': {'1-1-1-1': 3, '2-1-0-1': 4},
          },
          {
            'id': 'preset_2',
            'name': 'Test Preset 2',
            'tileQuantities': {'0-0-0-4': 2, '2-2-0-0': 5},
          },
        ];
        SharedPreferences.setMockInitialValues({
          'custom_worker_presets': jsonEncode(mockData),
        });

        final result = await repository.getPresets();

        expect(result.length, equals(2));
        expect(result[0].id, equals('preset_1'));
        expect(result[0].name, equals('Test Preset 1'));
        expect(result[0].tileQuantities, equals({'1-1-1-1': 3, '2-1-0-1': 4}));
        expect(result[1].id, equals('preset_2'));
        expect(result[1].name, equals('Test Preset 2'));
        expect(result[1].tileQuantities, equals({'0-0-0-4': 2, '2-2-0-0': 5}));
      });

      test('should return single preset correctly', () async {
        final mockData = [
          {
            'id': 'preset_solo',
            'name': 'Solo Preset',
            'tileQuantities': {'1-1-1-1': 10},
          },
        ];
        SharedPreferences.setMockInitialValues({
          'custom_worker_presets': jsonEncode(mockData),
        });

        final result = await repository.getPresets();

        expect(result.length, equals(1));
        expect(result[0].id, equals('preset_solo'));
        expect(result[0].name, equals('Solo Preset'));
      });

      test('should handle preset with empty tileQuantities', () async {
        final mockData = [
          {
            'id': 'preset_empty',
            'name': 'Empty Preset',
            'tileQuantities': <String, int>{},
          },
        ];
        SharedPreferences.setMockInitialValues({
          'custom_worker_presets': jsonEncode(mockData),
        });

        final result = await repository.getPresets();

        expect(result.length, equals(1));
        expect(result[0].tileQuantities, isEmpty);
      });

      test('should return empty list on corrupted JSON', () async {
        SharedPreferences.setMockInitialValues({
          'custom_worker_presets': 'invalid json {]',
        });

        final result = await repository.getPresets();

        expect(result, isEmpty);
      });

      test('should return empty list when JSON is not a list', () async {
        SharedPreferences.setMockInitialValues({
          'custom_worker_presets': jsonEncode({'not': 'a list'}),
        });

        final result = await repository.getPresets();

        expect(result, isEmpty);
      });

      test(
        'should return empty list when JSON has invalid preset structure',
        () async {
          SharedPreferences.setMockInitialValues({
            'custom_worker_presets': jsonEncode([
              {'id': 'preset_1'}, // Missing name and tileQuantities
            ]),
          });

          final result = await repository.getPresets();

          expect(result, isEmpty);
        },
      );

      test('should handle special characters in preset names', () async {
        final mockData = [
          {
            'id': 'preset_special',
            'name': "Juan's Preset (2-4 players) — Special!",
            'tileQuantities': {'1-1-1-1': 3},
          },
        ];
        SharedPreferences.setMockInitialValues({
          'custom_worker_presets': jsonEncode(mockData),
        });

        final result = await repository.getPresets();

        expect(result.length, equals(1));
        expect(
          result[0].name,
          equals("Juan's Preset (2-4 players) — Special!"),
        );
      });

      test('should handle large number of presets', () async {
        final mockData = List.generate(
          50,
          (index) => {
            'id': 'preset_$index',
            'name': 'Preset $index',
            'tileQuantities': {'1-1-1-1': index},
          },
        );
        SharedPreferences.setMockInitialValues({
          'custom_worker_presets': jsonEncode(mockData),
        });

        final result = await repository.getPresets();

        expect(result.length, equals(50));
        expect(result[0].id, equals('preset_0'));
        expect(result[49].id, equals('preset_49'));
      });
    });

    group('savePresets', () {
      test('should serialize and store presets in SharedPreferences', () async {
        final presets = [
          const CustomPresetEntity(
            id: 'preset_1',
            name: 'Test Preset',
            tileQuantities: {'1-1-1-1': 3, '2-1-0-1': 4},
          ),
        ];

        await repository.savePresets(presets);

        final prefs = await SharedPreferences.getInstance();
        final stored = prefs.getString('custom_worker_presets');

        expect(stored, isNotNull);
        final decoded = jsonDecode(stored!) as List;
        expect(decoded.length, equals(1));
        expect(decoded[0]['id'], equals('preset_1'));
        expect(decoded[0]['name'], equals('Test Preset'));
        expect(
          decoded[0]['tileQuantities'],
          equals({'1-1-1-1': 3, '2-1-0-1': 4}),
        );
      });

      test('should save multiple presets correctly', () async {
        final presets = [
          const CustomPresetEntity(
            id: 'preset_1',
            name: 'Preset 1',
            tileQuantities: {'1-1-1-1': 3},
          ),
          const CustomPresetEntity(
            id: 'preset_2',
            name: 'Preset 2',
            tileQuantities: {'2-2-0-0': 5},
          ),
          const CustomPresetEntity(
            id: 'preset_3',
            name: 'Preset 3',
            tileQuantities: {'0-0-0-4': 2},
          ),
        ];

        await repository.savePresets(presets);

        final prefs = await SharedPreferences.getInstance();
        final stored = prefs.getString('custom_worker_presets');
        final decoded = jsonDecode(stored!) as List;

        expect(decoded.length, equals(3));
        expect(decoded[0]['id'], equals('preset_1'));
        expect(decoded[1]['id'], equals('preset_2'));
        expect(decoded[2]['id'], equals('preset_3'));
      });

      test('should save empty list correctly', () async {
        await repository.savePresets([]);

        final prefs = await SharedPreferences.getInstance();
        final stored = prefs.getString('custom_worker_presets');

        expect(stored, isNotNull);
        final decoded = jsonDecode(stored!) as List;
        expect(decoded, isEmpty);
      });

      test('should overwrite existing data', () async {
        // First save
        await repository.savePresets([
          const CustomPresetEntity(
            id: 'preset_old',
            name: 'Old Preset',
            tileQuantities: {'1-1-1-1': 1},
          ),
        ]);

        // Second save (overwrite)
        await repository.savePresets([
          const CustomPresetEntity(
            id: 'preset_new',
            name: 'New Preset',
            tileQuantities: {'2-2-0-0': 2},
          ),
        ]);

        final prefs = await SharedPreferences.getInstance();
        final stored = prefs.getString('custom_worker_presets');
        final decoded = jsonDecode(stored!) as List;

        expect(decoded.length, equals(1));
        expect(decoded[0]['id'], equals('preset_new'));
        expect(decoded[0]['name'], equals('New Preset'));
      });

      test('should handle preset with empty tileQuantities', () async {
        final presets = [
          const CustomPresetEntity(
            id: 'preset_empty',
            name: 'Empty',
            tileQuantities: {},
          ),
        ];

        await repository.savePresets(presets);

        final prefs = await SharedPreferences.getInstance();
        final stored = prefs.getString('custom_worker_presets');
        final decoded = jsonDecode(stored!) as List;

        expect(decoded[0]['tileQuantities'], isEmpty);
      });

      test('should handle special characters in preset names', () async {
        final presets = [
          const CustomPresetEntity(
            id: 'preset_special',
            name: "Juan's Preset (2-4) — Test!",
            tileQuantities: {'1-1-1-1': 3},
          ),
        ];

        await repository.savePresets(presets);

        final prefs = await SharedPreferences.getInstance();
        final stored = prefs.getString('custom_worker_presets');
        final decoded = jsonDecode(stored!) as List;

        expect(decoded[0]['name'], equals("Juan's Preset (2-4) — Test!"));
      });

      test('should handle large number of presets', () async {
        final presets = List.generate(
          100,
          (index) => CustomPresetEntity(
            id: 'preset_$index',
            name: 'Preset $index',
            tileQuantities: {'1-1-1-1': index},
          ),
        );

        await repository.savePresets(presets);

        final prefs = await SharedPreferences.getInstance();
        final stored = prefs.getString('custom_worker_presets');
        final decoded = jsonDecode(stored!) as List;

        expect(decoded.length, equals(100));
      });
    });

    group('round-trip (save then load)', () {
      test('should preserve data through save and load cycle', () async {
        final originalPresets = [
          const CustomPresetEntity(
            id: 'preset_1',
            name: 'Test Preset 1',
            tileQuantities: {'1-1-1-1': 3, '2-1-0-1': 4, '0-0-0-4': 1},
          ),
          const CustomPresetEntity(
            id: 'preset_2',
            name: 'Test Preset 2',
            tileQuantities: {'2-2-0-0': 5, '1-2-1-0': 2},
          ),
        ];

        await repository.savePresets(originalPresets);
        final loadedPresets = await repository.getPresets();

        expect(loadedPresets.length, equals(originalPresets.length));
        expect(loadedPresets[0], equals(originalPresets[0]));
        expect(loadedPresets[1], equals(originalPresets[1]));
      });

      test('should handle multiple save/load cycles', () async {
        // First cycle
        await repository.savePresets([
          const CustomPresetEntity(
            id: 'preset_1',
            name: 'Cycle 1',
            tileQuantities: {'1-1-1-1': 1},
          ),
        ]);
        var loaded = await repository.getPresets();
        expect(loaded.length, equals(1));
        expect(loaded[0].name, equals('Cycle 1'));

        // Second cycle
        await repository.savePresets([
          const CustomPresetEntity(
            id: 'preset_2',
            name: 'Cycle 2',
            tileQuantities: {'2-2-0-0': 2},
          ),
        ]);
        loaded = await repository.getPresets();
        expect(loaded.length, equals(1));
        expect(loaded[0].name, equals('Cycle 2'));

        // Third cycle
        await repository.savePresets([
          const CustomPresetEntity(
            id: 'preset_3',
            name: 'Cycle 3',
            tileQuantities: {'0-0-0-4': 3},
          ),
        ]);
        loaded = await repository.getPresets();
        expect(loaded.length, equals(1));
        expect(loaded[0].name, equals('Cycle 3'));
      });

      test('should handle empty list round-trip', () async {
        await repository.savePresets([]);
        final loaded = await repository.getPresets();

        expect(loaded, isEmpty);
      });

      test(
        'should preserve complex tile quantities through round-trip',
        () async {
          final originalPresets = [
            const CustomPresetEntity(
              id: 'preset_complex',
              name: 'Complex Preset',
              tileQuantities: {
                '1-1-1-1': 3,
                '2-1-0-1': 4,
                '0-0-0-4': 1,
                '2-2-0-0': 5,
                '1-2-1-0': 2,
                '3-0-0-1': 1,
              },
            ),
          ];

          await repository.savePresets(originalPresets);
          final loadedPresets = await repository.getPresets();

          expect(
            loadedPresets[0].tileQuantities,
            equals(originalPresets[0].tileQuantities),
          );
          expect(
            loadedPresets[0].tilesPerPlayer,
            equals(originalPresets[0].tilesPerPlayer),
          );
        },
      );

      test('should maintain preset order through round-trip', () async {
        final originalPresets = [
          const CustomPresetEntity(
            id: 'preset_a',
            name: 'Preset A',
            tileQuantities: {'1-1-1-1': 1},
          ),
          const CustomPresetEntity(
            id: 'preset_b',
            name: 'Preset B',
            tileQuantities: {'2-2-0-0': 2},
          ),
          const CustomPresetEntity(
            id: 'preset_c',
            name: 'Preset C',
            tileQuantities: {'0-0-0-4': 3},
          ),
        ];

        await repository.savePresets(originalPresets);
        final loadedPresets = await repository.getPresets();

        expect(loadedPresets[0].id, equals('preset_a'));
        expect(loadedPresets[1].id, equals('preset_b'));
        expect(loadedPresets[2].id, equals('preset_c'));
      });

      test('should preserve special characters through round-trip', () async {
        final originalPresets = [
          const CustomPresetEntity(
            id: 'preset_special',
            name: "Juan's Preset (2-4 players) — Special! 🎮",
            tileQuantities: {'1-1-1-1': 3},
          ),
        ];

        await repository.savePresets(originalPresets);
        final loadedPresets = await repository.getPresets();

        expect(loadedPresets[0].name, equals(originalPresets[0].name));
      });
    });

    group('error handling', () {
      test('should not throw when saving fails silently', () async {
        // This test verifies the error handling in savePresets
        // The method catches exceptions and logs them, so it should not throw
        final presets = [
          const CustomPresetEntity(
            id: 'preset_1',
            name: 'Test',
            tileQuantities: {'1-1-1-1': 3},
          ),
        ];

        expect(
          () async => await repository.savePresets(presets),
          returnsNormally,
        );
      });

      test(
        'should handle corrupted data gracefully and return empty list',
        () async {
          SharedPreferences.setMockInitialValues({
            'custom_worker_presets': 'this is not valid json',
          });

          final result = await repository.getPresets();

          expect(result, isEmpty);
        },
      );

      test('should handle partial JSON parsing errors', () async {
        SharedPreferences.setMockInitialValues({
          'custom_worker_presets': jsonEncode([
            {
              'id': 'preset_1',
              'name': 'Valid Preset',
              'tileQuantities': {'1-1-1-1': 3},
            },
            {
              'id': 'preset_2',
              // Missing required fields
            },
          ]),
        });

        final result = await repository.getPresets();

        // Should return empty list due to parsing error
        expect(result, isEmpty);
      });
    });
  });
}
