import 'package:companion_for_cacao/shared/domain/entities/tile_settings_entity.dart';

abstract class SettingsRepository {
  Future<TileSettingsEntity> getTileSettings();
  Future<void> saveTileSettings(TileSettingsEntity settings);

  /// Whether the preparation screen has been shown on this device before.
  /// First time, step rows start expanded so new players see the full
  /// instructions without any interaction (spec-fase-ux1 §4).
  Future<bool> hasSeenPreparation();
  Future<void> markPreparationSeen();

  /// Whether the preparation opens in guided (page-by-page) mode instead
  /// of the checklist. Defaults to the list (spec-fase-ux2 §4).
  Future<bool> prefersGuidedPreparation();
  Future<void> setPrefersGuidedPreparation({required bool value});
}
