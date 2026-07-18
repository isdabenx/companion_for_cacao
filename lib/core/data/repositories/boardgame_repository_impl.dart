import 'package:companion_for_cacao/core/data/database/app_database.dart';
import 'package:companion_for_cacao/core/data/mappers/drift_entity_mappers.dart';
import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/module_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/core/domain/repositories/boardgame_repository.dart';

class BoardgameRepositoryImpl implements BoardgameRepository {
  BoardgameRepositoryImpl(this._database);

  final AppDatabase _database;

  @override
  Future<List<BoardgameEntity>> getAllBoardgames() async {
    try {
      final rows = await _database.getAllBoardgames();
      return rows.map((row) => row.toEntity()).toList();
    } catch (e) {
      throw Exception('Error fetching boardgames: $e');
    }
  }

  @override
  Future<List<ModuleEntity>> getAllModules() async {
    try {
      final rows = await _database.getAllModules();
      return rows.map((row) => row.toEntity()).toList();
    } catch (e) {
      throw Exception('Error fetching modules: $e');
    }
  }

  @override
  Future<List<TileEntity>> getAllTiles() async {
    try {
      final rows = await _database.getAllTiles();
      return rows.map((row) => row.toEntity()).toList();
    } catch (e) {
      throw Exception('Error fetching tiles: $e');
    }
  }
}
