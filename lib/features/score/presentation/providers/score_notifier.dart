import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/gem_mines_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/huts_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/score/domain/entities/hut_type.dart';
import 'package:companion_for_cacao/features/score/domain/entities/player_score_input_entity.dart';
import 'package:companion_for_cacao/features/score/domain/entities/score_result_entity.dart';
import 'package:companion_for_cacao/features/score/domain/entities/score_state_entity.dart';
import 'package:companion_for_cacao/features/score/domain/entities/temple_entry_entity.dart';
import 'package:companion_for_cacao/features/score/domain/services/hut_tile_supply.dart';
import 'package:companion_for_cacao/features/score/domain/services/score_calculator_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'score_notifier.g.dart';

/// Maximum sun tokens a player can hold (3 sun-worshiping places).
const int _maxSunTokens = 3;

/// Maximum cacao fruits a player can store (5 storage spaces).
const int _maxCacaoFruits = 5;

/// Sanity cap for free-count inputs (gold, workers, gems...).
const int _maxCount = 999;

@Riverpod(keepAlive: true)
class ScoreNotifier extends _$ScoreNotifier {
  @override
  ScoreStateEntity build() {
    // Starting a NEW game discards the previous scoring session — those
    // scores belonged to the game they were entered for.
    ref.listen(gameSetupProvider, (previous, next) {
      final wasStarted = previous?.value?.isStarted ?? false;
      final isStarted = next.value?.isStarted ?? false;
      if (!wasStarted && isStarted) ref.invalidateSelf();
    });
    // Snapshot, not watch: other setup changes (players, modules) must not
    // wipe a scoring session in progress. Use reset() to start over.
    final setup = ref.read(gameSetupProvider).value;
    if (setup == null || !setup.isStarted) return ScoreStateEntity();
    return ScoreStateEntity(
      players: setup.players,
      hutModuleActive: setup.modules.any(
        (m) => m.id == HutsModuleHandler.moduleId,
      ),
      gemMinesActive: setup.modules.any(
        (m) => m.id == GemMinesModuleHandler.moduleId,
      ),
    );
  }

  /// Discards the session and prefills again from the current game setup.
  void reset() => ref.invalidateSelf();

  // -------------------- Setup step --------------------

  void addPlayer(String name, String color) {
    if (state.players.any((p) => p.color == color)) return;
    state = state.copyWith(
      players: [
        ...state.players,
        PlayerEntity(name: name, color: color, isSelected: true),
      ],
    );
  }

  void removePlayer(String color) {
    state = state.copyWith(
      players: state.players.where((p) => p.color != color).toList(),
      // Drop data tied to the removed player.
      inputsByColor: Map.of(state.inputsByColor)..remove(color),
      maskOwners: [
        for (final owner in state.maskOwners) owner == color ? null : owner,
      ],
      temples: [
        for (final temple in state.temples)
          temple.copyWith(
            workersByColor: Map.of(temple.workersByColor)..remove(color),
          ),
      ],
    );
  }

  void updatePlayerName(String color, String name) {
    state = state.copyWith(
      players: [
        for (final p in state.players)
          if (p.color == color) p.copyWith(name: name) else p,
      ],
    );
  }

  void setHutModuleActive(bool value) {
    state = _clampStep(state.copyWith(hutModuleActive: value));
  }

  void setGemMinesActive(bool value) {
    state = _clampStep(state.copyWith(gemMinesActive: value));
  }

  /// Steps change when modules are toggled; keep the index in range of the
  /// updated step list.
  ScoreStateEntity _clampStep(ScoreStateEntity updated) {
    final maxIndex = updated.steps.length - 1;
    return updated.currentStepIndex > maxIndex
        ? updated.copyWith(currentStepIndex: maxIndex)
        : updated;
  }

  // -------------------- Navigation --------------------

  void setStep(int index) {
    if (index < 0 || index >= state.steps.length) return;
    state = state.copyWith(currentStepIndex: index);
  }

  void nextStep() => setStep(state.currentStepIndex + 1);

  void previousStep() => setStep(state.currentStepIndex - 1);

