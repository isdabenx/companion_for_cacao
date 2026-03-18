import 'dart:async';

import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/core/providers/repository_providers.dart';
import 'package:companion_for_cacao/shared/providers/boardgame_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tile_notifier.g.dart';

@Riverpod(keepAlive: true)
class TileNotifier extends _$TileNotifier {
  @override
  List<TileModel> build() {
    unawaited(_loadTiles());
    return [];
  }

  Future<void> _loadTiles() async {
    try {
      final repository = await ref.read(tileRepositoryProvider.future);
      final tiles = await repository.getAllTiles();
      final boardgames = ref.read(boardgameProvider);

      state = tiles.map((tile) {
        final boardgameRow = boardgames.firstWhere(
          (b) => b.id == tile.boardgameId,
          orElse: () => BoardgameModel(
            id: 0,
            name: 'Unknown',
            description: 'Unknown',
            filenameImage: '',
          ),
        );

        return tile.copyWith(
          boardgame: boardgameRow.id == 0 ? null : boardgameRow,
        );
      }).toList();
    } catch (e, stackTrace) {
      debugPrint('Error loading tiles: $e\n$stackTrace');
    }
  }

  Future<void> filterByIds(List<int> idsList) async {
    final repository = await ref.read(tileRepositoryProvider.future);
    final tiles = await repository.getTilesByIds(idsList);
    final boardgames = ref.read(boardgameProvider);

    state = tiles.map((tile) {
      final boardgameRow = boardgames.firstWhere(
        (b) => b.id == tile.boardgameId,
        orElse: () => BoardgameModel(
          id: 0,
          name: 'Unknown',
          description: 'Unknown',
          filenameImage: '',
        ),
      );

      return tile.copyWith(
        boardgame: boardgameRow.id == 0 ? null : boardgameRow,
      );
    }).toList();
  }

  List<TileModel> get tiles => state;

  void setTiles(List<TileModel> filteredTiles) => state = filteredTiles;
}
