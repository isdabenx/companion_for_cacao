import 'package:companion_for_cacao/config/providers/repository_providers.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/huts_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/new_workers_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'preparation_providers.g.dart';

/// State for the preparation screen itself — how it is being read, not what
/// the game is. The preparation content lives in `gameSetupProvider`.
///
/// `preparationProgress` and `preparationFirstRun` are `autoDispose` (plain
/// `@riverpod`): one is purely derived, the other a one-shot disk read, and
/// neither carries a decision the reader made. See
/// `config/providers/repository_providers.dart` for why everything else in
/// the app is `keepAlive`.

/// Which phases the reader has expanded or collapsed by hand. Only the
/// overrides are stored, so a phase toggled back to its default drops out
/// of the map.
///
/// `keepAlive`, unlike its neighbours here: this one IS a decision the
/// reader made. As autoDispose it did not survive stepping out to the game
/// board and back, while the steps ticked on the same screen did — two
/// things done in the same place with two different fates.
/// [PhaseExpansion.clearAll] is the explicit reset when the flow moves on.
@Riverpod(keepAlive: true)
class PhaseExpansion extends _$PhaseExpansion {
  @override
  Map<PreparationPhase, bool> build() {
    // Surviving the screen is the point; surviving the GAME is not. Without
    // this, starting a new game opened its preparation already collapsed,
    // inheriting how someone had been reading the previous one — the same
    // reasoning, and the same shape, as `ScoreNotifier`.
    ref.listen(gameSetupProvider, (previous, next) {
      final wasStarted = previous?.value?.isStarted ?? false;
      final isStarted = next.value?.isStarted ?? false;
      if (!wasStarted && isStarted) state = {};
    });
    return {};
  }

  void toggle(PreparationPhase phase, {required bool isDefaultExpanded}) {
    final currentlyExpanded = state[phase] ?? isDefaultExpanded;
    final newValue = !currentlyExpanded;
    if (newValue == isDefaultExpanded) {
      // Toggling back to default — remove override to keep map clean
      state = Map.from(state)..remove(phase);
    } else {
      state = {...state, phase: newValue};
    }
  }

  void clearAll() {
    state = {};
  }
}

/// True the first time the preparation screen is shown on this device:
/// step rows start expanded so new players read the full instructions
/// without any interaction. `DetailedPreparationWidget` marks it seen.
@riverpod
Future<bool> preparationFirstRun(Ref ref) async {
  final repository = ref.watch(settingsRepositoryProvider);
  return !(await repository.hasSeenPreparation());
}

/// Overall preparation progress as (completed, total), counting the
/// derived completion of the interactive steps (worker selection, hut
/// throw). Feeds the global progress bar and the celebration overlay.
@riverpod
(int, int) preparationProgress(Ref ref) {
  final preparation = ref.watch(
    gameSetupProvider.select((s) => s.value?.preparation ?? const []),
  );
  final workerSelectionApplied = ref.watch(
    gameSetupProvider.select((s) => s.value?.workerSelection != null),
  );
  final hutThrowRegistered = ref.watch(
    gameSetupProvider.select((s) => s.value?.hutLayout != null),
  );
  var completed = 0;
  var total = 0;
  for (final step in preparation) {
    // Informational rows (mixed-storage notes) are guidance, not tasks.
    if (step.informational) continue;
    total++;
    final isDone = switch (step.id) {
      NewWorkersModuleHandler.selectionStepId => workerSelectionApplied,
      HutsModuleHandler.marketStepId => hutThrowRegistered,
      _ => step.isCompleted,
    };
    if (isDone) completed++;
  }
  return (completed, total);
}
