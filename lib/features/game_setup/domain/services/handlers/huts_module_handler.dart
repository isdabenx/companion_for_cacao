import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/content/preparation_l10n.dart';
import 'package:companion_for_cacao/core/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/table_zone.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/module_preparation_handler.dart';

/// Handler for the Huts Module (Chocolatl expansion, Module D).
///
/// Rules:
/// - Adds purchasable huts with ongoing or end-game effects.
/// - Players can own at most one hut of each type.
/// - 12 hut tiles are randomly placed and sorted by building cost next to the bank.
class HutsModuleHandler implements ModulePreparationHandler {
  static const int moduleId = 4;

  HutsModuleHandler({PreparationL10n? l10n})
    : copy = l10n ?? PreparationL10n.en();

  /// Localized step content; defaults to English so tests need no wiring.
  final PreparationL10n copy;

  /// Step where the hut tiles are thrown. Its preparation card also hosts
  /// the optional throw-registration action, so the score calculator can
  /// know the exact hut supply of this game.
  static const String marketStepId = 'setup_huts_market';

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

    // Add all hut tiles from the expansions
    for (final expansion in activeExpansions) {
      for (final tile in expansion.tiles) {
        if (tile.moduleId == moduleId) {
          result.add(tile);
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

    // Find the last step of the boardSetup phase
    int lastBoardSetupIndex = -1;
    for (int i = 0; i < preparation.length; i++) {
      if (preparation[i].phase == PreparationPhase.boardSetup) {
        lastBoardSetupIndex = i;
      }
    }

    // Insert the huts market setup step at the end of boardSetup phase
    if (lastBoardSetupIndex >= 0) {
      preparation.insert(
        lastBoardSetupIndex + 1,
        PreparationEntity(
          id: marketStepId,
          label: copy.hutsMarketLabel,
          detail: copy.hutsMarketDetail,
          rationale: copy.hutsMarketRationale,
          tableZone: TableZone.supplies,
          phase: PreparationPhase.boardSetup,
        ),
      );
    }

    return preparation;
  }
}
