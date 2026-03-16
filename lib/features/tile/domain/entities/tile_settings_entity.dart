import 'package:companion_for_cacao/config/constants/tile_settings.dart';

class TileSettingsEntity {
  TileSettingsEntity({
    this.playerColorInBorder = true,
    this.playerColorInCircle = true,
    this.badgeTypeInImage = true,
    this.badgeTypeInText = true,
    this.boardgameInTitle = true,
    this.showQuantity = true,
  });
  final bool playerColorInBorder;
  final bool playerColorInCircle;
  final bool badgeTypeInImage;
  final bool badgeTypeInText;
  final bool boardgameInTitle;
  final bool showQuantity;

  TileSettingsEntity copyWith({
    bool? playerColorInBorder,
    bool? playerColorInCircle,
    bool? badgeTypeInImage,
    bool? badgeTypeInText,
    bool? boardgameInTitle,
    bool? showQuantity,
  }) {
    return TileSettingsEntity(
      playerColorInBorder: playerColorInBorder ?? this.playerColorInBorder,
      playerColorInCircle: playerColorInCircle ?? this.playerColorInCircle,
      badgeTypeInImage: badgeTypeInImage ?? this.badgeTypeInImage,
      badgeTypeInText: badgeTypeInText ?? this.badgeTypeInText,
      boardgameInTitle: boardgameInTitle ?? this.boardgameInTitle,
      showQuantity: showQuantity ?? this.showQuantity,
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
      default:
        return false;
    }
  }
}
