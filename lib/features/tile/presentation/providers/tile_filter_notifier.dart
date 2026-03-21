import 'package:companion_for_cacao/features/tile/domain/entities/tile_filter_state_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tile_filter_notifier.g.dart';

@riverpod
class TileFilterNotifier extends _$TileFilterNotifier {
  @override
  TileFilterStateEntity build() {
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
