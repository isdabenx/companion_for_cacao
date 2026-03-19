import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/providers/repository_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'boardgame_notifier.g.dart';

@Riverpod(keepAlive: true)
class BoardgameNotifier extends _$BoardgameNotifier {
  @override
  Future<List<BoardgameModel>> build() async {
    final repository = await ref.read(boardgameRepositoryProvider.future);
    final boardgames = await repository.getAllBoardgames();
    final modules = await repository.getAllModules();
    final tiles = await repository.getAllTiles();

    return boardgames
        .map(
          (boardgame) => boardgame.copyWith(
            modules: modules
                .where((module) => module.boardgameId == boardgame.id)
                .toList(),
            tiles: tiles
                .where((tile) => tile.boardgameId == boardgame.id)
                .map((tile) => tile.copyWith(boardgame: boardgame))
                .toList(),
          ),
        )
        .toList();
  }

  BoardgameModel boardgameById(int id) {
    final boardgames = state.value ?? [];
    return boardgames.firstWhere(
      (b) => b.id == id,
      orElse: () => BoardgameModel(
        description: 'Unknown',
        filenameImage: '',
        id: 0,
        name: 'Unknown',
      ),
    );
  }
}
