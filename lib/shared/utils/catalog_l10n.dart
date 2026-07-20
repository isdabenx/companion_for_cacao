import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/module_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';

/// Localized names and descriptions for the static catalog (boardgames,
/// modules and tiles), resolved by stable id through the ARB catalog.
///
/// The database keeps only identity data; every user-visible catalog
/// string lives in `lib/l10n/app_*.arb` under keys derived from the
/// stable ids (`tileDesc_<id>`, `boardgameX`, `moduleX`). Unknown ids
/// fall back to the seeded English fields so a stale database row can
/// never crash the UI.
extension TileCatalogL10n on TileEntity {
  String localizedName(AppLocalizations l10n) => switch (id) {
    'base.jungle_single_plantation' => l10n.tileSinglePlantation,
    'base.jungle_double_plantation' => l10n.tileDoublePlantation,
    'base.jungle_market_selling_2' => l10n.tileMarketSelling2,
    'base.jungle_market_selling_3' => l10n.tileMarketSelling3,
    'base.jungle_market_selling_4' => l10n.tileMarketSelling4,
    'base.jungle_gold_mine_value_1' => l10n.tileGoldMineV1,
    'base.jungle_gold_mine_value_2' => l10n.tileGoldMineV2,
    'base.jungle_water' => l10n.tileWater,
    'base.jungle_sun_worshiping_site' => l10n.tileSunWorshipingSite,
    'base.jungle_temple' => l10n.tileTemple,
    'chocolatl.jungle_watering' => l10n.tileWatering,
    'chocolatl.jungle_chocolate_kitchen' => l10n.tileChocolateKitchen,
    'chocolatl.jungle_chocolate_market' => l10n.tileChocolateMarket,
    'chocolatl.hut_market_crier' => l10n.hutMarketCrier,
    'chocolatl.hut_hermit' => l10n.hutHermit,
    'chocolatl.hut_road_worker' => l10n.hutRoadWorker,
    'chocolatl.hut_trader' => l10n.hutTrader,
    'chocolatl.hut_farmer' => l10n.hutFarmer,
    'chocolatl.hut_shaman' => l10n.hutShaman,
    'chocolatl.hut_monk' => l10n.hutMonk,
    'chocolatl.hut_master_builder' => l10n.hutMasterBuilder,
    'chocolatl.hut_foreman' => l10n.hutForeman,
    'chocolatl.hut_fountain_master' => l10n.hutFountainMaster,
    'chocolatl.hut_chiefs_daughter' => l10n.hutChiefsDaughter,
    'chocolatl.hut_chiefs_son' => l10n.hutChiefsSon,
    'chocolatl.hut_chiefs_wife' => l10n.hutChiefsWife,
    'chocolatl.hut_chief' => l10n.hutChief,
    'diamante.jungle_gem_mine' => l10n.tileGemMine,
    'diamante.jungle_tree_of_life' => l10n.tileTreeOfLife,
    // Worker tiles keep their distribution pattern (e.g. "1-1-1-1"),
    // which is language-neutral.
    _ => name,
  };

