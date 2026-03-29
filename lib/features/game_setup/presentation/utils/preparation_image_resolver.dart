import 'package:companion_for_cacao/config/constants/assets.dart';

/// Extension to resolve image keys to actual asset paths.
/// Maps domain-level image identifiers to presentation-layer asset paths.
extension PreparationImageResolver on String {
  /// Resolves an image key to its full asset path.
  ///
  /// Image key mapping:
  /// - 'village_board_$color' -> village board asset
  /// - 'carrier_$color' -> water carrier asset
  /// - 'tile_back_$color' -> tile back asset
  /// - 'tile_$filename' -> tile asset path
  /// - 'initial_tiles_cacao' -> initial tiles cacao asset
  /// - 'resources_cacao' -> cacao resources asset
  /// - 'resources_chocolate' -> chocolate bars asset
  /// - 'map_token' -> map token asset
  /// - 'map_board' -> map board asset
  /// - 'initial_tiles_watering' -> initial tiles watering asset
  String toAssetPath() => switch (this) {
    final s when s.startsWith('village_board_') =>
      '${Assets.preparationVillagePrefix}${s.replaceFirst('village_board_', '')}${Assets.preparationVillageSufix}',
    final s when s.startsWith('carrier_') =>
      '${Assets.preparationCarrierPrefix}${s.replaceFirst('carrier_', '')}${Assets.preparationCarrierSufix}',
    final s when s.startsWith('tile_back_') =>
      '${Assets.preparationTilePrefix}${s.replaceFirst('tile_back_', '')}${Assets.preparationTileSufix}',
    final s when s.startsWith('tile_') =>
      '${Assets.imagesTilePath}${s.replaceFirst('tile_', '')}',
    'initial_tiles_cacao' => Assets.preparationInitialTilesCacao,
    'resources_cacao' => Assets.preparationResourcesCacao,
    'resources_chocolate' => Assets.preparationChocolateBar,
    'map_token' => Assets.preparationMapToken,
    'map_board' => Assets.preparationMapBoard,
    'initial_tiles_watering' => Assets.preparationInitialTilesWatering,
    _ => this,
  };
}
