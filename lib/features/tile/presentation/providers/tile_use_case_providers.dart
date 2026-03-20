import 'package:companion_for_cacao/core/providers/repository_providers.dart';
import 'package:companion_for_cacao/features/tile/domain/use_cases/get_tiles_with_boardgame_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tile_use_case_providers.g.dart';

@Riverpod(keepAlive: true)
Future<GetTilesWithBoardgameUseCase> getTilesWithBoardgameUseCase(
  Ref ref,
) async {
  final tileRepository = await ref.watch(tileRepositoryProvider.future);
  final boardgameRepository = await ref.watch(
    boardgameRepositoryProvider.future,
  );
  return GetTilesWithBoardgameUseCase(tileRepository, boardgameRepository);
}
