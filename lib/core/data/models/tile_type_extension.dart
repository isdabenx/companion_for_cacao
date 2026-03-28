import 'package:companion_for_cacao/core/data/models/tile_model.dart';

extension TileTypeExtension on TileType {
  String get displayName {
    switch (this) {
      case TileType.player:
        return 'Player';
      case TileType.market:
        return 'Market';
      case TileType.plantation:
        return 'Plantation';
      case TileType.goldMine:
        return 'Gold Mine';
      case TileType.water:
        return 'Water';
      case TileType.temple:
        return 'Temple';
      case TileType.sunWorshipingSite:
        return 'Sun-Worshiping Site';
      case TileType.watering:
        return 'Watering';
      case TileType.chocolateKitchen:
        return 'Chocolate Kitchen';
      case TileType.chocolateMarket:
        return 'Chocolate Market';
      case TileType.mapTile:
        return 'Map Tile';
      case TileType.hut:
        return 'Hut';
    }
  }
}
