/// Every user-facing string of the preparation steps, centralized.
///
/// Handlers never contain literals: they call this catalog. When i18n
/// lands (roadmap: right after Fase UX-1) this is the only file that
/// migrates to ARB/gen-l10n.
///
/// Naming: `xxxLabel` is the one-line WHAT, `xxxDetail` the full HOW,
/// `xxxRationale` the optional WHY.
abstract final class PreparationCopy {
  // ---------------------------------------------------------------------
  // Player setup (base game)
  // ---------------------------------------------------------------------

  static const String villageBoardLabel = 'Take your village board';
  static String villageBoardDetail(String color) =>
      'Take the village board of color $color and place it in front of you. '
      'Your worker draw pile and water carrier track live there.';

  static const String waterCarrierLabel =
      'Put your water carrier on the "-10" field';
  static String waterCarrierDetail(String color) =>
      'Take the water carrier of color $color and place it on the water '
      'field with the value "-10" of your village board.';

  static const String ownTilesLabel = 'Take all your worker tiles';
  static String ownTilesDetail(String color) =>
      'Gather all worker tiles with the $color back; they are your personal '
      'supply for the whole game.';

  static String removeWorkerLabel(String distribution) =>
      'Return one $distribution worker tile to the box';
  static String removeWorkerDetail(String distribution) =>
      'Search your worker tiles for one of the $distribution tiles and '
      'return it to the game box.';
  static const String removeWorkerRationale =
      'With 3 or more players each player uses fewer worker tiles so the '
      'jungle does not run out before the game ends.';

  static const String shuffleWorkersLabel = 'Shuffle your workers and draw 3';
  static const String shuffleWorkersDetail =
      'Each player mixes their worker tiles and puts them as a face-down '
      'worker draw pile next to their village board. After that, they draw '
      'the 3 top worker tiles from their worker draw pile and take them '
      'into their hand.';

  // ---------------------------------------------------------------------
  // Board setup (base game)
  // ---------------------------------------------------------------------

  static const String initialTilesMarketLabel =
      'Place the 2 starting tiles diagonally';
  static const String initialTilesMarketDetail =
      'From the jungle tiles, get "single plantation" and "market, selling '
      'price 2" and place them face up in the middle of the table diagonally '
      'to one another; they form the starting tiles of the playing area.';

  static const String junglePileLabel = 'Build the jungle draw pile';
  static const String junglePileDetail =
      'Mix the remaining jungle tiles and lay them out as a face-down '
      'jungle draw pile.';

  static const String jungleDisplayLabel = 'Reveal 2 jungle tiles';
  static const String jungleDisplayDetail =
      'Draw the 2 top jungle tiles from the jungle draw pile and place them '
      'next to the pile as a face-up jungle display.';

  // ---------------------------------------------------------------------
  // Supplies (base game)
  // ---------------------------------------------------------------------

  static const String resourcesBankLabel = 'Lay out cacao, suns and the bank';
  static const String resourcesBankDetail =
      'Lay out the cacao fruits and the sun tokens as separate supply '
      'piles. Put the gold coins next to them to serve as the bank.';

  // ---------------------------------------------------------------------
  // Generic tile substitutions (shared by base + several modules)
  // ---------------------------------------------------------------------

  static String removeTilesLabel(int quantity, String tileName) =>
      'Return ${quantity}x $tileName to the box';
  static String removeTilesDetail(int quantity, String tileName) =>
      'Sort out ${quantity}x $tileName and put '
      '${quantity == 1 ? 'it' : 'them'} back in the box.';

  static String removeAllTilesLabel(String tileName) =>
      'Return all $tileName tiles to the box';
  static String removeAllTilesDetail(String tileName) =>
      'Sort out all $tileName tiles and put them back in the box.';

  static String addTilesLabel(int quantity, String tileName) =>
      'Add ${quantity}x $tileName to the jungle tiles';
  static String addTilesDetail(int quantity, String tileName) =>
      'Add ${quantity}x $tileName tiles to the jungle tiles before '
      'building the draw pile.';

  static const String twoPlayerRemovalRationale =
      'With 2 players the jungle is reduced so the playing area stays '
      'tight and the game keeps its pace.';
  static const String bigGame3pRemovalRationale =
      'The Big Game with 3 players removes a few tiles so the huge tile '
      'pool stays balanced.';

  // Tile display names used by removal/addition steps.
  static const String tileSinglePlantation = 'Single Plantation';
  static const String tileDoublePlantation = 'Double Plantation';
  static const String tileMarketSelling2 = 'Market, selling price 2';
  static const String tileMarketSelling3 = 'Market, selling price 3';
  static const String tileGoldMineV1 = 'Gold Mine, value 1';
  static const String tileGoldMineV2 = 'Gold Mine, value 2';
  static const String tileWater = 'Water';
  static const String tileSunWorshipingSite = 'Sun-Worshiping Site';
  static const String tileTemple = 'Temple';
  static const String tileWatering = 'Watering';
  static const String tileChocolateKitchen = 'Chocolate Kitchen';
  static const String tileChocolateMarket = 'Chocolate Market';
  static const String tileGemMine = 'Gem Mine';
  static const String tileTreeOfLife = 'Tree of Life';

