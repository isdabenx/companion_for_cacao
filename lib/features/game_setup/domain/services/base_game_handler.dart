import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/module_preparation_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/tile_adjustments.dart';

/// Constants for tile IDs used in game preparation.
/// These IDs are stable identifiers that don't change with translations.
class TileIds {
  TileIds._();

  // Worker tiles - format: base.worker_{color}_{value}
  static String workerTile(String color, String value) =>
      'base.worker_${color}_$value';

  // Jungle tiles - format: base.jungle_{type}_{subtype}
  static const String singlePlantation = 'base.jungle_single_plantation';
  static const String doublePlantation = 'base.jungle_double_plantation';
  static const String marketSelling2 = 'base.jungle_market_selling_2';
  static const String marketSelling3 = 'base.jungle_market_selling_3';
  static const String marketSelling4 = 'base.jungle_market_selling_4';
  static const String goldMineValue1 = 'base.jungle_gold_mine_value_1';
  static const String goldMineValue2 = 'base.jungle_gold_mine_value_2';
  static const String water = 'base.jungle_water';
  static const String sunWorshipingSite = 'base.jungle_sun_worshiping_site';
  static const String temple = 'base.jungle_temple';
}

/// Watering tile ID for Big Game 3-player removal.
const String _wateringTileId = 'chocolatl.jungle_watering';

class BaseGameHandler with TileAdjustments implements ModulePreparationHandler {
  BaseGameHandler({
    required this.baseGame,
    required this.activeExpansions,
    required this.selectedColors,
  });

  final BoardgameEntity baseGame;
  final List<BoardgameEntity> activeExpansions;
  final List<String> selectedColors;

  @override
  List<TileEntity> adjustTiles(
    List<TileEntity> tiles,
    int playerCount, {
    required List<BoardgameEntity> activeExpansions,
    bool isBigGame = false,
  }) {
    var adjustedTiles = <TileEntity>[...tiles];

    for (final color in selectedColors) {
      final tileColor = _tileColorFromString(color);
      if (tileColor == null) {
        continue;
      }

      adjustedTiles.addAll(
        activeExpansions.expand((boardgame) {
          return boardgame.tiles.where(
            (tile) =>
                tile.color == tileColor && (isBigGame || tile.moduleId == null),
          );
        }),
      );
    }

    if (!isBigGame && playerCount > 2) {
      adjustedTiles = adjustedTiles.map((tile) {
        // Remove one 1-1-1-1 worker tile per player (for >2 players)
        if (tile.id == TileIds.workerTile(tile.color?.name ?? '', '1-1-1-1')) {
          return tile.copyWith(quantity: tile.quantity - 1);
        }

        // Remove one 2-1-0-1 worker tile per player (for >3 players)
        if (playerCount > 3 &&
            tile.id == TileIds.workerTile(tile.color?.name ?? '', '2-1-0-1')) {
          return tile.copyWith(quantity: tile.quantity - 1);
        }

        return tile;
      }).toList();
    }

    if (isBigGame) {
      // Big Game: load ALL jungle tiles from ALL expansions (no moduleId filter)
      adjustedTiles.addAll(
        activeExpansions.expand(
          (boardgame) => boardgame.tiles.where((tile) => tile.color == null),
        ),
      );

      // 3-player Big Game: remove specific tiles
      if (playerCount == 3) {
        adjustedTiles = reduceTileById(
          adjustedTiles,
          id: TileIds.singlePlantation,
          amount: 2,
        );
        adjustedTiles = reduceTileById(
          adjustedTiles,
          id: TileIds.goldMineValue1,
          amount: 2,
        );
        adjustedTiles = reduceTileById(
          adjustedTiles,
          id: TileIds.marketSelling2,
          amount: 1,
        );
        adjustedTiles = reduceTileById(
          adjustedTiles,
          id: TileIds.marketSelling3,
          amount: 1,
        );
        adjustedTiles = reduceTileById(
          adjustedTiles,
          id: _wateringTileId,
          amount: 1,
        );
      }
    } else {
      // Normal game: load only base jungle tiles (moduleId == null)
      adjustedTiles.addAll(baseGame.tiles.where((tile) => tile.color == null));

      if (playerCount == 2) {
        // 2-player game: reduce specific jungle tiles
        adjustedTiles = reduceTileById(
          adjustedTiles,
          id: TileIds.singlePlantation,
          amount: 2,
        );
        adjustedTiles = reduceTileById(
          adjustedTiles,
          id: TileIds.marketSelling3,
          amount: 1,
        );
        adjustedTiles = reduceTileById(
          adjustedTiles,
          id: TileIds.goldMineValue1,
          amount: 1,
        );
        adjustedTiles = reduceTileById(
          adjustedTiles,
          id: TileIds.water,
          amount: 1,
        );
        adjustedTiles = reduceTileById(
          adjustedTiles,
          id: TileIds.sunWorshipingSite,
          amount: 1,
        );
        adjustedTiles = reduceTileById(
          adjustedTiles,
          id: TileIds.temple,
          amount: 1,
        );
      }
    }

    return adjustedTiles;
  }

