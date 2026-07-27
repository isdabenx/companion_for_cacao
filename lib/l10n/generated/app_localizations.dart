import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ca.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ca'),
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @colorWhite.
  ///
  /// In en, this message translates to:
  /// **'white'**
  String get colorWhite;

  /// No description provided for @colorRed.
  ///
  /// In en, this message translates to:
  /// **'red'**
  String get colorRed;

  /// No description provided for @colorPurple.
  ///
  /// In en, this message translates to:
  /// **'purple'**
  String get colorPurple;

  /// No description provided for @colorYellow.
  ///
  /// In en, this message translates to:
  /// **'yellow'**
  String get colorYellow;

  /// No description provided for @villageBoardLabel.
  ///
  /// In en, this message translates to:
  /// **'Take your village board'**
  String get villageBoardLabel;

  /// No description provided for @villageBoardDetailAll.
  ///
  /// In en, this message translates to:
  /// **'Each player takes the village board of their colour and places it in front of them. Their worker draw pile and water carrier track live there.'**
  String get villageBoardDetailAll;

  /// No description provided for @villageBoardDetail.
  ///
  /// In en, this message translates to:
  /// **'Take the village board of color {color} and place it in front of you. Your worker draw pile and water carrier track live there.'**
  String villageBoardDetail(String color);

  /// No description provided for @waterCarrierLabel.
  ///
  /// In en, this message translates to:
  /// **'Put your water carrier on the \"-10\" field'**
  String get waterCarrierLabel;

  /// No description provided for @waterCarrierDetailAll.
  ///
  /// In en, this message translates to:
  /// **'Each player takes the water carrier of their colour and places it on the \"-10\" water field of their village board.'**
  String get waterCarrierDetailAll;

  /// No description provided for @waterCarrierDetail.
  ///
  /// In en, this message translates to:
  /// **'Take the water carrier of color {color} and place it on the water field with the value \"-10\" of your village board.'**
  String waterCarrierDetail(String color);

  /// No description provided for @ownTilesLabel.
  ///
  /// In en, this message translates to:
  /// **'Take all your worker tiles'**
  String get ownTilesLabel;

  /// No description provided for @ownTilesDetailAll.
  ///
  /// In en, this message translates to:
  /// **'Each player gathers all worker tiles with their colour on the back; they are their personal supply for the whole game.'**
  String get ownTilesDetailAll;

  /// No description provided for @ownTilesDetail.
  ///
  /// In en, this message translates to:
  /// **'Gather all worker tiles with the {color} back; they are your personal supply for the whole game.'**
  String ownTilesDetail(String color);

  /// No description provided for @removeWorkerLabel.
  ///
  /// In en, this message translates to:
  /// **'Return one {distribution} worker tile to the box'**
  String removeWorkerLabel(String distribution);

  /// No description provided for @removeWorkerDetail.
  ///
  /// In en, this message translates to:
  /// **'Search your worker tiles for one of the {distribution} tiles and return it to the game box.'**
  String removeWorkerDetail(String distribution);

  /// No description provided for @removeWorkerDetailAll.
  ///
  /// In en, this message translates to:
  /// **'Each player searches their worker tiles for one of the {distribution} tiles and returns it to the game box.'**
  String removeWorkerDetailAll(String distribution);

  /// No description provided for @removeWorkerRationale.
  ///
  /// In en, this message translates to:
  /// **'With 3 or more players each player uses fewer worker tiles so the jungle does not run out before the game ends.'**
  String get removeWorkerRationale;

  /// No description provided for @shuffleWorkersLabel.
  ///
  /// In en, this message translates to:
  /// **'Shuffle your workers and draw 3'**
  String get shuffleWorkersLabel;

  /// No description provided for @shuffleWorkersDetail.
  ///
  /// In en, this message translates to:
  /// **'Each player mixes their worker tiles and puts them as a face-down worker draw pile next to their village board. After that, they draw the 3 top worker tiles from their worker draw pile and take them into their hand.'**
  String get shuffleWorkersDetail;

  /// No description provided for @initialTilesMarketLabel.
  ///
  /// In en, this message translates to:
  /// **'Place the 2 starting tiles diagonally'**
  String get initialTilesMarketLabel;

  /// No description provided for @initialTilesMarketDetail.
  ///
  /// In en, this message translates to:
  /// **'From the jungle tiles, get \"single plantation\" and \"market, selling price 2\" and place them face up in the middle of the table diagonally to one another; they form the starting tiles of the playing area.'**
  String get initialTilesMarketDetail;

  /// No description provided for @jungleGroupTitle.
  ///
  /// In en, this message translates to:
  /// **'The jungle'**
  String get jungleGroupTitle;

  /// No description provided for @gatherJungleLabel.
  ///
  /// In en, this message translates to:
  /// **'Gather the jungle tiles'**
  String get gatherJungleLabel;

  /// No description provided for @gatherJungleDetail.
  ///
  /// In en, this message translates to:
  /// **'Take all the base-game jungle tiles; you\'ll then modify them (remove/add) and form the pile.'**
  String get gatherJungleDetail;

  /// No description provided for @junglePileLabel.
  ///
  /// In en, this message translates to:
  /// **'Shuffle and form the pile'**
  String get junglePileLabel;

  /// No description provided for @junglePileDetail.
  ///
  /// In en, this message translates to:
  /// **'Shuffle all the jungle tiles face-down and form the pile, next to the board.'**
  String get junglePileDetail;

  /// No description provided for @junglePurgeLabel.
  ///
  /// In en, this message translates to:
  /// **'If you keep {expansion} mixed in'**
  String junglePurgeLabel(String expansion);

  /// No description provided for @junglePurgeDetail.
  ///
  /// In en, this message translates to:
  /// **'This game doesn\'t use these {expansion} jungle tiles: {tiles}. If you store them mixed with the base game, take them out before forming the pile.'**
  String junglePurgeDetail(String expansion, String tiles);

  /// No description provided for @jungleDisplayLabel.
  ///
  /// In en, this message translates to:
  /// **'Reveal 2 jungle tiles'**
  String get jungleDisplayLabel;

  /// No description provided for @jungleDisplayDetail.
  ///
  /// In en, this message translates to:
  /// **'Draw the 2 top jungle tiles from the jungle draw pile and place them next to the pile as a face-up jungle display.'**
  String get jungleDisplayDetail;

  /// No description provided for @resourcesBankLabel.
  ///
  /// In en, this message translates to:
  /// **'Lay out cacao, suns and the bank'**
  String get resourcesBankLabel;

  /// No description provided for @resourcesBankDetail.
  ///
  /// In en, this message translates to:
  /// **'Lay out the cacao fruits and the sun tokens as separate supply piles. Put the gold coins next to them to serve as the bank.'**
  String get resourcesBankDetail;

  /// No description provided for @removeTilesLabel.
  ///
  /// In en, this message translates to:
  /// **'Return {quantity}x {tileName} to the box'**
  String removeTilesLabel(int quantity, String tileName);

  /// No description provided for @removeTilesDetail.
  ///
  /// In en, this message translates to:
  /// **'{quantity, plural, =1{Sort out {quantity}x {tileName} and put it back in the box.} other{Sort out {quantity}x {tileName} and put them back in the box.}}'**
  String removeTilesDetail(num quantity, String tileName);

  /// No description provided for @removeAllTilesLabel.
  ///
  /// In en, this message translates to:
  /// **'Return all {tileName} tiles to the box'**
  String removeAllTilesLabel(String tileName);

  /// No description provided for @removeAllTilesDetail.
  ///
  /// In en, this message translates to:
  /// **'Sort out all {tileName} tiles and put them back in the box.'**
  String removeAllTilesDetail(String tileName);

  /// No description provided for @addTilesLabel.
  ///
  /// In en, this message translates to:
  /// **'Add {quantity}x {tileName} to the jungle tiles'**
  String addTilesLabel(int quantity, String tileName);

  /// No description provided for @addTilesDetail.
  ///
  /// In en, this message translates to:
  /// **'Add {quantity}x {tileName} tiles to the jungle tiles before building the draw pile.'**
  String addTilesDetail(int quantity, String tileName);

  /// No description provided for @twoPlayerRemovalRationale.
  ///
  /// In en, this message translates to:
  /// **'With 2 players the jungle is reduced so the playing area stays tight and the game keeps its pace.'**
  String get twoPlayerRemovalRationale;

  /// No description provided for @bigGame3pRemovalRationale.
  ///
  /// In en, this message translates to:
  /// **'The Big Game with 3 players removes a few tiles so the huge tile pool stays balanced.'**
  String get bigGame3pRemovalRationale;

  /// No description provided for @tileSinglePlantation.
  ///
  /// In en, this message translates to:
  /// **'Single Plantation'**
  String get tileSinglePlantation;

  /// No description provided for @tileDoublePlantation.
  ///
  /// In en, this message translates to:
  /// **'Double Plantation'**
  String get tileDoublePlantation;

  /// No description provided for @tileMarketSelling2.
  ///
  /// In en, this message translates to:
  /// **'Market, selling price 2'**
  String get tileMarketSelling2;

  /// No description provided for @tileMarketSelling3.
  ///
  /// In en, this message translates to:
  /// **'Market, selling price 3'**
  String get tileMarketSelling3;

  /// No description provided for @tileGoldMineV1.
  ///
  /// In en, this message translates to:
  /// **'Gold Mine, value 1'**
  String get tileGoldMineV1;

  /// No description provided for @tileGoldMineV2.
  ///
  /// In en, this message translates to:
  /// **'Gold Mine, value 2'**
  String get tileGoldMineV2;

  /// No description provided for @tileWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get tileWater;

  /// No description provided for @tileSunWorshipingSite.
  ///
  /// In en, this message translates to:
  /// **'Sun-Worshiping Site'**
  String get tileSunWorshipingSite;

  /// No description provided for @tileTemple.
  ///
  /// In en, this message translates to:
  /// **'Temple'**
  String get tileTemple;

  /// No description provided for @tileWatering.
  ///
  /// In en, this message translates to:
  /// **'Watering'**
  String get tileWatering;

  /// No description provided for @tileChocolateKitchen.
  ///
  /// In en, this message translates to:
  /// **'Chocolate Kitchen'**
  String get tileChocolateKitchen;

  /// No description provided for @tileChocolateMarket.
  ///
  /// In en, this message translates to:
  /// **'Chocolate Market'**
  String get tileChocolateMarket;

  /// No description provided for @tileGemMine.
  ///
  /// In en, this message translates to:
  /// **'Gem Mine'**
  String get tileGemMine;

  /// No description provided for @tileTreeOfLife.
  ///
  /// In en, this message translates to:
  /// **'Tree of Life'**
  String get tileTreeOfLife;

  /// No description provided for @mapTokensLabel.
  ///
  /// In en, this message translates to:
  /// **'Take 2 map tiles'**
  String get mapTokensLabel;

  /// No description provided for @mapTokensDetail.
  ///
  /// In en, this message translates to:
  /// **'Player {color} takes 2 map tiles.'**
  String mapTokensDetail(String color);

  /// No description provided for @mapTokensDetailAll.
  ///
  /// In en, this message translates to:
  /// **'Each player takes 2 map tiles.'**
  String get mapTokensDetailAll;

  /// No description provided for @mapTokensSurplusLabel.
  ///
  /// In en, this message translates to:
  /// **'Return the surplus map tiles to the box'**
  String get mapTokensSurplusLabel;

  /// No description provided for @mapTokensSurplusDetail.
  ///
  /// In en, this message translates to:
  /// **'Put the surplus map tiles back into the box.'**
  String get mapTokensSurplusDetail;

  /// No description provided for @mapBoardLabel.
  ///
  /// In en, this message translates to:
  /// **'Place the map board'**
  String get mapBoardLabel;

  /// No description provided for @mapBoardDetail.
  ///
  /// In en, this message translates to:
  /// **'Place the map board directly next to the jungle draw pile.'**
  String get mapBoardDetail;

  /// No description provided for @jungleDisplayMapLabel.
  ///
  /// In en, this message translates to:
  /// **'Reveal 4 jungle tiles (map board + display)'**
  String get jungleDisplayMapLabel;

  /// No description provided for @jungleDisplayMapDetail.
  ///
  /// In en, this message translates to:
  /// **'Draw the 4 top jungle tiles from the jungle draw pile. Lay the first two tiles face up on the marked spaces of the map board. Place the other two tiles as a face-up jungle display next to the map board.'**
  String get jungleDisplayMapDetail;

  /// No description provided for @initialTilesWaterLabel.
  ///
  /// In en, this message translates to:
  /// **'Place the 2 starting tiles diagonally'**
  String get initialTilesWaterLabel;

  /// No description provided for @initialTilesWaterDetail.
  ///
  /// In en, this message translates to:
  /// **'From the jungle tiles, get \"single plantation\" and \"water\" tiles and place them face up in the middle of the table diagonally to one another; they form the starting tiles of the playing area.'**
  String get initialTilesWaterDetail;

  /// No description provided for @initialTilesWaterRationale.
  ///
  /// In en, this message translates to:
  /// **'The Watering module swaps the starting market for a water tile.'**
  String get initialTilesWaterRationale;

  /// No description provided for @chocolateBarsLabel.
  ///
  /// In en, this message translates to:
  /// **'Lay out the 20 chocolate bars'**
  String get chocolateBarsLabel;

  /// No description provided for @chocolateBarsDetail.
  ///
  /// In en, this message translates to:
  /// **'Lay out the 20 chocolate bars as a separate supply pile next to the cacao fruits.'**
  String get chocolateBarsDetail;

  /// No description provided for @hutsMarketLabel.
  ///
  /// In en, this message translates to:
  /// **'Throw the 12 hut tiles'**
  String get hutsMarketLabel;

  /// No description provided for @hutsMarketDetail.
  ///
  /// In en, this message translates to:
  /// **'Take the 12 hut tiles, drop them from a low height to randomly determine their face-up side, and sort them by building cost next to the bank as a supply.'**
  String get hutsMarketDetail;

  /// No description provided for @hutsMarketRationale.
  ///
  /// In en, this message translates to:
  /// **'Variant: alternatively, players can agree on a specific selection of huts instead of a random assortment.'**
  String get hutsMarketRationale;

  /// No description provided for @gemsRemoveLabel.
  ///
  /// In en, this message translates to:
  /// **'Return 8 gems to the box'**
  String get gemsRemoveLabel;

  /// No description provided for @gemsRemoveDetail.
  ///
  /// In en, this message translates to:
  /// **'Remove 8 gems (2 of each color) and put them back into the box.'**
  String get gemsRemoveDetail;

  /// No description provided for @mineCarLabel.
  ///
  /// In en, this message translates to:
  /// **'Fill and shake the mine car'**
  String get mineCarLabel;

  /// No description provided for @mineCarAllDetail.
  ///
  /// In en, this message translates to:
  /// **'Fill all 32 gems into the mine car and mix them by shaking. Place the mine car next to the playing area.'**
  String get mineCarAllDetail;

  /// No description provided for @mineCarRemainingDetail.
  ///
  /// In en, this message translates to:
  /// **'Fill the remaining gems into the mine car and mix them by shaking. Place the mine car next to the playing area.'**
  String get mineCarRemainingDetail;

  /// No description provided for @masksLabel.
  ///
  /// In en, this message translates to:
  /// **'Sort the masks as a supply'**
  String get masksLabel;

  /// No description provided for @masksAllDetail.
  ///
  /// In en, this message translates to:
  /// **'Sort the 7 masks by their values in an ascending, overlapping row as a supply.'**
  String get masksAllDetail;

  /// No description provided for @masksWithout12Detail.
  ///
  /// In en, this message translates to:
  /// **'Sort the masks (without the value 12 mask) by their values in an ascending, overlapping row as a supply.'**
  String get masksWithout12Detail;

  /// No description provided for @gemMinesReminderLabel.
  ///
  /// In en, this message translates to:
  /// **'Rule reminder: gems on new mines'**
  String get gemMinesReminderLabel;

  /// No description provided for @gemMinesReminderDetail.
  ///
  /// In en, this message translates to:
  /// **'As soon as a gem mine tile is placed in the jungle display or onto the map board, shake out 6 gems from the mine car and put them on the gem mine tile.'**
  String get gemMinesReminderDetail;

  /// No description provided for @treeOfLife0004Label.
  ///
  /// In en, this message translates to:
  /// **'Add your 0-0-0-4 worker tile'**
  String get treeOfLife0004Label;

  /// No description provided for @treeOfLife0004Detail.
  ///
  /// In en, this message translates to:
  /// **'Tree of Life Module: Player {color} takes their 0-0-0-4 worker tile from the New Workers Module and adds it to their worker tiles.'**
  String treeOfLife0004Detail(String color);

  /// No description provided for @treeOfLife0004DetailAll.
  ///
  /// In en, this message translates to:
  /// **'Tree of Life Module: each player takes the 0-0-0-4 worker tile of their colour (from the New Workers Module) and adds it to their worker tiles.'**
  String get treeOfLife0004DetailAll;

  /// No description provided for @treeOfLife0004Rationale.
  ///
  /// In en, this message translates to:
  /// **'With 2 players the Tree of Life requires the 0-0-0-4 tile so every tree can be fully harvested (Diamante rulebook).'**
  String get treeOfLife0004Rationale;

  /// No description provided for @emperorLabel.
  ///
  /// In en, this message translates to:
  /// **'Place the Emperor figure'**
  String get emperorLabel;

  /// No description provided for @emperorOnMarketDetail.
  ///
  /// In en, this message translates to:
  /// **'After laying out the starting tiles, place the Emperor figure on the market, selling price 2.'**
  String get emperorOnMarketDetail;

  /// No description provided for @emperorOnWaterDetail.
  ///
  /// In en, this message translates to:
  /// **'After laying out the starting tiles, place the Emperor figure on the water tile.'**
  String get emperorOnWaterDetail;

  /// No description provided for @newWorkersSelectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose the worker tiles'**
  String get newWorkersSelectionLabel;

  /// No description provided for @newWorkersSelectionDetail.
  ///
  /// In en, this message translates to:
  /// **'Select which worker tiles you want to use for this game.'**
  String get newWorkersSelectionDetail;

  /// No description provided for @newWorkersBuildLabel.
  ///
  /// In en, this message translates to:
  /// **'Build the worker pile'**
  String get newWorkersBuildLabel;

  /// No description provided for @newWorkersBuildDetail.
  ///
  /// In en, this message translates to:
  /// **'Each player takes the tiles shown from each source.'**
  String get newWorkersBuildDetail;

  /// No description provided for @workerBuildFromBase.
  ///
  /// In en, this message translates to:
  /// **'From the base game, take:'**
  String get workerBuildFromBase;

  /// No description provided for @workerBuildFromExpansion.
  ///
  /// In en, this message translates to:
  /// **'From the Diamante expansion, take:'**
  String get workerBuildFromExpansion;

  /// No description provided for @returnToBoxTitle.
  ///
  /// In en, this message translates to:
  /// **'Return to the box'**
  String get returnToBoxTitle;

  /// No description provided for @returnToBoxSubtitle.
  ///
  /// In en, this message translates to:
  /// **'These tiles are not used in this game'**
  String get returnToBoxSubtitle;

  /// No description provided for @allSetTitle.
  ///
  /// In en, this message translates to:
  /// **'All set!'**
  String get allSetTitle;

  /// No description provided for @allSetMessage.
  ///
  /// In en, this message translates to:
  /// **'The table is ready. May the best cacao farmer win!'**
  String get allSetMessage;

  /// No description provided for @drawFirstPlayerAction.
  ///
  /// In en, this message translates to:
  /// **'Draw randomly instead'**
  String get drawFirstPlayerAction;

  /// No description provided for @drawAgainAction.
  ///
  /// In en, this message translates to:
  /// **'Draw again'**
  String get drawAgainAction;

  /// No description provided for @startsFirst.
  ///
  /// In en, this message translates to:
  /// **'{name} starts!'**
  String startsFirst(String name);

  /// No description provided for @backToGameAction.
  ///
  /// In en, this message translates to:
  /// **'Back to the game'**
  String get backToGameAction;

  /// No description provided for @menuHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get menuHome;

  /// No description provided for @menuGameSetup.
  ///
  /// In en, this message translates to:
  /// **'Game Setup'**
  String get menuGameSetup;

  /// No description provided for @menuTiles.
  ///
  /// In en, this message translates to:
  /// **'Tiles'**
  String get menuTiles;

  /// No description provided for @menuScores.
  ///
  /// In en, this message translates to:
  /// **'Scores'**
  String get menuScores;

  /// No description provided for @menuRules.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get menuRules;

  /// No description provided for @titlePreparation.
  ///
  /// In en, this message translates to:
  /// **'Preparation'**
  String get titlePreparation;

  /// No description provided for @titleGameDashboard.
  ///
  /// In en, this message translates to:
  /// **'Game Dashboard'**
  String get titleGameDashboard;

  /// No description provided for @phaseTilePool.
  ///
  /// In en, this message translates to:
  /// **'Tile Pool'**
  String get phaseTilePool;

  /// No description provided for @phasePlayerSetup.
  ///
  /// In en, this message translates to:
  /// **'Player Setup'**
  String get phasePlayerSetup;

  /// No description provided for @phaseBoardSetup.
  ///
  /// In en, this message translates to:
  /// **'Board Setup'**
  String get phaseBoardSetup;

  /// No description provided for @phaseSupplies.
  ///
  /// In en, this message translates to:
  /// **'Supplies'**
  String get phaseSupplies;

  /// No description provided for @playersSection.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get playersSection;

  /// No description provided for @expansionsSection.
  ///
  /// In en, this message translates to:
  /// **'Expansions'**
  String get expansionsSection;

  /// No description provided for @modulesSection.
  ///
  /// In en, this message translates to:
  /// **'Modules'**
  String get modulesSection;

  /// No description provided for @needMorePlayers.
  ///
  /// In en, this message translates to:
  /// **'Need {count}+'**
  String needMorePlayers(int count);

  /// No description provided for @tapColorHint.
  ///
  /// In en, this message translates to:
  /// **'Tap a color to add a player. Hold and drag to reorder.'**
  String get tapColorHint;

  /// No description provided for @selectExpansionsHint.
  ///
  /// In en, this message translates to:
  /// **'Select the expansions you\'re playing with'**
  String get selectExpansionsHint;

  /// No description provided for @selectModulesHint.
  ///
  /// In en, this message translates to:
  /// **'Select the modules you\'re playing with'**
  String get selectModulesHint;

  /// No description provided for @noExpansionWithModules.
  ///
  /// In en, this message translates to:
  /// **'No expansion with modules are selected'**
  String get noExpansionWithModules;

  /// No description provided for @noModules.
  ///
  /// In en, this message translates to:
  /// **'No modules'**
  String get noModules;

  /// No description provided for @startGame.
  ///
  /// In en, this message translates to:
  /// **'Start Game'**
  String get startGame;

  /// No description provided for @resumeGame.
  ///
  /// In en, this message translates to:
  /// **'Resume Game'**
  String get resumeGame;

  /// No description provided for @clearSetup.
  ///
  /// In en, this message translates to:
  /// **'Clear Setup'**
  String get clearSetup;

  /// No description provided for @gameVariant.
  ///
  /// In en, this message translates to:
  /// **'Game Variant'**
  String get gameVariant;

  /// No description provided for @bigGame.
  ///
  /// In en, this message translates to:
  /// **'Big Game'**
  String get bigGame;

  /// No description provided for @bigGameHint.
  ///
  /// In en, this message translates to:
  /// **'Use all tiles from all modules without substitutions'**
  String get bigGameHint;

  /// No description provided for @showAllTiles.
  ///
  /// In en, this message translates to:
  /// **'Show All Tiles'**
  String get showAllTiles;

  /// No description provided for @hideTiles.
  ///
  /// In en, this message translates to:
  /// **'Hide Tiles'**
  String get hideTiles;

  /// No description provided for @tilesInPlay.
  ///
  /// In en, this message translates to:
  /// **'Tiles in Play'**
  String get tilesInPlay;

  /// No description provided for @scoreCalculator.
  ///
  /// In en, this message translates to:
  /// **'Score Calculator'**
  String get scoreCalculator;

  /// No description provided for @noPlayersSelected.
  ///
  /// In en, this message translates to:
  /// **'No players selected'**
  String get noPlayersSelected;

  /// No description provided for @noTiles.
  ///
  /// In en, this message translates to:
  /// **'No tiles'**
  String get noTiles;

  /// No description provided for @baseGameOnly.
  ///
  /// In en, this message translates to:
  /// **'Base game only'**
  String get baseGameOnly;

  /// No description provided for @playerPosition.
  ///
  /// In en, this message translates to:
  /// **'Player {position}'**
  String playerPosition(int position);

  /// No description provided for @closeAction.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get closeAction;

  /// No description provided for @workerSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'The New Workers'**
  String get workerSheetTitle;

  /// No description provided for @workerChooseIntro.
  ///
  /// In en, this message translates to:
  /// **'Choose which worker tiles each player will use. All players use the same set.'**
  String get workerChooseIntro;

  /// No description provided for @workerHowItWorks.
  ///
  /// In en, this message translates to:
  /// **'How does it work?'**
  String get workerHowItWorks;

  /// No description provided for @workerHelpBody.
  ///
  /// In en, this message translates to:
  /// **'• The New Workers adds 4 new worker tiles with distributions different from the base game ones.\n• You can use a quick preset or manually adjust the quantity of each tile.\n• The balance between workers and jungle tiles matters: if the difference falls outside the indicated range, the game may feel unbalanced.\n• By default, the game recommends keeping 11 tiles per player, but you can add more for a longer game.'**
  String get workerHelpBody;

  /// No description provided for @workerPresetsSection.
  ///
  /// In en, this message translates to:
  /// **'Presets'**
  String get workerPresetsSection;

  /// No description provided for @workerRandomSection.
  ///
  /// In en, this message translates to:
  /// **'Random'**
  String get workerRandomSection;

  /// No description provided for @workerPresetBaseOnly.
  ///
  /// In en, this message translates to:
  /// **'Base only'**
  String get workerPresetBaseOnly;

  /// No description provided for @workerPresetReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get workerPresetReplace;

  /// No description provided for @workerPresetBase0004.
  ///
  /// In en, this message translates to:
  /// **'Base + 0-0-0-4'**
  String get workerPresetBase0004;

  /// No description provided for @workerPresetAddAll.
  ///
  /// In en, this message translates to:
  /// **'Add all'**
  String get workerPresetAddAll;

  /// No description provided for @workerAddAllDefault.
  ///
  /// In en, this message translates to:
  /// **'Add all (default)'**
  String get workerAddAllDefault;

  /// No description provided for @workerManual.
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get workerManual;

  /// No description provided for @workerSurprise.
  ///
  /// In en, this message translates to:
  /// **'Surprise'**
  String get workerSurprise;

  /// No description provided for @workerSurpriseChip.
  ///
  /// In en, this message translates to:
  /// **'Surprise +2'**
  String get workerSurpriseChip;

  /// No description provided for @workerSurpriseTooltip.
  ///
  /// In en, this message translates to:
  /// **'Base + 2 new tiles picked at random. Tap again for a different pair.'**
  String get workerSurpriseTooltip;

  /// No description provided for @workerDescBaseOnly.
  ///
  /// In en, this message translates to:
  /// **'Uses only the base game tiles (11 per player). The new Diamante tiles are not added.'**
  String get workerDescBaseOnly;

  /// No description provided for @workerDescReplace.
  ///
  /// In en, this message translates to:
  /// **'Replaces 4 base tiles (1-1-1-1) with the 4 new Diamante ones. Total: 11 per player.'**
  String get workerDescReplace;

  /// No description provided for @workerDescBase0004.
  ///
  /// In en, this message translates to:
  /// **'Adds only the 0-0-0-4 tile to the 11 base tiles. Total: 12 per player. Recommended by the community (BGG).'**
  String get workerDescBase0004;

  /// No description provided for @workerDescAddAll.
  ///
  /// In en, this message translates to:
  /// **'Adds the 4 new Diamante tiles to the 11 base ones. Total: 15 per player.'**
  String get workerDescAddAll;

  /// No description provided for @workerDescManual.
  ///
  /// In en, this message translates to:
  /// **'Manual selection: adjust the quantity of each tile individually.'**
  String get workerDescManual;

  /// No description provided for @workerDescSurprise.
  ///
  /// In en, this message translates to:
  /// **'Surprise: base tiles + 2 new Diamante tiles picked at random. Tap again for a different pair.'**
  String get workerDescSurprise;

  /// No description provided for @workerCustomPreset.
  ///
  /// In en, this message translates to:
  /// **'Custom preset: {name}'**
  String workerCustomPreset(String name);

  /// No description provided for @workerSummaryLine.
  ///
  /// In en, this message translates to:
  /// **'{label} · {count} tiles/player'**
  String workerSummaryLine(String label, int count);

  /// No description provided for @workerBaseTiles.
  ///
  /// In en, this message translates to:
  /// **'Base tiles'**
  String get workerBaseTiles;

  /// No description provided for @workerNewTiles.
  ///
  /// In en, this message translates to:
  /// **'New tiles (Diamante)'**
  String get workerNewTiles;

  /// No description provided for @workerBalanceOk.
  ///
  /// In en, this message translates to:
  /// **'Balance is fine'**
  String get workerBalanceOk;

  /// No description provided for @workerBalanceOut.
  ///
  /// In en, this message translates to:
  /// **'Outside recommended range'**
  String get workerBalanceOut;

  /// No description provided for @workerBalanceValid.
  ///
  /// In en, this message translates to:
  /// **'Valid'**
  String get workerBalanceValid;

  /// No description provided for @workerBalanceOutShort.
  ///
  /// In en, this message translates to:
  /// **'Out of range'**
  String get workerBalanceOutShort;

  /// No description provided for @workerBalanceHint.
  ///
  /// In en, this message translates to:
  /// **'The rulebook recommends this margin to keep the game balanced, but you can still apply the selection.'**
  String get workerBalanceHint;

  /// No description provided for @workerBalanceWorkersWord.
  ///
  /// In en, this message translates to:
  /// **'workers'**
  String get workerBalanceWorkersWord;

  /// No description provided for @workerBalanceJungleWord.
  ///
  /// In en, this message translates to:
  /// **'jungle'**
  String get workerBalanceJungleWord;

  /// No description provided for @workerBalanceRange.
  ///
  /// In en, this message translates to:
  /// **'(range: {min}–{max})'**
  String workerBalanceRange(int min, int max);

  /// No description provided for @workerTilesPerPlayerLine.
  ///
  /// In en, this message translates to:
  /// **'Tiles per player: {count}'**
  String workerTilesPerPlayerLine(int count);

  /// No description provided for @workerLockedTooltip.
  ///
  /// In en, this message translates to:
  /// **'Required by Tree of Life (2 players)'**
  String get workerLockedTooltip;

  /// No description provided for @resetAction.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetAction;

  /// No description provided for @applyAction.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get applyAction;

  /// No description provided for @workerSelectionResetNotice.
  ///
  /// In en, this message translates to:
  /// **'You changed the workers: build the pile again.'**
  String get workerSelectionResetNotice;

  /// No description provided for @saveAction.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveAction;

  /// No description provided for @deleteAction.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteAction;

  /// No description provided for @savePresetTitle.
  ///
  /// In en, this message translates to:
  /// **'Save as preset'**
  String get savePresetTitle;

  /// No description provided for @presetNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Preset name'**
  String get presetNameLabel;

  /// No description provided for @presetNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Our favorite'**
  String get presetNameHint;

  /// No description provided for @deletePresetTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete preset'**
  String get deletePresetTitle;

  /// No description provided for @deletePresetConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \'{name}\'?'**
  String deletePresetConfirm(String name);

  /// No description provided for @errorLoadingPresets.
  ///
  /// In en, this message translates to:
  /// **'Error loading custom presets'**
  String get errorLoadingPresets;

  /// No description provided for @errorSavingPresets.
  ///
  /// In en, this message translates to:
  /// **'Error saving custom presets'**
  String get errorSavingPresets;

  /// No description provided for @hutRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Register the hut throw'**
  String get hutRegisterTitle;

  /// No description provided for @hutRegisterHint.
  ///
  /// In en, this message translates to:
  /// **'Tap each hut face that landed up. Impossible ones disappear on their own.'**
  String get hutRegisterHint;

  /// No description provided for @hutRegisterAction.
  ///
  /// In en, this message translates to:
  /// **'Register which huts landed face up'**
  String get hutRegisterAction;

  /// No description provided for @hutRegisteredEdit.
  ///
  /// In en, this message translates to:
  /// **'Throw registered · tap to edit'**
  String get hutRegisteredEdit;

  /// No description provided for @forgetThrowAction.
  ///
  /// In en, this message translates to:
  /// **'Forget throw'**
  String get forgetThrowAction;

  /// No description provided for @guidedModeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Guided mode: one step at a time'**
  String get guidedModeTooltip;

  /// No description provided for @listModeTooltip.
  ///
  /// In en, this message translates to:
  /// **'Checklist mode'**
  String get listModeTooltip;

  /// No description provided for @guidedBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get guidedBack;

  /// No description provided for @guidedNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get guidedNext;

  /// No description provided for @hutMarketCrier.
  ///
  /// In en, this message translates to:
  /// **'Market Crier'**
  String get hutMarketCrier;

  /// No description provided for @hutHermit.
  ///
  /// In en, this message translates to:
  /// **'Hermit'**
  String get hutHermit;

  /// No description provided for @hutRoadWorker.
  ///
  /// In en, this message translates to:
  /// **'Road Worker'**
  String get hutRoadWorker;

  /// No description provided for @hutTrader.
  ///
  /// In en, this message translates to:
  /// **'Trader'**
  String get hutTrader;

  /// No description provided for @hutFarmer.
  ///
  /// In en, this message translates to:
  /// **'Farmer'**
  String get hutFarmer;

  /// No description provided for @hutShaman.
  ///
  /// In en, this message translates to:
  /// **'Shaman'**
  String get hutShaman;

  /// No description provided for @hutMonk.
  ///
  /// In en, this message translates to:
  /// **'Monk'**
  String get hutMonk;

  /// No description provided for @hutMasterBuilder.
  ///
  /// In en, this message translates to:
  /// **'Master Builder'**
  String get hutMasterBuilder;

  /// No description provided for @hutForeman.
  ///
  /// In en, this message translates to:
  /// **'Foreman'**
  String get hutForeman;

  /// No description provided for @hutFountainMaster.
  ///
  /// In en, this message translates to:
  /// **'Fountain Master'**
  String get hutFountainMaster;

  /// No description provided for @hutChiefsDaughter.
  ///
  /// In en, this message translates to:
  /// **'Chief\'s Daughter'**
  String get hutChiefsDaughter;

  /// No description provided for @hutChiefsSon.
  ///
  /// In en, this message translates to:
  /// **'Chief\'s Son'**
  String get hutChiefsSon;

  /// No description provided for @hutChiefsWife.
  ///
  /// In en, this message translates to:
  /// **'Chief\'s Wife'**
  String get hutChiefsWife;

  /// No description provided for @hutChief.
  ///
  /// In en, this message translates to:
  /// **'Chief'**
  String get hutChief;

  /// No description provided for @menuTitle.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menuTitle;

  /// No description provided for @summaryTiles.
  ///
  /// In en, this message translates to:
  /// **'Tiles'**
  String get summaryTiles;

  /// No description provided for @summaryWorkers.
  ///
  /// In en, this message translates to:
  /// **'Workers'**
  String get summaryWorkers;

  /// No description provided for @summaryJungle.
  ///
  /// In en, this message translates to:
  /// **'Jungle'**
  String get summaryJungle;

  /// No description provided for @summaryHuts.
  ///
  /// In en, this message translates to:
  /// **'Huts'**
  String get summaryHuts;

  /// No description provided for @tileMarketSelling4.
  ///
  /// In en, this message translates to:
  /// **'Market, selling price 4'**
  String get tileMarketSelling4;

  /// No description provided for @boardgameCacao.
  ///
  /// In en, this message translates to:
  /// **'Cacao'**
  String get boardgameCacao;

  /// No description provided for @boardgameChocolatl.
  ///
  /// In en, this message translates to:
  /// **'Cacao: Chocolatl'**
  String get boardgameChocolatl;

  /// No description provided for @boardgameDiamante.
  ///
  /// In en, this message translates to:
  /// **'Cacao: Diamante'**
  String get boardgameDiamante;

  /// No description provided for @expansionNameChocolatl.
  ///
  /// In en, this message translates to:
  /// **'Chocolatl'**
  String get expansionNameChocolatl;

  /// No description provided for @expansionNameDiamante.
  ///
  /// In en, this message translates to:
  /// **'Diamante'**
  String get expansionNameDiamante;

  /// No description provided for @moduleMaps.
  ///
  /// In en, this message translates to:
  /// **'Map Module'**
  String get moduleMaps;

  /// No description provided for @moduleWatering.
  ///
  /// In en, this message translates to:
  /// **'Watering Module'**
  String get moduleWatering;

  /// No description provided for @moduleChocolate.
  ///
  /// In en, this message translates to:
  /// **'Chocolate Module'**
  String get moduleChocolate;

  /// No description provided for @moduleHuts.
  ///
  /// In en, this message translates to:
  /// **'Hut Module'**
  String get moduleHuts;

  /// No description provided for @moduleGemMines.
  ///
  /// In en, this message translates to:
  /// **'The Gem Mines'**
  String get moduleGemMines;

  /// No description provided for @moduleTreeOfLife.
  ///
  /// In en, this message translates to:
  /// **'The Tree of Life'**
  String get moduleTreeOfLife;

  /// No description provided for @moduleEmperorsFavor.
  ///
  /// In en, this message translates to:
  /// **'The Favor of the Emperor'**
  String get moduleEmperorsFavor;

  /// No description provided for @moduleNewWorkers.
  ///
  /// In en, this message translates to:
  /// **'The New Workers'**
  String get moduleNewWorkers;

  /// No description provided for @moduleDescMaps.
  ///
  /// In en, this message translates to:
  /// **'Two extra jungle tiles lie face up on the map board next to the draw pile. When refilling jungle spaces, you may return 1 of your map tiles to the box to pick a tile from the map board instead of the display.'**
  String get moduleDescMaps;

  /// No description provided for @moduleDescWatering.
  ///
  /// In en, this message translates to:
  /// **'Three watering tiles replace plantations: their workers move your water carrier backwards, granting 4 cacao fruits per water field. A water tile replaces the market as the second starting tile.'**
  String get moduleDescWatering;

  /// No description provided for @moduleDescChocolate.
  ///
  /// In en, this message translates to:
  /// **'Chocolate kitchens and chocolate markets replace gold mines and price-3 markets: turn cacao fruits into chocolate bars and sell them for up to 7 gold.'**
  String get moduleDescChocolate;

  /// No description provided for @moduleDescHuts.
  ///
  /// In en, this message translates to:
  /// **'12 double-sided hut tiles wait next to the bank, sorted by cost. At the end of your turn you may build one, paying gold you already own; at game end each hut refunds its cost and grants its bonus.'**
  String get moduleDescHuts;

  /// No description provided for @moduleDescGemMines.
  ///
  /// In en, this message translates to:
  /// **'Five gem mines replace the temples. Activated workers collect gems from the mine car; a set of the 4 colors trades immediately for the lowest-value mask. Masks and leftover gems are worth gold.'**
  String get moduleDescGemMines;

  /// No description provided for @moduleDescTreeOfLife.
  ///
  /// In en, this message translates to:
  /// **'Three Trees of Life replace the gold mines: each adjacent worker takes 1 gold — but strength lies in serenity: an adjacent edge with no workers takes 3 gold.'**
  String get moduleDescTreeOfLife;

  /// No description provided for @moduleDescEmperorsFavor.
  ///
  /// In en, this message translates to:
  /// **'The Emperor starts on the market with selling price 2. Placing a worker tile in his row or column moves him onto it and pays 1 gold — and 1 more at the start of each of your turns while he still stands there.'**
  String get moduleDescEmperorsFavor;

  /// No description provided for @moduleDescNewWorkers.
  ///
  /// In en, this message translates to:
  /// **'16 worker tiles with new distributions (0-0-2-2, 0-2-0-2, 0-1-0-3, 0-0-0-4). Agree on any mix with the base tiles — every player uses the same set.'**
  String get moduleDescNewWorkers;

  /// No description provided for @tileDescWorker.
  ///
  /// In en, this message translates to:
  /// **'Worker tile {distribution} for the {color} player.'**
  String tileDescWorker(String distribution, String color);

  /// No description provided for @tileDesc_base_jungle_single_plantation.
  ///
  /// In en, this message translates to:
  /// **'For each of your activated workers on the adjacent edge of the tile, you may take **1 cacao fruit** from the supply. You put them individually on 1 unoccupied storage space on your village board. Each player has 5 storage spaces and may never store more than *5 cacao* fruits; any additional fruits that you acquire go to waste.\n\n![Take cacao](resource:assets/images/tiles/description/plantation.webp)'**
  String get tileDesc_base_jungle_single_plantation;

  /// No description provided for @tileDesc_base_jungle_double_plantation.
  ///
  /// In en, this message translates to:
  /// **'For each of your activated workers on the adjacent edge of the tile, you may take **2 cacao fruits** from the supply. You put them individually on 1 unoccupied storage space on your village board. Each player has 5 storage spaces and may never store more than *5 cacao* fruits; any additional fruits that you acquire go to waste.\n\n![Take cacao](resource:assets/images/tiles/description/plantation.webp)'**
  String get tileDesc_base_jungle_double_plantation;

  /// No description provided for @tileDesc_base_jungle_market_selling_2.
  ///
  /// In en, this message translates to:
  /// **'For each of your activated workers on the adjacent edge of the tile, you may sell **1 cacao** fruit from your storage at the price indicated on the market. You put the cacao fruit back in the supply and then take **2 gold** from the bank.\n\n![Put the cacao](resource:assets/images/tiles/description/market1.webp)\n\n![Take money](resource:assets/images/tiles/description/market2.webp)'**
  String get tileDesc_base_jungle_market_selling_2;

  /// No description provided for @tileDesc_base_jungle_market_selling_3.
  ///
  /// In en, this message translates to:
  /// **'For each of your activated workers on the adjacent edge of the tile, you may sell **1 cacao** fruit from your storage at the price indicated on the market. You put the cacao fruit back in the supply and then take **3 gold** from the bank.\n\n![Put the cacao](resource:assets/images/tiles/description/market1.webp)\n\n![Take money](resource:assets/images/tiles/description/market2.webp)'**
  String get tileDesc_base_jungle_market_selling_3;

  /// No description provided for @tileDesc_base_jungle_market_selling_4.
  ///
  /// In en, this message translates to:
  /// **'For each of your activated workers on the adjacent edge of the tile, you may sell **1 cacao** fruit from your storage at the price indicated on the market. You put the cacao fruit back in the supply and then take **4 gold** from the bank.\n\n![Put the cacao](resource:assets/images/tiles/description/market1.webp)\n\n![Take money](resource:assets/images/tiles/description/market2.webp)'**
  String get tileDesc_base_jungle_market_selling_4;

  /// No description provided for @tileDesc_base_jungle_gold_mine_value_1.
  ///
  /// In en, this message translates to:
  /// **'For each of your activated workers on the adjacent edge of the tile, you may take the value indicated – that is, either **1 gold** – from the bank.\n\n![Take money](resource:assets/images/tiles/description/gold_mine.webp)'**
  String get tileDesc_base_jungle_gold_mine_value_1;

  /// No description provided for @tileDesc_base_jungle_gold_mine_value_2.
  ///
  /// In en, this message translates to:
  /// **'For each of your activated workers on the adjacent edge of the tile, you may take the value indicated – that is, either **2 gold** – from the bank.\n\n![Take money](resource:assets/images/tiles/description/gold_mine.webp)'**
  String get tileDesc_base_jungle_gold_mine_value_2;

  /// No description provided for @tileDesc_base_jungle_water.
  ///
  /// In en, this message translates to:
  /// **'For each of your activated workers on the adjacent edge of the tile, you may move the water carrier on your village board 1 water field ahead in a clockwise direction. If the water carrier reaches the water field with the value \"16,\" he stops there; any possible further steps go to waste. \n\nAt the end of the game, you add to your gold coins the value of the water field on which your water carrier is standing. If the water carrier is still standing on a field with a negative value, you have to deduct the applicable number.\n\n![Move the water carrier](resource:assets/images/tiles/description/water.webp)'**
  String get tileDesc_base_jungle_water;

  /// No description provided for @tileDesc_base_jungle_sun_worshiping_site.
  ///
  /// In en, this message translates to:
  /// **'For each of your activated workers on the adjacent edge of the tile, you may take 1 sun token from the supply. You put it on an unoccupied sun-worshiping place on your village board. Each player has 3 sun-worshiping places and may never own more than 3 sun tokens. Sun tokens that you might get beyond that go to waste. \n\nTowards the end of the game, you can use sun tokens to \"overbuild\" one of your **own** worker tiles. At the end of the game, you get 1 gold from the bank for each sun token you have not used.\n\n![Take sun token](resource:assets/images/tiles/description/sun_worshiping_site1.webp) \n\n**OVERBUILDING A WORKER TILE**\n\n When the jungle draw pile has been depleted towards the end of the game and there are no jungle tiles left in the jungle display, you may, from now on, overbuild one of your **own** worker tiles, instead of adding it to the playing area in the usual way; for this, you have to put 1 sun token back in the supply. Choose 1 worker tile from your hand and put it **on top** of one of your **own** worker tiles that you placed earlier. After that, you carry out the actions of the adjacent jungle tiles for the activated workers. If you don\'t own any sun token, you cannot overbuild and have to place the new worker tile as usual.\n\n **Important:** Each worker tile may be overbuilt only **once**. ***Example:***\n\n *It is Red\'s turn. The jungle draw pile has been depleted and the jungle display is empty. Therefore, he is allowed to overbuild: He puts 1 sun token from one of his sun-worshiping places back in the supply; after that, he overbuilds 1 of his own worker tiles. He puts the new worker tile on top of the tile placed on an earlier turn and carries out the actions of the adjacent jungle tiles. First, he takes 2 cacao fruits for the worker at the double plantation and places them on two of his storage spaces. After that, he sells the two cacao fruits at the market for 2x4 = 8 gold. Finally, he moves his water carrier 1 space ahead.*'**
  String get tileDesc_base_jungle_sun_worshiping_site;

  /// No description provided for @tileDesc_base_jungle_temple.
  ///
  /// In en, this message translates to:
  /// **'The temples have no direct effect during the game. Only at the end of the game are the temples scored, individually, one after another. The player who has the most workers adjacent to the respective temple receives 6 gold from the bank. The player with the second most adjacent workers obtains 3 gold. If there is a tie for first place, 6 gold are evenly distributed among the players involved (and rounded down, if necessary). In this case, there is no gold awarded for second place. In case first place is clear but there is a tie for second place, 3 gold are evenly distributed among the players involved (and rounded down, if necessary). \n\n**Attention:** If any worker tiles adjacent to the temple have been overbuilt, only the worker tiles on top count for the scoring. \n\n**Note:** If there is only 1 player with workers adjacent to the temple, he gets 6 gold from the bank, as usual; no gold is awarded for second place. You need to have at least 1 worker adjacent to the temple in order to score for it. \n\n***Example:***\n\n *Yellow and Red both have 2 workers at this temple. Consequently, they share 6 gold for first place; each of them gets 3 gold from the bank. Purple has 1 worker at this temple. However, he goes away empty-handed, since second place is not awarded in this case.*\n\n![Temple](resource:assets/images/tiles/description/temple.webp)'**
  String get tileDesc_base_jungle_temple;

  /// No description provided for @tileDesc_chocolatl_jungle_watering.
  ///
  /// In en, this message translates to:
  /// **'For each of your activated workers on the adjacent edge of the tile, you may move back the water carrier on your village board 1 water field in an anti-clockwise direction. For each water field that you move your water carrier back, you take 4 cacao fruits from the supply and put them on unoccupied storage spaces on your village board. If your water carrier is standing on the water field with the value “-10”, you can\'t get any fruit.\n\n**Attention:** Any additional cacao fruit that you would get goes to waste, as usual. Therefore, it doesn’t make sense to connect tile edges that have more than 1 worker to a watering tile.'**
  String get tileDesc_chocolatl_jungle_watering;

  /// No description provided for @tileDesc_chocolatl_jungle_chocolate_kitchen.
  ///
  /// In en, this message translates to:
  /// **'For each of your activated workers on the adjacent edge of the tile, you may turn 1 cacao fruit from your storage into 1 chocolate bar. Put the cacao fruit back into the supply. After that, you take the chocolate bar from the supply and put it on an unoccupied storage space on your village board.\nEach storage space may be used either for 1 cacao fruit or for 1 chocolate bar.\n\n**END GAME**\n**Attention:** Leftover chocolate bars don\'t give you any gold at the end of the game.'**
  String get tileDesc_chocolatl_jungle_chocolate_kitchen;

  /// No description provided for @tileDesc_chocolatl_jungle_chocolate_market.
  ///
  /// In en, this message translates to:
  /// **'For each of your activated workers on the adjacent edge of the tile, you may sell 1 cacao fruit from your storage for 3 gold, or 1 chocolate bar from your storage for 7 gold. Put the cacao fruit or the chocolate bar back into the supply and then take the applicable amount of gold from the bank.\nIf you have activated more than 1 worker, you may choose for each of the activated workers individually whether you want to sell 1 cacao fruit or 1 chocolate bar.'**
  String get tileDesc_chocolatl_jungle_chocolate_market;

  /// No description provided for @tileDesc_diamante_jungle_gem_mine.
  ///
  /// In en, this message translates to:
  /// **'For each of your activated workers on the adjacent edge of the tile, you may take 1 gem of your choice from this gem mine. Place the gems next to your village board.\n\nAs soon as you have at least 1 gem in each of the 4 colours, you **must immediately** exchange this set of 4 gems for the mask with the lowest value available from the supply. Remove the exchanged gems from the game and put them back into the box.'**
  String get tileDesc_diamante_jungle_gem_mine;

  /// No description provided for @tileDesc_diamante_jungle_tree_of_life.
  ///
  /// In en, this message translates to:
  /// **'For each of your activated workers on the adjacent edge of the tile, you may take 1 gold from the bank.\n\nBut strength lies in serenity: If there are no workers depicted on the adjacent edge of the tile, you may even take 3 gold from the bank.'**
  String get tileDesc_diamante_jungle_tree_of_life;

  /// No description provided for @tileDesc_chocolatl_hut_market_crier.
  ///
  /// In en, this message translates to:
  /// **'**Building Cost:** 4 gold\n\n**Function:** Throughout the game, you sell your cacao fruits at adjacent markets with a selling price of 2 for 3 gold instead of for 2.\n\n**End of Game:** Add the building cost (4 gold) to your total gold.'**
  String get tileDesc_chocolatl_hut_market_crier;

  /// No description provided for @tileDesc_chocolatl_hut_hermit.
  ///
  /// In en, this message translates to:
  /// **'**Building Cost:** 6 gold\n\n**Function:** 1 gold for each of your workers that doesn\'t have an adjacent jungle tile at the end of the game.\n\n**End of Game:** Add the building cost (6 gold) plus the bonus to your total gold.'**
  String get tileDesc_chocolatl_hut_hermit;

  /// No description provided for @tileDesc_chocolatl_hut_road_worker.
  ///
  /// In en, this message translates to:
  /// **'**Building Cost:** 6 gold\n\n**Function:** At the end of the game, you obtain 1 gold for each of your worker tiles in the row or column where you have the most of your worker tiles.\n\n**End of Game:** Add the building cost (6 gold) plus the bonus to your total gold.'**
  String get tileDesc_chocolatl_hut_road_worker;

  /// No description provided for @tileDesc_chocolatl_hut_trader.
  ///
  /// In en, this message translates to:
  /// **'**Building Cost:** 6 gold\n\n**Function:** Leftover cacao fruits in your own storage give you 1 gold each at the end of the game.\n\n**End of Game:** Add the building cost (6 gold) plus the bonus to your total gold.'**
  String get tileDesc_chocolatl_hut_trader;

  /// No description provided for @tileDesc_chocolatl_hut_farmer.
  ///
  /// In en, this message translates to:
  /// **'**Building Cost:** 8 gold\n\n**Function:** Whenever you get exactly 4 cacao fruits on one turn during the game, you receive 1 more cacao fruit, provided you have enough space left in your storage.\n\n**End of Game:** Add the building cost (8 gold) to your total gold.'**
  String get tileDesc_chocolatl_hut_farmer;

  /// No description provided for @tileDesc_chocolatl_hut_shaman.
  ///
  /// In en, this message translates to:
  /// **'**Building Cost:** 8 gold\n\n**Function:** If you overbuild one of your worker tiles during the game, you don\'t have to put any sun token back into the supply for this.\n\n**End of Game:** Add the building cost (8 gold) to your total gold.'**
  String get tileDesc_chocolatl_hut_shaman;

  /// No description provided for @tileDesc_chocolatl_hut_monk.
  ///
  /// In en, this message translates to:
  /// **'**Building Cost:** 10 gold\n\n**Function:** 1 gold at the end of the game for each temple you have at least 1 worker adjacent to.\n\n**End of Game:** Add the building cost (10 gold) plus the bonus to your total gold.'**
  String get tileDesc_chocolatl_hut_monk;

  /// No description provided for @tileDesc_chocolatl_hut_master_builder.
  ///
  /// In en, this message translates to:
  /// **'**Building Cost:** 10 gold\n\n**Function:** At the end of the game, you obtain 1 gold for each of your other huts.\n\n**End of Game:** Add the building cost (10 gold) plus the bonus to your total gold.'**
  String get tileDesc_chocolatl_hut_master_builder;

  /// No description provided for @tileDesc_chocolatl_hut_foreman.
  ///
  /// In en, this message translates to:
  /// **'**Building Cost:** 12 gold\n\n**Function:**  When you play a worker tile with 3 workers on one edge during the game, it is counted as having an additional 4th worker on that edge.\n\n**End of Game:** Add the building cost (12 gold) to your total gold.'**
  String get tileDesc_chocolatl_hut_foreman;

  /// No description provided for @tileDesc_chocolatl_hut_fountain_master.
  ///
  /// In en, this message translates to:
  /// **'**Building Cost:** 12 gold\n\n**Function:** 4 gold at the end of the game if your own water carrier is standing on the water field with the value “16”.\n\n**End of Game:** Add the building cost (12 gold) plus the bonus (if applicable) to your total gold.'**
  String get tileDesc_chocolatl_hut_fountain_master;

  /// No description provided for @tileDesc_chocolatl_hut_chiefs_daughter.
  ///
  /// In en, this message translates to:
  /// **'**Building Cost:** 14 gold\n\n**Function:** 4 gold at the end of the game.\n\n**End of Game:** Add the building cost (14 gold) plus the bonus (4 gold) to your total gold.'**
  String get tileDesc_chocolatl_hut_chiefs_daughter;

  /// No description provided for @tileDesc_chocolatl_hut_chiefs_son.
  ///
  /// In en, this message translates to:
  /// **'**Building Cost:** 16 gold\n\n**Function:** 4 gold at the end of the game.\n\n**End of Game:** Add the building cost (16 gold) plus the bonus (4 gold) to your total gold.'**
  String get tileDesc_chocolatl_hut_chiefs_son;

  /// No description provided for @tileDesc_chocolatl_hut_chiefs_wife.
  ///
  /// In en, this message translates to:
  /// **'**Building Cost:** 20 gold\n\n**Function:** 5 gold at the end of the game.\n\n**End of Game:** Add the building cost (20 gold) plus the bonus (5 gold) to your total gold.'**
  String get tileDesc_chocolatl_hut_chiefs_wife;

  /// No description provided for @tileDesc_chocolatl_hut_chief.
  ///
  /// In en, this message translates to:
  /// **'**Building Cost:** 24 gold\n\n**Function:** 6 gold at the end of the game.\n\n**End of Game:** Add the building cost (24 gold) plus the bonus (6 gold) to your total gold.'**
  String get tileDesc_chocolatl_hut_chief;

  /// No description provided for @tileTypePlayer.
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get tileTypePlayer;

  /// No description provided for @tileTypeMarket.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get tileTypeMarket;

  /// No description provided for @tileTypePlantation.
  ///
  /// In en, this message translates to:
  /// **'Plantation'**
  String get tileTypePlantation;

  /// No description provided for @tileTypeGoldMine.
  ///
  /// In en, this message translates to:
  /// **'Gold Mine'**
  String get tileTypeGoldMine;

  /// No description provided for @tileTypeWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get tileTypeWater;

  /// No description provided for @tileTypeTemple.
  ///
  /// In en, this message translates to:
  /// **'Temple'**
  String get tileTypeTemple;

  /// No description provided for @tileTypeSunWorshipingSite.
  ///
  /// In en, this message translates to:
  /// **'Sun-Worshiping Site'**
  String get tileTypeSunWorshipingSite;

  /// No description provided for @tileTypeWatering.
  ///
  /// In en, this message translates to:
  /// **'Watering'**
  String get tileTypeWatering;

  /// No description provided for @tileTypeChocolateKitchen.
  ///
  /// In en, this message translates to:
  /// **'Chocolate Kitchen'**
  String get tileTypeChocolateKitchen;

  /// No description provided for @tileTypeChocolateMarket.
  ///
  /// In en, this message translates to:
  /// **'Chocolate Market'**
  String get tileTypeChocolateMarket;

  /// No description provided for @tileTypeMapTile.
  ///
  /// In en, this message translates to:
  /// **'Map Tile'**
  String get tileTypeMapTile;

  /// No description provided for @tileTypeHut.
  ///
  /// In en, this message translates to:
  /// **'Hut'**
  String get tileTypeHut;

  /// No description provided for @tileTypeGemMine.
  ///
  /// In en, this message translates to:
  /// **'Gem Mine'**
  String get tileTypeGemMine;

  /// No description provided for @tileTypeTreeOfLife.
  ///
  /// In en, this message translates to:
  /// **'Tree of Life'**
  String get tileTypeTreeOfLife;

  /// No description provided for @filterSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filterSheetTitle;

  /// No description provided for @clearAllAction.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAllAction;

  /// No description provided for @searchTileHint.
  ///
  /// In en, this message translates to:
  /// **'Search tile by name...'**
  String get searchTileHint;

  /// No description provided for @tileTypesSection.
  ///
  /// In en, this message translates to:
  /// **'Tile types'**
  String get tileTypesSection;

  /// No description provided for @filterTilesTooltip.
  ///
  /// In en, this message translates to:
  /// **'Filter tiles'**
  String get filterTilesTooltip;

  /// No description provided for @displaySettingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Display settings'**
  String get displaySettingsTooltip;

  /// No description provided for @activeFiltersCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 filter active} other{{count} filters active}}'**
  String activeFiltersCount(int count);

  /// No description provided for @costLabel.
  ///
  /// In en, this message translates to:
  /// **'Cost: {cost}'**
  String costLabel(int cost);

  /// No description provided for @settingsSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsSheetTitle;

  /// No description provided for @settingsGeneralSection.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settingsGeneralSection;

  /// No description provided for @settingsBadgesSection.
  ///
  /// In en, this message translates to:
  /// **'Badges'**
  String get settingsBadgesSection;

  /// No description provided for @settingsPlayerColorsSection.
  ///
  /// In en, this message translates to:
  /// **'Player colors'**
  String get settingsPlayerColorsSection;

  /// No description provided for @settingBoardgameTitle.
  ///
  /// In en, this message translates to:
  /// **'Boardgame title'**
  String get settingBoardgameTitle;

  /// No description provided for @settingShowQuantity.
  ///
  /// In en, this message translates to:
  /// **'Show quantity'**
  String get settingShowQuantity;

  /// No description provided for @settingCompactLayout.
  ///
  /// In en, this message translates to:
  /// **'Compact layout'**
  String get settingCompactLayout;

  /// No description provided for @settingBadgeTypeInText.
  ///
  /// In en, this message translates to:
  /// **'Badge tile type in text'**
  String get settingBadgeTypeInText;

  /// No description provided for @settingBadgeTypeInImage.
  ///
  /// In en, this message translates to:
  /// **'Badge tile type in image'**
  String get settingBadgeTypeInImage;

  /// No description provided for @settingPlayerColorInBorder.
  ///
  /// In en, this message translates to:
  /// **'Player color in border'**
  String get settingPlayerColorInBorder;

  /// No description provided for @settingPlayerColorInCircle.
  ///
  /// In en, this message translates to:
  /// **'Player color in circle'**
  String get settingPlayerColorInCircle;

  /// No description provided for @scoreStepSetup.
  ///
  /// In en, this message translates to:
  /// **'Players & Modules'**
  String get scoreStepSetup;

  /// No description provided for @scoreCatGold.
  ///
  /// In en, this message translates to:
  /// **'Accumulated Gold'**
  String get scoreCatGold;

  /// No description provided for @scoreCatWater.
  ///
  /// In en, this message translates to:
  /// **'Water Track'**
  String get scoreCatWater;

  /// No description provided for @scoreCatTemples.
  ///
  /// In en, this message translates to:
  /// **'Temples'**
  String get scoreCatTemples;

  /// No description provided for @scoreCatSun.
  ///
  /// In en, this message translates to:
  /// **'Sun Tokens'**
  String get scoreCatSun;

  /// No description provided for @scoreCatCacao.
  ///
  /// In en, this message translates to:
  /// **'Leftover Cacao'**
  String get scoreCatCacao;

  /// No description provided for @scoreCatHuts.
  ///
  /// In en, this message translates to:
  /// **'Huts'**
  String get scoreCatHuts;

  /// No description provided for @scoreCatGemMines.
  ///
  /// In en, this message translates to:
  /// **'Gem Mines'**
  String get scoreCatGemMines;

  /// No description provided for @startOverAction.
  ///
  /// In en, this message translates to:
  /// **'Start over'**
  String get startOverAction;

  /// No description provided for @startOverTitle.
  ///
  /// In en, this message translates to:
  /// **'Start over?'**
  String get startOverTitle;

  /// No description provided for @startOverBody.
  ///
  /// In en, this message translates to:
  /// **'This discards all entered scores and reloads players and modules from the current game setup.'**
  String get startOverBody;

  /// Reset confirmation when no game is running: nothing to reload from, the calculator simply empties.
  ///
  /// In en, this message translates to:
  /// **'This discards all entered scores and leaves the calculator empty.'**
  String get scoreClearBlankBody;

  /// No description provided for @scoreContextGame.
  ///
  /// In en, this message translates to:
  /// **'Scoring the game in progress'**
  String get scoreContextGame;

  /// No description provided for @scoreContextDetached.
  ///
  /// In en, this message translates to:
  /// **'Separate calculation'**
  String get scoreContextDetached;

  /// No description provided for @scoreBackToGameAction.
  ///
  /// In en, this message translates to:
  /// **'Back to the game'**
  String get scoreBackToGameAction;

  /// No description provided for @scoreResetChooseBody.
  ///
  /// In en, this message translates to:
  /// **'Reset the scoring for this game, or start a separate, empty calculation?'**
  String get scoreResetChooseBody;

  /// No description provided for @scoreResetGameOption.
  ///
  /// In en, this message translates to:
  /// **'Reset the game scoring'**
  String get scoreResetGameOption;

  /// No description provided for @scoreClearBlankOption.
  ///
  /// In en, this message translates to:
  /// **'Clear everything (separate calculation)'**
  String get scoreClearBlankOption;

  /// No description provided for @backAction.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backAction;

  /// No description provided for @nextAction.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextAction;

  /// No description provided for @resultsAction.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get resultsAction;

  /// No description provided for @needTwoPlayers.
  ///
  /// In en, this message translates to:
  /// **'Select at least 2 players'**
  String get needTwoPlayers;

  /// No description provided for @scoreSetupIntro.
  ///
  /// In en, this message translates to:
  /// **'Select the players of the finished game.'**
  String get scoreSetupIntro;

  /// No description provided for @scoreModulesIntro.
  ///
  /// In en, this message translates to:
  /// **'Modules that change the final scoring:'**
  String get scoreModulesIntro;

  /// No description provided for @scoreHutModuleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Chocolatl: built huts refund their cost and give bonuses'**
  String get scoreHutModuleSubtitle;

  /// No description provided for @scoreGemModuleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Diamante: gem mines replace the temples'**
  String get scoreGemModuleSubtitle;

  /// No description provided for @scoreGoldIntro.
  ///
  /// In en, this message translates to:
  /// **'Count the gold coins each player has. Tap the number for direct entry.'**
  String get scoreGoldIntro;

  /// No description provided for @scoreWaterIntro.
  ///
  /// In en, this message translates to:
  /// **'Select the water field where each water carrier ended the game. Negative fields subtract gold.'**
  String get scoreWaterIntro;

  /// No description provided for @scoreTemplesIntro.
  ///
  /// In en, this message translates to:
  /// **'Add one entry per temple and count the workers adjacent to it. Gold is awarded automatically: 6 for first place, 3 for second, ties split rounded down.'**
  String get scoreTemplesIntro;

  /// No description provided for @scoreSunIntro.
  ///
  /// In en, this message translates to:
  /// **'Sun tokens not used for overbuilding are worth 1 gold each (maximum 3).'**
  String get scoreSunIntro;

  /// No description provided for @scoreCacaoIntro.
  ///
  /// In en, this message translates to:
  /// **'Leftover cacao fruits give no gold, but they decide ties: with equal gold, the player with most cacao left wins.'**
  String get scoreCacaoIntro;

  /// No description provided for @scoreHutsIntro.
  ///
  /// In en, this message translates to:
  /// **'Mark the huts each player built. Building costs are refunded and bonuses added automatically. Huts are limited physical tiles: a grayed-out hut has no tile left (deselect it from its owner to reassign it).'**
  String get scoreHutsIntro;

  /// No description provided for @scoreGemsIntro.
  ///
  /// In en, this message translates to:
  /// **'Tap a mask tile and pick who owns it. Masks add their value in gold.'**
  String get scoreGemsIntro;

  /// No description provided for @scoreGemsLeftoverIntro.
  ///
  /// In en, this message translates to:
  /// **'Leftover gems next to each village board (1 gold each):'**
  String get scoreGemsLeftoverIntro;

  /// No description provided for @addTempleAction.
  ///
  /// In en, this message translates to:
  /// **'Add temple'**
  String get addTempleAction;

  /// No description provided for @removeTempleTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove temple'**
  String get removeTempleTooltip;

  /// No description provided for @templeNumber.
  ///
  /// In en, this message translates to:
  /// **'Temple {number}'**
  String templeNumber(int number);

  /// No description provided for @hutsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hut} other{{count} huts}}'**
  String hutsCount(int count);

  /// No description provided for @scoreHermitCount.
  ///
  /// In en, this message translates to:
  /// **'{hutName}: own workers with no adjacent jungle tile'**
  String scoreHermitCount(String hutName);

  /// No description provided for @scoreRoadWorkerCount.
  ///
  /// In en, this message translates to:
  /// **'{hutName}: worker tiles in your best row or column'**
  String scoreRoadWorkerCount(String hutName);

  /// No description provided for @assignMaskTooltip.
  ///
  /// In en, this message translates to:
  /// **'Assign mask'**
  String get assignMaskTooltip;

  /// No description provided for @nobodyOption.
  ///
  /// In en, this message translates to:
  /// **'Nobody'**
  String get nobodyOption;

  /// No description provided for @enterValueTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter value'**
  String get enterValueTitle;

  /// No description provided for @okAction.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okAction;

  /// No description provided for @finalScoreTitle.
  ///
  /// In en, this message translates to:
  /// **'Final Score'**
  String get finalScoreTitle;

  /// No description provided for @winsTheGameSingle.
  ///
  /// In en, this message translates to:
  /// **'wins the game!'**
  String get winsTheGameSingle;

  /// No description provided for @winsTheGameShared.
  ///
  /// In en, this message translates to:
  /// **'win the game!'**
  String get winsTheGameShared;

  /// No description provided for @sharedVictorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Shared victory! Tied on gold and leftover cacao.'**
  String get sharedVictorySubtitle;

  /// No description provided for @tiebreakSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Tie on gold broken by leftover cacao fruits.'**
  String get tiebreakSubtitle;

  /// No description provided for @leftoverCacaoTiebreaker.
  ///
  /// In en, this message translates to:
  /// **'Leftover cacao (tiebreaker)'**
  String get leftoverCacaoTiebreaker;

  /// No description provided for @homeIntro.
  ///
  /// In en, this message translates to:
  /// **'Companion for Cacao is a mobile application developed with Flutter designed to assist players of the Cacao board game and its expansions. The goal is to provide digital tools that enhance the gaming experience by facilitating score tracking, rule consultation, and game management.'**
  String get homeIntro;

  /// No description provided for @homeCompletedFeaturesTitle.
  ///
  /// In en, this message translates to:
  /// **'Completed Features'**
  String get homeCompletedFeaturesTitle;

  /// No description provided for @homePendingFeaturesTitle.
  ///
  /// In en, this message translates to:
  /// **'Pending Features'**
  String get homePendingFeaturesTitle;

  /// No description provided for @homeCompletedFeatures.
  ///
  /// In en, this message translates to:
  /// **'🏠 Main Menu: Quick access to all functionalities.\n🗂 Tile Database: Comprehensive catalog of tiles.\n🔍 Tile Filtering: Search and filter by multiple criteria.\n🌴 Cacao Base Game: Full support and game setup.\n🍫 Chocolatl Expansion: Full support including all 4 modules.\n🚀 Diamante Expansion: Full support including all 4 modules.\n🎲 Game Dashboard: Summary, preparation, and tiles in play.\n🌟 Big Game Variant: Integration of all modules and expansions.\n📖 Integrated Manuals: Read the game rules.\n🏆 Score Calculator: Automatic final scoring with official tie rules.\n🌐 Multi-language Support: Catalan, Spanish and English.\n📊 Adaptive UI: Optimized design for different screen sizes.\n🔄 Auto-Updater: Automatic detection of new versions.'**
  String get homeCompletedFeatures;

  /// No description provided for @homePendingFeatures.
  ///
  /// In en, this message translates to:
  /// **'🕒 Turn Timer: Control the duration of each turn.\n📜 Game History: Record of finished games and player stats.\n⚙️ Custom Settings: Adjust the game experience.'**
  String get homePendingFeatures;

  /// No description provided for @homeContactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact Me'**
  String get homeContactTitle;

  /// No description provided for @homeContactBody.
  ///
  /// In en, this message translates to:
  /// **'For suggestions, improvements, bug reports, or any other inquiries, you can visit our GitHub repository. The application is open-source and we are always looking for contributors to help improve it.'**
  String get homeContactBody;

  /// No description provided for @homeVisitRepo.
  ///
  /// In en, this message translates to:
  /// **'Visit our GitHub repository:'**
  String get homeVisitRepo;

  /// No description provided for @homeGithubBody.
  ///
  /// In en, this message translates to:
  /// **'On GitHub, you can open \"issues\" to report bugs, suggest new features, or even submit \"pull requests\" with your own contributions. We strive to constantly improve the app and appreciate any help!'**
  String get homeGithubBody;

  /// No description provided for @rulesBaseGame.
  ///
  /// In en, this message translates to:
  /// **'Base Game'**
  String get rulesBaseGame;

  /// No description provided for @rulesInstructions.
  ///
  /// In en, this message translates to:
  /// **'Instructions'**
  String get rulesInstructions;

  /// No description provided for @rulesOverview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get rulesOverview;

  /// No description provided for @rulesExpansionHeader.
  ///
  /// In en, this message translates to:
  /// **'Expansion: {name}'**
  String rulesExpansionHeader(String name);

  /// No description provided for @rulesExpansionRules.
  ///
  /// In en, this message translates to:
  /// **'{name} Rules'**
  String rulesExpansionRules(String name);

  /// No description provided for @openMenuTooltip.
  ///
  /// In en, this message translates to:
  /// **'Open menu'**
  String get openMenuTooltip;

  /// No description provided for @quantityAll.
  ///
  /// In en, this message translates to:
  /// **'ALL'**
  String get quantityAll;

  /// No description provided for @errorGenericRetry.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGenericRetry;

  /// No description provided for @pageNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Page Not Found'**
  String get pageNotFoundTitle;

  /// No description provided for @routeNotFound.
  ///
  /// In en, this message translates to:
  /// **'Route not found: {uri}'**
  String routeNotFound(String uri);

  /// No description provided for @invalidDataMessage.
  ///
  /// In en, this message translates to:
  /// **'Invalid data for this screen.'**
  String get invalidDataMessage;

  /// No description provided for @retryAction.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryAction;

  /// No description provided for @playerNameHint.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get playerNameHint;

  /// No description provided for @aboutIntro.
  ///
  /// In en, this message translates to:
  /// **'Digital tools for Cacao players and its expansions: game setup, score counting and rules lookup, all in one place.'**
  String get aboutIntro;

  /// No description provided for @aboutOpenSource.
  ///
  /// In en, this message translates to:
  /// **'Open source'**
  String get aboutOpenSource;

  /// No description provided for @aboutIncludedTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s included'**
  String get aboutIncludedTitle;

  /// No description provided for @aboutInDevelopmentTitle.
  ///
  /// In en, this message translates to:
  /// **'In development'**
  String get aboutInDevelopmentTitle;

  /// No description provided for @aboutSoonBadge.
  ///
  /// In en, this message translates to:
  /// **'soon'**
  String get aboutSoonBadge;

  /// No description provided for @aboutRepoTitle.
  ///
  /// In en, this message translates to:
  /// **'GitHub repository'**
  String get aboutRepoTitle;

  /// No description provided for @aboutRepoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Report bugs, suggest improvements or contribute'**
  String get aboutRepoSubtitle;

  /// No description provided for @aboutMadeWith.
  ///
  /// In en, this message translates to:
  /// **'Made with Flutter'**
  String get aboutMadeWith;

  /// No description provided for @aboutFeaturePrep.
  ///
  /// In en, this message translates to:
  /// **'Guided setup'**
  String get aboutFeaturePrep;

  /// No description provided for @aboutFeaturePrepSub.
  ///
  /// In en, this message translates to:
  /// **'Step by step for the base game and expansions'**
  String get aboutFeaturePrepSub;

  /// No description provided for @aboutFeatureScore.
  ///
  /// In en, this message translates to:
  /// **'Score calculator'**
  String get aboutFeatureScore;

  /// No description provided for @aboutFeatureScoreSub.
  ///
  /// In en, this message translates to:
  /// **'Final score with the official tiebreakers'**
  String get aboutFeatureScoreSub;

  /// No description provided for @aboutFeatureTiles.
  ///
  /// In en, this message translates to:
  /// **'Tile catalogue'**
  String get aboutFeatureTiles;

  /// No description provided for @aboutFeatureTilesSub.
  ///
  /// In en, this message translates to:
  /// **'Search and filter by multiple criteria'**
  String get aboutFeatureTilesSub;

  /// No description provided for @aboutFeatureRules.
  ///
  /// In en, this message translates to:
  /// **'Rules and manuals'**
  String get aboutFeatureRules;

  /// No description provided for @aboutFeatureRulesSub.
  ///
  /// In en, this message translates to:
  /// **'Built-in lookup inside the app'**
  String get aboutFeatureRulesSub;

  /// No description provided for @aboutFeatureExpansions.
  ///
  /// In en, this message translates to:
  /// **'Full expansions'**
  String get aboutFeatureExpansions;

  /// No description provided for @aboutFeatureExpansionsSub.
  ///
  /// In en, this message translates to:
  /// **'Xocolatl, Diamante and the Big Game variant'**
  String get aboutFeatureExpansionsSub;

  /// No description provided for @aboutFeatureLangs.
  ///
  /// In en, this message translates to:
  /// **'Multi-language'**
  String get aboutFeatureLangs;

  /// No description provided for @aboutFeatureLangsSub.
  ///
  /// In en, this message translates to:
  /// **'Catalan, Spanish and English'**
  String get aboutFeatureLangsSub;

  /// No description provided for @aboutSoonTimer.
  ///
  /// In en, this message translates to:
  /// **'Turn timer'**
  String get aboutSoonTimer;

  /// No description provided for @aboutSoonHistory.
  ///
  /// In en, this message translates to:
  /// **'History and statistics'**
  String get aboutSoonHistory;

  /// No description provided for @aboutSoonSettings.
  ///
  /// In en, this message translates to:
  /// **'Custom settings'**
  String get aboutSoonSettings;

  /// No description provided for @homeCardSetupSub.
  ///
  /// In en, this message translates to:
  /// **'Set up players, expansions and modules'**
  String get homeCardSetupSub;

  /// No description provided for @homeCardTilesSub.
  ///
  /// In en, this message translates to:
  /// **'Browse the full tile catalogue'**
  String get homeCardTilesSub;

  /// No description provided for @homeCardScoresSub.
  ///
  /// In en, this message translates to:
  /// **'Compute the final score automatically'**
  String get homeCardScoresSub;

  /// No description provided for @homeCardRulesSub.
  ///
  /// In en, this message translates to:
  /// **'Built-in manuals and quick reference'**
  String get homeCardRulesSub;

  /// No description provided for @homeAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About the app'**
  String get homeAboutTitle;

  /// No description provided for @homeTagline.
  ///
  /// In en, this message translates to:
  /// **'Your table-side companion for Cacao'**
  String get homeTagline;

  /// No description provided for @loadingLabel.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get loadingLabel;

  /// No description provided for @scoreTemplesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No temples yet — add one for each temple on the board.'**
  String get scoreTemplesEmpty;

  /// No description provided for @expansionsModulesSection.
  ///
  /// In en, this message translates to:
  /// **'Expansions and modules'**
  String get expansionsModulesSection;

  /// No description provided for @expansionSelectHint.
  ///
  /// In en, this message translates to:
  /// **'Tap an expansion to turn it on and pick its modules.'**
  String get expansionSelectHint;

  /// No description provided for @expansionTapHint.
  ///
  /// In en, this message translates to:
  /// **'Tap to pick its modules'**
  String get expansionTapHint;

  /// No description provided for @modulesPickLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose modules'**
  String get modulesPickLabel;

  /// No description provided for @moduleCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count} / {total} modules'**
  String moduleCountLabel(int count, int total);

  /// No description provided for @cancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelAction;

  /// No description provided for @clearSetupBody.
  ///
  /// In en, this message translates to:
  /// **'This clears the selected players, expansions and modules.'**
  String get clearSetupBody;

  /// No description provided for @moduleWarningPickOne.
  ///
  /// In en, this message translates to:
  /// **'Pick at least one module'**
  String get moduleWarningPickOne;

  /// No description provided for @expansionNeedsModuleHint.
  ///
  /// In en, this message translates to:
  /// **'An expansion has no modules selected'**
  String get expansionNeedsModuleHint;

  /// No description provided for @playersNeededHint.
  ///
  /// In en, this message translates to:
  /// **'Add at least 2 players'**
  String get playersNeededHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ca', 'en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ca':
      return AppLocalizationsCa();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
