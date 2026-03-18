import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';

/// Abstract interface for module-specific preparation handlers.
/// Each game module (base or expansion) implements this to provide
/// its tile adjustments and preparation steps.
abstract class ModulePreparationHandler {
  /// Adjusts the tile pool based on module rules.
  /// [tiles] is the current mutable list of tiles.
  /// [playerCount] is the number of selected players.
  /// Returns the modified tile list.
  List<TileModel> adjustTiles(List<TileModel> tiles, int playerCount);

  /// Generates preparation steps for this module.
  /// [players] is the list of selected players.
  /// [tiles] is the current tile list (after adjustments).
  /// Returns the list of preparation steps to add.
  List<PreparationEntity> generatePreparation(
    List<PlayerEntity> players,
    List<TileModel> tiles,
  );
}
