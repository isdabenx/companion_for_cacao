import 'package:companion_for_cacao/core/data/database/app_database.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/tile/data/repositories/tile_repository.dart';

class TileRepositoryImpl implements TileRepository {
  TileRepositoryImpl(this._database);

  final AppDatabase _database;

  @override
  Future<List<TileModel>> getAllTiles() async {
    final rows = await _database.getAllTiles();
    return rows.map(TileModel.fromDrift).toList();
  }

  @override
  Future<List<TileModel>> getTilesByIds(List<int> ids) async {
    final rows = await _database.getTilesByIds(ids);
    return rows.map(TileModel.fromDrift).toList();
  }
}
