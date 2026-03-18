import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/module_model.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/base_game_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/preparation_pipeline.dart';
import 'package:companion_for_cacao/shared/providers/boardgame_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameSetupNotifier extends Notifier<GameSetupStateEntity> {
  @override
  GameSetupStateEntity build() {
    final boardgame = ref
        .read(boardgameNotifierProvider.notifier)
        .boardgameById(1);
    return GameSetupStateEntity(expansions: [boardgame]);
  }

  void addPlayer(String name, String color) {
    final player = PlayerEntity(name: name, color: color, isSelected: true);
    state = state.copyWith(players: [...state.players, player]);
  }

  void removePlayer(String color) {
    state = state.copyWith(
      players: state.players.where((p) => p.color != color).toList(),
    );
  }

  void updatePlayerSelection(String color, {required bool isSelected}) {
    state = state.copyWith(
      players: state.players.map((p) {
        if (p.color == color) {
          return p.copyWith(isSelected: isSelected);
        }
        return p;
      }).toList(),
    );
  }

  void addExpansion(BoardgameModel expansion) {
    state = state.copyWith(expansions: [...state.expansions, expansion]);
  }

  void removeExpansion(BoardgameModel expansion) {
    state = state.copyWith(
      expansions: state.expansions.where((e) => e.id != expansion.id).toList(),
    );
  }

  void toggleExpansion(BoardgameModel expansion) {
    if (state.expansions.any((e) => e.id == expansion.id)) {
      removeExpansion(expansion);
    } else {
      addExpansion(expansion);
    }
  }

  void addModule(ModuleModel module) {
    state = state.copyWith(modules: [...state.modules, module]);
  }

  void removeModule(ModuleModel module) {
    state = state.copyWith(
      modules: state.modules.where((m) => m.id != module.id).toList(),
    );
  }

  void toggleModule(ModuleModel module) {
    if (state.modules.any((m) => m.id == module.id)) {
      removeModule(module);
    } else {
      addModule(module);
    }
  }

  void startGame() {
    final modules = state.modules
        .where((m) => state.expansions.any((e) => e.id == m.boardgameId))
        .toList();
    final players = state.players
        .where((p) => p.isSelected && p.name.isNotEmpty)
        .toList();

    final playerColors = players.map((p) => p.color).toSet();
    final filteredColors = AppColors.colors.keys
        .where(playerColors.contains)
        .toList();
    final baseGame = state.expansions.firstWhere(
      (expansion) => expansion.id == 1,
      orElse: () =>
          ref.read(boardgameNotifierProvider.notifier).boardgameById(1),
    );

    final pipeline = PreparationPipeline(
      baseHandler: BaseGameHandler(
        baseGame: baseGame,
        activeExpansions: state.expansions,
        selectedColors: filteredColors,
      ),
      moduleHandlers: const {},
    );

    final result = pipeline.execute(
      state.copyWith(players: players, modules: modules),
    );

    state = state.copyWith(
      players: players,
      modules: modules,
      tiles: result.tiles,
      preparation: result.preparation,
    );
  }
}

final gameSetupProvider =
    NotifierProvider<GameSetupNotifier, GameSetupStateEntity>(() {
      return GameSetupNotifier();
    });
