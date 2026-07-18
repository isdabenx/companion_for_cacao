import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/shared/providers/boardgame_use_case_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'boardgame_notifier.g.dart';

@Riverpod(keepAlive: true)
class BoardgameNotifier extends _$BoardgameNotifier {
  @override
  Future<List<BoardgameEntity>> build() async {
    final useCase = await ref.watch(loadBoardgamesUseCaseProvider.future);
    return useCase.execute();
  }

  BoardgameEntity boardgameById(int id) {
    final boardgames = state.value ?? [];
    return boardgames.firstWhere(
      (b) => b.id == id,
      orElse: () => BoardgameEntity(
        description: 'Unknown',
        filenameImage: '',
        id: 0,
        name: 'Unknown',
      ),
    );
  }
}
