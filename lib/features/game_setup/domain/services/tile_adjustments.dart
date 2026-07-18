import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';

/// Shared tile-list adjustment helpers used by preparation handlers.
mixin TileAdjustments {
  /// Reduces the quantity of the tile with [id] by up to [amount],
  /// never going below zero.
  List<TileEntity> reduceTileById(
    List<TileEntity> tiles, {
    required String id,
    required int amount,
  }) {
    var remaining = amount;

    return tiles.map((tile) {
      if (remaining == 0 || tile.id != id) {
        return tile;
      }

      final reduction = tile.quantity >= remaining ? remaining : tile.quantity;
      remaining -= reduction;

      return tile.copyWith(quantity: tile.quantity - reduction);
    }).toList();
  }

  /// Adds [quantityEach] copies of every tile belonging to [moduleId]
  /// (looked up in the active expansions' definitions), incrementing
  /// existing pool entries or appending new ones.
  List<TileEntity> addModuleTiles(
    List<TileEntity> tiles, {
    required int moduleId,
    required int quantityEach,
    required List<BoardgameEntity> activeExpansions,
  }) {
    final result = <TileEntity>[...tiles];

    final tileDefs = [
      for (final expansion in activeExpansions)
        for (final tile in expansion.tiles)
          if (tile.moduleId == moduleId) tile,
    ];

    for (final tileDef in tileDefs) {
      final index = result.indexWhere((t) => t.id == tileDef.id);
      if (index >= 0) {
        result[index] = result[index].copyWith(
          quantity: result[index].quantity + quantityEach,
        );
      } else {
        result.add(tileDef.copyWith(quantity: quantityEach));
      }
    }

    return result;
  }
}
