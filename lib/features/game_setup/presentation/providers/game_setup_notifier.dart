import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/module_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
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
    final preparation = <PreparationEntity>[];
    final modules = state.modules
        .where((m) => state.expansions.any((e) => e.id == m.boardgameId))
        .toList();
    final players = state.players
        .where((p) => p.isSelected && p.name.isNotEmpty)
        .toList();

    final playerColors = players.map((p) => p.color).toSet();
    final filteredColors = AppColors.colors.keys.where(playerColors.contains);

    var tiles = filteredColors.expand((color) {
      preparation
        ..add(
          PreparationEntity(
            description:
                'Player $color takes the village board of color $color',
            color: color,
            imagePath:
                '${Assets.preparationVillagePrefix}$color${Assets.preparationVillageSufix}',
          ),
        )
        ..add(
          PreparationEntity(
            description:
                'Player $color takes the water carrier of color $color',
            color: color,
            imagePath:
                '${Assets.preparationCarrierPrefix}$color${Assets.preparationCarrierSufix}',
          ),
        )
        ..add(
          PreparationEntity(
            description:
                'Player $color puts the water carrier on the water field with the value “-10”',
            color: color,
          ),
        )
        ..add(
          PreparationEntity(
            description: 'Player $color get all tiles with color $color',
            color: color,
            imagePath:
                '${Assets.preparationTilePrefix}$color${Assets.preparationTileSufix}',
          ),
        );
      return state.expansions.expand((boardgame) {
        return boardgame.tiles.where(
          (t) =>
              t.color ==
              TileColor.values.firstWhere(
                (c) => c.toString().split('.').last == color,
              ),
        );
      });
    }).toList();

    if (players.length > 2) {
      tiles = tiles.map((tile) {
        final color = tile.color.toString().split('.').last;
        if (tile.name == '1-1-1-1') {
          preparation.add(
            PreparationEntity(
              description:
                  'Player $color searches for one of the 1-1-1-1 worker tiles and returns it to the game box',
              color: color,
              imagePath: '${Assets.imagesTilePath}${tile.filenameImage}',
            ),
          );
          return tile.copyWith(quantity: tile.quantity - 1);
        }
        if (players.length > 3 && tile.name == '2-1-0-1') {
          preparation.add(
            PreparationEntity(
              description:
                  'Player $color searches for one of the 2-1-0-1 worker tiles and returns it to the game box',
              color: color,
              imagePath: '${Assets.imagesTilePath}${tile.filenameImage}',
            ),
          );
          return tile.copyWith(quantity: tile.quantity - 1);
        }
        return tile;
      }).toList();
    }

    state.expansions.where((e) => e.id == 1).forEach((e) {
      tiles.addAll(e.tiles.where((t) => t.color == null));
    });

    preparation
      ..add(
        const PreparationEntity(
          description:
              'Each player mixes their worker tiles and puts them as a face-down worker draw pile next to their village board. After that, they draw the 3 top worker tiles from their worker draw pile and take them into their hand',
        ),
      )
      ..add(
        const PreparationEntity(
          description:
              'From the jungle tiles, get "single plantation" and "market, selling price 2" and place them face up in the middle of the table diagonally to one another; they form the starting tiles of the playing area',
          imagePath: Assets.preparationInitialTilesCacao,
        ),
      )
      ..add(
        const PreparationEntity(
          description:
              'Mix the remaining jungle tiles and lay them out as a face-down jungle draw pile',
        ),
      )
      ..add(
        const PreparationEntity(
          description:
              'Draw the 2 top jungle tiles from the jungle draw pile and place them next to the pile as a face-up jungle display',
        ),
      )
      ..add(
        const PreparationEntity(
          description:
              'Lay out the cacao fruits and the sun tokens as separate supply piles. Put the gold coins next to them to serve as the bank',
          imagePath: Assets.preparationResourcesCacao,
        ),
      );

    state = state.copyWith(
      players: players,
      modules: modules,
      tiles: tiles,
      preparation: preparation,
    );
  }
}

final gameSetupProvider =
    NotifierProvider<GameSetupNotifier, GameSetupStateEntity>(() {
      return GameSetupNotifier();
    });
