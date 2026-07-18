import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';

/// Abstract interface for module-specific preparation handlers.
/// Each game module (base or expansion) implements this to provide
/// its tile adjustments and preparation steps.
abstract class ModulePreparationHandler {
  /// Adjusts the tile pool based on module rules.
  /// [tiles] is the current mutable list of tiles.
  /// [playerCount] is the number of selected players.
  /// [activeExpansions] provides access to expansion tile definitions.
  /// [isBigGame] when true, skips tile substitutions (Big Game uses all tiles).
  /// Returns the modified tile list.
  List<TileEntity> adjustTiles(
    List<TileEntity> tiles,
    int playerCount, {
    required List<BoardgameEntity> activeExpansions,
    bool isBigGame = false,
  });

  /// Modifies preparation steps for this module.
  /// [players] is the list of selected players.
  /// [tiles] is the current tile list (after adjustments).
  /// [currentSteps] is the current list of preparation steps.
  /// [isBigGame] when true, skips substitution steps (Big Game uses all tiles).
  /// Returns the modified preparation steps list.
  List<PreparationEntity> modifyPreparationSteps(
    List<PlayerEntity> players,
    List<TileEntity> tiles,
    List<PreparationEntity> currentSteps, {
    bool isBigGame = false,
  });
}