  String localizedDescription(AppLocalizations l10n) {
    if (type == TileType.player) {
      final colorName = color?.localizedName(l10n);
      if (colorName != null) return l10n.tileDescWorker(name, colorName);
    }
    return switch (id) {
      'base.jungle_single_plantation' =>
        l10n.tileDesc_base_jungle_single_plantation,
      'base.jungle_double_plantation' =>
        l10n.tileDesc_base_jungle_double_plantation,
      'base.jungle_market_selling_2' =>
        l10n.tileDesc_base_jungle_market_selling_2,
      'base.jungle_market_selling_3' =>
        l10n.tileDesc_base_jungle_market_selling_3,
      'base.jungle_market_selling_4' =>
        l10n.tileDesc_base_jungle_market_selling_4,
      'base.jungle_gold_mine_value_1' =>
        l10n.tileDesc_base_jungle_gold_mine_value_1,
      'base.jungle_gold_mine_value_2' =>
        l10n.tileDesc_base_jungle_gold_mine_value_2,
      'base.jungle_water' => l10n.tileDesc_base_jungle_water,
      'base.jungle_sun_worshiping_site' =>
        l10n.tileDesc_base_jungle_sun_worshiping_site,
      'base.jungle_temple' => l10n.tileDesc_base_jungle_temple,
      'chocolatl.jungle_watering' => l10n.tileDesc_chocolatl_jungle_watering,
      'chocolatl.jungle_chocolate_kitchen' =>
        l10n.tileDesc_chocolatl_jungle_chocolate_kitchen,
      'chocolatl.jungle_chocolate_market' =>
        l10n.tileDesc_chocolatl_jungle_chocolate_market,
      'chocolatl.hut_market_crier' => l10n.tileDesc_chocolatl_hut_market_crier,
      'chocolatl.hut_hermit' => l10n.tileDesc_chocolatl_hut_hermit,
      'chocolatl.hut_road_worker' => l10n.tileDesc_chocolatl_hut_road_worker,
      'chocolatl.hut_trader' => l10n.tileDesc_chocolatl_hut_trader,
      'chocolatl.hut_farmer' => l10n.tileDesc_chocolatl_hut_farmer,
      'chocolatl.hut_shaman' => l10n.tileDesc_chocolatl_hut_shaman,
      'chocolatl.hut_monk' => l10n.tileDesc_chocolatl_hut_monk,
      'chocolatl.hut_master_builder' =>
        l10n.tileDesc_chocolatl_hut_master_builder,
      'chocolatl.hut_foreman' => l10n.tileDesc_chocolatl_hut_foreman,
      'chocolatl.hut_fountain_master' =>
        l10n.tileDesc_chocolatl_hut_fountain_master,
      'chocolatl.hut_chiefs_daughter' =>
        l10n.tileDesc_chocolatl_hut_chiefs_daughter,
      'chocolatl.hut_chiefs_son' => l10n.tileDesc_chocolatl_hut_chiefs_son,
      'chocolatl.hut_chiefs_wife' => l10n.tileDesc_chocolatl_hut_chiefs_wife,
      'chocolatl.hut_chief' => l10n.tileDesc_chocolatl_hut_chief,
      'diamante.jungle_gem_mine' => l10n.tileDesc_diamante_jungle_gem_mine,
      'diamante.jungle_tree_of_life' =>
        l10n.tileDesc_diamante_jungle_tree_of_life,
      _ => description,
    };
  }
}

extension TileColorL10n on TileColor {
  String localizedName(AppLocalizations l10n) => switch (this) {
    TileColor.red => l10n.colorRed,
    TileColor.purple => l10n.colorPurple,
    TileColor.white => l10n.colorWhite,
    TileColor.yellow => l10n.colorYellow,
  };
}

extension TileTypeL10n on TileType {
  String localizedName(AppLocalizations l10n) => switch (this) {
    TileType.player => l10n.tileTypePlayer,
    TileType.market => l10n.tileTypeMarket,
    TileType.plantation => l10n.tileTypePlantation,
    TileType.goldMine => l10n.tileTypeGoldMine,
    TileType.water => l10n.tileTypeWater,
    TileType.temple => l10n.tileTypeTemple,
    TileType.sunWorshipingSite => l10n.tileTypeSunWorshipingSite,
    TileType.watering => l10n.tileTypeWatering,
    TileType.chocolateKitchen => l10n.tileTypeChocolateKitchen,
    TileType.chocolateMarket => l10n.tileTypeChocolateMarket,
    TileType.mapTile => l10n.tileTypeMapTile,
    TileType.hut => l10n.tileTypeHut,
    TileType.gemMine => l10n.tileTypeGemMine,
    TileType.treeOfLife => l10n.tileTypeTreeOfLife,
  };
}

extension BoardgameCatalogL10n on BoardgameEntity {
  String localizedName(AppLocalizations l10n) => switch (id) {
    1 => l10n.boardgameCacao,
    2 => l10n.boardgameChocolatl,
    3 => l10n.boardgameDiamante,
    _ => name,
  };
}

extension ModuleCatalogL10n on ModuleEntity {
  String localizedName(AppLocalizations l10n) => switch (id) {
    1 => l10n.moduleMaps,
    2 => l10n.moduleWatering,
    3 => l10n.moduleChocolate,
    4 => l10n.moduleHuts,
    5 => l10n.moduleGemMines,
    6 => l10n.moduleTreeOfLife,
    7 => l10n.moduleEmperorsFavor,
    8 => l10n.moduleNewWorkers,
    _ => name,
  };

  String localizedDescription(AppLocalizations l10n) => switch (id) {
    1 => l10n.moduleDescMaps,
    2 => l10n.moduleDescWatering,
    3 => l10n.moduleDescChocolate,
    4 => l10n.moduleDescHuts,
    5 => l10n.moduleDescGemMines,
    6 => l10n.moduleDescTreeOfLife,
    7 => l10n.moduleDescEmperorsFavor,
    8 => l10n.moduleDescNewWorkers,
    _ => description,
  };
}
