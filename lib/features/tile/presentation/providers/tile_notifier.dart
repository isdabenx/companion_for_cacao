import 'dart:async';

import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/tile/presentation/providers/tile_use_case_providers.dart';
import 'package:companion_for_cacao/features/tile/presentation/providers/tile_filter_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tile_notifier.g.dart';

@Riverpod(keepAlive: true)
class TileNotifier extends _$TileNotifier {
  List<TileModel> _allTiles = [];

  @override
  Future<List<TileModel>> build() async {
    final useCase = await ref.watch(
      getTilesWithBoardgameUseCaseProvider.future,
    );
    _allTiles = await useCase.execute();

    ref.listen(tileFilterProvider, (previous, next) {
      _applyFilters();
    });

    return _applyFiltersTo(_allTiles);
  }

  void _applyFilters() {
    state = AsyncData(_applyFiltersTo(_allTiles));
  }

  List<TileModel> _applyFiltersTo(List<TileModel> tiles) {
    final filter = ref.read(tileFilterProvider);
    return tiles.where((tile) => filter.matches(tile)).toList();
  }

  Future<void> filterByIds(List<String> idsList) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final useCase = await ref.read(
        getTilesWithBoardgameUseCaseProvider.future,
      );
      _allTiles = await useCase.execute(idsList: idsList);
      return _applyFiltersTo(_allTiles);
    });
  }
}
