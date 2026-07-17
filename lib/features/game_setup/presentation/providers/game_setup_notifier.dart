import 'package:companion_for_cacao/config/constants/game_constants.dart';
import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/module_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/worker_selection_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/new_workers_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_use_case_providers.dart';
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
      orElse: () => BoardgameModel(
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

  void addExpansion(BoardgameModel expansion) {
    if (state.value == null) return;
    state = AsyncData(
      state.value!.copyWith(
        expansions: [...state.value!.expansions, expansion],
      ),
    );
  }

  void removeExpansion(BoardgameModel expansion) {
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

  void toggleExpansion(BoardgameModel expansion) {
    if (state.value == null) return;
    if (state.value!.expansions.any((e) => e.id == expansion.id)) {
      removeExpansion(expansion);
    } else {
      addExpansion(expansion);
    }
  }

  void addModule(ModuleModel module) {
    if (state.value == null) return;
    state = AsyncData(
      state.value!.copyWith(modules: [...state.value!.modules, module]),
    );
  }

  void removeModule(ModuleModel module) {
    if (state.value == null) return;
    state = AsyncData(
      state.value!.copyWith(
        modules: state.value!.modules.where((m) => m.id != module.id).toList(),
      ),
    );
  }

  void toggleModule(ModuleModel module) {
    if (state.value == null) return;
    if (state.value!.modules.any((m) => m.id == module.id)) {
      removeModule(module);
      // Clear worker selection when Module D is removed
      if (module.id == NewWorkersModuleHandler.moduleId) {
        state = AsyncData(state.value!.copyWith(clearWorkerSelection: true));
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

  /// Total number of modules available across all selected expansions.
  static const int _totalModuleCount = 8;

  /// Resets isBigGame to false if conditions are no longer met
  /// (requires all 8 modules + 3-4 players).
  void _resetBigGameIfInvalid() {
    if (state.value == null || !state.value!.isBigGame) return;
    final playerCount = state.value!.players.length;
    final moduleCount = state.value!.modules.length;
    if (moduleCount < _totalModuleCount || playerCount < 3 || playerCount > 4) {
      state = AsyncData(state.value!.copyWith(isBigGame: false));
    }
  }

  void startGame() {
    if (state.value == null) return;
    // Worker selection is a per-game choice made during preparation: every
    // new game starts from the default (add all), never from a selection
    // applied in a previous game.
    final setup = state.value!.copyWith(clearWorkerSelection: true);
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
      ),
    );
  }

  Future<void> clearAll() async {
    final boardgames = await ref.read(boardgameProvider.future);
    final baseGame = boardgames.firstWhere(
      (b) => b.id == GameConstants.baseGameId,
      orElse: () => BoardgameModel(
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
    final updated = state.value!.copyWith(workerSelection: selection);
    final useCase = ref.read(prepareGameUseCaseProvider);
    state = AsyncData(
      useCase
          .execute(updated)
          .copyWith(isStarted: true, workerSelection: selection),
    );
  }

  /// Clears the worker tile selection (reverts to default addAll behavior).
  void clearWorkerSelection() {
    if (state.value == null) return;
    state = AsyncData(state.value!.copyWith(clearWorkerSelection: true));
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
