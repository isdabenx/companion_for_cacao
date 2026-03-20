import 'package:companion_for_cacao/features/game_setup/domain/use_cases/prepare_game_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_setup_use_case_providers.g.dart';

@riverpod
PrepareGameUseCase prepareGameUseCase(Ref ref) {
  return PrepareGameUseCase();
}
