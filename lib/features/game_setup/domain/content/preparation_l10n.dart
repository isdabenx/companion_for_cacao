import 'dart:ui';

import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';

/// Localized preparation content for the domain layer.
///
/// Handlers build steps at pipeline time, without a BuildContext, so they
/// receive this abstraction instead of calling `AppLocalizations.of`. The
/// single source of truth for every string is the ARB catalog
/// (`lib/l10n/app_*.arb`); this class only adapts it. UI code with a
/// context keeps using `AppLocalizations.of(context)` directly.
class PreparationL10n {
  const PreparationL10n(this._l10n);

  /// English fallback used as the default of handler constructors so
  /// domain tests need no wiring. Production injects the active locale
  /// via `preparationL10nProvider`.
  factory PreparationL10n.en() =>
      PreparationL10n(lookupAppLocalizations(const Locale('en')));

  factory PreparationL10n.forLocale(Locale locale) =>
      PreparationL10n(lookupAppLocalizations(locale));

  final AppLocalizations _l10n;

  /// Localized player color name for use inside step texts
  /// ("village board of color *red*" must translate the color too).
  String colorName(String color) => switch (color) {
    'white' => _l10n.colorWhite,
    'red' => _l10n.colorRed,
    'purple' => _l10n.colorPurple,
    'yellow' => _l10n.colorYellow,
    _ => color,
  };

  // Player setup (base game)
  String get villageBoardLabel => _l10n.villageBoardLabel;
  String villageBoardDetail(String color) =>
      _l10n.villageBoardDetail(colorName(color));
  String get waterCarrierLabel => _l10n.waterCarrierLabel;
  String waterCarrierDetail(String color) =>
      _l10n.waterCarrierDetail(colorName(color));
  String get ownTilesLabel => _l10n.ownTilesLabel;
  String ownTilesDetail(String color) => _l10n.ownTilesDetail(colorName(color));
  String removeWorkerLabel(String distribution) =>
      _l10n.removeWorkerLabel(distribution);
  String removeWorkerDetail(String distribution) =>
      _l10n.removeWorkerDetail(distribution);
  String get removeWorkerRationale => _l10n.removeWorkerRationale;
  String get shuffleWorkersLabel => _l10n.shuffleWorkersLabel;
  String get shuffleWorkersDetail => _l10n.shuffleWorkersDetail;

  // Board setup (base game)
  String get initialTilesMarketLabel => _l10n.initialTilesMarketLabel;
  String get initialTilesMarketDetail => _l10n.initialTilesMarketDetail;
  String get junglePileLabel => _l10n.junglePileLabel;
  String get junglePileDetail => _l10n.junglePileDetail;
  String get jungleDisplayLabel => _l10n.jungleDisplayLabel;
  String get jungleDisplayDetail => _l10n.jungleDisplayDetail;

  // Supplies (base game)
  String get resourcesBankLabel => _l10n.resourcesBankLabel;
  String get resourcesBankDetail => _l10n.resourcesBankDetail;

  // Generic tile substitutions
  String removeTilesLabel(int quantity, String tileName) =>
      _l10n.removeTilesLabel(quantity, tileName);
  String removeTilesDetail(int quantity, String tileName) =>
      _l10n.removeTilesDetail(quantity, tileName);
  String removeAllTilesLabel(String tileName) =>
      _l10n.removeAllTilesLabel(tileName);
  String removeAllTilesDetail(String tileName) =>
      _l10n.removeAllTilesDetail(tileName);
  String addTilesLabel(int quantity, String tileName) =>
      _l10n.addTilesLabel(quantity, tileName);
  String addTilesDetail(int quantity, String tileName) =>
      _l10n.addTilesDetail(quantity, tileName);
  String get twoPlayerRemovalRationale => _l10n.twoPlayerRemovalRationale;
  String get bigGame3pRemovalRationale => _l10n.bigGame3pRemovalRationale;

