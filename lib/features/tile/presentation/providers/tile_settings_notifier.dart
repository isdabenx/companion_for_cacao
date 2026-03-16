import 'dart:async';

import 'package:companion_for_cacao/config/constants/tile_settings.dart';
import 'package:companion_for_cacao/features/tile/domain/entities/tile_settings_entity.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TileSettingsNotifier extends Notifier<TileSettingsEntity> {
  @override
  TileSettingsEntity build() {
    unawaited(_loadSettings());
    return TileSettingsEntity();
  }

  void togglePlayerColorInBorder() {
    state = state.copyWith(playerColorInBorder: !state.playerColorInBorder);
    unawaited(_saveSettings());
  }

  void togglePlayerColorInCircle() {
    state = state.copyWith(playerColorInCircle: !state.playerColorInCircle);
    unawaited(_saveSettings());
  }

  void toggleBadgeTypeInImage() {
    state = state.copyWith(badgeTypeInImage: !state.badgeTypeInImage);
    unawaited(_saveSettings());
  }

  void toggleBadgeTypeInText() {
    state = state.copyWith(badgeTypeInText: !state.badgeTypeInText);
    unawaited(_saveSettings());
  }

  void toggleBoardgameInTitle() {
    state = state.copyWith(boardgameInTitle: !state.boardgameInTitle);
    unawaited(_saveSettings());
  }

  void toggleShowQuantity() {
    state = state.copyWith(showQuantity: !state.showQuantity);
    unawaited(_saveSettings());
  }

  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      state = TileSettingsEntity(
        playerColorInBorder: prefs.getBool('playerColorInBorder') ?? true,
        playerColorInCircle: prefs.getBool('playerColorInCircle') ?? true,
        badgeTypeInImage: prefs.getBool('badgeTypeInImage') ?? true,
        badgeTypeInText: prefs.getBool('badgeTypeInText') ?? true,
        boardgameInTitle: prefs.getBool('boardgameInTitle') ?? true,
        showQuantity: prefs.getBool('showQuantity') ?? true,
      );
    } catch (e, stackTrace) {
      debugPrint('Error loading tile settings: $e\n$stackTrace');
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('playerColorInBorder', state.playerColorInBorder);
      await prefs.setBool('playerColorInCircle', state.playerColorInCircle);
      await prefs.setBool('badgeTypeInImage', state.badgeTypeInImage);
      await prefs.setBool('badgeTypeInText', state.badgeTypeInText);
      await prefs.setBool('boardgameInTitle', state.boardgameInTitle);
      await prefs.setBool('showQuantity', state.showQuantity);
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

final tileSettingsNotifier =
    NotifierProvider<TileSettingsNotifier, TileSettingsEntity>(
      TileSettingsNotifier.new,
    );
