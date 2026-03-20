import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/core/data/repositories/boardgame_repository.dart';
import 'package:companion_for_cacao/features/tile/data/repositories/tile_repository.dart';

class GetTilesWithBoardgameUseCase {
  final TileRepository _tileRepository;
  final BoardgameRepository _boardgameRepository;

  GetTilesWithBoardgameUseCase(this._tileRepository, this._boardgameRepository);

  Future<List<TileModel>> execute({List<int>? idsList}) async {
    final tiles = idsList != null
        ? await _tileRepository.getTilesByIds(idsList)
        : await _tileRepository.getAllTiles();
    final boardgames = await _boardgameRepository.getAllBoardgames();

    return _mapTiles(tiles, boardgames);
  }

  List<TileModel> _mapTiles(
    List<TileModel> tiles,
    List<BoardgameModel> boardgames,
  ) {
    return tiles.map((tile) {
      final boardgameRow = boardgames.firstWhere(
        (b) => b.id == tile.boardgameId,
        orElse: () => BoardgameModel(
          id: 0,
          name: 'Unknown',
          description: 'Unknown',
          filenameImage: '',
        ),
      );

      final isUnknown = boardgameRow.id == 0;
      return tile.copyWith(
        boardgame: isUnknown ? null : boardgameRow,
        clearBoardgame: isUnknown,
      );
    }).toList();
  }
}
