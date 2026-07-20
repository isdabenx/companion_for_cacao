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
  String get colorPurple => 'violeta';

  @override
  String get colorYellow => 'groc';

  @override
  String get villageBoardLabel => 'Agafa el tauler del teu poblat';

  @override
  String villageBoardDetail(String color) {
    return 'Agafa el tauler de poblat de color $color i posa-te\'l al davant. Hi ha els teus magatzems i els remansos de l\'aiguader.';
  }

  @override
  String get waterCarrierLabel => 'Posa l\'aiguader al remans \"-10\"';

  @override
  String waterCarrierDetail(String color) {
    return 'Agafa l\'aiguader de color $color i col·loca\'l al remans de valor \"-10\" del tauler del teu poblat.';
  }

  @override
  String get ownTilesLabel => 'Agafa totes les teves rajoles de recol·lectors';

  @override
  String ownTilesDetail(String color) {
    return 'Reuneix totes les rajoles de recol·lectors amb el revers de color $color; són la teva reserva personal per a tota la partida.';
  }

  @override
  String removeWorkerLabel(String distribution) {
    return 'Torna una rajola de recol·lectors $distribution a la capsa';
  }

  @override
  String removeWorkerDetail(String distribution) {
    return 'Busca entre les teves rajoles de recol·lectors una de les $distribution i torna-la a la capsa del joc.';
  }

  @override
  String get removeWorkerRationale =>
      'Amb 3 o més jugadors cadascú usa menys rajoles de recol·lectors perquè la selva no s\'esgoti abans que acabi la partida.';

  @override
  String get shuffleWorkersLabel => 'Barreja els recol·lectors i roba\'n 3';

  @override
  String get shuffleWorkersDetail =>
      'Cada jugador barreja les seves rajoles de recol·lectors i les posa cap per avall formant una pila al costat del tauler del seu poblat. A continuació, roba les 3 rajoles superiors de la seva pila i les pren a la mà.';

  @override
  String get initialTilesMarketLabel =>
      'Posa les 2 rajoles inicials en diagonal';

  @override
  String get initialTilesMarketDetail =>
      'De les rajoles de selva, busca la \"plantació simple\" i el \"mercat de preu de venda 2\" i posa-les cara amunt al mig de la taula, en diagonal l\'una respecte de l\'altra; són les rajoles inicials de la zona de joc.';

  @override
  String get junglePileLabel => 'Munta la pila de la selva';

  @override
  String get junglePileDetail =>
      'Barreja les rajoles de selva restants i posa-les cap per avall formant la pila de la selva.';

  @override
  String get jungleDisplayLabel => 'Descobreix la selva explorada';

  @override
  String get jungleDisplayDetail =>
      'Roba les 2 rajoles superiors de la pila de la selva i posa-les cara amunt al costat de la pila: formen la selva explorada.';

  @override
  String get resourcesBankLabel => 'Prepara el cacau, els sols i la banca';

  @override
  String get resourcesBankDetail =>
      'Posa els fruits del cacau i les fitxes de sol formant reserves separades. Posa-hi al costat les monedes d\'or formant la banca.';

  @override
  String removeTilesLabel(int quantity, String tileName) {
    return 'Torna ${quantity}x $tileName a la capsa';
  }

  @override
  String removeTilesDetail(num quantity, String tileName) {
    String _temp0 = intl.Intl.pluralLogic(
      quantity,
      locale: localeName,
      other: 'Busca ${quantity}x $tileName i deixa-les a la capsa.',
      one: 'Busca ${quantity}x $tileName i deixa-la a la capsa.',
    );
    return '$_temp0';
  }

  @override
  String removeAllTilesLabel(String tileName) {
    return 'Torna totes les rajoles de $tileName a la capsa';
  }

  @override
  String removeAllTilesDetail(String tileName) {
    return 'Busca totes les rajoles de $tileName i deixa-les a la capsa.';
  }

  @override
  String addTilesLabel(int quantity, String tileName) {
    return 'Afegeix ${quantity}x $tileName a la selva';
  }

  @override
  String addTilesDetail(int quantity, String tileName) {
    return 'Afegeix ${quantity}x $tileName a les rajoles de selva abans de muntar la pila de la selva.';
  }

  @override
  String get twoPlayerRemovalRationale =>
      'Amb 2 jugadors la selva es redueix perquè la zona de joc quedi recollida i la partida mantingui el ritme.';

  @override
  String get bigGame3pRemovalRationale =>
      'El Big Game amb 3 jugadors retira unes quantes rajoles perquè el gran conjunt de rajoles quedi equilibrat.';

  @override
  String get tileSinglePlantation => 'Plantació simple';

  @override
  String get tileDoublePlantation => 'Plantació doble';

  @override
  String get tileMarketSelling2 => 'Mercat, preu de venda 2';

  @override
  String get tileMarketSelling3 => 'Mercat, preu de venda 3';

  @override
  String get tileGoldMineV1 => 'Mina d\'or, valor 1';

  @override
  String get tileGoldMineV2 => 'Mina d\'or, valor 2';

  @override
  String get tileWater => 'Cenot';

  @override
  String get tileSunWorshipingSite => 'Adoració al sol';

  @override
  String get tileTemple => 'Temple';

  @override
  String get tileWatering => 'Irrigació';

  @override
  String get tileChocolateKitchen => 'Xocolatera';

  @override
  String get tileChocolateMarket => 'Mercat de xocolata';

  @override
  String get tileGemMine => 'Mina de gemmes';

  @override
  String get tileTreeOfLife => 'Arbre de la vida';

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
      'Les fitxes de mapa sobrants es tornen a la capsa.';

  @override
  String get mapBoardLabel => 'Col·loca el tauler de mapes';

  @override
  String get mapBoardDetail =>
      'Després de preparar la pila de la selva, col·loca el tauler de mapes al seu costat.';

  @override
  String get jungleDisplayMapLabel =>
      'Descobreix 4 rajoles de selva (tauler de mapes + selva explorada)';

  @override
  String get jungleDisplayMapDetail =>
      'Pren les quatre rajoles superiors de la pila de la selva. Posa les dues primeres, cara amunt, a les caselles del tauler de mapes; les altres dues formen la selva explorada, com és habitual.';

  @override
  String get initialTilesWaterLabel =>
      'Posa les 2 rajoles inicials en diagonal';

  @override
  String get initialTilesWaterDetail =>
      'Com a rajoles inicials, posa una plantació simple (com sempre) i, en lloc del mercat de preu de venda \"2\", un cenot.';

  @override
  String get initialTilesWaterRationale =>
      'El mòdul d\'irrigació canvia el mercat inicial per un cenot.';

  @override
  String get chocolateBarsLabel => 'Prepara les 20 tauletes de xocolata';

  @override
  String get chocolateBarsDetail =>
      'Deixa les tauletes de xocolata formant una reserva al costat dels fruits del cacau.';

  @override
  String get hutsMarketLabel => 'Deixa caure les 12 rajoles de cabana';

  @override
  String get hutsMarketDetail =>
      'Sosté les 12 rajoles de cabana amb les mans, a una certa alçada sobre la taula, i deixa-les caure. Les cares que mostrin seran les que s\'usin en aquesta partida. Després, vigilant de no girar-ne cap, col·loca-les al costat de la banca, ordenades segons el seu cost.';

  @override
  String get hutsMarketRationale =>
      'Variant: en lloc de determinar a l\'atzar les funcions disponibles, els jugadors poden acordar inicialment, per a cada cabana, quina de les seves dues cares s\'usa.';

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
      'Quan una rajola de mina de gemmes es posi a la selva explorada o al tauler de mapes, treu 6 gemmes de la vagoneta i posa-les sobre la rajola de mina.';

  @override
  String get treeOfLife0004Label =>
      'Afegeix la teva rajola de recol·lectors 0-0-0-4';

  @override
  String treeOfLife0004Detail(String color) {
    return 'Mòdul L\'arbre de la vida: el jugador $color agafa la seva rajola de recol·lectors 0-0-0-4 del mòdul Els nous recol·lectors i l\'afegeix a les seves rajoles.';
  }

  @override
  String get treeOfLife0004Rationale =>
      'Amb 2 jugadors L\'arbre de la vida requereix la rajola 0-0-0-4 perquè tots els arbres es puguin collir del tot (reglament de Diamante).';

  @override
  String get emperorLabel => 'Col·loca la figura de l\'ahau';

  @override
  String get emperorOnMarketDetail =>
      'Després de posar les rajoles inicials, posa la figura de l\'ahau sobre el mercat de preu de venda \"2\".';

  @override
  String get emperorOnWaterDetail =>
      'Després de posar les rajoles inicials, posa la figura de l\'ahau sobre el cenot.';

  @override
  String get newWorkersSelectionLabel => 'Tria les rajoles de recol·lectors';

  @override
  String get newWorkersSelectionDetail =>
      'Selecciona quines rajoles de recol·lectors voleu usar en aquesta partida.';

  @override
  String get returnToBoxTitle => 'Torna a la capsa';

  @override
  String get returnToBoxSubtitle =>
      'Aquestes rajoles no s\'usen en aquesta partida';

  @override
  String get allSetTitle => 'Tot a punt!';

  @override
  String get allSetMessage =>
      'La taula està preparada. Que guanyi el millor cultivador de cacau!';

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

  @override
  String get menuHome => 'Inici';

  @override
  String get menuGameSetup => 'Nova partida';

  @override
  String get menuTiles => 'Rajoles';

  @override
  String get menuScores => 'Puntuacions';

  @override
  String get menuRules => 'Regles';

  @override
  String get titlePreparation => 'Preparació';

  @override
  String get titleGameDashboard => 'Tauler de partida';

  @override
  String get phaseTilePool => 'Rajoles en joc';

  @override
  String get phasePlayerSetup => 'Preparació dels jugadors';

  @override
  String get phaseBoardSetup => 'Preparació de la taula';

  @override
  String get phaseSupplies => 'Reserves';

  @override
  String get playersSection => 'Jugadors';

  @override
  String get expansionsSection => 'Expansions';

  @override
  String get modulesSection => 'Mòduls';

  @override
  String needMorePlayers(int count) {
    return 'En falten $count+';
  }

  @override
  String get tapColorHint =>
      'Toca un color per afegir un jugador. Mantén premut i arrossega per reordenar.';

  @override
  String get selectExpansionsHint => 'Selecciona les expansions amb què jugueu';

  @override
  String get selectModulesHint => 'Selecciona els mòduls amb què jugueu';

  @override
  String get noExpansionWithModules =>
      'No hi ha cap expansió amb mòduls seleccionada';

  @override
  String get noModules => 'Sense mòduls';

  @override
  String get startGame => 'Comença la partida';

  @override
  String get resumeGame => 'Reprèn la partida';

  @override
  String get clearSetup => 'Neteja-ho tot';

  @override
  String get gameVariant => 'Variant de joc';

  @override
  String get bigGame => 'Big Game';

  @override
  String get bigGameHint =>
      'Usa totes les rajoles de tots els mòduls, sense substitucions';

  @override
  String get showAllTiles => 'Mostra totes les rajoles';

  @override
  String get hideTiles => 'Amaga les rajoles';

  @override
  String get tilesInPlay => 'Rajoles en joc';

  @override
  String get scoreCalculator => 'Calculadora de puntuació';

  @override
  String get noPlayersSelected => 'Cap jugador seleccionat';

  @override
  String get noTiles => 'Sense rajoles';

  @override
  String get baseGameOnly => 'Només el joc base';

  @override
  String playerPosition(int position) {
    return 'Jugador $position';
  }

  @override
  String get closeAction => 'Tanca';

  @override
  String get workerSheetTitle => 'Els nous recol·lectors';

  @override
  String get workerChooseIntro =>
      'Tria quines rajoles de recol·lectors usarà cada jugador. Tots els jugadors usen el mateix conjunt.';

  @override
  String get workerHowItWorks => 'Com funciona?';

  @override
  String get workerHelpBody =>
      '• Els nous recol·lectors afegeix 4 rajoles de recol·lectors noves amb distribucions diferents de les del joc base.\n• Pots usar un ajust ràpid o regular manualment la quantitat de cada rajola.\n• L\'equilibri entre recol·lectors i rajoles de selva importa: si la diferència queda fora del marge indicat, la partida pot quedar desequilibrada.\n• Per defecte, el joc recomana mantenir 11 rajoles per jugador, però en pots afegir més per a una partida més llarga.';

  @override
  String get workerPresetsSection => 'Ajustos ràpids';

  @override
  String get workerRandomSection => 'Atzar';

  @override
  String get workerPresetBaseOnly => 'Només base';

  @override
  String get workerPresetReplace => 'Substitueix';

  @override
  String get workerPresetBase0004 => 'Base + 0-0-0-4';

  @override
  String get workerPresetAddAll => 'Afegeix-les totes';

  @override
  String get workerAddAllDefault => 'Afegeix-les totes (per defecte)';

  @override
  String get workerManual => 'Manual';

  @override
  String get workerSurprise => 'Sorpresa';

  @override
  String get workerSurpriseChip => 'Sorpresa +2';

  @override
  String get workerSurpriseTooltip =>
      'Base + 2 rajoles noves triades a l\'atzar. Torna a tocar per a una parella diferent.';

  @override
  String get workerDescBaseOnly =>
      'Usa només les rajoles del joc base (11 per jugador). Les rajoles noves de Diamante no s\'hi afegeixen.';

  @override
  String get workerDescReplace =>
      'Substitueix 4 rajoles base (1-1-1-1) per les 4 noves de Diamante. Total: 11 per jugador.';

  @override
  String get workerDescBase0004 =>
      'Afegeix només la rajola 0-0-0-4 a les 11 de base. Total: 12 per jugador. Recomanat per la comunitat (BGG).';

  @override
  String get workerDescAddAll =>
      'Afegeix les 4 rajoles noves de Diamante a les 11 de base. Total: 15 per jugador.';

  @override
  String get workerDescManual =>
      'Selecció manual: regula la quantitat de cada rajola individualment.';

  @override
  String get workerDescSurprise =>
      'Sorpresa: rajoles base + 2 noves de Diamante triades a l\'atzar. Torna a tocar per a una parella diferent.';

  @override
  String workerCustomPreset(String name) {
    return 'Ajust personalitzat: $name';
  }

  @override
  String workerSummaryLine(String label, int count) {
    return '$label · $count rajoles/jugador';
  }

  @override
  String get workerBaseTiles => 'Rajoles base';

  @override
  String get workerNewTiles => 'Rajoles noves (Diamante)';

  @override
  String get workerBalanceOk => 'L\'equilibri és correcte';

  @override
  String get workerBalanceOut => 'Fora del marge recomanat';

  @override
  String get workerBalanceValid => 'Vàlid';

  @override
  String get workerBalanceOutShort => 'Fora de marge';

  @override
  String get workerBalanceHint =>
      'El reglament recomana aquest marge per mantenir la partida equilibrada, però pots aplicar la selecció igualment.';

  @override
  String get workerBalanceWorkersWord => 'recol·lectors';

  @override
  String get workerBalanceJungleWord => 'selva';

  @override
  String workerBalanceRange(int min, int max) {
    return '(marge: $min–$max)';
  }

  @override
  String workerTilesPerPlayerLine(int count) {
    return 'Rajoles per jugador: $count';
  }

  @override
  String get workerLockedTooltip =>
      'Obligatòria amb L\'arbre de la vida (2 jugadors)';

  @override
  String get resetAction => 'Restableix';

  @override
  String get applyAction => 'Aplica';

  @override
  String get saveAction => 'Desa';

  @override
  String get deleteAction => 'Elimina';

  @override
  String get savePresetTitle => 'Desa com a ajust';

  @override
  String get presetNameLabel => 'Nom de l\'ajust';

  @override
  String get presetNameHint => 'p. ex. El nostre preferit';

  @override
  String get deletePresetTitle => 'Eliminar l\'ajust';

  @override
  String deletePresetConfirm(String name) {
    return 'Vols eliminar \'$name\'?';
  }

  @override
  String get errorLoadingPresets =>
      'Error en carregar els ajustos personalitzats';

  @override
  String get errorSavingPresets => 'Error en desar els ajustos personalitzats';

  @override
  String get hutRegisterTitle => 'Registra la tirada de cabanes';

  @override
  String get hutRegisterHint =>
      'Per a cada rajola física, tria la cara que ha quedat amunt.';

  @override
  String get hutRegisterAction =>
      'Registra quines cabanes han quedat cara amunt';

  @override
  String get hutRegisteredEdit => 'Tirada registrada · toca per editar';

  @override
  String get forgetThrowAction => 'Oblida la tirada';

  @override
  String get hutMarketCrier => 'El pregoner del mercat';

  @override
  String get hutHermit => 'El remeier';

  @override
  String get hutRoadWorker => 'El cuidador de sacbeobs';

  @override
  String get hutTrader => 'El comerciant';

  @override
  String get hutFarmer => 'L\'agricultor';

  @override
  String get hutShaman => 'El xaman';

  @override
  String get hutMonk => 'L\'uay';

  @override
  String get hutMasterBuilder => 'El constructor';

  @override
  String get hutForeman => 'El capatàs';

  @override
  String get hutFountainMaster => 'El bruixot saurí';

  @override
  String get hutChiefsDaughter => 'La filla del cap';

  @override
  String get hutChiefsSon => 'El fill del cap';

  @override
  String get hutChiefsWife => 'La dona del cap';

  @override
  String get hutChief => 'El cap';

  @override
  String get menuTitle => 'Menú';

  @override
  String get summaryTiles => 'Rajoles';

  @override
  String get summaryWorkers => 'Recol·lectors';

  @override
  String get summaryJungle => 'Selva';

  @override
  String get summaryHuts => 'Cabanes';
}
