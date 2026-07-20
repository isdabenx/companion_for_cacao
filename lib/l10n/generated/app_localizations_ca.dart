// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get colorWhite => 'blanc';

  @override
  String get colorRed => 'vermell';

  @override
  String get colorPurple => 'lila';

  @override
  String get colorYellow => 'groc';

  @override
  String get villageBoardLabel => 'Agafa el teu tauler de poblat';

  @override
  String villageBoardDetail(String color) {
    return 'Agafa el tauler de poblat de color $color i posa-te\'l al davant. Hi aniran la teva pila de treballadors i el track del portador d\'aigua.';
  }

  @override
  String get waterCarrierLabel =>
      'Posa el portador d\'aigua a la casella \"-10\"';

  @override
  String waterCarrierDetail(String color) {
    return 'Agafa el portador d\'aigua de color $color i col·loca\'l a la casella d\'aigua amb valor \"-10\" del teu tauler de poblat.';
  }

  @override
  String get ownTilesLabel => 'Agafa totes les teves rajoles de treballador';

  @override
  String ownTilesDetail(String color) {
    return 'Reuneix totes les rajoles de treballador amb el dors de color $color; són la teva reserva personal per a tota la partida.';
  }

  @override
  String removeWorkerLabel(String distribution) {
    return 'Torna una rajola de treballador $distribution a la capsa';
  }

  @override
  String removeWorkerDetail(String distribution) {
    return 'Busca entre les teves rajoles de treballador una de les $distribution i torna-la a la capsa del joc.';
  }

  @override
  String get removeWorkerRationale =>
      'Amb 3 o més jugadors cadascú usa menys rajoles de treballador perquè la jungla no s\'esgoti abans que acabi la partida.';

  @override
  String get shuffleWorkersLabel => 'Barreja els treballadors i roba\'n 3';

  @override
  String get shuffleWorkersDetail =>
      'Cada jugador barreja les seves rajoles de treballador i les posa com a pila de robatori cap per avall al costat del seu tauler de poblat. Després, roba les 3 rajoles superiors de la seva pila i les pren a la mà.';

  @override
  String get initialTilesMarketLabel =>
      'Posa les 2 rajoles inicials en diagonal';

  @override
  String get initialTilesMarketDetail =>
      'De les rajoles de jungla, agafa la \"plantació simple\" i el \"mercat de preu 2\" i posa-les cara amunt al mig de la taula, en diagonal l\'una respecte de l\'altra; formen les rajoles inicials de la zona de joc.';

  @override
  String get junglePileLabel => 'Munta la pila de jungla';

  @override
  String get junglePileDetail =>
      'Barreja les rajoles de jungla restants i posa-les com a pila de robatori cap per avall.';

  @override
  String get jungleDisplayLabel => 'Gira 2 rajoles de jungla';

  @override
  String get jungleDisplayDetail =>
      'Roba les 2 rajoles superiors de la pila de jungla i posa-les al costat de la pila com a mostra de jungla cara amunt.';

  @override
  String get resourcesBankLabel => 'Prepara el cacau, els sols i la banca';

  @override
  String get resourcesBankDetail =>
      'Posa els fruits de cacau i les fitxes de sol com a piles de reserva separades. Posa-hi al costat les monedes d\'or com a banca.';

  @override
  String removeTilesLabel(int quantity, String tileName) {
    return 'Torna ${quantity}x $tileName a la capsa';
  }

  @override
  String removeTilesDetail(num quantity, String tileName) {
    String _temp0 = intl.Intl.pluralLogic(
      quantity,
      locale: localeName,
      other: 'Aparta ${quantity}x $tileName i torna-ho a la capsa.',
      one: 'Aparta ${quantity}x $tileName i torna-ho a la capsa.',
    );
    return '$_temp0';
  }

  @override
  String removeAllTilesLabel(String tileName) {
    return 'Torna totes les rajoles de $tileName a la capsa';
  }

  @override
  String removeAllTilesDetail(String tileName) {
    return 'Aparta totes les rajoles de $tileName i torna-les a la capsa.';
  }

  @override
  String addTilesLabel(int quantity, String tileName) {
    return 'Afegeix ${quantity}x $tileName a la jungla';
  }

  @override
  String addTilesDetail(int quantity, String tileName) {
    return 'Afegeix ${quantity}x $tileName a les rajoles de jungla abans de muntar la pila de robatori.';
  }

  @override
  String get twoPlayerRemovalRationale =>
      'Amb 2 jugadors la jungla es redueix perquè la zona de joc quedi recollida i la partida mantingui el ritme.';

  @override
  String get bigGame3pRemovalRationale =>
      'El Big Game amb 3 jugadors retira unes quantes rajoles perquè el gran conjunt de rajoles quedi equilibrat.';

  @override
  String get tileSinglePlantation => 'Plantació simple';

  @override
  String get tileDoublePlantation => 'Plantació doble';

  @override
  String get tileMarketSelling2 => 'Mercat de preu 2';

  @override
  String get tileMarketSelling3 => 'Mercat de preu 3';

  @override
  String get tileGoldMineV1 => 'Mina d\'or de valor 1';

  @override
  String get tileGoldMineV2 => 'Mina d\'or de valor 2';

  @override
  String get tileWater => 'Aigua';

  @override
  String get tileSunWorshipingSite => 'Lloc d\'adoració del sol';

  @override
  String get tileTemple => 'Temple';

  @override
  String get tileWatering => 'Reg';

  @override
  String get tileChocolateKitchen => 'Cuina de xocolata';

  @override
  String get tileChocolateMarket => 'Mercat de xocolata';

  @override
  String get tileGemMine => 'Mina de gemmes';

  @override
  String get tileTreeOfLife => 'Arbre de la Vida';

  @override
  String get mapTokensLabel => 'Agafa 2 fitxes de mapa';

  @override
  String mapTokensDetail(String color) {
    return 'El jugador $color agafa 2 fitxes de mapa.';
  }

  @override
  String get mapTokensSurplusLabel =>
      'Torna les fitxes de mapa sobrants a la capsa';

  @override
  String get mapTokensSurplusDetail =>
      'Torna les fitxes de mapa sobrants a la capsa.';

  @override
  String get mapBoardLabel => 'Col·loca el tauler de mapa';

  @override
  String get mapBoardDetail =>
      'Col·loca el tauler de mapa just al costat de la pila de jungla.';

  @override
  String get jungleDisplayMapLabel =>
      'Gira 4 rajoles de jungla (tauler de mapa + mostra)';

  @override
  String get jungleDisplayMapDetail =>
      'Roba les 4 rajoles superiors de la pila de jungla. Posa les dues primeres cara amunt als espais marcats del tauler de mapa. Posa les altres dues com a mostra de jungla cara amunt al costat del tauler de mapa.';

  @override
  String get initialTilesWaterLabel =>
      'Posa les 2 rajoles inicials en diagonal';

  @override
  String get initialTilesWaterDetail =>
      'De les rajoles de jungla, agafa la \"plantació simple\" i l\'\"aigua\" i posa-les cara amunt al mig de la taula, en diagonal l\'una respecte de l\'altra; formen les rajoles inicials de la zona de joc.';

  @override
  String get initialTilesWaterRationale =>
      'El mòdul de Reg canvia el mercat inicial per una rajola d\'aigua.';

  @override
  String get chocolateBarsLabel => 'Prepara les 20 rajoles de xocolata';

  @override
  String get chocolateBarsDetail =>
      'Posa les 20 rajoles de xocolata com a pila de reserva separada al costat dels fruits de cacau.';

  @override
  String get hutsMarketLabel => 'Llança les 12 rajoles de cabana';

  @override
  String get hutsMarketDetail =>
      'Agafa les 12 rajoles de cabana, deixa-les caure des de poca alçada per determinar a l\'atzar quina cara queda amunt, i ordena-les per cost de construcció al costat de la banca com a reserva.';

  @override
  String get hutsMarketRationale =>
      'Variant: alternativament, els jugadors poden acordar una selecció concreta de cabanes en lloc d\'un assortiment aleatori.';

  @override
  String get gemsRemoveLabel => 'Torna 8 gemmes a la capsa';

  @override
  String get gemsRemoveDetail =>
      'Retira 8 gemmes (2 de cada color) i torna-les a la capsa.';

  @override
  String get mineCarLabel => 'Omple i sacseja la vagoneta';

  @override
  String get mineCarAllDetail =>
      'Fica les 32 gemmes a la vagoneta i barreja-les sacsejant-la. Posa la vagoneta al costat de la zona de joc.';

  @override
  String get mineCarRemainingDetail =>
      'Fica les gemmes restants a la vagoneta i barreja-les sacsejant-la. Posa la vagoneta al costat de la zona de joc.';

  @override
  String get masksLabel => 'Ordena les màscares com a reserva';

  @override
  String get masksAllDetail =>
      'Ordena les 7 màscares pel seu valor en una filera ascendent i encavalcada com a reserva.';

  @override
  String get masksWithout12Detail =>
      'Ordena les màscares (sense la de valor 12) pel seu valor en una filera ascendent i encavalcada com a reserva.';

  @override
  String get gemMinesReminderLabel =>
      'Recordatori de regla: gemmes a les mines noves';

  @override
  String get gemMinesReminderDetail =>
      'Quan una rajola de mina de gemmes es posi a la mostra de jungla o al tauler de mapa, treu 6 gemmes de la vagoneta i posa-les sobre la rajola de mina.';

  @override
  String get treeOfLife0004Label =>
      'Afegeix la teva rajola de treballador 0-0-0-4';

  @override
  String treeOfLife0004Detail(String color) {
    return 'Mòdul Arbre de la Vida: el jugador $color agafa la seva rajola de treballador 0-0-0-4 del mòdul Nous Treballadors i l\'afegeix a les seves rajoles.';
  }

  @override
  String get treeOfLife0004Rationale =>
      'Amb 2 jugadors l\'Arbre de la Vida requereix la rajola 0-0-0-4 perquè tots els arbres es puguin collir del tot (reglament de Diamante).';

  @override
  String get emperorLabel => 'Col·loca la figura de l\'Emperador';

  @override
  String get emperorOnMarketDetail =>
      'Després de posar les rajoles inicials, col·loca la figura de l\'Emperador sobre el mercat de preu 2.';

  @override
  String get emperorOnWaterDetail =>
      'Després de posar les rajoles inicials, col·loca la figura de l\'Emperador sobre la rajola d\'aigua.';

  @override
  String get newWorkersSelectionLabel => 'Tria les rajoles de treballador';

  @override
  String get newWorkersSelectionDetail =>
      'Selecciona quines rajoles de treballador voleu usar en aquesta partida.';

  @override
  String get returnToBoxTitle => 'Torna a la capsa';

  @override
  String get returnToBoxSubtitle =>
      'Aquestes rajoles no s\'usen en aquesta partida';

  @override
  String get allSetTitle => 'Tot a punt!';

  @override
  String get allSetMessage =>
      'La taula està preparada. Que guanyi el millor plantador de cacau!';

  @override
  String get drawFirstPlayerAction => 'Sortejar-lo a l\'atzar';

  @override
  String get drawAgainAction => 'Torna a sortejar';

  @override
  String startsFirst(String name) {
    return 'Comença $name!';
  }

  @override
  String get backToGameAction => 'Torna a la partida';
}
