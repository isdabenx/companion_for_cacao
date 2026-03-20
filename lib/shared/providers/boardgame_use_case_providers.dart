import 'package:companion_for_cacao/core/providers/repository_providers.dart';
import 'package:companion_for_cacao/shared/domain/use_cases/load_boardgames_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'boardgame_use_case_providers.g.dart';

@Riverpod(keepAlive: true)
Future<LoadBoardgamesUseCase> loadBoardgamesUseCase(Ref ref) async {
  final repository = await ref.watch(boardgameRepositoryProvider.future);
  return LoadBoardgamesUseCase(repository);
}
