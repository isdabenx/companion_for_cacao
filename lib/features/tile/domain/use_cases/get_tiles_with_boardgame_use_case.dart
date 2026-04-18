import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/module_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/core/data/repositories/boardgame_repository.dart';
import 'package:companion_for_cacao/features/tile/data/repositories/tile_repository.dart';

class GetTilesWithBoardgameUseCase {
  final TileRepository _tileRepository;
  final BoardgameRepository _boardgameRepository;

  GetTilesWithBoardgameUseCase(this._tileRepository, this._boardgameRepository);

  Future<List<TileModel>> execute({List<String>? idsList}) async {
    final tiles = idsList != null
        ? await _tileRepository.getTilesByIds(idsList)
        : await _tileRepository.getAllTiles();
    final boardgames = await _boardgameRepository.getAllBoardgames();
    final modules = await _boardgameRepository.getAllModules();

    return _mapTiles(tiles, boardgames, modules);
  }

  List<TileModel> _mapTiles(
    List<TileModel> tiles,
    List<BoardgameModel> boardgames,
    List<ModuleModel> modules,
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

      final isUnknownBoardgame = boardgameRow.id == 0;

      final moduleRow = tile.moduleId != null
          ? modules.firstWhere(
              (m) => m.id == tile.moduleId,
              orElse: () => ModuleModel(
                id: 0,
                name: 'Unknown',
                description: 'Unknown',
                boardgameId: 0,
              ),
            )
          : null;

      final isUnknownModule = moduleRow?.id == 0;

      return tile.copyWith(
        boardgame: isUnknownBoardgame ? null : boardgameRow,
        clearBoardgame: isUnknownBoardgame,
        module: isUnknownModule ? null : moduleRow,
        clearModule: isUnknownModule,
      );
    }).toList();
  }
}
