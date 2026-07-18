import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';

abstract class TileRepository {
  Future<List<TileEntity>> getAllTiles();
  Future<List<TileEntity>> getTilesByIds(List<String> ids);
}