  @override
  List<PreparationEntity> modifyPreparationSteps(
    List<PlayerEntity> players,
    List<TileEntity> tiles,
    List<PreparationEntity> currentSteps, {
    bool isBigGame = false,
  }) {
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
            imageKey: 'village_board_$color',
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
            imageKey: 'carrier_$color',
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
            imageKey: 'tile_back_$color',
            phase: PreparationPhase.playerSetup,
          ),
        );
    }

    // Worker tile removals only in normal mode (Big Game uses all workers)
    if (!isBigGame && players.length > 2) {
      for (final player in players) {
        final workerTile = _findWorkerTileByColorAndValue(
          tiles,
          color: player.color,
          value: '1-1-1-1',
        );
        if (workerTile != null) {
          preparation.add(
            PreparationEntity(
              id: 'setup_remove_worker_1_${player.color}',
              description:
                  'Player ${player.color} searches for one of the 1-1-1-1 worker tiles and returns it to the game box',
              color: player.color,
              variables: {'color': player.color},
              imageKey: 'tile_${workerTile.filenameImage}',
              phase: PreparationPhase.playerSetup,
            ),
          );
        }

        if (players.length > 3) {
          final workerTile201 = _findWorkerTileByColorAndValue(
            tiles,
            color: player.color,
            value: '2-1-0-1',
          );

          if (workerTile201 != null) {
            preparation.add(
              PreparationEntity(
                id: 'setup_remove_worker_2_${player.color}',
                description:
                    'Player ${player.color} searches for one of the 2-1-0-1 worker tiles and returns it to the game box',
                color: player.color,
                variables: {'color': player.color},
                imageKey: 'tile_${workerTile201.filenameImage}',
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
          imageKey: 'initial_tiles_cacao',
          phase: PreparationPhase.boardSetup,
        ),
      );

    if (!isBigGame && players.length == 2) {
      preparation.addAll(_twoPlayerJungleTileRemovals());
    }

    if (isBigGame && players.length == 3) {
      preparation.addAll(_bigGame3pJungleTileRemovals());
    }

    preparation
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
          imageKey: 'resources_cacao',
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

  TileEntity? _findWorkerTileByColorAndValue(
    List<TileEntity> tiles, {
    required String color,
    required String value,
  }) {
    final tileColor = _tileColorFromString(color);
    if (tileColor == null) {
      return null;
    }

    final targetId = TileIds.workerTile(color, value);
    for (final tile in tiles) {
      if (tile.id == targetId && tile.color == tileColor) {
        return tile;
      }
    }

    return null;
  }

  List<PreparationEntity> _twoPlayerJungleTileRemovals() {
    return const [
      PreparationEntity(
        id: 'setup_jungle_tiles_2p_removal_single_plantation',
        description:
            'Sort out 2x Single Plantation and put them back in the box',
        imageKey: 'jungle_single_plantation',
        phase: PreparationPhase.boardSetup,
      ),
      PreparationEntity(
        id: 'setup_jungle_tiles_2p_removal_market_selling_3',
        description:
            'Sort out 1x Market, selling price 3 and put it back in the box',
        imageKey: 'jungle_market_selling_3',
        phase: PreparationPhase.boardSetup,
      ),
      PreparationEntity(
        id: 'setup_jungle_tiles_2p_removal_gold_mine_value_1',
        description:
            'Sort out 1x Gold Mine, value 1 and put it back in the box',
        imageKey: 'jungle_gold_mine_v1',
        phase: PreparationPhase.boardSetup,
      ),
      PreparationEntity(
        id: 'setup_jungle_tiles_2p_removal_water',
        description: 'Sort out 1x Water and put it back in the box',
        imageKey: 'jungle_water',
        phase: PreparationPhase.boardSetup,
      ),
      PreparationEntity(
        id: 'setup_jungle_tiles_2p_removal_sun_worshiping_site',
        description:
            'Sort out 1x Sun-Worshiping Site and put it back in the box',
        imageKey: 'jungle_sun_worshiping_site',
        phase: PreparationPhase.boardSetup,
      ),
      PreparationEntity(
        id: 'setup_jungle_tiles_2p_removal_temple',
        description: 'Sort out 1x Temple and put it back in the box',
        imageKey: 'jungle_temple',
        phase: PreparationPhase.boardSetup,
      ),
    ];
  }

  List<PreparationEntity> _bigGame3pJungleTileRemovals() {
    return const [
      PreparationEntity(
        id: 'setup_big_game_3p_removal_single_plantation',
        description:
            'Sort out 2x Single Plantation and put them back in the box',
        imageKey: 'jungle_single_plantation',
        phase: PreparationPhase.boardSetup,
      ),
      PreparationEntity(
        id: 'setup_big_game_3p_removal_gold_mine_v1',
        description:
            'Sort out 2x Gold Mine, value 1 and put them back in the box',
        imageKey: 'jungle_gold_mine_v1',
        phase: PreparationPhase.boardSetup,
      ),
      PreparationEntity(
        id: 'setup_big_game_3p_removal_market_selling_2',
        description:
            'Sort out 1x Market, selling price 2 and put it back in the box',
        imageKey: 'jungle_market_selling_2',
        phase: PreparationPhase.boardSetup,
      ),
      PreparationEntity(
        id: 'setup_big_game_3p_removal_market_selling_3',
        description:
            'Sort out 1x Market, selling price 3 and put it back in the box',
        imageKey: 'jungle_market_selling_3',
        phase: PreparationPhase.boardSetup,
      ),
      PreparationEntity(
        id: 'setup_big_game_3p_removal_watering',
        description: 'Sort out 1x Watering and put it back in the box',
        imageKey: 'jungle_watering',
        phase: PreparationPhase.boardSetup,
      ),
    ];
  }
}
