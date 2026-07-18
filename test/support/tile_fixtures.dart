import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/module_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';

/// Builds a [TileModel] with sensible test defaults.
///
/// Only override what the test cares about; everything else gets a
/// generic value.
TileModel makeTile({
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
  return TileModel(
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

/// Builds a [BoardgameModel] with sensible test defaults.
BoardgameModel makeBoardgame({
  int id = 1,
  String name = 'Cacao',
  String description = 'Test Boardgame',
  String filenameImage = 'test.png',
  int? requireId,
  List<ModuleModel> modules = const [],
  List<TileModel> tiles = const [],
}) {
  return BoardgameModel(
    id: id,
    name: name,
    description: description,
    filenameImage: filenameImage,
    requireId: requireId,
    modules: modules,
    tiles: tiles,
  );
}

/// Builds a [ModuleModel] with sensible test defaults.
ModuleModel makeModule({
  int id = 1,
  String name = 'Test Module',
  String description = 'Test module description',
  int? boardgameId,
}) {
  return ModuleModel(
    id: id,
    name: name,
    description: description,
    boardgameId: boardgameId,
  );
}
