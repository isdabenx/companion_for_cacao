import 'dart:async';

import 'package:companion_for_cacao/config/constants/tile_settings.dart';
import 'package:companion_for_cacao/config/providers/repository_providers.dart';
import 'package:companion_for_cacao/core/utils/app_logger.dart';
import 'package:companion_for_cacao/shared/domain/entities/tile_settings_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

  void toggleCompactTileLayout() {
    state.whenData(
      (s) => _updateState(s.copyWith(compactTileLayout: !s.compactTileLayout)),
    );
  }

  /// Error policy lives HERE, in one place — the repository is pure I/O
  /// and propagates failures.
  ///
  /// Load failures degrade to default settings instead of surfacing an
  /// AsyncError: these are cosmetic display preferences, and the tile
  /// widgets read them via `select((s) => s.value)` — blocking the whole
  /// tile catalog over a failed preference read would be worse UX.
  Future<TileSettingsEntity> _loadSettings() async {
    try {
      final repository = ref.read(settingsRepositoryProvider);
      return await repository.getTileSettings();
    } catch (e, stackTrace) {
      AppLogger.error('Error loading tile settings', e, stackTrace);
      return TileSettingsEntity();
    }
  }

  /// Saves are optimistic: the in-memory state is already updated, so a
  /// failed write only costs persistence across restarts. Logged, not
  /// surfaced.
  Future<void> _saveSettings(TileSettingsEntity current) async {
    try {
      final repository = ref.read(settingsRepositoryProvider);
      await repository.saveTileSettings(current);
    } catch (e, stackTrace) {
      AppLogger.error('Error saving tile settings', e, stackTrace);
    }
  }

  void toggleSettings(String action) {
    switch (action) {
      case TileSettings.playerColorInBorder:
        togglePlayerColorInBorder();
        return;
      case TileSettings.playerColorInCircle:
        togglePlayerColorInCircle();
        return;
      case TileSettings.badgeTypeInImage:
        toggleBadgeTypeInImage();
        return;
      case TileSettings.badgeTypeInText:
        toggleBadgeTypeInText();
        return;
      case TileSettings.boardgameInTitle:
        toggleBoardgameInTitle();
        return;
      case TileSettings.showQuantity:
        toggleShowQuantity();
        return;
      case TileSettings.compactTileLayout:
        toggleCompactTileLayout();
        return;
    }
  }
}
