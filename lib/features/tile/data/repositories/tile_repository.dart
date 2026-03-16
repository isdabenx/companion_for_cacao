import 'package:companion_for_cacao/core/data/models/tile_model.dart';

abstract class TileRepository {
  Future<List<TileModel>> getAllTiles();
  Future<List<TileModel>> getTilesByIds(List<int> ids);
}
