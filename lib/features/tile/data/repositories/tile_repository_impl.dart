import 'package:companion_for_cacao/core/data/database/app_database.dart';
import 'package:companion_for_cacao/core/data/mappers/drift_entity_mappers.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/features/tile/domain/repositories/tile_repository.dart';

class TileRepositoryImpl implements TileRepository {
  TileRepositoryImpl(this._database);

  final AppDatabase _database;

  @override
  Future<List<TileEntity>> getAllTiles() async {
    try {
      final rows = await _database.getAllTiles();
      return rows.map((row) => row.toEntity()).toList();
    } catch (e) {
      throw Exception('Error fetching tiles: $e');
    }
  }

  @override
  Future<List<TileEntity>> getTilesByIds(List<String> ids) async {
    try {
      final rows = await _database.getTilesByIds(ids);
      return rows.map((row) => row.toEntity()).toList();
    } catch (e) {
      throw Exception('Error fetching tiles by IDs: $e');
    }
  }
}
