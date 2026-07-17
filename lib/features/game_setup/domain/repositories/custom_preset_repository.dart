import 'package:companion_for_cacao/features/game_setup/domain/entities/custom_preset_entity.dart';

/// Repository interface for user-created worker tile presets.
abstract class CustomPresetRepository {
  /// Returns all stored custom presets.
  Future<List<CustomPresetEntity>> getPresets();

  /// Persists the full list of custom presets.
  Future<void> savePresets(List<CustomPresetEntity> presets);
}
