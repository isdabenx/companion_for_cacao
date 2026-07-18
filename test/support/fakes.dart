import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/shared/providers/boardgame_notifier.dart';

/// Fake [BoardgameNotifier] that returns the given [boardgames] from build().
///
/// Shared by provider/screen/widget tests that override [boardgameProvider]
/// with a fixed list of boardgames.
class FakeBoardgameNotifier extends BoardgameNotifier {
  FakeBoardgameNotifier(this.boardgames);

  final List<BoardgameEntity> boardgames;

  @override
  Future<List<BoardgameEntity>> build() async {
    return boardgames;
  }
}
