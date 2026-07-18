import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/module_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';

/// Builds a [TileEntity] with sensible test defaults.
///
/// Only override what the test cares about; everything else gets a
/// generic value.
TileEntity makeTile({
  String id = 'test.tile',
  String name = 'Test Tile',
  String description = 'Test description',
  String filenameImage = 'test.png',
  int quantity = 1,
  TileType? type,
  TileColor? color,
  int? boardgameId = 1,
  int? moduleId,
  int? hutCost,
}) {
  return TileEntity(
    id: id,
    name: name,
    description: description,
    filenameImage: filenameImage,
    quantity: quantity,
    type: type,
    color: color,
    boardgameId: boardgameId,
    moduleId: moduleId,
    hutCost: hutCost,
  );
}

/// Builds a [BoardgameEntity] with sensible test defaults.
BoardgameEntity makeBoardgame({
  int id = 1,
  String name = 'Cacao',
  String description = 'Test Boardgame',
  String filenameImage = 'test.png',
  int? requireId,
  List<ModuleEntity> modules = const [],
  List<TileEntity> tiles = const [],
}) {
  return BoardgameEntity(
    id: id,
    name: name,
    description: description,
    filenameImage: filenameImage,
    requireId: requireId,
    modules: modules,
    tiles: tiles,
  );
}

/// Builds a [ModuleEntity] with sensible test defaults.
ModuleEntity makeModule({
  int id = 1,
  String name = 'Test Module',
  String description = 'Test module description',
  int? boardgameId,
}) {
  return ModuleEntity(
    id: id,
    name: name,
    description: description,
    boardgameId: boardgameId,
  );
}
