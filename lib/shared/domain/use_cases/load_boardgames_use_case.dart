import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/domain/repositories/boardgame_repository.dart';

class LoadBoardgamesUseCase {
  final BoardgameRepository _repository;

  LoadBoardgamesUseCase(this._repository);

  Future<List<BoardgameModel>> execute() async {
    final boardgames = await _repository.getAllBoardgames();
    final modules = await _repository.getAllModules();
    final tiles = await _repository.getAllTiles();

    return boardgames
        .map(
          (boardgame) => boardgame.copyWith(
            modules: modules
                .where((module) => module.boardgameId == boardgame.id)
                .toList(),
            tiles: tiles.where((tile) => tile.boardgameId == boardgame.id).map((
              tile,
            ) {
              final matchedModule = modules.firstWhere(
                (m) => m.id == tile.moduleId,
                orElse: () => modules
                    .first, // Dummy value, but ignored due to the check below
              );
              return tile.copyWith(
                boardgame: boardgame,
                module: tile.moduleId != null ? matchedModule : null,
                clearModule: tile.moduleId == null,
              );
            }).toList(),
          ),
        )
        .toList();
  }
}
