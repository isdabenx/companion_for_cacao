import 'package:companion_for_cacao/features/tile/domain/entities/tile_settings_entity.dart';

abstract class SettingsRepository {
  Future<TileSettingsEntity> getTileSettings();
  Future<void> saveTileSettings(TileSettingsEntity settings);
}
