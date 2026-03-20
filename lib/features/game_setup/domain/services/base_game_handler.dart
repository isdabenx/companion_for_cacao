import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/module_preparation_handler.dart';

class BaseGameHandler implements ModulePreparationHandler {
  BaseGameHandler({
    required this.baseGame,
    required this.activeExpansions,
    required this.selectedColors,
  });

  final BoardgameModel baseGame;
  final List<BoardgameModel> activeExpansions;
  final List<String> selectedColors;

  @override
  List<TileModel> adjustTiles(List<TileModel> tiles, int playerCount) {
    var adjustedTiles = <TileModel>[...tiles];

    for (final color in selectedColors) {
      final tileColor = _tileColorFromString(color);
      if (tileColor == null) {
        continue;
      }

      adjustedTiles.addAll(
        activeExpansions.expand((boardgame) {
          return boardgame.tiles.where((tile) => tile.color == tileColor);
        }),
      );
    }

    if (playerCount > 2) {
      adjustedTiles = adjustedTiles.map((tile) {
        if (tile.name == '1-1-1-1') {
          return tile.copyWith(quantity: tile.quantity - 1);
        }

        if (playerCount > 3 && tile.name == '2-1-0-1') {
          return tile.copyWith(quantity: tile.quantity - 1);
        }

        return tile;
      }).toList();
    }

    adjustedTiles.addAll(baseGame.tiles.where((tile) => tile.color == null));

    if (playerCount == 2) {
      adjustedTiles = _reduceJungleTileByName(
        adjustedTiles,
        name: 'Single Plantation',
        amount: 2,
      );
      adjustedTiles = _reduceJungleTileByName(
        adjustedTiles,
        name: 'Selling price 3',
        amount: 1,
      );
      adjustedTiles = _reduceJungleTileByName(
        adjustedTiles,
        name: 'Value 1',
        amount: 1,
      );
      adjustedTiles = _reduceJungleTileByName(
        adjustedTiles,
        name: 'Water',
        amount: 1,
      );
      adjustedTiles = _reduceJungleTileByName(
        adjustedTiles,
        name: 'Sun-Worshiping Site',
        amount: 1,
      );
      adjustedTiles = _reduceJungleTileByName(
        adjustedTiles,
        name: 'Temple',
        amount: 1,
      );
    }

    return adjustedTiles;
  }

