import 'package:companion_for_cacao/config/constants/tile_settings.dart';
import 'package:companion_for_cacao/core/domain/repositories/settings_repository.dart';
import 'package:companion_for_cacao/shared/domain/entities/tile_settings_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pure I/O implementation: errors propagate to the caller so the
/// policy (fall back to defaults, surface, retry…) is decided in a
/// single place — the notifier that owns the state.
class SettingsRepositoryImpl implements SettingsRepository {
  @override
  Future<TileSettingsEntity> getTileSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return TileSettingsEntity(
      playerColorInBorder:
          prefs.getBool(TileSettings.playerColorInBorder) ?? true,
      playerColorInCircle:
          prefs.getBool(TileSettings.playerColorInCircle) ?? true,
      badgeTypeInImage: prefs.getBool(TileSettings.badgeTypeInImage) ?? true,
      badgeTypeInText: prefs.getBool(TileSettings.badgeTypeInText) ?? true,
      boardgameInTitle: prefs.getBool(TileSettings.boardgameInTitle) ?? true,
      showQuantity: prefs.getBool(TileSettings.showQuantity) ?? true,
      compactTileLayout: prefs.getBool(TileSettings.compactTileLayout) ?? false,
    );
  }

  @override
  Future<void> saveTileSettings(TileSettingsEntity current) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
      TileSettings.playerColorInBorder,
      current.playerColorInBorder,
    );
    await prefs.setBool(
      TileSettings.playerColorInCircle,
      current.playerColorInCircle,
    );
    await prefs.setBool(
      TileSettings.badgeTypeInImage,
      current.badgeTypeInImage,
    );
    await prefs.setBool(TileSettings.badgeTypeInText, current.badgeTypeInText);
    await prefs.setBool(
      TileSettings.boardgameInTitle,
      current.boardgameInTitle,
    );
    await prefs.setBool(TileSettings.showQuantity, current.showQuantity);
    await prefs.setBool(
      TileSettings.compactTileLayout,
      current.compactTileLayout,
    );
  }
}
