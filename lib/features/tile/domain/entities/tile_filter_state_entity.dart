import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:flutter/foundation.dart';

@immutable
class TileFilterStateEntity {
  const TileFilterStateEntity({
    this.searchQuery = '',
    this.selectedBoardgameIds = const {},
    this.selectedTileTypes = const {},
  });

  final String searchQuery;
  final Set<int> selectedBoardgameIds;
  final Set<String> selectedTileTypes;

  /// Returns true if any filter is currently active
  bool get hasActiveFilters =>
      searchQuery.isNotEmpty ||
      selectedBoardgameIds.isNotEmpty ||
      selectedTileTypes.isNotEmpty;

  /// Returns the count of active filters
  int get activeFilterCount {
    int count = 0;
    if (searchQuery.isNotEmpty) count++;
    count += selectedBoardgameIds.length;
    count += selectedTileTypes.length;
    return count;
  }

  bool matches(TileModel tile) {
    if (searchQuery.isNotEmpty) {
      if (!tile.name.toLowerCase().contains(searchQuery.toLowerCase())) {
        return false;
      }
    }

    if (selectedBoardgameIds.isNotEmpty) {
      if (!selectedBoardgameIds.contains(tile.boardgameId)) {
        return false;
      }
    }

    if (selectedTileTypes.isNotEmpty) {
      if (!selectedTileTypes.contains(tile.typeAsString)) {
        return false;
      }
    }

    return true;
  }

  TileFilterStateEntity copyWith({
    String? searchQuery,
    Set<int>? selectedBoardgameIds,
    Set<String>? selectedTileTypes,
  }) {
    return TileFilterStateEntity(
      searchQuery: searchQuery ?? this.searchQuery,
      selectedBoardgameIds: selectedBoardgameIds ?? this.selectedBoardgameIds,
      selectedTileTypes: selectedTileTypes ?? this.selectedTileTypes,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TileFilterStateEntity &&
        other.searchQuery == searchQuery &&
        setEquals(other.selectedBoardgameIds, selectedBoardgameIds) &&
        setEquals(other.selectedTileTypes, selectedTileTypes);
  }

  @override
  int get hashCode =>
      searchQuery.hashCode ^
      selectedBoardgameIds.hashCode ^
      selectedTileTypes.hashCode;
}
