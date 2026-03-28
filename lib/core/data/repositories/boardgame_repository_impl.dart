import 'package:companion_for_cacao/core/data/database/app_database.dart';
import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/module_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/core/data/repositories/boardgame_repository.dart';

class BoardgameRepositoryImpl implements BoardgameRepository {
  BoardgameRepositoryImpl(this._database);

  final AppDatabase _database;

  @override
  Future<List<BoardgameModel>> getAllBoardgames() async {
    try {
      final rows = await _database.getAllBoardgames();
      return rows.map(BoardgameModel.fromDrift).toList();
    } catch (e) {
      throw Exception('Error fetching boardgames: $e');
    }
  }

  @override
  Future<List<ModuleModel>> getAllModules() async {
    try {
      final rows = await _database.getAllModules();
      return rows.map(ModuleModel.fromDrift).toList();
    } catch (e) {
      throw Exception('Error fetching modules: $e');
    }
  }

  @override
  Future<List<TileModel>> getAllTiles() async {
    try {
      final rows = await _database.getAllTiles();
      return rows.map(TileModel.fromDrift).toList();
    } catch (e) {
      throw Exception('Error fetching tiles: $e');
    }
  }
}