  // -------------------- Per-player inputs --------------------

  void setAccumulatedGold(String color, int value) {
    _updateInput(
      color,
      (input) => input.copyWith(accumulatedGold: value.clamp(0, _maxCount)),
    );
  }

  void setWaterFieldIndex(String color, int index) {
    final maxIndex = ScoreCalculatorService.waterTrackValues.length - 1;
    _updateInput(
      color,
      (input) => input.copyWith(waterFieldIndex: index.clamp(0, maxIndex)),
    );
  }

  void setSunTokens(String color, int value) {
    _updateInput(
      color,
      (input) => input.copyWith(sunTokens: value.clamp(0, _maxSunTokens)),
    );
  }

  void setCacaoFruits(String color, int value) {
    _updateInput(
      color,
      (input) => input.copyWith(cacaoFruits: value.clamp(0, _maxCacaoFruits)),
    );
  }

  /// Adds [hut] to [color], or removes it when tapped by its current owner.
  ///
  /// Huts are physical double-sided tiles ([HutTileSupply]): some functions
  /// exist twice, the Chief family only once, and the two sides of a tile
  /// exclude each other. Adding is refused (no-op) when the resulting
  /// layout could not be built with real tiles — to reassign a hut, remove
  /// it from its current owner first.
  void toggleHut(String color, HutType hut) {
    if (state.inputOf(color).huts.contains(hut)) {
      _updateInput(
        color,
        (input) => input.copyWith(huts: Set.of(input.huts)..remove(hut)),
      );
      return;
    }
    if (!state.canBuildHut(color, hut)) return;
    _updateInput(color, (input) => input.copyWith(huts: {...input.huts, hut}));
  }

  void setHermitWorkers(String color, int value) {
    _updateInput(
      color,
      (input) => input.copyWith(hermitWorkers: value.clamp(0, _maxCount)),
    );
  }

  void setRoadWorkerTiles(String color, int value) {
    _updateInput(
      color,
      (input) => input.copyWith(roadWorkerTiles: value.clamp(0, _maxCount)),
    );
  }

  void setLeftoverGems(String color, int value) {
    _updateInput(
      color,
      (input) => input.copyWith(leftoverGems: value.clamp(0, _maxCount)),
    );
  }

  void _updateInput(
    String color,
    PlayerScoreInputEntity Function(PlayerScoreInputEntity) update,
  ) {
    state = state.copyWith(
      inputsByColor: {
        ...state.inputsByColor,
        color: update(state.inputOf(color)),
      },
    );
  }

  // -------------------- Temples --------------------

  void addTemple() {
    final nextId = state.temples.isEmpty
        ? 1
        : state.temples.map((t) => t.id).reduce((a, b) => a > b ? a : b) + 1;
    state = state.copyWith(
      temples: [
        ...state.temples,
        TempleEntryEntity(id: nextId),
      ],
    );
  }

  void removeTemple(int id) {
    state = state.copyWith(
      temples: state.temples.where((t) => t.id != id).toList(),
    );
  }

  void setTempleWorkers(int templeId, String color, int workers) {
    state = state.copyWith(
      temples: [
        for (final temple in state.temples)
          if (temple.id == templeId)
            temple.copyWith(
              workersByColor: {
                ...temple.workersByColor,
                color: workers.clamp(0, _maxCount),
              },
            )
          else
            temple,
      ],
    );
  }

  // -------------------- Gem masks --------------------

  /// Assigns mask [maskIndex] to [color], or clears it when [color] is
  /// null. A mask is a single physical tile, so it has at most one owner.
  void setMaskOwner(int maskIndex, String? color) {
    if (maskIndex < 0 || maskIndex >= state.maskOwners.length) return;
    final owners = List<String?>.from(state.maskOwners);
    owners[maskIndex] = color;
    state = state.copyWith(maskOwners: owners);
  }
}

/// Live final-scoring result derived from the calculator inputs.
@riverpod
ScoreResultEntity scoreResult(Ref ref) {
  final state = ref.watch(scoreProvider);
  return const ScoreCalculatorService().calculate(state.toServiceInput());
}
