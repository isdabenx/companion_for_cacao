import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/module_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';

abstract class BoardgameRepository {
  Future<List<BoardgameEntity>> getAllBoardgames();
  Future<List<ModuleEntity>> getAllModules();
  Future<List<TileEntity>> getAllTiles();
}
