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

  /// No description provided for @junglePileLabel.
  ///
  /// In en, this message translates to:
  /// **'Build the jungle draw pile'**
  String get junglePileLabel;

  /// No description provided for @junglePileDetail.
  ///
  /// In en, this message translates to:
  /// **'Mix the remaining jungle tiles and lay them out as a face-down jungle draw pile.'**
  String get junglePileDetail;

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
  /// **'For each physical tile, pick the side that landed face up.'**
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