  // ---------------------------------------------------------------------
  // Map module (Chocolatl, Module A)
  // ---------------------------------------------------------------------

  static const String mapTokensLabel = 'Take 2 map tiles';
  static String mapTokensDetail(String color) =>
      'Player $color takes 2 map tiles.';

  static const String mapTokensSurplusLabel =
      'Return the surplus map tiles to the box';
  static const String mapTokensSurplusDetail =
      'Put the surplus map tiles back into the box.';

  static const String mapBoardLabel = 'Place the map board';
  static const String mapBoardDetail =
      'Place the map board directly next to the jungle draw pile.';

  static const String jungleDisplayMapLabel =
      'Reveal 4 jungle tiles (map board + display)';
  static const String jungleDisplayMapDetail =
      'Draw the 4 top jungle tiles from the jungle draw pile. Lay the first '
      'two tiles face up on the marked spaces of the map board. Place the '
      'other two tiles as a face-up jungle display next to the map board.';

  // ---------------------------------------------------------------------
  // Watering module (Chocolatl, Module B)
  // ---------------------------------------------------------------------

  static const String initialTilesWaterLabel =
      'Place the 2 starting tiles diagonally';
  static const String initialTilesWaterDetail =
      'From the jungle tiles, get "single plantation" and "water" tiles and '
      'place them face up in the middle of the table diagonally to one '
      'another; they form the starting tiles of the playing area.';
  static const String initialTilesWaterRationale =
      'The Watering module swaps the starting market for a water tile.';

  // ---------------------------------------------------------------------
  // Chocolate module (Chocolatl, Module C)
  // ---------------------------------------------------------------------

  static const String chocolateBarsLabel = 'Lay out the 20 chocolate bars';
  static const String chocolateBarsDetail =
      'Lay out the 20 chocolate bars as a separate supply pile next to the '
      'cacao fruits.';

  // ---------------------------------------------------------------------
  // Huts module (Chocolatl, Module D)
  // ---------------------------------------------------------------------

  static const String hutsMarketLabel = 'Throw the 12 hut tiles';
  static const String hutsMarketDetail =
      'Take the 12 hut tiles, drop them from a low height to randomly '
      'determine their face-up side, and sort them by building cost next '
      'to the bank as a supply.';
  static const String hutsMarketRationale =
      'Variant: alternatively, players can agree on a specific selection '
      'of huts instead of a random assortment.';

  // ---------------------------------------------------------------------
  // Gem mines module (Diamante)
  // ---------------------------------------------------------------------

  static const String gemsRemoveLabel = 'Return 8 gems to the box';
  static const String gemsRemoveDetail =
      'Remove 8 gems (2 of each color) and put them back into the box.';

  static const String mineCarLabel = 'Fill and shake the mine car';
  static const String mineCarAllDetail =
      'Fill all 32 gems into the mine car and mix them by shaking. Place '
      'the mine car next to the playing area.';
  static const String mineCarRemainingDetail =
      'Fill the remaining gems into the mine car and mix them by shaking. '
      'Place the mine car next to the playing area.';

  static const String masksLabel = 'Sort the masks as a supply';
  static const String masksAllDetail =
      'Sort the 7 masks by their values in an ascending, overlapping row '
      'as a supply.';
  static const String masksWithout12Detail =
      'Sort the masks (without the value 12 mask) by their values in an '
      'ascending, overlapping row as a supply.';

  static const String gemMinesReminderLabel =
      'Rule reminder: gems on new mines';
  static const String gemMinesReminderDetail =
      'As soon as a gem mine tile is placed in the jungle display or onto '
      'the map board, shake out 6 gems from the mine car and put them on '
      'the gem mine tile.';

  // ---------------------------------------------------------------------
  // Tree of Life module (Diamante)
  // ---------------------------------------------------------------------

  static const String treeOfLife0004Label = 'Add your 0-0-0-4 worker tile';
  static String treeOfLife0004Detail(String color) =>
      'Tree of Life Module: Player $color takes their 0-0-0-4 worker tile '
      'from the New Workers Module and adds it to their worker tiles.';
  static const String treeOfLife0004Rationale =
      'With 2 players the Tree of Life requires the 0-0-0-4 tile so every '
      'tree can be fully harvested (Diamante rulebook).';

  // ---------------------------------------------------------------------
  // Emperor's Favor module (Diamante)
  // ---------------------------------------------------------------------

  static const String emperorLabel = 'Place the Emperor figure';
  static const String emperorOnMarketDetail =
      'After laying out the starting tiles, place the Emperor figure on '
      'the market, selling price 2.';
  static const String emperorOnWaterDetail =
      'After laying out the starting tiles, place the Emperor figure on '
      'the water tile.';

  // ---------------------------------------------------------------------
  // New Workers module (Diamante)
  // ---------------------------------------------------------------------

  static const String newWorkersSelectionLabel = 'Choose the worker tiles';
  static const String newWorkersSelectionDetail =
      'Select which worker tiles you want to use for this game.';

  // ---------------------------------------------------------------------
  // Preparation screen UI (group cards)
  // ---------------------------------------------------------------------

  static const String returnToBoxTitle = 'Return to the box';
  static const String returnToBoxSubtitle =
      'These tiles are not used in this game';
}
