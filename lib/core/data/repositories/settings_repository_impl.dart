import 'package:companion_for_cacao/core/data/repositories/settings_repository.dart';
import 'package:companion_for_cacao/features/tile/domain/entities/tile_settings_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  @override
  Future<TileSettingsEntity> getTileSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return TileSettingsEntity(
        playerColorInBorder: prefs.getBool('playerColorInBorder') ?? true,
        playerColorInCircle: prefs.getBool('playerColorInCircle') ?? true,
        badgeTypeInImage: prefs.getBool('badgeTypeInImage') ?? true,
        badgeTypeInText: prefs.getBool('badgeTypeInText') ?? true,
        boardgameInTitle: prefs.getBool('boardgameInTitle') ?? true,
        showQuantity: prefs.getBool('showQuantity') ?? true,
        compactTileLayout: prefs.getBool('compactTileLayout') ?? false,
      );
    } catch (e, stackTrace) {
      debugPrint('Error loading tile settings: $e\n$stackTrace');
      return TileSettingsEntity();
    }
  }

  @override
  Future<void> saveTileSettings(TileSettingsEntity current) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('playerColorInBorder', current.playerColorInBorder);
      await prefs.setBool('playerColorInCircle', current.playerColorInCircle);
      await prefs.setBool('badgeTypeInImage', current.badgeTypeInImage);
      await prefs.setBool('badgeTypeInText', current.badgeTypeInText);
      await prefs.setBool('boardgameInTitle', current.boardgameInTitle);
      await prefs.setBool('showQuantity', current.showQuantity);
      await prefs.setBool('compactTileLayout', current.compactTileLayout);
    } catch (e, stackTrace) {
      debugPrint('Error saving tile settings: $e\n$stackTrace');
    }
  }
}
