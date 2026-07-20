import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/content/preparation_l10n.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/table_zone.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/module_preparation_handler.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/preparation_steps.dart';

class GemMinesModuleHandler implements ModulePreparationHandler {
  static const int moduleId = 5;

  GemMinesModuleHandler({PreparationL10n? l10n})
    : copy = l10n ?? PreparationL10n.en();

  /// Localized step content; defaults to English so tests need no wiring.
  final PreparationL10n copy;

  @override
  List<TileEntity> adjustTiles(
    List<TileEntity> tiles,
    int playerCount, {
    required List<BoardgameEntity> activeExpansions,
    bool isBigGame = false,
  }) {
    // Big Game: all tiles already loaded by base handler
    if (isBigGame) return tiles;

    final result = <TileEntity>[...tiles];

    // Remove all temples
    result.removeWhere((tile) => tile.type == TileType.temple);

    // Add gem mines from expansion
    for (final expansion in activeExpansions) {
      for (final tile in expansion.tiles) {
        if (tile.type == TileType.gemMine) {
          if (playerCount == 2) {
            result.add(tile.copyWith(quantity: tile.quantity - 1));
          } else {
            result.add(tile);
          }
        }
      }
    }

    return result;
  }

  @override
  List<PreparationEntity> modifyPreparationSteps(
    List<PlayerEntity> players,
    List<TileEntity> tiles,
    List<PreparationEntity> currentSteps, {
    bool isBigGame = false,
  }) {
    final preparation = <PreparationEntity>[...currentSteps];

    // Big Game: skip tile substitution steps, only add supplies
    if (isBigGame) {
      preparation.add(
        PreparationEntity(
          id: 'setup_gem_mines_mine_car',
          label: copy.mineCarLabel,
          detail: copy.mineCarAllDetail,
          tableZone: TableZone.supplies,
          phase: PreparationPhase.supplies,
          imageKey: 'resources_mine_car',
        ),
      );

      preparation.add(
        PreparationEntity(
          id: 'setup_gem_mines_masks',
          label: copy.masksLabel,
          detail: copy.masksAllDetail,
          tableZone: TableZone.supplies,
          phase: PreparationPhase.supplies,
          imageKey: 'resources_masks',
        ),
      );

      preparation.add(
        PreparationEntity(
          id: 'setup_gem_mines_rule_reminder',
          label: copy.gemMinesReminderLabel,
          detail: copy.gemMinesReminderDetail,
          tableZone: TableZone.supplies,
          phase: PreparationPhase.supplies,
        ),
      );

      return preparation;
    }

    // For 2 players: remove the base game temple removal step (it only
    // removes 1 temple, but gem mines removes ALL temples).
    if (players.length == 2) {
      preparation.removeWhere(
        (step) => step.id == 'setup_jungle_tiles_2p_removal_temple',
      );
    }

    // Insert visible tile substitution steps before 'setup_jungle_draw_pile'
    final substitutionSteps = _tileSubstitutionSteps(players.length);
    final drawPileIndex = preparation.indexWhere(
      (step) => step.id == 'setup_jungle_draw_pile',
    );
    if (drawPileIndex >= 0) {
      preparation.insertAll(drawPileIndex, substitutionSteps);
    } else {
      preparation.addAll(substitutionSteps);
    }

    // Add gem mine supplies steps
    if (players.length == 2) {
      preparation.add(
        PreparationEntity(
          id: 'setup_gem_mines_remove_gems',
          label: copy.gemsRemoveLabel,
          detail: copy.gemsRemoveDetail,
          rationale: copy.twoPlayerRemovalRationale,
          tableZone: TableZone.box,
          quantity: 8,
          phase: PreparationPhase.supplies,
          imageKey: 'resources_gems',
        ),
      );
    }

    preparation.add(
      PreparationEntity(
        id: 'setup_gem_mines_mine_car',
        label: copy.mineCarLabel,
        detail: players.length == 2
            ? copy.mineCarRemainingDetail
            : copy.mineCarAllDetail,
        tableZone: TableZone.supplies,
        phase: PreparationPhase.supplies,
        imageKey: 'resources_mine_car',
      ),
    );

    preparation.add(
      PreparationEntity(
        id: 'setup_gem_mines_masks',
        label: copy.masksLabel,
        detail: players.length == 2
            ? copy.masksWithout12Detail
            : copy.masksAllDetail,
        tableZone: TableZone.supplies,
        phase: PreparationPhase.supplies,
        imageKey: 'resources_masks',
      ),
    );

    preparation.add(
      PreparationEntity(
        id: 'setup_gem_mines_rule_reminder',
        label: copy.gemMinesReminderLabel,
        detail: copy.gemMinesReminderDetail,
        tableZone: TableZone.supplies,
        phase: PreparationPhase.supplies,
      ),
    );

    return preparation;
  }

  /// Generates visible preparation steps for the gem mines tile substitution.
  List<PreparationEntity> _tileSubstitutionSteps(int playerCount) {
    return [
      // "All temples" has no fixed quantity: the label says it (see spec).
      PreparationEntity(
        id: 'setup_gem_mines_remove_temples',
        label: copy.removeAllTilesLabel(copy.tileTemple),
        detail: copy.removeAllTilesDetail(copy.tileTemple),
        tableZone: TableZone.box,
        groupId: PreparationGroups.returnToBox,
        imageKey: 'jungle_temple',
        phase: PreparationPhase.boardSetup,
      ),
      PreparationSteps.addition(
        copy: copy,
        id: 'setup_gem_mines_add_gem_mines',
        quantity: playerCount == 2 ? 4 : 5,
        tileName: copy.tileGemMine,
        imageKey: 'jungle_gem_mine',
      ),
    ];
  }
}
