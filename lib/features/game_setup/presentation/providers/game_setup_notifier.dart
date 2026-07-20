import 'package:collection/collection.dart';
import 'package:companion_for_cacao/config/constants/game_constants.dart';
import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/module_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/hut_layout_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/worker_selection_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/huts_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/new_workers_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_use_case_providers.dart';
import 'package:companion_for_cacao/features/tile/tile_public_api.dart';
import 'package:companion_for_cacao/shared/providers/boardgame_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_setup_notifier.g.dart';

@Riverpod(keepAlive: true)
class GameSetupNotifier extends _$GameSetupNotifier {
  @override
  FutureOr<GameSetupStateEntity> build() async {
    final boardgames = await ref.watch(boardgameProvider.future);
    final baseGame = boardgames.firstWhere(
      (b) => b.id == GameConstants.baseGameId,
      orElse: () => BoardgameEntity(
        id: GameConstants.baseGameId,
        name: 'Cacao',
        description: '',
        filenameImage: '',
      ),
    );
    return GameSetupStateEntity(expansions: [baseGame]);
  }

  void reorderColorOrder(int oldIndex, int newIndex) {
    if (state.value == null) return;
    final order = List<String>.from(state.value!.colorOrder);
    final item = order.removeAt(oldIndex);
    order.insert(newIndex, item);
    state = AsyncData(state.value!.copyWith(colorOrder: order));
  }

  void addPlayer(String name, String color) {
    if (state.value == null) return;
    // Add player to the end of the list
    state = AsyncData(
      state.value!.copyWith(
        players: [
          ...state.value!.players,
          PlayerEntity(name: name, color: color, isSelected: true),
        ],
      ),
    );
    _resetBigGameIfInvalid();
  }

  void removePlayer(String color) {
    if (state.value == null) return;
    state = AsyncData(
      state.value!.copyWith(
        players: state.value!.players.where((p) => p.color != color).toList(),
      ),
    );
    _resetBigGameIfInvalid();
  }

  void reorderPlayers(int oldIndex, int newIndex) {
    if (state.value == null) return;
    final players = List<PlayerEntity>.from(state.value!.players);
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = players.removeAt(oldIndex);
    players.insert(newIndex, item);
    state = AsyncData(state.value!.copyWith(players: players));
  }

  void updatePlayerSelection(String color, {required bool isSelected}) {
    if (state.value == null) return;
    state = AsyncData(
      state.value!.copyWith(
        players: state.value!.players.map((p) {
          if (p.color == color) {
            return p.copyWith(isSelected: isSelected);
          }
          return p;
        }).toList(),
      ),
    );
  }

  void addExpansion(BoardgameEntity expansion) {
    if (state.value == null) return;
    state = AsyncData(
      state.value!.copyWith(
        expansions: [...state.value!.expansions, expansion],
      ),
    );
  }

  void removeExpansion(BoardgameEntity expansion) {
    if (state.value == null) return;
    state = AsyncData(
      state.value!.copyWith(
        expansions: state.value!.expansions
            .where((e) => e.id != expansion.id)
            .toList(),
      ),
    );
    _resetBigGameIfInvalid();
  }

  void toggleExpansion(BoardgameEntity expansion) {
    if (state.value == null) return;
    if (state.value!.expansions.any((e) => e.id == expansion.id)) {
      removeExpansion(expansion);
    } else {
      addExpansion(expansion);
    }
  }

  void addModule(ModuleEntity module) {
    if (state.value == null) return;
    state = AsyncData(
      state.value!.copyWith(modules: [...state.value!.modules, module]),
    );
  }

  void removeModule(ModuleEntity module) {
    if (state.value == null) return;
    state = AsyncData(
      state.value!.copyWith(
        modules: state.value!.modules.where((m) => m.id != module.id).toList(),
      ),
    );
  }

  void toggleModule(ModuleEntity module) {
    if (state.value == null) return;
    if (state.value!.modules.any((m) => m.id == module.id)) {
      removeModule(module);
      // Clear worker selection when Module D is removed
      if (module.id == NewWorkersModuleHandler.moduleId) {
        state = AsyncData(state.value!.copyWith(clearWorkerSelection: true));
      }
      // Clear the registered hut throw when the Hut Module is removed
      if (module.id == HutsModuleHandler.moduleId) {
        state = AsyncData(state.value!.copyWith(clearHutLayout: true));
      }
    } else {
      addModule(module);
    }
    _resetBigGameIfInvalid();
  }

