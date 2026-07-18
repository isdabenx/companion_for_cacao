import 'package:companion_for_cacao/core/data/database/app_database.dart';
import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/module_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';

/// Maps a drift [Tile] row to a pure domain [TileEntity].
extension TileRowMapper on Tile {
  TileEntity toEntity() {
    return TileEntity(
      id: id,
      name: name,
      description: description,
      filenameImage: filenameImage,
      quantity: quantity,
      type: TileEntity.typeFromName(type),
      color: TileEntity.colorFromName(color),
      boardgameId: boardgameId,
      moduleId: moduleId,
      hutCost: hutCost,
    );
  }
}

/// Maps a drift [Boardgame] row to a pure domain [BoardgameEntity].
extension BoardgameRowMapper on Boardgame {
  BoardgameEntity toEntity() {
    return BoardgameEntity(
      id: id,
      name: name,
      description: description,
      filenameImage: filenameImage,
      requireId: requireId,
    );
  }
}

/// Maps a drift [Module] row to a pure domain [ModuleEntity].
extension ModuleRowMapper on Module {
  ModuleEntity toEntity() {
    return ModuleEntity(
      id: id,
      name: name,
      description: description,
      boardgameId: boardgameId,
    );
  }
}
