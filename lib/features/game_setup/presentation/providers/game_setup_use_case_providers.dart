import 'package:companion_for_cacao/features/game_setup/domain/use_cases/prepare_game_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_setup_use_case_providers.g.dart';

// keepAlive: read from the keepAlive gameSetupProvider — a keepAlive
// provider must not depend on an autoDispose one (riverpod_lint:
// only_use_keep_alive_inside_keep_alive).
@Riverpod(keepAlive: true)
PrepareGameUseCase prepareGameUseCase(Ref ref) {
  return PrepareGameUseCase();
}