  // Tile display names
  String get tileSinglePlantation => _l10n.tileSinglePlantation;
  String get tileDoublePlantation => _l10n.tileDoublePlantation;
  String get tileMarketSelling2 => _l10n.tileMarketSelling2;
  String get tileMarketSelling3 => _l10n.tileMarketSelling3;
  String get tileGoldMineV1 => _l10n.tileGoldMineV1;
  String get tileGoldMineV2 => _l10n.tileGoldMineV2;
  String get tileWater => _l10n.tileWater;
  String get tileSunWorshipingSite => _l10n.tileSunWorshipingSite;
  String get tileTemple => _l10n.tileTemple;
  String get tileWatering => _l10n.tileWatering;
  String get tileChocolateKitchen => _l10n.tileChocolateKitchen;
  String get tileChocolateMarket => _l10n.tileChocolateMarket;
  String get tileGemMine => _l10n.tileGemMine;
  String get tileTreeOfLife => _l10n.tileTreeOfLife;

  // Map module
  String get mapTokensLabel => _l10n.mapTokensLabel;
  String mapTokensDetail(String color) =>
      _l10n.mapTokensDetail(colorName(color));
  String get mapTokensSurplusLabel => _l10n.mapTokensSurplusLabel;
  String get mapTokensSurplusDetail => _l10n.mapTokensSurplusDetail;
  String get mapBoardLabel => _l10n.mapBoardLabel;
  String get mapBoardDetail => _l10n.mapBoardDetail;
  String get jungleDisplayMapLabel => _l10n.jungleDisplayMapLabel;
  String get jungleDisplayMapDetail => _l10n.jungleDisplayMapDetail;

  // Watering module
  String get initialTilesWaterLabel => _l10n.initialTilesWaterLabel;
  String get initialTilesWaterDetail => _l10n.initialTilesWaterDetail;
  String get initialTilesWaterRationale => _l10n.initialTilesWaterRationale;

  // Chocolate module
  String get chocolateBarsLabel => _l10n.chocolateBarsLabel;
  String get chocolateBarsDetail => _l10n.chocolateBarsDetail;

  // Huts module
  String get hutsMarketLabel => _l10n.hutsMarketLabel;
  String get hutsMarketDetail => _l10n.hutsMarketDetail;
  String get hutsMarketRationale => _l10n.hutsMarketRationale;

  // Gem mines module
  String get gemsRemoveLabel => _l10n.gemsRemoveLabel;
  String get gemsRemoveDetail => _l10n.gemsRemoveDetail;
  String get mineCarLabel => _l10n.mineCarLabel;
  String get mineCarAllDetail => _l10n.mineCarAllDetail;
  String get mineCarRemainingDetail => _l10n.mineCarRemainingDetail;
  String get masksLabel => _l10n.masksLabel;
  String get masksAllDetail => _l10n.masksAllDetail;
  String get masksWithout12Detail => _l10n.masksWithout12Detail;
  String get gemMinesReminderLabel => _l10n.gemMinesReminderLabel;
  String get gemMinesReminderDetail => _l10n.gemMinesReminderDetail;

  // Tree of Life module
  String get treeOfLife0004Label => _l10n.treeOfLife0004Label;
  String treeOfLife0004Detail(String color) =>
      _l10n.treeOfLife0004Detail(colorName(color));
  String get treeOfLife0004Rationale => _l10n.treeOfLife0004Rationale;

  // Emperor's Favor module
  String get emperorLabel => _l10n.emperorLabel;
  String get emperorOnMarketDetail => _l10n.emperorOnMarketDetail;
  String get emperorOnWaterDetail => _l10n.emperorOnWaterDetail;

  // New Workers module
  String get newWorkersSelectionLabel => _l10n.newWorkersSelectionLabel;
  String get newWorkersSelectionDetail => _l10n.newWorkersSelectionDetail;
}
