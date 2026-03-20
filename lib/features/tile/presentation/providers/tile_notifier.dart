import 'dart:async';

import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/tile/presentation/providers/tile_use_case_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tile_notifier.g.dart';

@Riverpod(keepAlive: true)
class TileNotifier extends _$TileNotifier {
  @override
  Future<List<TileModel>> build() async {
    final useCase = await ref.watch(
      getTilesWithBoardgameUseCaseProvider.future,
    );
    return useCase.execute();
  }

  Future<void> filterByIds(List<int> idsList) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final useCase = await ref.read(
        getTilesWithBoardgameUseCaseProvider.future,
      );
      return useCase.execute(idsList: idsList);
    });
  }

  void setTiles(List<TileModel> filteredTiles) {
    state = AsyncData(filteredTiles);
  }
}
