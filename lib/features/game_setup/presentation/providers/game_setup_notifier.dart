import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/module_model.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/base_game_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/preparation_pipeline.dart';
import 'package:companion_for_cacao/shared/providers/boardgame_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_setup_notifier.g.dart';

@Riverpod(keepAlive: true)
class GameSetupNotifier extends _$GameSetupNotifier {
  @override
  FutureOr<GameSetupStateEntity> build() async {
    final boardgames = await ref.watch(boardgameProvider.future);
    final baseGame = boardgames.firstWhere(
      (b) => b.id == 1,
      orElse: () => BoardgameModel(
        id: 1,
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
  }

  void removePlayer(String color) {
    if (state.value == null) return;
    state = AsyncData(
      state.value!.copyWith(
        players: state.value!.players.where((p) => p.color != color).toList(),
      ),
    );
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
    } else {
      addModule(module);
    }
  }

  void startGame() {
    if (state.value == null) return;

    final currentSetup = state.value!;
    final modules = currentSetup.modules
        .where((m) => currentSetup.expansions.any((e) => e.id == m.boardgameId))
        .toList();
    final players = currentSetup.players
        .where((p) => p.isSelected && p.name.isNotEmpty)
        .toList();

    final playerColors = players.map((p) => p.color).toSet();
    final filteredColors = AppColors.colors.keys
        .where(playerColors.contains)
        .toList();

    final baseGame = currentSetup.expansions.firstWhere((e) => e.id == 1);

    final pipeline = PreparationPipeline(
      baseHandler: BaseGameHandler(
        baseGame: baseGame,
        activeExpansions: currentSetup.expansions,
        selectedColors: filteredColors,
      ),
      moduleHandlers: const {},
    );

    final result = pipeline.execute(
      currentSetup.copyWith(players: players, modules: modules),
    );

    state = AsyncData(
      currentSetup.copyWith(
        players: players,
        modules: modules,
        tiles: result.tiles,
        preparation: result.preparation,
      ),
    );
  }
}
