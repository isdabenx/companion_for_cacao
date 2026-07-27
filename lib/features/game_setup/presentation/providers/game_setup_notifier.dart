import 'dart:math';

import 'package:collection/collection.dart';
import 'package:companion_for_cacao/config/constants/game_constants.dart';
import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/hut_type.dart';
import 'package:companion_for_cacao/core/domain/entities/module_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/hut_layout_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/player_entity.dart';
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

  /// Applies [change] to the loaded setup, and does nothing while the game
  /// data is still loading.
  ///
  /// Every mutator goes through here. Written out, each one repeats the null
  /// guard and then reaches back through `state.value!` two or three more
  /// times — and a new mutator that forgets the guard throws instead of
  /// no-opping. Returning [setup] unchanged is a valid no-op: the state
  /// compares equal, so nothing rebuilds.
  void _update(
    GameSetupStateEntity Function(GameSetupStateEntity setup) change,
  ) {
    final setup = state.value;
    if (setup == null) return;
    state = AsyncData(change(setup));
  }

  void reorderColorOrder(int oldIndex, int newIndex) {
    _update((setup) {
      final order = List<String>.from(setup.colorOrder);
      final item = order.removeAt(oldIndex);
      order.insert(newIndex, item);
      return setup.copyWith(colorOrder: order);
    });
  }

  void addPlayer(String name, String color) {
    // Added at the end of the list.
    _update(
      (setup) => setup.copyWith(
        players: [
          ...setup.players,
          PlayerEntity(name: name, color: color, isSelected: true),
        ],
      ),
    );
    _resetBigGameIfInvalid();
  }

  void removePlayer(String color) {
    _update(
      (setup) => setup.copyWith(
        players: setup.players.where((p) => p.color != color).toList(),
      ),
    );
    _resetBigGameIfInvalid();
  }

  void reorderPlayers(int oldIndex, int newIndex) {
    _update((setup) {
      final players = List<PlayerEntity>.from(setup.players);
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final item = players.removeAt(oldIndex);
      players.insert(newIndex, item);
      return setup.copyWith(players: players);
    });
  }

  void updatePlayerSelection(String color, {required bool isSelected}) {
    _update(
      (setup) => setup.copyWith(
        players: [
          for (final player in setup.players)
            if (player.color == color)
              player.copyWith(isSelected: isSelected)
            else
              player,
        ],
      ),
    );
  }

  void addExpansion(BoardgameEntity expansion) {
    _update(
      (setup) => setup.copyWith(expansions: [...setup.expansions, expansion]),
    );
  }

  void removeExpansion(BoardgameEntity expansion) {
    _update(
      (setup) => setup.copyWith(
        expansions: setup.expansions
            .where((e) => e.id != expansion.id)
            .toList(),
      ),
    );
    _resetBigGameIfInvalid();
  }

  void toggleExpansion(BoardgameEntity expansion) {
    final setup = state.value;
    if (setup == null) return;
    if (setup.expansions.any((e) => e.id == expansion.id)) {
      removeExpansion(expansion);
    } else {
      addExpansion(expansion);
    }
  }

  void addModule(ModuleEntity module) {
    _update((setup) => setup.copyWith(modules: [...setup.modules, module]));
  }

  void removeModule(ModuleEntity module) {
    _update(
      (setup) => setup.copyWith(
        modules: setup.modules.where((m) => m.id != module.id).toList(),
      ),
    );
  }

  void toggleModule(ModuleEntity module) {
    final setup = state.value;
    if (setup == null) return;
    if (setup.modules.any((m) => m.id == module.id)) {
      removeModule(module);
      // Clear worker selection when Module D is removed
      if (module.id == NewWorkersModuleHandler.moduleId) {
        _update((s) => s.copyWith(clearWorkerSelection: true));
      }
      // Clear the registered hut throw when the Hut Module is removed
      if (module.id == HutsModuleHandler.moduleId) {
        _update((s) => s.copyWith(clearHutLayout: true));
      }
    } else {
      addModule(module);
    }
    _resetBigGameIfInvalid();
  }

  void setBigGame(bool value) {
    _update((setup) => setup.copyWith(isBigGame: value));
  }

  /// Resets isBigGame to false if the Big Game rule
  /// ([GameSetupStateEntity.canEnableBigGame]) is no longer met.
  void _resetBigGameIfInvalid() {
    final setup = state.value;
    if (setup == null || !setup.isBigGame || setup.canEnableBigGame) return;
    state = AsyncData(setup.copyWith(isBigGame: false));
  }

  void startGame() {
    // Guarded before the side effects: with nothing loaded there is no game
    // to start, so the in-play filters must not be dropped either.
    if (state.value == null) return;
    // A new game also starts without leftover in-play tile filters
    ref.invalidate(tileFilterProvider(TileFilterScope.inPlay));
    final useCase = ref.read(prepareGameUseCaseProvider);
    _update((setup) {
      // Worker selection and the hut throw are per-game choices made during
      // preparation: every new game starts from scratch, never from choices
      // applied in a previous game.
      final fresh = setup.copyWith(
        clearWorkerSelection: true,
        clearHutLayout: true,
      );
      return useCase.execute(fresh).copyWith(isStarted: true);
    });
  }

  void resetGame() {
    _update(
      (setup) => setup.copyWith(
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
    _update((setup) => setup.copyWith(clearWorkerSelection: true));
  }

  /// Registers which side of each hut tile landed face up in the throw.
  /// The hut-throw preparation step derives its completion from this (see
  /// DetailedPreparationWidget), so registering IS completing the step.
  /// The tiles in play are refreshed to show exactly the face-up huts.
  void applyHutLayout(HutLayoutEntity layout) {
    _update(
      (setup) => _rerunPipeline(setup, setup.copyWith(hutLayout: layout)),
    );
  }

  /// Forgets the registered hut throw (supply becomes unknown again),
  /// which also reopens its preparation step and restores the full hut
  /// list in the tiles in play.
  void clearHutLayout() {
    _update(
      (setup) => _rerunPipeline(setup, setup.copyWith(clearHutLayout: true)),
    );
  }

  void togglePreparationCompletion(String id) {
    _update(
      (setup) => setup.copyWith(
        preparation: [
          for (final prep in setup.preparation)
            if (prep.id == id)
              prep.copyWith(isCompleted: !prep.isCompleted)
            else
              prep,
        ],
      ),
    );
  }

  /// Toggles a whole preparation group (e.g. a player's corner card):
  /// if every member is completed, unchecks them all; otherwise checks
  /// them all. Group completion itself stays derived from the members.
  void toggleGroupCompletion(String groupId) {
    _update((setup) {
      // Informational rows never toggle (they carry no completion).
      final members = setup.preparation.where(
        (p) => p.groupId == groupId && !p.informational,
      );
      if (members.isEmpty) return setup;
      final allCompleted = members.every((p) => p.isCompleted);
      return setup.copyWith(
        preparation: [
          for (final prep in setup.preparation)
            if (prep.groupId == groupId && !prep.informational)
              prep.copyWith(isCompleted: !allCompleted)
            else
              prep,
        ],
      );
    });
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
    _update(
      (setup) => setup.copyWith(
        players: [
          for (final player in setup.players)
            if (player.color == color)
              player.copyWith(name: newName)
            else
              player,
        ],
      ),
    );
  }
}
