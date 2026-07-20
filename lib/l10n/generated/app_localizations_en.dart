// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get colorWhite => 'white';

  @override
  String get colorRed => 'red';

  @override
  String get colorPurple => 'purple';

  @override
  String get colorYellow => 'yellow';

  @override
  String get villageBoardLabel => 'Take your village board';

  @override
  String villageBoardDetail(String color) {
    return 'Take the village board of color $color and place it in front of you. Your worker draw pile and water carrier track live there.';
  }

  @override
  String get waterCarrierLabel => 'Put your water carrier on the \"-10\" field';

  @override
  String waterCarrierDetail(String color) {
    return 'Take the water carrier of color $color and place it on the water field with the value \"-10\" of your village board.';
  }

  @override
  String get ownTilesLabel => 'Take all your worker tiles';

  @override
  String ownTilesDetail(String color) {
    return 'Gather all worker tiles with the $color back; they are your personal supply for the whole game.';
  }

  @override
  String removeWorkerLabel(String distribution) {
    return 'Return one $distribution worker tile to the box';
  }

  @override
  String removeWorkerDetail(String distribution) {
    return 'Search your worker tiles for one of the $distribution tiles and return it to the game box.';
  }

  @override
  String get removeWorkerRationale =>
      'With 3 or more players each player uses fewer worker tiles so the jungle does not run out before the game ends.';

  @override
  String get shuffleWorkersLabel => 'Shuffle your workers and draw 3';

  @override
  String get shuffleWorkersDetail =>
      'Each player mixes their worker tiles and puts them as a face-down worker draw pile next to their village board. After that, they draw the 3 top worker tiles from their worker draw pile and take them into their hand.';

  @override
  String get initialTilesMarketLabel => 'Place the 2 starting tiles diagonally';

  @override
  String get initialTilesMarketDetail =>
      'From the jungle tiles, get \"single plantation\" and \"market, selling price 2\" and place them face up in the middle of the table diagonally to one another; they form the starting tiles of the playing area.';

  @override
  String get junglePileLabel => 'Build the jungle draw pile';

  @override
  String get junglePileDetail =>
      'Mix the remaining jungle tiles and lay them out as a face-down jungle draw pile.';

  @override
  String get jungleDisplayLabel => 'Reveal 2 jungle tiles';

  @override
  String get jungleDisplayDetail =>
      'Draw the 2 top jungle tiles from the jungle draw pile and place them next to the pile as a face-up jungle display.';

  @override
  String get resourcesBankLabel => 'Lay out cacao, suns and the bank';

  @override
  String get resourcesBankDetail =>
      'Lay out the cacao fruits and the sun tokens as separate supply piles. Put the gold coins next to them to serve as the bank.';

  @override
  String removeTilesLabel(int quantity, String tileName) {
    return 'Return ${quantity}x $tileName to the box';
  }

  @override
  String removeTilesDetail(num quantity, String tileName) {
    String _temp0 = intl.Intl.pluralLogic(
      quantity,
      locale: localeName,
      other: 'Sort out ${quantity}x $tileName and put them back in the box.',
      one: 'Sort out ${quantity}x $tileName and put it back in the box.',
    );
    return '$_temp0';
  }

  @override
  String removeAllTilesLabel(String tileName) {
    return 'Return all $tileName tiles to the box';
  }

  @override
  String removeAllTilesDetail(String tileName) {
    return 'Sort out all $tileName tiles and put them back in the box.';
  }

  @override
  String addTilesLabel(int quantity, String tileName) {
    return 'Add ${quantity}x $tileName to the jungle tiles';
  }

  @override
  String addTilesDetail(int quantity, String tileName) {
    return 'Add ${quantity}x $tileName tiles to the jungle tiles before building the draw pile.';
  }

  @override
  String get twoPlayerRemovalRationale =>
      'With 2 players the jungle is reduced so the playing area stays tight and the game keeps its pace.';

  @override
  String get bigGame3pRemovalRationale =>
      'The Big Game with 3 players removes a few tiles so the huge tile pool stays balanced.';

  @override
  String get tileSinglePlantation => 'Single Plantation';

  @override
  String get tileDoublePlantation => 'Double Plantation';

  @override
  String get tileMarketSelling2 => 'Market, selling price 2';

  @override
  String get tileMarketSelling3 => 'Market, selling price 3';

  @override
  String get tileGoldMineV1 => 'Gold Mine, value 1';

  @override
  String get tileGoldMineV2 => 'Gold Mine, value 2';

  @override
  String get tileWater => 'Water';

  @override
  String get tileSunWorshipingSite => 'Sun-Worshiping Site';

  @override
  String get tileTemple => 'Temple';

  @override
  String get tileWatering => 'Watering';

  @override
  String get tileChocolateKitchen => 'Chocolate Kitchen';

  @override
  String get tileChocolateMarket => 'Chocolate Market';

  @override
  String get tileGemMine => 'Gem Mine';

  @override
  String get tileTreeOfLife => 'Tree of Life';

  @override
  String get mapTokensLabel => 'Take 2 map tiles';

  @override
  String mapTokensDetail(String color) {
    return 'Player $color takes 2 map tiles.';
  }

  @override
  String get mapTokensSurplusLabel => 'Return the surplus map tiles to the box';

  @override
  String get mapTokensSurplusDetail =>
      'Put the surplus map tiles back into the box.';

  @override
  String get mapBoardLabel => 'Place the map board';

  @override
  String get mapBoardDetail =>
      'Place the map board directly next to the jungle draw pile.';

  @override
  String get jungleDisplayMapLabel =>
      'Reveal 4 jungle tiles (map board + display)';

  @override
  String get jungleDisplayMapDetail =>
      'Draw the 4 top jungle tiles from the jungle draw pile. Lay the first two tiles face up on the marked spaces of the map board. Place the other two tiles as a face-up jungle display next to the map board.';

  @override
  String get initialTilesWaterLabel => 'Place the 2 starting tiles diagonally';

  @override
  String get initialTilesWaterDetail =>
      'From the jungle tiles, get \"single plantation\" and \"water\" tiles and place them face up in the middle of the table diagonally to one another; they form the starting tiles of the playing area.';

  @override
  String get initialTilesWaterRationale =>
      'The Watering module swaps the starting market for a water tile.';

  @override
  String get chocolateBarsLabel => 'Lay out the 20 chocolate bars';

  @override
  String get chocolateBarsDetail =>
      'Lay out the 20 chocolate bars as a separate supply pile next to the cacao fruits.';

  @override
  String get hutsMarketLabel => 'Throw the 12 hut tiles';

  @override
  String get hutsMarketDetail =>
      'Take the 12 hut tiles, drop them from a low height to randomly determine their face-up side, and sort them by building cost next to the bank as a supply.';

  @override
  String get hutsMarketRationale =>
      'Variant: alternatively, players can agree on a specific selection of huts instead of a random assortment.';

  @override
  String get gemsRemoveLabel => 'Return 8 gems to the box';

  @override
  String get gemsRemoveDetail =>
      'Remove 8 gems (2 of each color) and put them back into the box.';

  @override
  String get mineCarLabel => 'Fill and shake the mine car';

  @override
  String get mineCarAllDetail =>
      'Fill all 32 gems into the mine car and mix them by shaking. Place the mine car next to the playing area.';

  @override
  String get mineCarRemainingDetail =>
      'Fill the remaining gems into the mine car and mix them by shaking. Place the mine car next to the playing area.';

  @override
  String get masksLabel => 'Sort the masks as a supply';

  @override
  String get masksAllDetail =>
      'Sort the 7 masks by their values in an ascending, overlapping row as a supply.';

  @override
  String get masksWithout12Detail =>
      'Sort the masks (without the value 12 mask) by their values in an ascending, overlapping row as a supply.';

  @override
  String get gemMinesReminderLabel => 'Rule reminder: gems on new mines';

  @override
  String get gemMinesReminderDetail =>
      'As soon as a gem mine tile is placed in the jungle display or onto the map board, shake out 6 gems from the mine car and put them on the gem mine tile.';

  @override
  String get treeOfLife0004Label => 'Add your 0-0-0-4 worker tile';

  @override
  String treeOfLife0004Detail(String color) {
    return 'Tree of Life Module: Player $color takes their 0-0-0-4 worker tile from the New Workers Module and adds it to their worker tiles.';
  }

  @override
  String get treeOfLife0004Rationale =>
      'With 2 players the Tree of Life requires the 0-0-0-4 tile so every tree can be fully harvested (Diamante rulebook).';

  @override
  String get emperorLabel => 'Place the Emperor figure';

  @override
  String get emperorOnMarketDetail =>
      'After laying out the starting tiles, place the Emperor figure on the market, selling price 2.';

  @override
  String get emperorOnWaterDetail =>
      'After laying out the starting tiles, place the Emperor figure on the water tile.';

  @override
  String get newWorkersSelectionLabel => 'Choose the worker tiles';

  @override
  String get newWorkersSelectionDetail =>
      'Select which worker tiles you want to use for this game.';

  @override
  String get returnToBoxTitle => 'Return to the box';

  @override
  String get returnToBoxSubtitle => 'These tiles are not used in this game';

  @override
  String get allSetTitle => 'All set!';

  @override
  String get allSetMessage =>
      'The table is ready. May the best cacao farmer win!';

  @override
  String get drawFirstPlayerAction => 'Draw randomly instead';

  @override
  String get drawAgainAction => 'Draw again';

  @override
  String startsFirst(String name) {
    return '$name starts!';
  }

  @override
  String get backToGameAction => 'Back to the game';
}
