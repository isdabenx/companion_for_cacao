import 'package:companion_for_cacao/features/tile/domain/entities/tile_filter_scope.dart';
import 'package:companion_for_cacao/features/tile/domain/entities/tile_filter_state_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tile_filter_notifier.g.dart';

// Family keyed by [TileFilterScope]: the catalog and the in-game
// "Tiles in Play" screen each have independent filter state.
//
// keepAlive: watched by the keepAlive filteredTilesProvider — a keepAlive
// provider must not depend on an autoDispose one (riverpod_lint:
// only_use_keep_alive_inside_keep_alive). Being permanently watched, it
// effectively never disposed anyway; this makes that explicit.
@Riverpod(keepAlive: true)
class TileFilterNotifier extends _$TileFilterNotifier {
  @override
  TileFilterStateEntity build(TileFilterScope scope) {
    return const TileFilterStateEntity();
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void toggleBoardgame(int boardgameId) {
    final currentSet = Set<int>.from(state.selectedBoardgameIds);
    if (currentSet.contains(boardgameId)) {
      currentSet.remove(boardgameId);
    } else {
      currentSet.add(boardgameId);
    }
    state = state.copyWith(selectedBoardgameIds: currentSet);
  }

  void toggleTileType(String type) {
    final currentSet = Set<String>.from(state.selectedTileTypes);
    if (currentSet.contains(type)) {
      currentSet.remove(type);
    } else {
      currentSet.add(type);
    }
    state = state.copyWith(selectedTileTypes: currentSet);
  }

  void clearFilters() {
    state = const TileFilterStateEntity();
  }
}
