import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/content/preparation_l10n.dart';
import 'package:companion_for_cacao/core/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_actor.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/table_zone.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/module_preparation_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/preparation_steps.dart';
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
    PreparationL10n? l10n,
  }) : copy = l10n ?? PreparationL10n.en();

  /// Localized step content; defaults to English so tests need no wiring.
  final PreparationL10n copy;

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

    // Personal setup is the same action for every player, so state it once
    // ("each player…") instead of repeating it per colour — fewer steps. The
    // component image is shown in grey (white as reference) and a colour bar
    // of the players indicates who does it (added at render time).
    preparation
      ..add(
        PreparationEntity(
          id: 'setup_village_board',
          label: copy.villageBoardLabel,
          detail: copy.villageBoardDetailAll,
          actor: PreparationActor.allPlayers,
          tableZone: TableZone.playerArea,
          imageKey: 'village_board_white',
          colorReferenceImage: true,
          phase: PreparationPhase.playerSetup,
        ),
      )
      // Fuses the former take-the-carrier and put-it-on-the-field steps:
      // one physical gesture, one step (spec-fase-ux1 §2.2).
      ..add(
        PreparationEntity(
          id: 'setup_water_carrier',
          label: copy.waterCarrierLabel,
          detail: copy.waterCarrierDetailAll,
          actor: PreparationActor.allPlayers,
          tableZone: TableZone.playerArea,
          imageKey: 'carrier_white',
          colorReferenceImage: true,
          phase: PreparationPhase.playerSetup,
        ),
      )
      ..add(
        PreparationEntity(
          id: 'setup_tiles',
          label: copy.ownTilesLabel,
          detail: copy.ownTilesDetailAll,
          actor: PreparationActor.allPlayers,
          tableZone: TableZone.playerArea,
          imageKey: 'tile_back_white',
          colorReferenceImage: true,
          phase: PreparationPhase.playerSetup,
        ),
      );

    // Worker tile removals only in normal mode (Big Game uses all workers).
    // A single generalized "each player returns their own tile" step per
    // value — the tile art is any colour's (the UI greys it as a reference).
    if (!isBigGame && players.length > 2) {
      final workerTile = _findWorkerTileByColorAndValue(
        tiles,
        color: players.first.color,
        value: '1-1-1-1',
      );
      if (workerTile != null) {
        preparation.add(
          PreparationEntity(
            id: 'setup_remove_worker_1',
            label: copy.removeWorkerLabel('1-1-1-1'),
            detail: copy.removeWorkerDetailAll('1-1-1-1'),
            rationale: copy.removeWorkerRationale,
            actor: PreparationActor.allPlayers,
            tableZone: TableZone.box,
            quantity: 1,
            imageKey: 'tile_${workerTile.filenameImage}',
            colorReferenceImage: true,
            phase: PreparationPhase.playerSetup,
          ),
        );
      }

      if (players.length > 3) {
        final workerTile201 = _findWorkerTileByColorAndValue(
          tiles,
          color: players.first.color,
          value: '2-1-0-1',
        );

        if (workerTile201 != null) {
          preparation.add(
            PreparationEntity(
              id: 'setup_remove_worker_2',
              label: copy.removeWorkerLabel('2-1-0-1'),
              detail: copy.removeWorkerDetailAll('2-1-0-1'),
              rationale: copy.removeWorkerRationale,
              actor: PreparationActor.allPlayers,
              tableZone: TableZone.box,
              quantity: 1,
              imageKey: 'tile_${workerTile201.filenameImage}',
              colorReferenceImage: true,
              phase: PreparationPhase.playerSetup,
            ),
          );
        }
      }
    }

    preparation
      ..add(
        PreparationEntity(
          id: 'setup_shuffle_workers',
          label: copy.shuffleWorkersLabel,
          detail: copy.shuffleWorkersDetail,
          actor: PreparationActor.allPlayers,
          tableZone: TableZone.playerArea,
          phase: PreparationPhase.playerSetup,
        ),
      )
      ..add(
        PreparationEntity(
          id: 'setup_initial_tiles_plantation_market',
          label: copy.initialTilesMarketLabel,
          detail: copy.initialTilesMarketDetail,
          tableZone: TableZone.startingArea,
          imageKey: 'initial_tiles_cacao',
          phase: PreparationPhase.boardSetup,
        ),
      );

    // Jungle-pile assembly, all under one "the jungle" card: gather first,
    // then any return/add steps modules slot in before the shuffle, then
    // shuffle and reveal. See [PreparationGroups.jungle].
    preparation.add(
      PreparationEntity(
        id: 'setup_gather_jungle',
        label: copy.gatherJungleLabel,
        detail: copy.gatherJungleDetail,
        tableZone: TableZone.junglePile,
        groupId: PreparationGroups.jungle,
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
        PreparationEntity(
          id: 'setup_jungle_draw_pile',
          label: copy.junglePileLabel,
          detail: copy.junglePileDetail,
          tableZone: TableZone.junglePile,
          groupId: PreparationGroups.jungle,
          phase: PreparationPhase.boardSetup,
        ),
      )
      ..add(
        PreparationEntity(
          id: 'setup_jungle_display',
          label: copy.jungleDisplayLabel,
          detail: copy.jungleDisplayDetail,
          tableZone: TableZone.jungleDisplay,
          groupId: PreparationGroups.jungle,
          phase: PreparationPhase.boardSetup,
        ),
      )
      ..add(
        PreparationEntity(
          id: 'setup_resources_bank',
          label: copy.resourcesBankLabel,
          detail: copy.resourcesBankDetail,
          tableZone: TableZone.supplies,
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
    return [
      PreparationSteps.removal(
        copy: copy,
        id: 'setup_jungle_tiles_2p_removal_single_plantation',
        quantity: 2,
        tileName: copy.tileSinglePlantation,
        imageKey: 'jungle_single_plantation',
        rationale: copy.twoPlayerRemovalRationale,
      ),
      PreparationSteps.removal(
        copy: copy,
        id: 'setup_jungle_tiles_2p_removal_market_selling_3',
        quantity: 1,
        tileName: copy.tileMarketSelling3,
        imageKey: 'jungle_market_selling_3',
        rationale: copy.twoPlayerRemovalRationale,
      ),
      PreparationSteps.removal(
        copy: copy,
        id: 'setup_jungle_tiles_2p_removal_gold_mine_value_1',
        quantity: 1,
        tileName: copy.tileGoldMineV1,
        imageKey: 'jungle_gold_mine_v1',
        rationale: copy.twoPlayerRemovalRationale,
      ),
      PreparationSteps.removal(
        copy: copy,
        id: 'setup_jungle_tiles_2p_removal_water',
        quantity: 1,
        tileName: copy.tileWater,
        imageKey: 'jungle_water',
        rationale: copy.twoPlayerRemovalRationale,
      ),
      PreparationSteps.removal(
        copy: copy,
        id: 'setup_jungle_tiles_2p_removal_sun_worshiping_site',
        quantity: 1,
        tileName: copy.tileSunWorshipingSite,
        imageKey: 'jungle_sun_worshiping_site',
        rationale: copy.twoPlayerRemovalRationale,
      ),
      PreparationSteps.removal(
        copy: copy,
        id: 'setup_jungle_tiles_2p_removal_temple',
        quantity: 1,
        tileName: copy.tileTemple,
        imageKey: 'jungle_temple',
        rationale: copy.twoPlayerRemovalRationale,
      ),
    ];
  }

  List<PreparationEntity> _bigGame3pJungleTileRemovals() {
    return [
      PreparationSteps.removal(
        copy: copy,
        id: 'setup_big_game_3p_removal_single_plantation',
        quantity: 2,
        tileName: copy.tileSinglePlantation,
        imageKey: 'jungle_single_plantation',
        rationale: copy.bigGame3pRemovalRationale,
      ),
      PreparationSteps.removal(
        copy: copy,
        id: 'setup_big_game_3p_removal_gold_mine_v1',
        quantity: 2,
        tileName: copy.tileGoldMineV1,
        imageKey: 'jungle_gold_mine_v1',
        rationale: copy.bigGame3pRemovalRationale,
      ),
      PreparationSteps.removal(
        copy: copy,
        id: 'setup_big_game_3p_removal_market_selling_2',
        quantity: 1,
        tileName: copy.tileMarketSelling2,
        imageKey: 'jungle_market_selling_2',
        rationale: copy.bigGame3pRemovalRationale,
      ),
      PreparationSteps.removal(
        copy: copy,
        id: 'setup_big_game_3p_removal_market_selling_3',
        quantity: 1,
        tileName: copy.tileMarketSelling3,
        imageKey: 'jungle_market_selling_3',
        rationale: copy.bigGame3pRemovalRationale,
      ),
      PreparationSteps.removal(
        copy: copy,
        id: 'setup_big_game_3p_removal_watering',
        quantity: 1,
        tileName: copy.tileWatering,
        imageKey: 'jungle_watering',
        rationale: copy.bigGame3pRemovalRationale,
      ),
    ];
  }
}
