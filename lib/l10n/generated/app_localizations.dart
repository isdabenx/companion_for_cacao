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
