import 'dart:math';

import 'package:collection/collection.dart';
import 'package:companion_for_cacao/config/constants/game_constants.dart';
import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/hut_type.dart';
import 'package:companion_for_cacao/core/domain/entities/module_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/hut_layout_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/worker_selection_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/huts_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/handlers/new_workers_module_handler.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_use_case_providers.dart';
import 'package:companion_for_cacao/features/tile/tile_public_api.dart';
import 'package:companion_for_cacao/shared/providers/boardgame_notifier.dart';
import 'package:companion_for_cacao/shared/utils/hut_type_assets.dart';
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

  /// Preparation steps whose physical action depends on the worker
  /// composition. When the selection changes they become stale, so any that
  /// were already ticked must be re-opened (ids mirror BaseGameHandler and
  /// [NewWorkersModuleHandler.buildStepId]).
  static const _workerDependentStepIds = {
    'setup_new_workers_build',
    'setup_shuffle_workers',
  };

  /// Applies a worker tile selection and re-runs the pipeline to update
  /// tiles and preparation steps accordingly.
  ///
  /// Returns true when the change re-opened a dependent step the user had
  /// already completed (so the UI can warn them to redo it).
  bool applyWorkerSelection(WorkerSelectionEntity selection) {
    final previous = state.value;
    if (previous == null) return false;
    final selectionChanged = previous.workerSelection != selection;
    var next = _rerunPipeline(
      previous,
      previous.copyWith(workerSelection: selection),
    );

    var reopenedCompleted = false;
    if (selectionChanged) {
      // Only re-open (and later warn) if a dependent step was actually ticked.
      reopenedCompleted = next.preparation.any(
        (s) => s.isCompleted && _workerDependentStepIds.contains(s.id),
      );
      if (reopenedCompleted) {
        next = next.copyWith(
          preparation: [
            for (final step in next.preparation)
              if (step.isCompleted && _workerDependentStepIds.contains(step.id))
                step.copyWith(isCompleted: false)
              else
                step,
          ],
        );
      }
    }
    state = AsyncData(next);
    return reopenedCompleted;
  }

  /// Re-runs the preparation pipeline for [updated] mid-game, carrying over
  /// the completion of steps the user had already checked (matched by id)
  /// and re-applying the registered hut throw to the tiles in play.
  GameSetupStateEntity _rerunPipeline(
    GameSetupStateEntity previous,
    GameSetupStateEntity updated,
  ) {
    final useCase = ref.read(prepareGameUseCaseProvider);
    final result = useCase.execute(updated);
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
    return _applyHutLayoutToTiles(
      result.copyWith(
        preparation: preparation,
        isStarted: true,
        workerSelection: updated.workerSelection,
        hutLayout: updated.hutLayout,
        clearWorkerSelection: updated.workerSelection == null,
        clearHutLayout: updated.hutLayout == null,
      ),
    );
  }

  /// With a hut throw registered, the tiles in play show exactly the huts
  /// on the table: face-down functions are dropped and face-up ones carry
  /// their real count (e.g. Market Crier x2 when both copies landed up).
  GameSetupStateEntity _applyHutLayoutToTiles(GameSetupStateEntity setup) {
    final layout = setup.hutLayout;
    if (layout == null) return setup;
    final counts = layout.availableCounts;
    final hutByTileId = {for (final hut in HutType.values) hut.tileId: hut};
    final tiles = <TileEntity>[
      for (final tile in setup.tiles)
        if (!hutByTileId.containsKey(tile.id))
          tile
        else if ((counts[hutByTileId[tile.id]] ?? 0) > 0)
          tile.copyWith(quantity: counts[hutByTileId[tile.id]]),
    ];
    return setup.copyWith(tiles: tiles);
  }

  /// Clears the worker tile selection (reverts to default addAll behavior).
  void clearWorkerSelection() {
    if (state.value == null) return;
    state = AsyncData(state.value!.copyWith(clearWorkerSelection: true));
  }

  /// Registers which side of each hut tile landed face up in the throw.
  /// The hut-throw preparation step derives its completion from this (see
  /// DetailedPreparationWidget), so registering IS completing the step.
  /// The tiles in play are refreshed to show exactly the face-up huts.
  void applyHutLayout(HutLayoutEntity layout) {
    if (state.value == null) return;
    final previous = state.value!;
    state = AsyncData(
      _rerunPipeline(previous, previous.copyWith(hutLayout: layout)),
    );
  }

  /// Forgets the registered hut throw (supply becomes unknown again),
  /// which also reopens its preparation step and restores the full hut
  /// list in the tiles in play.
  void clearHutLayout() {
    if (state.value == null) return;
    final previous = state.value!;
    state = AsyncData(
      _rerunPipeline(previous, previous.copyWith(clearHutLayout: true)),
    );
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

  /// Toggles a whole preparation group (e.g. a player's corner card):
  /// if every member is completed, unchecks them all; otherwise checks
  /// them all. Group completion itself stays derived from the members.
  void toggleGroupCompletion(String groupId) {
    if (state.value == null) return;
    // Informational rows never toggle (they carry no completion).
    final members = state.value!.preparation.where(
      (p) => p.groupId == groupId && !p.informational,
    );
    if (members.isEmpty) return;
    final allCompleted = members.every((p) => p.isCompleted);
    state = AsyncData(
      state.value!.copyWith(
        preparation: state.value!.preparation.map((prep) {
          if (prep.groupId == groupId && !prep.informational) {
            return prep.copyWith(isCompleted: !allCompleted);
          }
          return prep;
        }).toList(),
      ),
    );
  }

  /// Draws a random first player among the selected ones: rotates
  /// [GameSetupStateEntity.colorOrder] so their color sits first (turn
  /// order is the grid position) and returns the drawn player so the UI
  /// can announce them. Returns null with fewer than 2 selected players.
  PlayerEntity? drawRandomFirstPlayer({Random? random}) {
    final current = state.value;
    if (current == null) return null;
    final selected = current.players.where((p) => p.isSelected).toList();
    if (selected.length < 2) return null;

    final rng = random ?? Random();
    final drawn = selected[rng.nextInt(selected.length)];
    final order = List<String>.from(current.colorOrder)
      ..remove(drawn.color)
      ..insert(0, drawn.color);
    state = AsyncData(current.copyWith(colorOrder: order));
    return drawn;
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
