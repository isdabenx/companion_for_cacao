import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/tile/presentation/providers/tile_use_case_providers.dart';
import 'package:companion_for_cacao/features/tile/presentation/providers/tile_filter_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tile_notifier.g.dart';

/// Provider that fetches all tiles from the database.
/// This is the source of truth for tile data.
@Riverpod(keepAlive: true)
class AllTiles extends _$AllTiles {
  @override
  Future<List<TileModel>> build() async {
    final useCase = await ref.watch(
      getTilesWithBoardgameUseCaseProvider.future,
    );
    return useCase.execute();
  }

  /// Refetch tiles filtered by specific IDs.
  Future<void> filterByIds(List<String> idsList) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final useCase = await ref.read(
        getTilesWithBoardgameUseCaseProvider.future,
      );
      return useCase.execute(idsList: idsList);
    });
  }
}

/// Derived provider that applies the current filter to all tiles.
/// This is the provider that UI should watch for filtered results.
/// It automatically updates when either tiles or filter changes.
@Riverpod(keepAlive: true)
Future<List<TileModel>> filteredTiles(Ref ref) async {
  // Watch both dependencies - rebuilds when either changes
  final tiles = await ref.watch(allTilesProvider.future);
  final filter = ref.watch(tileFilterProvider);

  // Return filtered list
  return tiles.where((tile) => filter.matches(tile)).toList();
}
