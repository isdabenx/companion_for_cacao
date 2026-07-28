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
  String get villageBoardDetailAll =>
      'Each player takes the village board of their colour and places it in front of them. Their worker draw pile and water carrier track live there.';

  @override
  String villageBoardDetail(String color) {
    return 'Take the village board of color $color and place it in front of you. Your worker draw pile and water carrier track live there.';
  }

  @override
  String get waterCarrierLabel => 'Put your water carrier on the \"-10\" field';

  @override
  String get waterCarrierDetailAll =>
      'Each player takes the water carrier of their colour and places it on the \"-10\" water field of their village board.';

  @override
  String waterCarrierDetail(String color) {
    return 'Take the water carrier of color $color and place it on the water field with the value \"-10\" of your village board.';
  }

  @override
  String get ownTilesLabel => 'Take all your worker tiles';

  @override
  String get ownTilesDetailAll =>
      'Each player gathers all worker tiles with their colour on the back; they are their personal supply for the whole game.';

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
  String removeWorkerDetailAll(String distribution) {
    return 'Each player searches their worker tiles for one of the $distribution tiles and returns it to the game box.';
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
  String get jungleGroupTitle => 'The jungle';

  @override
  String get gatherJungleLabel => 'Gather the jungle tiles';

  @override
  String get gatherJungleDetail =>
      'Take all the base-game jungle tiles; you\'ll then modify them (remove/add) and form the pile.';

  @override
  String get junglePileLabel => 'Shuffle and form the pile';

  @override
  String get junglePileDetail =>
      'Shuffle all the jungle tiles face-down and form the pile, next to the board.';

  @override
  String junglePurgeLabel(String expansion) {
    return 'If you keep $expansion mixed in';
  }

  @override
  String junglePurgeDetail(String expansion, String tiles) {
    return 'This game doesn\'t use these $expansion jungle tiles: $tiles. If you store them mixed with the base game, take them out before forming the pile.';
  }

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
  String get mapTokensDetailAll => 'Each player takes 2 map tiles.';

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
  String get treeOfLife0004DetailAll =>
      'Tree of Life Module: each player takes the 0-0-0-4 worker tile of their colour (from the New Workers Module) and adds it to their worker tiles.';

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
  String get newWorkersBuildLabel => 'Build the worker pile';

  @override
  String get newWorkersBuildDetail =>
      'Each player takes the tiles shown from each source.';

  @override
  String get workerBuildFromBase => 'From the base game, take:';

  @override
  String get workerBuildFromExpansion => 'From the Diamante expansion, take:';

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

  @override
  String get menuHome => 'Home';

  @override
  String get menuGameSetup => 'Game Setup';

  @override
  String get menuTiles => 'Tiles';

  @override
  String get menuScores => 'Scores';

  @override
  String get menuRules => 'Rules';

  @override
  String get titlePreparation => 'Preparation';

  @override
  String get titleGameDashboard => 'Game Dashboard';

  @override
  String get phaseTilePool => 'Tile Pool';

  @override
  String get phasePlayerSetup => 'Player Setup';

  @override
  String get phaseBoardSetup => 'Board Setup';

  @override
  String get phaseSupplies => 'Supplies';

  @override
  String get playersSection => 'Players';

  @override
  String get expansionsSection => 'Expansions';

  @override
  String get modulesSection => 'Modules';

  @override
  String needMorePlayers(int count) {
    return 'Need $count+';
  }

  @override
  String get tapColorHint =>
      'Tap a color to add a player. Hold and drag to reorder.';

  @override
  String get selectExpansionsHint =>
      'Select the expansions you\'re playing with';

  @override
  String get selectModulesHint => 'Select the modules you\'re playing with';

  @override
  String get noExpansionWithModules => 'No expansion with modules are selected';

  @override
  String get noModules => 'No modules';

  @override
  String get startGame => 'Start Game';

  @override
  String get resumeGame => 'Resume Game';

  @override
  String get clearSetup => 'Clear Setup';

  @override
  String get gameVariant => 'Game Variant';

  @override
  String get bigGame => 'Big Game';

  @override
  String get bigGameHint =>
      'Use all tiles from all modules without substitutions';

  @override
  String get showAllTiles => 'Show All Tiles';

  @override
  String get hideTiles => 'Hide Tiles';

  @override
  String get tilesInPlay => 'Tiles in Play';

  @override
  String get scoreCalculator => 'Score Calculator';

  @override
  String get noPlayersSelected => 'No players selected';

  @override
  String get noTiles => 'No tiles';

  @override
  String get baseGameOnly => 'Base game only';

  @override
  String playerPosition(int position) {
    return 'Player $position';
  }

  @override
  String get closeAction => 'Close';

  @override
  String get workerSheetTitle => 'The New Workers';

  @override
  String get workerChooseIntro =>
      'Choose which worker tiles each player will use. All players use the same set.';

  @override
  String get workerHowItWorks => 'How does it work?';

  @override
  String get workerHelpBody =>
      '• The New Workers adds 4 new worker tiles with distributions different from the base game ones.\n• You can use a quick preset or manually adjust the quantity of each tile.\n• The balance between workers and jungle tiles matters: if the difference falls outside the indicated range, the game may feel unbalanced.\n• By default, the game recommends keeping 11 tiles per player, but you can add more for a longer game.';

  @override
  String get workerPresetsSection => 'Presets';

  @override
  String get workerRandomSection => 'Random';

  @override
  String get workerPresetBaseOnly => 'Base only';

  @override
  String get workerPresetReplace => 'Replace';

  @override
  String get workerPresetBase0004 => 'Base + 0-0-0-4';

  @override
  String get workerPresetAddAll => 'Add all';

  @override
  String get workerAddAllDefault => 'Add all (default)';

  @override
  String get workerManual => 'Manual';

  @override
  String get workerSurprise => 'Surprise';

  @override
  String get workerSurpriseChip => 'Surprise +2';

  @override
  String get workerSurpriseTooltip =>
      'Base + 2 new tiles picked at random. Tap again for a different pair.';

  @override
  String get workerDescBaseOnly =>
      'Uses only the base game tiles (11 per player). The new Diamante tiles are not added.';

  @override
  String get workerDescReplace =>
      'Replaces 4 base tiles (1-1-1-1) with the 4 new Diamante ones. Total: 11 per player.';

  @override
  String get workerDescBase0004 =>
      'Adds only the 0-0-0-4 tile to the 11 base tiles. Total: 12 per player. Recommended by the community (BGG).';

  @override
  String get workerDescAddAll =>
      'Adds the 4 new Diamante tiles to the 11 base ones. Total: 15 per player.';

  @override
  String get workerDescManual =>
      'Manual selection: adjust the quantity of each tile individually.';

  @override
  String get workerDescSurprise =>
      'Surprise: base tiles + 2 new Diamante tiles picked at random. Tap again for a different pair.';

  @override
  String workerCustomPreset(String name) {
    return 'Custom preset: $name';
  }

  @override
  String workerSummaryLine(String label, int count) {
    return '$label · $count tiles/player';
  }

  @override
  String get workerBaseTiles => 'Base tiles';

  @override
  String get workerNewTiles => 'New tiles (Diamante)';

  @override
  String get workerBalanceOk => 'Balance is fine';

  @override
  String get workerBalanceOut => 'Outside recommended range';

  @override
  String get workerBalanceValid => 'Valid';

  @override
  String get workerBalanceOutShort => 'Out of range';

  @override
  String get workerBalanceHint =>
      'The rulebook recommends this margin to keep the game balanced, but you can still apply the selection.';

  @override
  String get workerBalanceWorkersWord => 'workers';

  @override
  String get workerBalanceJungleWord => 'jungle';

  @override
  String workerBalanceRange(int min, int max) {
    return '(range: $min–$max)';
  }

  @override
  String workerTilesPerPlayerLine(int count) {
    return 'Tiles per player: $count';
  }

  @override
  String get workerLockedTooltip => 'Required by Tree of Life (2 players)';

  @override
  String get resetAction => 'Reset';

  @override
  String get applyAction => 'Apply';

  @override
  String get workerSelectionResetNotice =>
      'You changed the workers: build the pile again.';

  @override
  String get saveAction => 'Save';

  @override
  String get deleteAction => 'Delete';

  @override
  String get savePresetTitle => 'Save as preset';

  @override
  String get presetNameLabel => 'Preset name';

  @override
  String get presetNameHint => 'e.g. Our favorite';

  @override
  String get deletePresetTitle => 'Delete preset';

  @override
  String deletePresetConfirm(String name) {
    return 'Delete \'$name\'?';
  }

  @override
  String get errorLoadingPresets => 'Error loading custom presets';

  @override
  String get errorSavingPresets => 'Error saving custom presets';

  @override
  String get hutRegisterTitle => 'Register the hut throw';

  @override
  String get hutRegisterHint =>
      'Tap each hut face that landed up. Impossible ones disappear on their own.';

  @override
  String get hutRegisterAction => 'Register which huts landed face up';

  @override
  String get hutRegisteredEdit => 'Throw registered · tap to edit';

  @override
  String get forgetThrowAction => 'Forget throw';

  @override
  String get guidedModeTooltip => 'Guided mode: one step at a time';

  @override
  String get listModeTooltip => 'Checklist mode';

  @override
  String get guidedBack => 'Back';

  @override
  String get guidedNext => 'Next';

  @override
  String guidedPendingSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count steps left — go to the first',
      one: '1 step left — go to it',
    );
    return '$_temp0';
  }

  @override
  String get hutMarketCrier => 'Market Crier';

  @override
  String get hutHermit => 'Hermit';

  @override
  String get hutRoadWorker => 'Road Worker';

  @override
  String get hutTrader => 'Trader';

  @override
  String get hutFarmer => 'Farmer';

  @override
  String get hutShaman => 'Shaman';

  @override
  String get hutMonk => 'Monk';

  @override
  String get hutMasterBuilder => 'Master Builder';

  @override
  String get hutForeman => 'Foreman';

  @override
  String get hutFountainMaster => 'Fountain Master';

  @override
  String get hutChiefsDaughter => 'Chief\'s Daughter';

  @override
  String get hutChiefsSon => 'Chief\'s Son';

  @override
  String get hutChiefsWife => 'Chief\'s Wife';

  @override
  String get hutChief => 'Chief';

  @override
  String get menuTitle => 'Menu';

  @override
  String get summaryTiles => 'Tiles';

  @override
  String get summaryWorkers => 'Workers';

  @override
  String get summaryJungle => 'Jungle';

  @override
  String get summaryHuts => 'Huts';

  @override
  String get tileMarketSelling4 => 'Market, selling price 4';

  @override
  String get boardgameCacao => 'Cacao';

  @override
  String get boardgameChocolatl => 'Cacao: Chocolatl';

  @override
  String get boardgameDiamante => 'Cacao: Diamante';

  @override
  String get expansionNameChocolatl => 'Chocolatl';

  @override
  String get expansionNameDiamante => 'Diamante';

  @override
  String get moduleMaps => 'Map Module';

  @override
  String get moduleWatering => 'Watering Module';

  @override
  String get moduleChocolate => 'Chocolate Module';

  @override
  String get moduleHuts => 'Hut Module';

  @override
  String get moduleGemMines => 'The Gem Mines';

  @override
  String get moduleTreeOfLife => 'The Tree of Life';

  @override
  String get moduleEmperorsFavor => 'The Favor of the Emperor';

  @override
  String get moduleNewWorkers => 'The New Workers';

  @override
  String get moduleDescMaps =>
      'Two extra jungle tiles lie face up on the map board next to the draw pile. When refilling jungle spaces, you may return 1 of your map tiles to the box to pick a tile from the map board instead of the display.';

  @override
  String get moduleDescWatering =>
      'Three watering tiles replace plantations: their workers move your water carrier backwards, granting 4 cacao fruits per water field. A water tile replaces the market as the second starting tile.';

  @override
  String get moduleDescChocolate =>
      'Chocolate kitchens and chocolate markets replace gold mines and price-3 markets: turn cacao fruits into chocolate bars and sell them for up to 7 gold.';

  @override
  String get moduleDescHuts =>
      '12 double-sided hut tiles wait next to the bank, sorted by cost. At the end of your turn you may build one, paying gold you already own; at game end each hut refunds its cost and grants its bonus.';

  @override
  String get moduleDescGemMines =>
      'Five gem mines replace the temples. Activated workers collect gems from the mine car; a set of the 4 colors trades immediately for the lowest-value mask. Masks and leftover gems are worth gold.';

  @override
  String get moduleDescTreeOfLife =>
      'Three Trees of Life replace the gold mines: each adjacent worker takes 1 gold — but strength lies in serenity: an adjacent edge with no workers takes 3 gold.';

  @override
  String get moduleDescEmperorsFavor =>
      'The Emperor starts on the market with selling price 2. Placing a worker tile in his row or column moves him onto it and pays 1 gold — and 1 more at the start of each of your turns while he still stands there.';

  @override
  String get moduleDescNewWorkers =>
      '16 worker tiles with new distributions (0-0-2-2, 0-2-0-2, 0-1-0-3, 0-0-0-4). Agree on any mix with the base tiles — every player uses the same set.';

  @override
  String tileDescWorker(String distribution, String color) {
    return 'Worker tile $distribution for the $color player.';
  }

  @override
  String get tileDesc_base_jungle_single_plantation =>
      'For each of your activated workers on the adjacent edge of the tile, you may take **1 cacao fruit** from the supply. You put them individually on 1 unoccupied storage space on your village board. Each player has 5 storage spaces and may never store more than *5 cacao* fruits; any additional fruits that you acquire go to waste.\n\n![Take cacao](resource:assets/images/tiles/description/plantation.webp)';

  @override
  String get tileDesc_base_jungle_double_plantation =>
      'For each of your activated workers on the adjacent edge of the tile, you may take **2 cacao fruits** from the supply. You put them individually on 1 unoccupied storage space on your village board. Each player has 5 storage spaces and may never store more than *5 cacao* fruits; any additional fruits that you acquire go to waste.\n\n![Take cacao](resource:assets/images/tiles/description/plantation.webp)';

  @override
  String get tileDesc_base_jungle_market_selling_2 =>
      'For each of your activated workers on the adjacent edge of the tile, you may sell **1 cacao** fruit from your storage at the price indicated on the market. You put the cacao fruit back in the supply and then take **2 gold** from the bank.\n\n![Put the cacao](resource:assets/images/tiles/description/market1.webp)\n\n![Take money](resource:assets/images/tiles/description/market2.webp)';

  @override
  String get tileDesc_base_jungle_market_selling_3 =>
      'For each of your activated workers on the adjacent edge of the tile, you may sell **1 cacao** fruit from your storage at the price indicated on the market. You put the cacao fruit back in the supply and then take **3 gold** from the bank.\n\n![Put the cacao](resource:assets/images/tiles/description/market1.webp)\n\n![Take money](resource:assets/images/tiles/description/market2.webp)';

  @override
  String get tileDesc_base_jungle_market_selling_4 =>
      'For each of your activated workers on the adjacent edge of the tile, you may sell **1 cacao** fruit from your storage at the price indicated on the market. You put the cacao fruit back in the supply and then take **4 gold** from the bank.\n\n![Put the cacao](resource:assets/images/tiles/description/market1.webp)\n\n![Take money](resource:assets/images/tiles/description/market2.webp)';

  @override
  String get tileDesc_base_jungle_gold_mine_value_1 =>
      'For each of your activated workers on the adjacent edge of the tile, you may take the value indicated – that is, either **1 gold** – from the bank.\n\n![Take money](resource:assets/images/tiles/description/gold_mine.webp)';

  @override
  String get tileDesc_base_jungle_gold_mine_value_2 =>
      'For each of your activated workers on the adjacent edge of the tile, you may take the value indicated – that is, either **2 gold** – from the bank.\n\n![Take money](resource:assets/images/tiles/description/gold_mine.webp)';

  @override
  String get tileDesc_base_jungle_water =>
      'For each of your activated workers on the adjacent edge of the tile, you may move the water carrier on your village board 1 water field ahead in a clockwise direction. If the water carrier reaches the water field with the value \"16,\" he stops there; any possible further steps go to waste. \n\nAt the end of the game, you add to your gold coins the value of the water field on which your water carrier is standing. If the water carrier is still standing on a field with a negative value, you have to deduct the applicable number.\n\n![Move the water carrier](resource:assets/images/tiles/description/water.webp)';

  @override
  String get tileDesc_base_jungle_sun_worshiping_site =>
      'For each of your activated workers on the adjacent edge of the tile, you may take 1 sun token from the supply. You put it on an unoccupied sun-worshiping place on your village board. Each player has 3 sun-worshiping places and may never own more than 3 sun tokens. Sun tokens that you might get beyond that go to waste. \n\nTowards the end of the game, you can use sun tokens to \"overbuild\" one of your **own** worker tiles. At the end of the game, you get 1 gold from the bank for each sun token you have not used.\n\n![Take sun token](resource:assets/images/tiles/description/sun_worshiping_site1.webp) \n\n**OVERBUILDING A WORKER TILE**\n\n When the jungle draw pile has been depleted towards the end of the game and there are no jungle tiles left in the jungle display, you may, from now on, overbuild one of your **own** worker tiles, instead of adding it to the playing area in the usual way; for this, you have to put 1 sun token back in the supply. Choose 1 worker tile from your hand and put it **on top** of one of your **own** worker tiles that you placed earlier. After that, you carry out the actions of the adjacent jungle tiles for the activated workers. If you don\'t own any sun token, you cannot overbuild and have to place the new worker tile as usual.\n\n **Important:** Each worker tile may be overbuilt only **once**. ***Example:***\n\n *It is Red\'s turn. The jungle draw pile has been depleted and the jungle display is empty. Therefore, he is allowed to overbuild: He puts 1 sun token from one of his sun-worshiping places back in the supply; after that, he overbuilds 1 of his own worker tiles. He puts the new worker tile on top of the tile placed on an earlier turn and carries out the actions of the adjacent jungle tiles. First, he takes 2 cacao fruits for the worker at the double plantation and places them on two of his storage spaces. After that, he sells the two cacao fruits at the market for 2x4 = 8 gold. Finally, he moves his water carrier 1 space ahead.*';

  @override
  String get tileDesc_base_jungle_temple =>
      'The temples have no direct effect during the game. Only at the end of the game are the temples scored, individually, one after another. The player who has the most workers adjacent to the respective temple receives 6 gold from the bank. The player with the second most adjacent workers obtains 3 gold. If there is a tie for first place, 6 gold are evenly distributed among the players involved (and rounded down, if necessary). In this case, there is no gold awarded for second place. In case first place is clear but there is a tie for second place, 3 gold are evenly distributed among the players involved (and rounded down, if necessary). \n\n**Attention:** If any worker tiles adjacent to the temple have been overbuilt, only the worker tiles on top count for the scoring. \n\n**Note:** If there is only 1 player with workers adjacent to the temple, he gets 6 gold from the bank, as usual; no gold is awarded for second place. You need to have at least 1 worker adjacent to the temple in order to score for it. \n\n***Example:***\n\n *Yellow and Red both have 2 workers at this temple. Consequently, they share 6 gold for first place; each of them gets 3 gold from the bank. Purple has 1 worker at this temple. However, he goes away empty-handed, since second place is not awarded in this case.*\n\n![Temple](resource:assets/images/tiles/description/temple.webp)';

  @override
  String get tileDesc_chocolatl_jungle_watering =>
      'For each of your activated workers on the adjacent edge of the tile, you may move back the water carrier on your village board 1 water field in an anti-clockwise direction. For each water field that you move your water carrier back, you take 4 cacao fruits from the supply and put them on unoccupied storage spaces on your village board. If your water carrier is standing on the water field with the value “-10”, you can\'t get any fruit.\n\n**Attention:** Any additional cacao fruit that you would get goes to waste, as usual. Therefore, it doesn’t make sense to connect tile edges that have more than 1 worker to a watering tile.';

  @override
  String get tileDesc_chocolatl_jungle_chocolate_kitchen =>
      'For each of your activated workers on the adjacent edge of the tile, you may turn 1 cacao fruit from your storage into 1 chocolate bar. Put the cacao fruit back into the supply. After that, you take the chocolate bar from the supply and put it on an unoccupied storage space on your village board.\nEach storage space may be used either for 1 cacao fruit or for 1 chocolate bar.\n\n**END GAME**\n**Attention:** Leftover chocolate bars don\'t give you any gold at the end of the game.';

  @override
  String get tileDesc_chocolatl_jungle_chocolate_market =>
      'For each of your activated workers on the adjacent edge of the tile, you may sell 1 cacao fruit from your storage for 3 gold, or 1 chocolate bar from your storage for 7 gold. Put the cacao fruit or the chocolate bar back into the supply and then take the applicable amount of gold from the bank.\nIf you have activated more than 1 worker, you may choose for each of the activated workers individually whether you want to sell 1 cacao fruit or 1 chocolate bar.';

  @override
  String get tileDesc_diamante_jungle_gem_mine =>
      'For each of your activated workers on the adjacent edge of the tile, you may take 1 gem of your choice from this gem mine. Place the gems next to your village board.\n\nAs soon as you have at least 1 gem in each of the 4 colours, you **must immediately** exchange this set of 4 gems for the mask with the lowest value available from the supply. Remove the exchanged gems from the game and put them back into the box.';

  @override
  String get tileDesc_diamante_jungle_tree_of_life =>
      'For each of your activated workers on the adjacent edge of the tile, you may take 1 gold from the bank.\n\nBut strength lies in serenity: If there are no workers depicted on the adjacent edge of the tile, you may even take 3 gold from the bank.';

  @override
  String get tileDesc_chocolatl_hut_market_crier =>
      '**Building Cost:** 4 gold\n\n**Function:** Throughout the game, you sell your cacao fruits at adjacent markets with a selling price of 2 for 3 gold instead of for 2.\n\n**End of Game:** Add the building cost (4 gold) to your total gold.';

  @override
  String get tileDesc_chocolatl_hut_hermit =>
      '**Building Cost:** 6 gold\n\n**Function:** 1 gold for each of your workers that doesn\'t have an adjacent jungle tile at the end of the game.\n\n**End of Game:** Add the building cost (6 gold) plus the bonus to your total gold.';

  @override
  String get tileDesc_chocolatl_hut_road_worker =>
      '**Building Cost:** 6 gold\n\n**Function:** At the end of the game, you obtain 1 gold for each of your worker tiles in the row or column where you have the most of your worker tiles.\n\n**End of Game:** Add the building cost (6 gold) plus the bonus to your total gold.';

  @override
  String get tileDesc_chocolatl_hut_trader =>
      '**Building Cost:** 6 gold\n\n**Function:** Leftover cacao fruits in your own storage give you 1 gold each at the end of the game.\n\n**End of Game:** Add the building cost (6 gold) plus the bonus to your total gold.';

  @override
  String get tileDesc_chocolatl_hut_farmer =>
      '**Building Cost:** 8 gold\n\n**Function:** Whenever you get exactly 4 cacao fruits on one turn during the game, you receive 1 more cacao fruit, provided you have enough space left in your storage.\n\n**End of Game:** Add the building cost (8 gold) to your total gold.';

  @override
  String get tileDesc_chocolatl_hut_shaman =>
      '**Building Cost:** 8 gold\n\n**Function:** If you overbuild one of your worker tiles during the game, you don\'t have to put any sun token back into the supply for this.\n\n**End of Game:** Add the building cost (8 gold) to your total gold.';

  @override
  String get tileDesc_chocolatl_hut_monk =>
      '**Building Cost:** 10 gold\n\n**Function:** 1 gold at the end of the game for each temple you have at least 1 worker adjacent to.\n\n**End of Game:** Add the building cost (10 gold) plus the bonus to your total gold.';

  @override
  String get tileDesc_chocolatl_hut_master_builder =>
      '**Building Cost:** 10 gold\n\n**Function:** At the end of the game, you obtain 1 gold for each of your other huts.\n\n**End of Game:** Add the building cost (10 gold) plus the bonus to your total gold.';

  @override
  String get tileDesc_chocolatl_hut_foreman =>
      '**Building Cost:** 12 gold\n\n**Function:**  When you play a worker tile with 3 workers on one edge during the game, it is counted as having an additional 4th worker on that edge.\n\n**End of Game:** Add the building cost (12 gold) to your total gold.';

  @override
  String get tileDesc_chocolatl_hut_fountain_master =>
      '**Building Cost:** 12 gold\n\n**Function:** 4 gold at the end of the game if your own water carrier is standing on the water field with the value “16”.\n\n**End of Game:** Add the building cost (12 gold) plus the bonus (if applicable) to your total gold.';

  @override
  String get tileDesc_chocolatl_hut_chiefs_daughter =>
      '**Building Cost:** 14 gold\n\n**Function:** 4 gold at the end of the game.\n\n**End of Game:** Add the building cost (14 gold) plus the bonus (4 gold) to your total gold.';

  @override
  String get tileDesc_chocolatl_hut_chiefs_son =>
      '**Building Cost:** 16 gold\n\n**Function:** 4 gold at the end of the game.\n\n**End of Game:** Add the building cost (16 gold) plus the bonus (4 gold) to your total gold.';

  @override
  String get tileDesc_chocolatl_hut_chiefs_wife =>
      '**Building Cost:** 20 gold\n\n**Function:** 5 gold at the end of the game.\n\n**End of Game:** Add the building cost (20 gold) plus the bonus (5 gold) to your total gold.';

  @override
  String get tileDesc_chocolatl_hut_chief =>
      '**Building Cost:** 24 gold\n\n**Function:** 6 gold at the end of the game.\n\n**End of Game:** Add the building cost (24 gold) plus the bonus (6 gold) to your total gold.';

  @override
  String get tileTypePlayer => 'Player';

  @override
  String get tileTypeMarket => 'Market';

  @override
  String get tileTypePlantation => 'Plantation';

  @override
  String get tileTypeGoldMine => 'Gold Mine';

  @override
  String get tileTypeWater => 'Water';

  @override
  String get tileTypeTemple => 'Temple';

  @override
  String get tileTypeSunWorshipingSite => 'Sun-Worshiping Site';

  @override
  String get tileTypeWatering => 'Watering';

  @override
  String get tileTypeChocolateKitchen => 'Chocolate Kitchen';

  @override
  String get tileTypeChocolateMarket => 'Chocolate Market';

  @override
  String get tileTypeMapTile => 'Map Tile';

  @override
  String get tileTypeHut => 'Hut';

  @override
  String get tileTypeGemMine => 'Gem Mine';

  @override
  String get tileTypeTreeOfLife => 'Tree of Life';

  @override
  String get filterSheetTitle => 'Filters';

  @override
  String get clearAllAction => 'Clear all';

  @override
  String get searchTileHint => 'Search tile by name...';

  @override
  String get tileTypesSection => 'Tile types';

  @override
  String get filterTilesTooltip => 'Filter tiles';

  @override
  String get displaySettingsTooltip => 'Display settings';

  @override
  String activeFiltersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count filters active',
      one: '1 filter active',
    );
    return '$_temp0';
  }

  @override
  String costLabel(int cost) {
    return 'Cost: $cost';
  }

  @override
  String get settingsSheetTitle => 'Settings';

  @override
  String get settingsGeneralSection => 'General';

  @override
  String get settingsBadgesSection => 'Badges';

  @override
  String get settingsPlayerColorsSection => 'Player colors';

  @override
  String get settingBoardgameTitle => 'Boardgame title';

  @override
  String get settingShowQuantity => 'Show quantity';

  @override
  String get settingCompactLayout => 'Compact layout';

  @override
  String get settingBadgeTypeInText => 'Badge tile type in text';

  @override
  String get settingBadgeTypeInImage => 'Badge tile type in image';

  @override
  String get settingPlayerColorInBorder => 'Player color in border';

  @override
  String get settingPlayerColorInCircle => 'Player color in circle';

  @override
  String get scoreStepSetup => 'Players & Modules';

  @override
  String get scoreCatGold => 'Accumulated Gold';

  @override
  String get scoreCatWater => 'Water Track';

  @override
  String get scoreCatTemples => 'Temples';

  @override
  String get scoreCatSun => 'Sun Tokens';

  @override
  String get scoreCatCacao => 'Leftover Cacao';

  @override
  String get scoreCatHuts => 'Huts';

  @override
  String get scoreCatGemMines => 'Gem Mines';

  @override
  String get startOverAction => 'Start over';

  @override
  String get startOverTitle => 'Start over?';

  @override
  String get startOverBody =>
      'This discards all entered scores and reloads players and modules from the current game setup.';

  @override
  String get scoreClearBlankBody =>
      'This discards all entered scores and leaves the calculator empty.';

  @override
  String get scoreContextGame => 'Scoring the game in progress';

  @override
  String get scoreContextDetached => 'Separate calculation';

  @override
  String get scoreBackToGameAction => 'Back to the game';

  @override
  String get scoreResetChooseBody =>
      'Reset the scoring for this game, or start a separate, empty calculation?';

  @override
  String get scoreResetGameOption => 'Reset the game scoring';

  @override
  String get scoreClearBlankOption => 'Clear everything (separate calculation)';

  @override
  String get backAction => 'Back';

  @override
  String get nextAction => 'Next';

  @override
  String get resultsAction => 'Results';

  @override
  String get needTwoPlayers => 'Select at least 2 players';

  @override
  String get scoreSetupIntro => 'Select the players of the finished game.';

  @override
  String get scoreModulesIntro => 'Modules that change the final scoring:';

  @override
  String get scoreHutModuleSubtitle =>
      'Chocolatl: built huts refund their cost and give bonuses';

  @override
  String get scoreGemModuleSubtitle =>
      'Diamante: gem mines replace the temples';

  @override
  String get scoreGoldIntro =>
      'Count the gold coins each player has. Tap the number for direct entry.';

  @override
  String get scoreWaterIntro =>
      'Select the water field where each water carrier ended the game. Negative fields subtract gold.';

  @override
  String get scoreTemplesIntro =>
      'Add one entry per temple and count the workers adjacent to it. Gold is awarded automatically: 6 for first place, 3 for second, ties split rounded down.';

  @override
  String get scoreSunIntro =>
      'Sun tokens not used for overbuilding are worth 1 gold each (maximum 3).';

  @override
  String get scoreCacaoIntro =>
      'Leftover cacao fruits give no gold, but they decide ties: with equal gold, the player with most cacao left wins.';

  @override
  String get scoreHutsIntro =>
      'Mark the huts each player built. Building costs are refunded and bonuses added automatically. Huts are limited physical tiles: a grayed-out hut has no tile left (deselect it from its owner to reassign it).';

  @override
  String get scoreGemsIntro =>
      'Tap a mask tile and pick who owns it. Masks add their value in gold.';

  @override
  String get scoreGemsLeftoverIntro =>
      'Leftover gems next to each village board (1 gold each):';

  @override
  String get addTempleAction => 'Add temple';

  @override
  String get removeTempleTooltip => 'Remove temple';

  @override
  String templeNumber(int number) {
    return 'Temple $number';
  }

  @override
  String hutsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count huts',
      one: '1 hut',
    );
    return '$_temp0';
  }

  @override
  String scoreHermitCount(String hutName) {
    return '$hutName: own workers with no adjacent jungle tile';
  }

  @override
  String scoreRoadWorkerCount(String hutName) {
    return '$hutName: worker tiles in your best row or column';
  }

  @override
  String get assignMaskTooltip => 'Assign mask';

  @override
  String get nobodyOption => 'Nobody';

  @override
  String get enterValueTitle => 'Enter value';

  @override
  String get okAction => 'OK';

  @override
  String get finalScoreTitle => 'Final Score';

  @override
  String get winsTheGameSingle => 'wins the game!';

  @override
  String get winsTheGameShared => 'win the game!';

  @override
  String get sharedVictorySubtitle =>
      'Shared victory! Tied on gold and leftover cacao.';

  @override
  String get tiebreakSubtitle => 'Tie on gold broken by leftover cacao fruits.';

  @override
  String get leftoverCacaoTiebreaker => 'Leftover cacao (tiebreaker)';

  @override
  String get homeIntro =>
      'Companion for Cacao is a mobile application developed with Flutter designed to assist players of the Cacao board game and its expansions. The goal is to provide digital tools that enhance the gaming experience by facilitating score tracking, rule consultation, and game management.';

  @override
  String get homeCompletedFeaturesTitle => 'Completed Features';

  @override
  String get homePendingFeaturesTitle => 'Pending Features';

  @override
  String get homeCompletedFeatures =>
      '🏠 Main Menu: Quick access to all functionalities.\n🗂 Tile Database: Comprehensive catalog of tiles.\n🔍 Tile Filtering: Search and filter by multiple criteria.\n🌴 Cacao Base Game: Full support and game setup.\n🍫 Chocolatl Expansion: Full support including all 4 modules.\n🚀 Diamante Expansion: Full support including all 4 modules.\n🎲 Game Dashboard: Summary, preparation, and tiles in play.\n🌟 Big Game Variant: Integration of all modules and expansions.\n📖 Integrated Manuals: Read the game rules.\n🏆 Score Calculator: Automatic final scoring with official tie rules.\n🌐 Multi-language Support: Catalan, Spanish and English.\n📊 Adaptive UI: Optimized design for different screen sizes.\n🔄 Auto-Updater: Automatic detection of new versions.';

  @override
  String get homePendingFeatures =>
      '🕒 Turn Timer: Control the duration of each turn.\n📜 Game History: Record of finished games and player stats.\n⚙️ Custom Settings: Adjust the game experience.';

  @override
  String get homeContactTitle => 'Contact Me';

  @override
  String get homeContactBody =>
      'For suggestions, improvements, bug reports, or any other inquiries, you can visit our GitHub repository. The application is open-source and we are always looking for contributors to help improve it.';

  @override
  String get homeVisitRepo => 'Visit our GitHub repository:';

  @override
  String get homeGithubBody =>
      'On GitHub, you can open \"issues\" to report bugs, suggest new features, or even submit \"pull requests\" with your own contributions. We strive to constantly improve the app and appreciate any help!';

  @override
  String get rulesBaseGame => 'Base Game';

  @override
  String get rulesInstructions => 'Instructions';

  @override
  String get rulesOverview => 'Overview';

  @override
  String rulesExpansionHeader(String name) {
    return 'Expansion: $name';
  }

  @override
  String rulesExpansionRules(String name) {
    return '$name Rules';
  }

  @override
  String get openMenuTooltip => 'Open menu';

  @override
  String get quantityAll => 'ALL';

  @override
  String get errorGenericRetry => 'Something went wrong. Please try again.';

  @override
  String get pageNotFoundTitle => 'Page Not Found';

  @override
  String routeNotFound(String uri) {
    return 'Route not found: $uri';
  }

  @override
  String get errorTitle => 'Error';

  @override
  String get invalidDataMessage => 'Invalid data for this screen.';

  @override
  String get retryAction => 'Retry';

  @override
  String get playerNameHint => 'Name';

  @override
  String get aboutIntro =>
      'Digital tools for Cacao players and its expansions: game setup, score counting and rules lookup, all in one place.';

  @override
  String get aboutOpenSource => 'Open source';

  @override
  String get aboutIncludedTitle => 'What\'s included';

  @override
  String get aboutInDevelopmentTitle => 'In development';

  @override
  String get aboutSoonBadge => 'soon';

  @override
  String get aboutRepoTitle => 'GitHub repository';

  @override
  String get aboutRepoSubtitle =>
      'Report bugs, suggest improvements or contribute';

  @override
  String get aboutMadeWith => 'Made with Flutter';

  @override
  String get aboutFeaturePrep => 'Guided setup';

  @override
  String get aboutFeaturePrepSub =>
      'Step by step for the base game and expansions';

  @override
  String get aboutFeatureScore => 'Score calculator';

  @override
  String get aboutFeatureScoreSub =>
      'Final score with the official tiebreakers';

  @override
  String get aboutFeatureTiles => 'Tile catalogue';

  @override
  String get aboutFeatureTilesSub => 'Search and filter by multiple criteria';

  @override
  String get aboutFeatureRules => 'Rules and manuals';

  @override
  String get aboutFeatureRulesSub => 'Built-in lookup inside the app';

  @override
  String get aboutFeatureExpansions => 'Full expansions';

  @override
  String get aboutFeatureExpansionsSub =>
      'Xocolatl, Diamante and the Big Game variant';

  @override
  String get aboutFeatureLangs => 'Multi-language';

  @override
  String get aboutFeatureLangsSub => 'Catalan, Spanish and English';

  @override
  String get aboutSoonTimer => 'Turn timer';

  @override
  String get aboutSoonHistory => 'History and statistics';

  @override
  String get aboutSoonSettings => 'Custom settings';

  @override
  String get homeCardSetupSub => 'Set up players, expansions and modules';

  @override
  String get homeCardTilesSub => 'Browse the full tile catalogue';

  @override
  String get homeCardScoresSub => 'Compute the final score automatically';

  @override
  String get homeCardRulesSub => 'Built-in manuals and quick reference';

  @override
  String get homeAboutTitle => 'About the app';

  @override
  String get homeTagline => 'Your table-side companion for Cacao';

  @override
  String get loadingLabel => 'Loading…';

  @override
  String get scoreTemplesEmpty =>
      'No temples yet — add one for each temple on the board.';

  @override
  String get expansionsModulesSection => 'Expansions and modules';

  @override
  String get expansionSelectHint =>
      'Tap an expansion to turn it on and pick its modules.';

  @override
  String get expansionTapHint => 'Tap to pick its modules';

  @override
  String get modulesPickLabel => 'Choose modules';

  @override
  String moduleCountLabel(int count, int total) {
    return '$count / $total modules';
  }

  @override
  String get cancelAction => 'Cancel';

  @override
  String get clearSetupBody =>
      'This clears the selected players, expansions and modules.';

  @override
  String get moduleWarningPickOne => 'Pick at least one module';

  @override
  String get expansionNeedsModuleHint => 'An expansion has no modules selected';

  @override
  String get playersNeededHint => 'Add at least 2 players';
}