  void setBigGame(bool value) {
    if (state.value == null) return;
    state = AsyncData(state.value!.copyWith(isBigGame: value));
  }

  /// Resets isBigGame to false if the Big Game rule
  /// ([GameSetupStateEntity.canEnableBigGame]) is no longer met.
  void _resetBigGameIfInvalid() {
    if (state.value == null || !state.value!.isBigGame) return;
    if (!state.value!.canEnableBigGame) {
      state = AsyncData(state.value!.copyWith(isBigGame: false));
    }
  }

  void startGame() {
    if (state.value == null) return;
    // Worker selection and the hut throw are per-game choices made during
    // preparation: every new game starts from scratch, never from choices
    // applied in a previous game.
    final setup = state.value!.copyWith(
      clearWorkerSelection: true,
      clearHutLayout: true,
    );
    // A new game also starts without leftover in-play tile filters
    ref.invalidate(tileFilterProvider(TileFilterScope.inPlay));
    final useCase = ref.read(prepareGameUseCaseProvider);
    state = AsyncData(useCase.execute(setup).copyWith(isStarted: true));
  }

  void resetGame() {
    if (state.value == null) return;
    state = AsyncData(
      state.value!.copyWith(
        preparation: [],
        tiles: [],
        isStarted: false,
        clearWorkerSelection: true,
        clearHutLayout: true,
      ),
    );
  }

  Future<void> clearAll() async {
    final boardgames = await ref.read(boardgameProvider.future);
    final baseGame = boardgames.firstWhere(
      (b) => b.id == GameConstants.baseGameId,
      orElse: () => BoardgameEntity(
        id: GameConstants.baseGameId,
        name: 'Cacao',
        description: '',
        filenameImage: '',
      ),
    );
    state = AsyncData(GameSetupStateEntity(expansions: [baseGame]));
  }

  /// Applies a worker tile selection and re-runs the pipeline to update
  /// tiles and preparation steps accordingly.
  void applyWorkerSelection(WorkerSelectionEntity selection) {
    if (state.value == null) return;
    final previous = state.value!;
    final updated = previous.copyWith(workerSelection: selection);
    final useCase = ref.read(prepareGameUseCaseProvider);
    final result = useCase.execute(updated);
    // The pipeline regenerates the preparation list from scratch: carry
    // over the completion of steps the user had already checked (matched
    // by id), so re-applying a selection doesn't wipe their progress.
    final preparation = [
      for (final step in result.preparation)
        step.copyWith(
          isCompleted:
              previous.preparation
                  .firstWhereOrNull((p) => p.id == step.id)
                  ?.isCompleted ??
              step.isCompleted,
        ),
    ];
    state = AsyncData(
      result.copyWith(
        preparation: preparation,
        isStarted: true,
        workerSelection: selection,
      ),
    );
  }

  /// Clears the worker tile selection (reverts to default addAll behavior).
  void clearWorkerSelection() {
    if (state.value == null) return;
    state = AsyncData(state.value!.copyWith(clearWorkerSelection: true));
  }

  /// Registers which side of each hut tile landed face up in the throw.
  /// The hut-throw preparation step derives its completion from this (see
  /// DetailedPreparationWidget), so registering IS completing the step.
  void applyHutLayout(HutLayoutEntity layout) {
    if (state.value == null) return;
    state = AsyncData(state.value!.copyWith(hutLayout: layout));
  }

  /// Forgets the registered hut throw (supply becomes unknown again),
  /// which also reopens its preparation step.
  void clearHutLayout() {
    if (state.value == null) return;
    state = AsyncData(state.value!.copyWith(clearHutLayout: true));
  }

  void togglePreparationCompletion(String id) {
    if (state.value == null) return;
    state = AsyncData(
      state.value!.copyWith(
        preparation: state.value!.preparation.map((prep) {
          if (prep.id == id) {
            return prep.copyWith(isCompleted: !prep.isCompleted);
          }
          return prep;
        }).toList(),
      ),
    );
  }

  void updatePlayerName(String color, String newName) {
    if (state.value == null) return;
    state = AsyncData(
      state.value!.copyWith(
        players: state.value!.players.map((p) {
          if (p.color == color) {
            return p.copyWith(name: newName);
          }
          return p;
        }).toList(),
      ),
    );
  }
}
