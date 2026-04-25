import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/module_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';

abstract class BoardgameRepository {
  Future<List<BoardgameModel>> getAllBoardgames();
  Future<List<ModuleModel>> getAllModules();
  Future<List<TileModel>> getAllTiles();
}
