import 'dart:async';

import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/core/providers/repository_providers.dart';
import 'package:companion_for_cacao/shared/providers/boardgame_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tile_notifier.g.dart';

@Riverpod(keepAlive: true)
class TileNotifier extends _$TileNotifier {
  @override
  Future<List<TileModel>> build() async {
    final repository = await ref.watch(tileRepositoryProvider.future);
    final tiles = await repository.getAllTiles();
    final boardgames = await ref.watch(boardgameProvider.future);

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

  Future<void> filterByIds(List<int> idsList) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = await ref.read(tileRepositoryProvider.future);
      final tiles = await repository.getTilesByIds(idsList);
      final boardgames = ref.read(boardgameProvider).value ?? [];
      return _mapTiles(tiles, boardgames);
    });
  }

  void setTiles(List<TileModel> filteredTiles) {
    state = AsyncData(filteredTiles);
  }
}