  @override
  List<PreparationEntity> modifyPreparationSteps(
    List<PlayerEntity> players,
    List<TileModel> tiles,
    List<PreparationEntity> currentSteps,
  ) {
    final preparation = <PreparationEntity>[...currentSteps];

    for (final player in players) {
      final color = player.color;

      preparation
        ..add(
          PreparationEntity(
            id: 'setup_village_board_$color',
            description:
                'Player $color takes the village board of color $color',
            color: color,
            variables: {'color': color},
            imagePath:
                '${Assets.preparationVillagePrefix}$color${Assets.preparationVillageSufix}',
            phase: PreparationPhase.playerSetup,
          ),
        )
        ..add(
          PreparationEntity(
            id: 'setup_water_carrier_$color',
            description:
                'Player $color takes the water carrier of color $color',
            color: color,
            variables: {'color': color},
            imagePath:
                '${Assets.preparationCarrierPrefix}$color${Assets.preparationCarrierSufix}',
            phase: PreparationPhase.playerSetup,
          ),
        )
        ..add(
          PreparationEntity(
            id: 'setup_water_field_$color',
            description:
                'Player $color puts the water carrier on the water field with the value "-10"',
            color: color,
            variables: {'color': color},
            phase: PreparationPhase.playerSetup,
          ),
        )
        ..add(
          PreparationEntity(
            id: 'setup_tiles_$color',
            description: 'Player $color gets all tiles with color $color',
            color: color,
            variables: {'color': color},
            imagePath:
                '${Assets.preparationTilePrefix}$color${Assets.preparationTileSufix}',
            phase: PreparationPhase.playerSetup,
          ),
        );
    }

    if (players.length > 2) {
      for (final player in players) {
        final workerTile = _findTileByNameAndColor(
          tiles,
          name: '1-1-1-1',
          color: player.color,
        );
        if (workerTile != null) {
          preparation.add(
            PreparationEntity(
              id: 'setup_remove_worker_1_${player.color}',
              description:
                  'Player ${player.color} searches for one of the 1-1-1-1 worker tiles and returns it to the game box',
              color: player.color,
              variables: {'color': player.color},
              imagePath: '${Assets.imagesTilePath}${workerTile.filenameImage}',
              phase: PreparationPhase.playerSetup,
            ),
          );
        }

        if (players.length > 3) {
          final workerTile201 = _findTileByNameAndColor(
            tiles,
            name: '2-1-0-1',
            color: player.color,
          );

          if (workerTile201 != null) {
            preparation.add(
              PreparationEntity(
                id: 'setup_remove_worker_2_${player.color}',
                description:
                    'Player ${player.color} searches for one of the 2-1-0-1 worker tiles and returns it to the game box',
                color: player.color,
                variables: {'color': player.color},
                imagePath:
                    '${Assets.imagesTilePath}${workerTile201.filenameImage}',
                phase: PreparationPhase.playerSetup,
              ),
            );
          }
        }
      }
    }

    preparation
      ..add(
        const PreparationEntity(
          id: 'setup_shuffle_workers',
          description:
              'Each player mixes their worker tiles and puts them as a face-down worker draw pile next to their village board. After that, they draw the 3 top worker tiles from their worker draw pile and take them into their hand',
          phase: PreparationPhase.playerSetup,
        ),
      )
      ..add(
        const PreparationEntity(
          id: 'setup_initial_tiles_plantation_market',
          description:
              'From the jungle tiles, get "single plantation" and "market, selling price 2" and place them face up in the middle of the table diagonally to one another; they form the starting tiles of the playing area',
          imagePath: Assets.preparationInitialTilesCacao,
          phase: PreparationPhase.boardSetup,
        ),
      )
      ..add(
        const PreparationEntity(
          id: 'setup_jungle_draw_pile',
          description:
              'Mix the remaining jungle tiles and lay them out as a face-down jungle draw pile',
          phase: PreparationPhase.boardSetup,
        ),
      )
      ..add(
        const PreparationEntity(
          id: 'setup_jungle_display',
          description:
              'Draw the 2 top jungle tiles from the jungle draw pile and place them next to the pile as a face-up jungle display',
          phase: PreparationPhase.boardSetup,
        ),
      )
      ..add(
        const PreparationEntity(
          id: 'setup_resources_bank',
          description:
              'Lay out the cacao fruits and the sun tokens as separate supply piles. Put the gold coins next to them to serve as the bank',
          imagePath: Assets.preparationResourcesCacao,
          phase: PreparationPhase.supplies,
        ),
      );

    return preparation;
  }

  TileColor? _tileColorFromString(String color) {
    for (final tileColor in TileColor.values) {
      if (tileColor.name == color) {
        return tileColor;
      }
    }
    return null;
  }

  TileModel? _findTileByNameAndColor(
    List<TileModel> tiles, {
    required String name,
    required String color,
  }) {
    final tileColor = _tileColorFromString(color);
    if (tileColor == null) {
      return null;
    }

    for (final tile in tiles) {
      if (tile.name == name && tile.color == tileColor) {
        return tile;
      }
    }

    return null;
  }

  List<TileModel> _reduceJungleTileByName(
    List<TileModel> tiles, {
    required String name,
    required int amount,
  }) {
    var remaining = amount;

    return tiles.map((tile) {
      if (remaining == 0 || tile.color != null || tile.name != name) {
        return tile;
      }

      final reduction = tile.quantity >= remaining ? remaining : tile.quantity;
      remaining -= reduction;

      return tile.copyWith(quantity: tile.quantity - reduction);
    }).toList();
  }
}
