import 'dart:async';

import 'package:companion_for_cacao/config/providers/repository_providers.dart';
import 'package:companion_for_cacao/core/utils/app_logger.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/custom_preset_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'custom_preset_notifier.g.dart';

@Riverpod(keepAlive: true)
class CustomPresetNotifier extends _$CustomPresetNotifier {
  @override
  Future<List<CustomPresetEntity>> build() async {
    return _loadPresets();
  }

  /// Adds a new custom preset and persists.
  void addPreset(CustomPresetEntity preset) {
    final current = state.value ?? [];
    final updated = [...current, preset];
    state = AsyncData(updated);
    unawaited(_savePresets(updated));
  }

  /// Deletes a custom preset by id and persists.
  void deletePreset(String id) {
    final current = state.value ?? [];
    final updated = current.where((p) => p.id != id).toList();
    state = AsyncData(updated);
    unawaited(_savePresets(updated));
  }

  Future<List<CustomPresetEntity>> _loadPresets() async {
    try {
      final repository = ref.read(customPresetRepositoryProvider);
      return await repository.getPresets();
    } catch (e, stackTrace) {
      AppLogger.error('Error loading custom presets', e, stackTrace);
      return [];
    }
  }

  Future<void> _savePresets(List<CustomPresetEntity> presets) async {
    try {
      final repository = ref.read(customPresetRepositoryProvider);
      await repository.savePresets(presets);
    } catch (e, stackTrace) {
      AppLogger.error('Error saving custom presets', e, stackTrace);
    }
  }
}
