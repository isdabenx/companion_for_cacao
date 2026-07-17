import 'package:companion_for_cacao/config/providers/repository_providers.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/custom_preset_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/repositories/custom_preset_repository.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/custom_preset_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCustomPresetRepository extends Mock
    implements CustomPresetRepository {}

void main() {
  late MockCustomPresetRepository mockRepository;

  const presetA = CustomPresetEntity(
    id: 'preset_1',
    name: 'Our favorite',
    tileQuantities: {'1-1-1-1': 3, '0-0-0-4': 1},
  );
  const presetB = CustomPresetEntity(
    id: 'preset_2',
    name: 'Long game',
    tileQuantities: {'1-1-1-1': 4, '2-1-0-1': 5, '0-0-2-2': 1},
  );

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        customPresetRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
  }

  setUp(() {
    mockRepository = MockCustomPresetRepository();
    when(() => mockRepository.savePresets(any())).thenAnswer((_) async {});
  });

  setUpAll(() {
    registerFallbackValue(<CustomPresetEntity>[]);
  });

  group('CustomPresetNotifier', () {
    test('build loads presets from the repository', () async {
      when(
        () => mockRepository.getPresets(),
      ).thenAnswer((_) async => [presetA]);

      final container = createContainer();
      addTearDown(container.dispose);

      final presets = await container.read(customPresetProvider.future);
      expect(presets, [presetA]);
    });

    test('addPreset appends and persists', () async {
      when(() => mockRepository.getPresets()).thenAnswer((_) async => []);

      final container = createContainer();
      addTearDown(container.dispose);
      await container.read(customPresetProvider.future);

      container.read(customPresetProvider.notifier).addPreset(presetA);

      final presets = container.read(customPresetProvider).value;
      expect(presets, [presetA]);
      verify(() => mockRepository.savePresets([presetA])).called(1);
    });

    test('deletePreset removes by id and persists', () async {
      when(
        () => mockRepository.getPresets(),
      ).thenAnswer((_) async => [presetA, presetB]);

      final container = createContainer();
      addTearDown(container.dispose);
      await container.read(customPresetProvider.future);

      container.read(customPresetProvider.notifier).deletePreset(presetA.id);

      final presets = container.read(customPresetProvider).value;
      expect(presets, [presetB]);
      verify(() => mockRepository.savePresets([presetB])).called(1);
    });

    test('build returns empty list when repository throws', () async {
      when(
        () => mockRepository.getPresets(),
      ).thenThrow(Exception('storage error'));

      final container = createContainer();
      addTearDown(container.dispose);

      final presets = await container.read(customPresetProvider.future);
      expect(presets, isEmpty);
    });
  });
}
