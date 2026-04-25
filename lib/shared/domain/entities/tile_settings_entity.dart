import 'package:companion_for_cacao/config/constants/tile_settings.dart';

class TileSettingsEntity {
  TileSettingsEntity({
    this.playerColorInBorder = true,
    this.playerColorInCircle = true,
    this.badgeTypeInImage = true,
    this.badgeTypeInText = true,
    this.boardgameInTitle = true,
    this.showQuantity = true,
    this.compactTileLayout = false,
  });
  final bool playerColorInBorder;
  final bool playerColorInCircle;
  final bool badgeTypeInImage;
  final bool badgeTypeInText;
  final bool boardgameInTitle;
  final bool showQuantity;
  final bool compactTileLayout;

  TileSettingsEntity copyWith({
    bool? playerColorInBorder,
    bool? playerColorInCircle,
    bool? badgeTypeInImage,
    bool? badgeTypeInText,
    bool? boardgameInTitle,
    bool? showQuantity,
    bool? compactTileLayout,
  }) {
    return TileSettingsEntity(
      playerColorInBorder: playerColorInBorder ?? this.playerColorInBorder,
      playerColorInCircle: playerColorInCircle ?? this.playerColorInCircle,
      badgeTypeInImage: badgeTypeInImage ?? this.badgeTypeInImage,
      badgeTypeInText: badgeTypeInText ?? this.badgeTypeInText,
      boardgameInTitle: boardgameInTitle ?? this.boardgameInTitle,
      showQuantity: showQuantity ?? this.showQuantity,
      compactTileLayout: compactTileLayout ?? this.compactTileLayout,
    );
  }

  bool settings(String action) {
    switch (action) {
      case TileSettings.playerColorInBorder:
        return playerColorInBorder;
      case TileSettings.playerColorInCircle:
        return playerColorInCircle;
      case TileSettings.badgeTypeInImage:
        return badgeTypeInImage;
      case TileSettings.badgeTypeInText:
        return badgeTypeInText;
      case TileSettings.boardgameInTitle:
        return boardgameInTitle;
      case TileSettings.showQuantity:
        return showQuantity;
      case TileSettings.compactTileLayout:
        return compactTileLayout;
      default:
        return false;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TileSettingsEntity &&
        other.playerColorInBorder == playerColorInBorder &&
        other.playerColorInCircle == playerColorInCircle &&
        other.badgeTypeInImage == badgeTypeInImage &&
        other.badgeTypeInText == badgeTypeInText &&
        other.boardgameInTitle == boardgameInTitle &&
        other.showQuantity == showQuantity &&
        other.compactTileLayout == compactTileLayout;
  }

  @override
  int get hashCode => Object.hash(
    playerColorInBorder,
    playerColorInCircle,
    badgeTypeInImage,
    badgeTypeInText,
    boardgameInTitle,
    showQuantity,
    compactTileLayout,
  );
}
