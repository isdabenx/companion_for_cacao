import 'dart:async';

import 'package:companion_for_cacao/config/constants/tile_settings.dart';
import 'package:companion_for_cacao/features/tile/domain/entities/tile_settings_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'tile_settings_notifier.g.dart';

@Riverpod(keepAlive: true)
class TileSettingsNotifier extends _$TileSettingsNotifier {
  @override
  Future<TileSettingsEntity> build() async {
    return _loadSettings();
  }

  void _updateState(TileSettingsEntity updated) {
    state = AsyncData(updated);
    unawaited(_saveSettings(updated));
  }

  void togglePlayerColorInBorder() {
    state.whenData(
      (s) =>
          _updateState(s.copyWith(playerColorInBorder: !s.playerColorInBorder)),
    );
  }

  void togglePlayerColorInCircle() {
    state.whenData(
      (s) =>
          _updateState(s.copyWith(playerColorInCircle: !s.playerColorInCircle)),
    );
  }

  void toggleBadgeTypeInImage() {
    state.whenData(
      (s) => _updateState(s.copyWith(badgeTypeInImage: !s.badgeTypeInImage)),
    );
  }

  void toggleBadgeTypeInText() {
    state.whenData(
      (s) => _updateState(s.copyWith(badgeTypeInText: !s.badgeTypeInText)),
    );
  }

  void toggleBoardgameInTitle() {
    state.whenData(
      (s) => _updateState(s.copyWith(boardgameInTitle: !s.boardgameInTitle)),
    );
  }

  void toggleShowQuantity() {
    state.whenData(
      (s) => _updateState(s.copyWith(showQuantity: !s.showQuantity)),
    );
  }

  Future<TileSettingsEntity> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return TileSettingsEntity(
        playerColorInBorder: prefs.getBool('playerColorInBorder') ?? true,
        playerColorInCircle: prefs.getBool('playerColorInCircle') ?? true,
        badgeTypeInImage: prefs.getBool('badgeTypeInImage') ?? true,
        badgeTypeInText: prefs.getBool('badgeTypeInText') ?? true,
        boardgameInTitle: prefs.getBool('boardgameInTitle') ?? true,
        showQuantity: prefs.getBool('showQuantity') ?? true,
      );
    } catch (e, stackTrace) {
      debugPrint('Error loading tile settings: $e\n$stackTrace');
      return TileSettingsEntity();
    }
  }

  Future<void> _saveSettings(TileSettingsEntity current) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('playerColorInBorder', current.playerColorInBorder);
      await prefs.setBool('playerColorInCircle', current.playerColorInCircle);
      await prefs.setBool('badgeTypeInImage', current.badgeTypeInImage);
      await prefs.setBool('badgeTypeInText', current.badgeTypeInText);
      await prefs.setBool('boardgameInTitle', current.boardgameInTitle);
      await prefs.setBool('showQuantity', current.showQuantity);
    } catch (e, stackTrace) {
      debugPrint('Error saving tile settings: $e\n$stackTrace');
    }
  }

  void toggleSettings(String action) {
    switch (action) {
      case TileSettings.playerColorInBorder:
        togglePlayerColorInBorder();
      case TileSettings.playerColorInCircle:
        togglePlayerColorInCircle();
      case TileSettings.badgeTypeInImage:
        toggleBadgeTypeInImage();
      case TileSettings.badgeTypeInText:
        toggleBadgeTypeInText();
      case TileSettings.boardgameInTitle:
        toggleBoardgameInTitle();
      case TileSettings.showQuantity:
        toggleShowQuantity();
    }
  }
}
