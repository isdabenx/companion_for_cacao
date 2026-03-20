import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/module_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
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
    final useCase = ref.read(prepareGameUseCaseProvider);
    state = AsyncData(useCase.execute(state.value!));
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
