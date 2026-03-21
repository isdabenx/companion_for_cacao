import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'preparation_provider.g.dart';

@riverpod
class PreparationCompletion extends _$PreparationCompletion {
  @override
  Map<String, bool> build() {
    return {};
  }

  void toggleCompletion(String id) {
    state = {...state, id: !(state[id] ?? false)};
  }

  void setCompletion(String id, bool value) {
    state = {...state, id: value};
  }
}

@riverpod
class PhaseExpansion extends _$PhaseExpansion {
  @override
  Map<PreparationPhase, bool> build() {
    return {};
  }

  void toggle(PreparationPhase phase) {
    state = {...state, phase: !(state[phase] ?? false)};
  }

  void setExpanded(PreparationPhase phase, bool isExpanded) {
    state = {...state, phase: isExpanded};
  }

  void clear(PreparationPhase phase) {
    final newState = {...state};
    newState.remove(phase);
    state = newState;
  }

  void clearAll() {
    state = {};
  }
}
