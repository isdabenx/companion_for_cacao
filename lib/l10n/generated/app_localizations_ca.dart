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
  String get villageBoardDetailAll =>
      'Cada jugador agafa el tauler de poblat del seu color i se\'l posa al davant. Hi ha els magatzems i els remansos de l\'aiguader.';

  @override
  String villageBoardDetail(String color) {
    return 'Agafa el tauler de poblat de color $color i posa-te\'l al davant. Hi ha els teus magatzems i els remansos de l\'aiguader.';
  }

  @override
  String get waterCarrierLabel => 'Posa l\'aiguader al remans \"-10\"';

  @override
  String get waterCarrierDetailAll =>
      'Cada jugador agafa l\'aiguader del seu color i el col·loca al remans de valor \"-10\" del seu tauler.';

  @override
  String waterCarrierDetail(String color) {
    return 'Agafa l\'aiguader de color $color i col·loca\'l al remans de valor \"-10\" del tauler del teu poblat.';
  }

  @override
  String get ownTilesLabel => 'Agafa totes les teves rajoles de recol·lectors';

  @override
  String get ownTilesDetailAll =>
      'Cada jugador reuneix totes les rajoles de recol·lectors del seu color; són la seva reserva personal per a tota la partida.';

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
  String removeWorkerDetailAll(String distribution) {
    return 'Cada jugador busca entre les seves rajoles de recol·lectors una de les $distribution i la torna a la capsa del joc.';
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
  String get jungleGroupTitle => 'La selva';

  @override
  String get gatherJungleLabel => 'Reuneix les rajoles de la selva';

  @override
  String get gatherJungleDetail =>
      'Agafa totes les rajoles de selva del joc base; tot seguit les modificaràs (treure/afegir) i en formaràs la pila.';

  @override
  String get junglePileLabel => 'Barreja i forma la pila';

  @override
  String get junglePileDetail =>
      'Barreja totes les rajoles de la selva cara avall i forma la pila, al costat del tauler.';

  @override
  String junglePurgeLabel(String expansion) {
    return 'Si tens $expansion barrejada';
  }

  @override
  String junglePurgeDetail(String expansion, String tiles) {
    return 'Aquesta partida no usa aquestes rajoles de selva de $expansion: $tiles. Si les tens barrejades amb el joc base, treu-les abans de muntar la pila.';
  }

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
  String get mapTokensDetailAll => 'Cada jugador agafa 2 fitxes de mapa.';

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
  String get treeOfLife0004DetailAll =>
      'Mòdul L\'arbre de la vida: cada jugador agafa la rajola de recol·lectors 0-0-0-4 del seu color (del mòdul Els nous recol·lectors) i l\'afegeix a les seves rajoles.';

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
  String get newWorkersBuildLabel => 'Munta la pila de recol·lectors';

  @override
  String get newWorkersBuildDetail =>
      'Cada jugador agafa les rajoles indicades de cada origen.';

  @override
  String get workerBuildFromBase => 'Del joc base, agafa:';

  @override
  String get workerBuildFromExpansion => 'De l\'expansió Diamante, agafa:';

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
  String get menuGame => 'Partida';

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
  String get workerSelectionResetNotice =>
      'Has canviat els recol·lectors: torna a muntar la pila.';

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
      'Toca cada cara de cabana que ha quedat amunt. Les impossibles desapareixen soles.';

  @override
  String get hutRegisterAction =>
      'Registra quines cabanes han quedat cara amunt';

  @override
  String get hutRegisteredEdit => 'Tirada registrada · toca per editar';

  @override
  String get forgetThrowAction => 'Oblida la tirada';

  @override
  String get guidedModeTooltip => 'Mode guiat: un pas cada vegada';

  @override
  String get listModeTooltip => 'Mode llista';

  @override
  String get guidedBack => 'Enrere';

  @override
  String get guidedNext => 'Següent';

  @override
  String guidedPendingSteps(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Queden $count passos — vés al primer',
      one: 'Queda 1 pas — vés-hi',
    );
    return '$_temp0';
  }

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
  String get summaryTiles => 'Rajoles';

  @override
  String get summaryWorkers => 'Recol·lectors';

  @override
  String get summaryJungle => 'Selva';

  @override
  String get summaryHuts => 'Cabanes';

  @override
  String get tileMarketSelling4 => 'Mercat, preu de venda 4';

  @override
  String get boardgameCacao => 'Cacao';

  @override
  String get boardgameChocolatl => 'Cacao: Xocolatl';

  @override
  String get boardgameDiamante => 'Cacao: Diamante';

  @override
  String get expansionNameChocolatl => 'Xocolatl';

  @override
  String get expansionNameDiamante => 'Diamante';

  @override
  String get moduleMaps => 'Mapes';

  @override
  String get moduleWatering => 'Irrigació';

  @override
  String get moduleChocolate => 'Xocolata';

  @override
  String get moduleHuts => 'Cabanes';

  @override
  String get moduleGemMines => 'Les mines de gemmes';

  @override
  String get moduleTreeOfLife => 'L\'arbre de la vida';

  @override
  String get moduleEmperorsFavor => 'El favor de l\'ahau';

  @override
  String get moduleNewWorkers => 'Els nous recol·lectors';

  @override
  String get moduleDescMaps =>
      'Dues rajoles de selva addicionals queden cara amunt al tauler de mapes, al costat de la pila de la selva. En omplir espais de selva, pots retornar 1 de les teves fitxes de mapa a la capsa per triar una rajola del tauler de mapes en lloc de la selva explorada.';

  @override
  String get moduleDescWatering =>
      'Tres rajoles d\'irrigació substitueixen plantacions: els seus recol·lectors fan retrocedir el teu aiguader i donen 4 fruits de cacau per remans. Un cenot substitueix el mercat com a segona rajola inicial.';

  @override
  String get moduleDescChocolate =>
      'Les xocolateres i els mercats de xocolata substitueixen mines d\'or i mercats de preu 3: converteix fruits de cacau en tauletes de xocolata i ven-les per fins a 7 monedes d\'or.';

  @override
  String get moduleDescHuts =>
      '12 rajoles de cabana de doble cara esperen al costat de la banca, ordenades per cost. Al final del teu torn en pots construir una pagant or que ja tinguis; al final de la partida cada cabana retorna el seu cost i dona la seva bonificació.';

  @override
  String get moduleDescGemMines =>
      'Cinc mines de gemmes substitueixen els temples. Els recol·lectors activats recullen gemmes de la vagoneta; un joc dels 4 colors es canvia immediatament per la màscara de valor més baix. Les màscares i les gemmes sobrants valen or.';

  @override
  String get moduleDescTreeOfLife =>
      'Tres arbres de la vida substitueixen les mines d\'or: cada recol·lector adjacent pren 1 moneda d\'or — però la força rau en la serenitat: un costat adjacent sense recol·lectors en pren 3.';

  @override
  String get moduleDescEmperorsFavor =>
      'L\'ahau comença al mercat de preu de venda «2». Col·locar una rajola de recol·lectors a la seva fila o columna el mou damunt d\'aquesta i dona 1 moneda d\'or — i 1 més al començament de cada torn teu mentre hi continuï.';

  @override
  String get moduleDescNewWorkers =>
      '16 rajoles de recol·lectors amb distribucions noves (0-0-2-2, 0-2-0-2, 0-1-0-3, 0-0-0-4). Acordeu qualsevol combinació amb les rajoles del joc base — tots els jugadors usen el mateix conjunt.';

  @override
  String tileDescWorker(String distribution, String color) {
    return 'Rajola de recol·lectors $distribution del jugador $color.';
  }

  @override
  String get tileDesc_base_jungle_single_plantation =>
      'Per cada recol·lector teu activat al costat adjacent de la rajola, pots agafar **1 fruit de cacau** de la reserva. Posa\'ls individualment en 1 magatzem buit del teu tauler de poblat. Cada jugador té 5 magatzems i mai no pot emmagatzemar més de *5 fruits de cacau*; els fruits addicionals que obtinguis es perden.\n\n![Agafa el cacau](resource:assets/images/tiles/description/plantation.webp)';

  @override
  String get tileDesc_base_jungle_double_plantation =>
      'Per cada recol·lector teu activat al costat adjacent de la rajola, pots agafar **2 fruits de cacau** de la reserva. Posa\'ls individualment en 1 magatzem buit del teu tauler de poblat. Cada jugador té 5 magatzems i mai no pot emmagatzemar més de *5 fruits de cacau*; els fruits addicionals que obtinguis es perden.\n\n![Agafa el cacau](resource:assets/images/tiles/description/plantation.webp)';

  @override
  String get tileDesc_base_jungle_market_selling_2 =>
      'Per cada recol·lector teu activat al costat adjacent de la rajola, pots vendre **1 fruit de cacau** del teu magatzem al preu que indica el mercat. Retorna el fruit de cacau a la reserva i agafa **2 monedes d\'or** de la banca.\n\n![Retorna el cacau](resource:assets/images/tiles/description/market1.webp)\n\n![Agafa les monedes](resource:assets/images/tiles/description/market2.webp)';

  @override
  String get tileDesc_base_jungle_market_selling_3 =>
      'Per cada recol·lector teu activat al costat adjacent de la rajola, pots vendre **1 fruit de cacau** del teu magatzem al preu que indica el mercat. Retorna el fruit de cacau a la reserva i agafa **3 monedes d\'or** de la banca.\n\n![Retorna el cacau](resource:assets/images/tiles/description/market1.webp)\n\n![Agafa les monedes](resource:assets/images/tiles/description/market2.webp)';

  @override
  String get tileDesc_base_jungle_market_selling_4 =>
      'Per cada recol·lector teu activat al costat adjacent de la rajola, pots vendre **1 fruit de cacau** del teu magatzem al preu que indica el mercat. Retorna el fruit de cacau a la reserva i agafa **4 monedes d\'or** de la banca.\n\n![Retorna el cacau](resource:assets/images/tiles/description/market1.webp)\n\n![Agafa les monedes](resource:assets/images/tiles/description/market2.webp)';

  @override
  String get tileDesc_base_jungle_gold_mine_value_1 =>
      'Per cada recol·lector teu activat al costat adjacent de la rajola, pots agafar de la banca el valor indicat, és a dir, **1 moneda d\'or**.\n\n![Agafa les monedes](resource:assets/images/tiles/description/gold_mine.webp)';

  @override
  String get tileDesc_base_jungle_gold_mine_value_2 =>
      'Per cada recol·lector teu activat al costat adjacent de la rajola, pots agafar de la banca el valor indicat, és a dir, **2 monedes d\'or**.\n\n![Agafa les monedes](resource:assets/images/tiles/description/gold_mine.webp)';

  @override
  String get tileDesc_base_jungle_water =>
      'Per cada recol·lector teu activat al costat adjacent de la rajola, pots avançar l\'aiguader del teu tauler de poblat 1 remans en sentit horari. Si l\'aiguader arriba al remans de valor \"16\", s\'hi atura; els passos que sobrin es perden.\n\nAl final de la partida, sumes a les teves monedes d\'or el valor del remans on és el teu aiguader. Si l\'aiguader encara és en un remans de valor negatiu, has de restar el nombre corresponent.\n\n![Mou l\'aiguader](resource:assets/images/tiles/description/water.webp)';

  @override
  String get tileDesc_base_jungle_sun_worshiping_site =>
      'Per cada recol·lector teu activat al costat adjacent de la rajola, pots agafar 1 fitxa de sol de la reserva. Posa-la en un lloc d\'adoració al sol buit del teu tauler de poblat. Cada jugador té 3 llocs d\'adoració al sol i mai no pot tenir més de 3 fitxes de sol. Les fitxes de sol que obtinguis de més es perden.\n\nCap al final de la partida, pots usar les fitxes de sol per \"sobreedificar\" una de les teves **pròpies** rajoles de recol·lectors. Al final de la partida, reps 1 moneda d\'or de la banca per cada fitxa de sol que no hagis usat.\n\n![Agafa una fitxa de sol](resource:assets/images/tiles/description/sun_worshiping_site1.webp)\n\n**SOBREEDIFICAR UNA RAJOLA DE RECOL·LECTORS**\n\nQuan la pila de la selva s\'hagi esgotat cap al final de la partida i no quedin rajoles de selva a la selva explorada, a partir d\'aleshores pots sobreedificar una de les teves **pròpies** rajoles de recol·lectors, en lloc d\'afegir-la a la zona de joc de la manera habitual; per fer-ho, has de retornar 1 fitxa de sol a la reserva. Tria 1 rajola de recol·lectors de la teva mà i posa-la **damunt** d\'una de les teves **pròpies** rajoles col·locades anteriorment. Després, duus a terme les accions de les rajoles de selva adjacents per als recol·lectors activats. Si no tens cap fitxa de sol, no pots sobreedificar i has de col·locar la nova rajola com és habitual.\n\n**Important:** cada rajola de recol·lectors només es pot sobreedificar **una vegada**. ***Exemple:***\n\n*És el torn del vermell. La pila de la selva s\'ha esgotat i la selva explorada és buida. Per tant, pot sobreedificar: retorna a la reserva 1 fitxa de sol d\'un dels seus llocs d\'adoració al sol; després, sobreedifica 1 de les seves rajoles de recol·lectors. Posa la rajola nova damunt de la rajola col·locada en un torn anterior i duu a terme les accions de les rajoles de selva adjacents. Primer, agafa 2 fruits de cacau pel recol·lector de la plantació doble i els posa en dos dels seus magatzems. Després, ven els dos fruits de cacau al mercat per 2x4 = 8 monedes d\'or. Finalment, avança el seu aiguader 1 remans.*';

  @override
  String get tileDesc_base_jungle_temple =>
      'Els temples no tenen cap efecte directe durant la partida. Només al final de la partida es puntuen els temples, individualment, un rere l\'altre. El jugador que té més recol·lectors adjacents al temple corresponent rep 6 monedes d\'or de la banca. El jugador amb el segon nombre més alt de recol·lectors adjacents n\'obté 3. Si hi ha empat al primer lloc, les 6 monedes d\'or es reparteixen equitativament entre els jugadors implicats (arrodonint cap avall si cal). En aquest cas, no es dona or pel segon lloc. Si el primer lloc és clar però hi ha empat al segon, les 3 monedes d\'or es reparteixen equitativament entre els jugadors implicats (arrodonint cap avall si cal).\n\n**Atenció:** si alguna rajola de recol·lectors adjacent al temple ha estat sobreedificada, només compten per a la puntuació les rajoles de dalt.\n\n**Nota:** si només hi ha 1 jugador amb recol·lectors adjacents al temple, rep 6 monedes d\'or de la banca, com és habitual; no es dona or pel segon lloc. Cal tenir almenys 1 recol·lector adjacent al temple per puntuar-hi.\n\n***Exemple:***\n\n*El groc i el vermell tenen 2 recol·lectors cadascun en aquest temple. Per tant, es reparteixen les 6 monedes d\'or del primer lloc; cadascun rep 3 monedes d\'or de la banca. El violeta té 1 recol·lector en aquest temple; tanmateix, se\'n va amb les mans buides, perquè en aquest cas el segon lloc no es premia.*\n\n![Temple](resource:assets/images/tiles/description/temple.webp)';

  @override
  String get tileDesc_chocolatl_jungle_watering =>
      'Per cada recol·lector teu activat al costat adjacent de la rajola, pots fer retrocedir l\'aiguader del teu tauler de poblat 1 remans en sentit antihorari. Per cada remans que facis retrocedir el teu aiguader, agafes 4 fruits de cacau de la reserva i els poses en magatzems buits del teu tauler de poblat. Si el teu aiguader és al remans de valor “-10”, no pots obtenir cap fruit.\n\n**Atenció:** els fruits de cacau addicionals que obtindries es perden, com és habitual. Per això no té sentit connectar a una rajola d\'irrigació costats de rajola amb més d\'1 recol·lector.';

  @override
  String get tileDesc_chocolatl_jungle_chocolate_kitchen =>
      'Per cada recol·lector teu activat al costat adjacent de la rajola, pots convertir 1 fruit de cacau del teu magatzem en 1 tauleta de xocolata. Retorna el fruit de cacau a la reserva. Després, agafa la tauleta de xocolata de la reserva i posa-la en un magatzem buit del teu tauler de poblat.\nCada magatzem pot contenir o bé 1 fruit de cacau o bé 1 tauleta de xocolata.\n\n**FINAL DE LA PARTIDA**\n**Atenció:** les tauletes de xocolata sobrants no donen cap moneda d\'or al final de la partida.';

  @override
  String get tileDesc_chocolatl_jungle_chocolate_market =>
      'Per cada recol·lector teu activat al costat adjacent de la rajola, pots vendre 1 fruit de cacau del teu magatzem per 3 monedes d\'or, o 1 tauleta de xocolata del teu magatzem per 7 monedes d\'or. Retorna el fruit de cacau o la tauleta de xocolata a la reserva i agafa de la banca la quantitat d\'or corresponent.\nSi has activat més d\'1 recol·lector, pots triar individualment per a cada recol·lector activat si vols vendre 1 fruit de cacau o 1 tauleta de xocolata.';

  @override
  String get tileDesc_diamante_jungle_gem_mine =>
      'Per cada recol·lector teu activat al costat adjacent de la rajola, pots agafar 1 gemma a la teva elecció d\'aquesta mina de gemmes. Posa les gemmes al costat del teu tauler de poblat.\n\nQuan tinguis almenys 1 gemma de cadascun dels 4 colors, **has de canviar immediatament** aquest joc de 4 gemmes per la màscara de valor més baix disponible a la reserva. Retira de la partida les gemmes canviades i torna-les a la capsa.';

  @override
  String get tileDesc_diamante_jungle_tree_of_life =>
      'Per cada recol·lector teu activat al costat adjacent de la rajola, pots agafar 1 moneda d\'or de la banca.\n\nPerò la força rau en la serenitat: si no hi ha cap recol·lector representat al costat adjacent de la rajola, pots agafar fins i tot 3 monedes d\'or de la banca.';

  @override
  String get tileDesc_chocolatl_hut_market_crier =>
      '**Cost de construcció:** 4 monedes d\'or\n\n**Funció:** durant tota la partida, vens els teus fruits de cacau als mercats adjacents de preu de venda 2 per 3 monedes d\'or en lloc de 2.\n\n**Final de la partida:** suma el cost de construcció (4 monedes d\'or) al teu or total.';

  @override
  String get tileDesc_chocolatl_hut_hermit =>
      '**Cost de construcció:** 6 monedes d\'or\n\n**Funció:** 1 moneda d\'or per cada recol·lector teu que no tingui cap rajola de selva adjacent al final de la partida.\n\n**Final de la partida:** suma el cost de construcció (6 monedes d\'or) més la bonificació al teu or total.';

  @override
  String get tileDesc_chocolatl_hut_road_worker =>
      '**Cost de construcció:** 6 monedes d\'or\n\n**Funció:** al final de la partida, obtens 1 moneda d\'or per cada rajola de recol·lectors teva a la fila o columna on tinguis més rajoles de recol·lectors.\n\n**Final de la partida:** suma el cost de construcció (6 monedes d\'or) més la bonificació al teu or total.';

  @override
  String get tileDesc_chocolatl_hut_trader =>
      '**Cost de construcció:** 6 monedes d\'or\n\n**Funció:** els fruits de cacau sobrants al teu magatzem et donen 1 moneda d\'or cadascun al final de la partida.\n\n**Final de la partida:** suma el cost de construcció (6 monedes d\'or) més la bonificació al teu or total.';

  @override
  String get tileDesc_chocolatl_hut_farmer =>
      '**Cost de construcció:** 8 monedes d\'or\n\n**Funció:** sempre que obtinguis exactament 4 fruits de cacau en un mateix torn durant la partida, reps 1 fruit de cacau addicional, sempre que et quedi espai al magatzem.\n\n**Final de la partida:** suma el cost de construcció (8 monedes d\'or) al teu or total.';

  @override
  String get tileDesc_chocolatl_hut_shaman =>
      '**Cost de construcció:** 8 monedes d\'or\n\n**Funció:** si sobreedifiques una de les teves rajoles de recol·lectors durant la partida, no has de retornar cap fitxa de sol a la reserva per fer-ho.\n\n**Final de la partida:** suma el cost de construcció (8 monedes d\'or) al teu or total.';

  @override
  String get tileDesc_chocolatl_hut_monk =>
      '**Cost de construcció:** 10 monedes d\'or\n\n**Funció:** 1 moneda d\'or al final de la partida per cada temple on tinguis almenys 1 recol·lector adjacent.\n\n**Final de la partida:** suma el cost de construcció (10 monedes d\'or) més la bonificació al teu or total.';

  @override
  String get tileDesc_chocolatl_hut_master_builder =>
      '**Cost de construcció:** 10 monedes d\'or\n\n**Funció:** al final de la partida, obtens 1 moneda d\'or per cadascuna de les teves altres cabanes.\n\n**Final de la partida:** suma el cost de construcció (10 monedes d\'or) més la bonificació al teu or total.';

  @override
  String get tileDesc_chocolatl_hut_foreman =>
      '**Cost de construcció:** 12 monedes d\'or\n\n**Funció:** quan col·loques una rajola de recol·lectors amb 3 recol·lectors en un costat durant la partida, es compta com si tingués un 4t recol·lector addicional en aquell costat.\n\n**Final de la partida:** suma el cost de construcció (12 monedes d\'or) al teu or total.';

  @override
  String get tileDesc_chocolatl_hut_fountain_master =>
      '**Cost de construcció:** 12 monedes d\'or\n\n**Funció:** 4 monedes d\'or al final de la partida si el teu aiguader és al remans de valor “16”.\n\n**Final de la partida:** suma el cost de construcció (12 monedes d\'or) més la bonificació (si escau) al teu or total.';

  @override
  String get tileDesc_chocolatl_hut_chiefs_daughter =>
      '**Cost de construcció:** 14 monedes d\'or\n\n**Funció:** 4 monedes d\'or al final de la partida.\n\n**Final de la partida:** suma el cost de construcció (14 monedes d\'or) més la bonificació (4 monedes d\'or) al teu or total.';

  @override
  String get tileDesc_chocolatl_hut_chiefs_son =>
      '**Cost de construcció:** 16 monedes d\'or\n\n**Funció:** 4 monedes d\'or al final de la partida.\n\n**Final de la partida:** suma el cost de construcció (16 monedes d\'or) més la bonificació (4 monedes d\'or) al teu or total.';

  @override
  String get tileDesc_chocolatl_hut_chiefs_wife =>
      '**Cost de construcció:** 20 monedes d\'or\n\n**Funció:** 5 monedes d\'or al final de la partida.\n\n**Final de la partida:** suma el cost de construcció (20 monedes d\'or) més la bonificació (5 monedes d\'or) al teu or total.';

  @override
  String get tileDesc_chocolatl_hut_chief =>
      '**Cost de construcció:** 24 monedes d\'or\n\n**Funció:** 6 monedes d\'or al final de la partida.\n\n**Final de la partida:** suma el cost de construcció (24 monedes d\'or) més la bonificació (6 monedes d\'or) al teu or total.';

  @override
  String get tileTypePlayer => 'Jugador';

  @override
  String get tileTypeMarket => 'Mercat';

  @override
  String get tileTypePlantation => 'Plantació';

  @override
  String get tileTypeGoldMine => 'Mina d\'or';

  @override
  String get tileTypeWater => 'Cenot';

  @override
  String get tileTypeTemple => 'Temple';

  @override
  String get tileTypeSunWorshipingSite => 'Adoració al sol';

  @override
  String get tileTypeWatering => 'Irrigació';

  @override
  String get tileTypeChocolateKitchen => 'Xocolatera';

  @override
  String get tileTypeChocolateMarket => 'Mercat de xocolata';

  @override
  String get tileTypeMapTile => 'Rajola de mapa';

  @override
  String get tileTypeHut => 'Cabana';

  @override
  String get tileTypeGemMine => 'Mina de gemmes';

  @override
  String get tileTypeTreeOfLife => 'Arbre de la vida';

  @override
  String get filterSheetTitle => 'Filtres';

  @override
  String get clearAllAction => 'Esborra-ho tot';

  @override
  String get searchTileHint => 'Cerca una rajola pel nom...';

  @override
  String get tileTypesSection => 'Tipus de rajola';

  @override
  String get filterTilesTooltip => 'Filtra les rajoles';

  @override
  String get displaySettingsTooltip => 'Opcions de visualització';

  @override
  String activeFiltersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count filtres actius',
      one: '1 filtre actiu',
    );
    return '$_temp0';
  }

  @override
  String costLabel(int cost) {
    return 'Cost: $cost';
  }

  @override
  String get settingsSheetTitle => 'Opcions';

  @override
  String get settingsGeneralSection => 'General';

  @override
  String get settingsBadgesSection => 'Insígnies';

  @override
  String get settingsPlayerColorsSection => 'Colors de jugador';

  @override
  String get settingBoardgameTitle => 'Títol del joc';

  @override
  String get settingShowQuantity => 'Mostra la quantitat';

  @override
  String get settingCompactLayout => 'Disposició compacta';

  @override
  String get settingBadgeTypeInText => 'Tipus de rajola en text';

  @override
  String get settingBadgeTypeInImage => 'Tipus de rajola a la imatge';

  @override
  String get settingPlayerColorInBorder => 'Color del jugador a la vora';

  @override
  String get settingPlayerColorInCircle => 'Color del jugador en cercle';

  @override
  String get scoreStepSetup => 'Jugadors i mòduls';

  @override
  String get scoreCatGold => 'Or acumulat';

  @override
  String get scoreCatWater => 'Remansos de l\'aiguader';

  @override
  String get scoreCatTemples => 'Temples';

  @override
  String get scoreCatSun => 'Fitxes de sol';

  @override
  String get scoreCatCacao => 'Cacau sobrant';

  @override
  String get scoreCatHuts => 'Cabanes';

  @override
  String get scoreCatGemMines => 'Mines de gemmes';

  @override
  String get startOverAction => 'Torna a començar';

  @override
  String get startOverTitle => 'Tornar a començar?';

  @override
  String get startOverBody =>
      'Això descarta totes les puntuacions introduïdes i torna a carregar els jugadors i mòduls de la partida configurada.';

  @override
  String get scoreClearBlankBody =>
      'Això descarta totes les puntuacions introduïdes i deixa la calculadora buida.';

  @override
  String get scoreContextGame => 'Puntuant la partida en curs';

  @override
  String get scoreContextDetached => 'Càlcul a part';

  @override
  String get scoreBackToGameAction => 'Torna a la partida';

  @override
  String get scoreResetChooseBody =>
      'Vols reiniciar la puntuació d\'aquesta partida o començar un càlcul a part, buit?';

  @override
  String get scoreResetGameOption => 'Reinicia la puntuació de la partida';

  @override
  String get scoreClearBlankOption => 'Buida-ho tot (càlcul a part)';

  @override
  String get backAction => 'Enrere';

  @override
  String get nextAction => 'Següent';

  @override
  String get resultsAction => 'Resultats';

  @override
  String get needTwoPlayers => 'Selecciona almenys 2 jugadors';

  @override
  String get scoreSetupIntro =>
      'Selecciona els jugadors de la partida acabada.';

  @override
  String get scoreModulesIntro => 'Mòduls que canvien la puntuació final:';

  @override
  String get scoreHutModuleSubtitle =>
      'Xocolatl: les cabanes construïdes retornen el cost i donen bonificacions';

  @override
  String get scoreGemModuleSubtitle =>
      'Diamante: les mines de gemmes substitueixen els temples';

  @override
  String get scoreGoldIntro =>
      'Compta les monedes d\'or de cada jugador. Toca el número per introduir-lo directament.';

  @override
  String get scoreWaterIntro =>
      'Selecciona el remans on ha acabat la partida cada aiguader. Els remansos negatius resten or.';

  @override
  String get scoreTemplesIntro =>
      'Afegeix una entrada per temple i compta els recol·lectors adjacents. L\'or s\'atorga automàticament: 6 pel primer lloc, 3 pel segon, i els empats es reparteixen arrodonint cap avall.';

  @override
  String get scoreSunIntro =>
      'Les fitxes de sol no usades per sobreedificar valen 1 moneda d\'or cadascuna (màxim 3).';

  @override
  String get scoreCacaoIntro =>
      'Els fruits de cacau sobrants no donen or, però decideixen els empats: amb el mateix or, guanya el jugador amb més cacau sobrant.';

  @override
  String get scoreHutsIntro =>
      'Marca les cabanes que ha construït cada jugador. Els costos de construcció es retornen i les bonificacions s\'afegeixen automàticament. Les cabanes són rajoles físiques limitades: una cabana en gris no té cap rajola disponible (desselecciona-la del seu propietari per reassignar-la).';

  @override
  String get scoreGemsIntro =>
      'Toca una màscara i tria de qui és. Les màscares sumen el seu valor en or.';

  @override
  String get scoreGemsLeftoverIntro =>
      'Gemmes sobrants al costat de cada tauler de poblat (1 moneda d\'or cadascuna):';

  @override
  String get addTempleAction => 'Afegeix un temple';

  @override
  String get removeTempleTooltip => 'Elimina el temple';

  @override
  String templeNumber(int number) {
    return 'Temple $number';
  }

  @override
  String hutsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count cabanes',
      one: '1 cabana',
    );
    return '$_temp0';
  }

  @override
  String scoreHermitCount(String hutName) {
    return '$hutName: recol·lectors propis sense cap rajola de selva adjacent';
  }

  @override
  String scoreRoadWorkerCount(String hutName) {
    return '$hutName: rajoles de recol·lectors a la teva millor fila o columna';
  }

  @override
  String get assignMaskTooltip => 'Assigna la màscara';

  @override
  String get nobodyOption => 'Ningú';

  @override
  String get enterValueTitle => 'Introdueix el valor';

  @override
  String get okAction => 'D\'acord';

  @override
  String get finalScoreTitle => 'Puntuació final';

  @override
  String get winsTheGameSingle => 'guanya la partida!';

  @override
  String get winsTheGameShared => 'guanyen la partida!';

  @override
  String get sharedVictorySubtitle =>
      'Victòria compartida! Empat en or i en cacau sobrant.';

  @override
  String get tiebreakSubtitle => 'Empat en or resolt pel cacau sobrant.';

  @override
  String get leftoverCacaoTiebreaker => 'Cacau sobrant (desempat)';

  @override
  String get homeIntro =>
      'Companion for Cacao és una aplicació mòbil desenvolupada amb Flutter pensada per ajudar els jugadors del joc de taula Cacao i les seves expansions. L\'objectiu és oferir eines digitals que millorin l\'experiència de joc facilitant el recompte de punts, la consulta de regles i la gestió de la partida.';

  @override
  String get homeCompletedFeaturesTitle => 'Funcionalitats completades';

  @override
  String get homePendingFeaturesTitle => 'Funcionalitats pendents';

  @override
  String get homeCompletedFeatures =>
      '🏠 Menú principal: accés ràpid a totes les funcionalitats.\n🗂 Base de dades de rajoles: catàleg complet de rajoles.\n🔍 Filtre de rajoles: cerca i filtra per múltiples criteris.\n🌴 Joc base Cacao: suport complet i preparació de la partida.\n🍫 Expansió Xocolatl: suport complet amb els 4 mòduls.\n🚀 Expansió Diamante: suport complet amb els 4 mòduls.\n🎲 Tauler de partida: resum, preparació i rajoles en joc.\n🌟 Variant Big Game: integració de tots els mòduls i expansions.\n📖 Manuals integrats: consulta les regles del joc.\n🏆 Calculadora de puntuació: puntuació final automàtica amb les regles oficials de desempat.\n🌐 Multi idioma: català, castellà i anglès.\n📊 Interfície adaptativa: disseny optimitzat per a diferents mides de pantalla.\n🔄 Actualitzador automàtic: detecció automàtica de versions noves.';

  @override
  String get homePendingFeatures =>
      '🕒 Temporitzador de torns: controla la durada de cada torn.\n📜 Historial de partides: registre de partides acabades i estadístiques de jugadors.\n⚙️ Configuració personalitzada: ajusta l\'experiència de joc.';

  @override
  String get homeContactTitle => 'Contacte';

  @override
  String get homeContactBody =>
      'Per a suggeriments, millores, informes d\'errors o qualsevol altra consulta, pots visitar el nostre repositori de GitHub. L\'aplicació és de codi obert i sempre busquem col·laboradors que ajudin a millorar-la.';

  @override
  String get homeVisitRepo => 'Visita el nostre repositori de GitHub:';

  @override
  String get homeGithubBody =>
      'A GitHub pots obrir «issues» per informar d\'errors, proposar funcionalitats noves o fins i tot enviar «pull requests» amb les teves pròpies contribucions. Treballem per millorar l\'aplicació constantment i agraïm qualsevol ajuda!';

  @override
  String get rulesBaseGame => 'Joc base';

  @override
  String get rulesInstructions => 'Instruccions';

  @override
  String get rulesOverview => 'Referència ràpida';

  @override
  String rulesExpansionHeader(String name) {
    return 'Expansió: $name';
  }

  @override
  String rulesExpansionRules(String name) {
    return 'Regles de $name';
  }

  @override
  String get quantityAll => 'TOTES';

  @override
  String get errorGenericRetry => 'Alguna cosa ha fallat. Torna-ho a provar.';

  @override
  String get pageNotFoundTitle => 'Pàgina no trobada';

  @override
  String routeNotFound(String uri) {
    return 'Ruta no trobada: $uri';
  }

  @override
  String get errorTitle => 'Error';

  @override
  String get invalidDataMessage => 'Dades no vàlides per a aquesta pantalla.';

  @override
  String get retryAction => 'Reintenta';

  @override
  String get playerNameHint => 'Nom';

  @override
  String get aboutIntro =>
      'Eines digitals per als jugadors de Cacao i les seves expansions: preparació de la partida, recompte de punts i consulta de regles, tot en un sol lloc.';

  @override
  String get aboutOpenSource => 'Codi obert';

  @override
  String get aboutIncludedTitle => 'Què inclou';

  @override
  String get aboutInDevelopmentTitle => 'En desenvolupament';

  @override
  String get aboutSoonBadge => 'aviat';

  @override
  String get aboutRepoTitle => 'Repositori a GitHub';

  @override
  String get aboutRepoSubtitle =>
      'Reporta errors, proposa millores o col·labora';

  @override
  String get aboutMadeWith => 'Fet amb Flutter';

  @override
  String get aboutFeaturePrep => 'Preparació guiada';

  @override
  String get aboutFeaturePrepSub =>
      'Pas a pas per al joc base i les expansions';

  @override
  String get aboutFeatureScore => 'Calculadora de punts';

  @override
  String get aboutFeatureScoreSub =>
      'Puntuació final amb els desempats oficials';

  @override
  String get aboutFeatureTiles => 'Catàleg de rajoles';

  @override
  String get aboutFeatureTilesSub => 'Cerca i filtra per múltiples criteris';

  @override
  String get aboutFeatureRules => 'Regles i manuals';

  @override
  String get aboutFeatureRulesSub => 'Consulta integrada dins l\'app';

  @override
  String get aboutFeatureExpansions => 'Expansions completes';

  @override
  String get aboutFeatureExpansionsSub =>
      'Xocolatl, Diamante i la variant Big Game';

  @override
  String get aboutFeatureLangs => 'Multi-idioma';

  @override
  String get aboutFeatureLangsSub => 'Català, castellà i anglès';

  @override
  String get aboutSoonTimer => 'Temporitzador de torns';

  @override
  String get aboutSoonHistory => 'Historial i estadístiques';

  @override
  String get aboutSoonSettings => 'Configuració personalitzada';

  @override
  String get homeCardResumeSub => 'Continua on ho vas deixar';

  @override
  String get homeCardSetupSub => 'Configura jugadors, expansions i mòduls';

  @override
  String get homeCardTilesSub => 'Consulta el catàleg complet de rajoles';

  @override
  String get homeCardScoresSub => 'Calcula la puntuació final automàticament';

  @override
  String get homeCardRulesSub => 'Manuals integrats i referència ràpida';

  @override
  String get homeAboutTitle => 'Sobre l\'app';

  @override
  String get homeTagline => 'El teu company de taula per al Cacao';

  @override
  String get loadingLabel => 'Carregant…';

  @override
  String get scoreTemplesEmpty =>
      'Encara no hi ha temples — afegeix-ne un per cada temple del tauler.';

  @override
  String get expansionsModulesSection => 'Expansions i mòduls';

  @override
  String get expansionSelectHint =>
      'Toca una expansió per activar-la i triar-ne els mòduls.';

  @override
  String get expansionTapHint => 'Toca per triar-ne els mòduls';

  @override
  String get modulesPickLabel => 'Tria els mòduls';

  @override
  String moduleCountLabel(int count, int total) {
    return '$count / $total mòduls';
  }

  @override
  String get cancelAction => 'Cancel·la';

  @override
  String get exitWithGameTitle => 'Vols sortir de l\'app?';

  @override
  String get exitWithGameBody =>
      'Tens una partida en curs. Si tanques l\'app la perdràs: els jugadors, els mòduls i tots els passos que has marcat.';

  @override
  String get exitWithGameAction => 'Surt i descarta';

  @override
  String get clearSetupBody =>
      'Això esborra els jugadors, expansions i mòduls seleccionats.';

  @override
  String get moduleWarningPickOne => 'Tria almenys un mòdul';

  @override
  String get expansionNeedsModuleHint =>
      'Alguna expansió no té cap mòdul triat';

  @override
  String get playersNeededHint => 'Afegeix almenys 2 jugadors';
}
