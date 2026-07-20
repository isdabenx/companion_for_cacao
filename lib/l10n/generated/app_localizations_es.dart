// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get colorWhite => 'blanco';

  @override
  String get colorRed => 'rojo';

  @override
  String get colorPurple => 'violeta';

  @override
  String get colorYellow => 'amarillo';

  @override
  String get villageBoardLabel => 'Coge el tablero de tu aldea';

  @override
  String villageBoardDetail(String color) {
    return 'Coge el tablero de aldea de color $color y colócalo delante de ti. Ahí están tus almacenes y los remansos del aguador.';
  }

  @override
  String get waterCarrierLabel => 'Pon el aguador en el remanso \"-10\"';

  @override
  String waterCarrierDetail(String color) {
    return 'Coge el aguador de color $color y colócalo en el remanso de valor \"-10\" del tablero de tu aldea.';
  }

  @override
  String get ownTilesLabel => 'Coge todas tus losetas de recolectores';

  @override
  String ownTilesDetail(String color) {
    return 'Reúne todas las losetas de recolectores con el reverso de color $color; son tu reserva personal para toda la partida.';
  }

  @override
  String removeWorkerLabel(String distribution) {
    return 'Devuelve una loseta de recolectores $distribution a la caja';
  }

  @override
  String removeWorkerDetail(String distribution) {
    return 'Busca entre tus losetas de recolectores una de las $distribution y devuélvela a la caja del juego.';
  }

  @override
  String get removeWorkerRationale =>
      'Con 3 o más jugadores cada uno usa menos losetas de recolectores para que la selva no se agote antes de acabar la partida.';

  @override
  String get shuffleWorkersLabel => 'Mezcla tus recolectores y roba 3';

  @override
  String get shuffleWorkersDetail =>
      'Cada jugador mezcla sus losetas de recolectores y las coloca boca abajo formando una pila junto al tablero de su aldea. A continuación, roba las 3 losetas superiores de su pila y las toma en la mano.';

  @override
  String get initialTilesMarketLabel =>
      'Coloca las 2 losetas iniciales en diagonal';

  @override
  String get initialTilesMarketDetail =>
      'De las losetas de selva, busca la \"plantación simple\" y el \"mercado de precio de venta 2\" y colócalas boca arriba en el centro de la mesa, en diagonal una respecto de la otra; son las losetas iniciales de la zona de juego.';

  @override
  String get junglePileLabel => 'Monta la pila de la selva';

  @override
  String get junglePileDetail =>
      'Mezcla las losetas de selva restantes y colócalas boca abajo formando la pila de la selva.';

  @override
  String get jungleDisplayLabel => 'Revela la selva explorada';

  @override
  String get jungleDisplayDetail =>
      'Roba las 2 losetas superiores de la pila de la selva y colócalas boca arriba junto a la pila: forman la selva explorada.';

  @override
  String get resourcesBankLabel => 'Prepara el cacao, los soles y la banca';

  @override
  String get resourcesBankDetail =>
      'Coloca los frutos del cacao y las fichas de Sol formando reservas separadas. Pon al lado las monedas de oro formando la banca.';

  @override
  String removeTilesLabel(int quantity, String tileName) {
    return 'Devuelve ${quantity}x $tileName a la caja';
  }

  @override
  String removeTilesDetail(num quantity, String tileName) {
    String _temp0 = intl.Intl.pluralLogic(
      quantity,
      locale: localeName,
      other: 'Busca ${quantity}x $tileName y déjalas en la caja.',
      one: 'Busca ${quantity}x $tileName y déjala en la caja.',
    );
    return '$_temp0';
  }

  @override
  String removeAllTilesLabel(String tileName) {
    return 'Devuelve todas las losetas de $tileName a la caja';
  }

  @override
  String removeAllTilesDetail(String tileName) {
    return 'Busca todas las losetas de $tileName y déjalas en la caja.';
  }

  @override
  String addTilesLabel(int quantity, String tileName) {
    return 'Añade ${quantity}x $tileName a la selva';
  }

  @override
  String addTilesDetail(int quantity, String tileName) {
    return 'Añade ${quantity}x $tileName a las losetas de selva antes de montar la pila de la selva.';
  }

  @override
  String get twoPlayerRemovalRationale =>
      'Con 2 jugadores la selva se reduce para que la zona de juego quede recogida y la partida mantenga el ritmo.';

  @override
  String get bigGame3pRemovalRationale =>
      'El Big Game con 3 jugadores retira unas cuantas losetas para que el gran conjunto de losetas quede equilibrado.';

  @override
  String get tileSinglePlantation => 'Plantación simple';

  @override
  String get tileDoublePlantation => 'Plantación doble';

  @override
  String get tileMarketSelling2 => 'Mercado, precio de venta 2';

  @override
  String get tileMarketSelling3 => 'Mercado, precio de venta 3';

  @override
  String get tileGoldMineV1 => 'Mina de oro, valor 1';

  @override
  String get tileGoldMineV2 => 'Mina de oro, valor 2';

  @override
  String get tileWater => 'Cenote';

  @override
  String get tileSunWorshipingSite => 'Adoración al Sol';

  @override
  String get tileTemple => 'Templo';

  @override
  String get tileWatering => 'Irrigación';

  @override
  String get tileChocolateKitchen => 'Chocolatera';

  @override
  String get tileChocolateMarket => 'Mercado de chocolate';

  @override
  String get tileGemMine => 'Mina de gemas';

  @override
  String get tileTreeOfLife => 'Árbol de la vida';

  @override
  String get mapTokensLabel => 'Coge 2 fichas de mapa';

  @override
  String mapTokensDetail(String color) {
    return 'El jugador $color coge 2 fichas de mapa.';
  }

  @override
  String get mapTokensSurplusLabel =>
      'Devuelve las fichas de mapa sobrantes a la caja';

  @override
  String get mapTokensSurplusDetail =>
      'Las fichas de mapa sobrantes se devuelven a la caja.';

  @override
  String get mapBoardLabel => 'Coloca el tablero de mapas';

  @override
  String get mapBoardDetail =>
      'Tras preparar la pila de la selva, coloca el tablero de mapas a su lado.';

  @override
  String get jungleDisplayMapLabel =>
      'Revela 4 losetas de selva (tablero de mapas + selva explorada)';

  @override
  String get jungleDisplayMapDetail =>
      'Toma las cuatro losetas superiores de la pila de la selva. Coloca las dos primeras, boca arriba, en las casillas del tablero de mapas; las otras dos forman la selva explorada, del modo habitual.';

  @override
  String get initialTilesWaterLabel =>
      'Coloca las 2 losetas iniciales en diagonal';

  @override
  String get initialTilesWaterDetail =>
      'Como losetas iniciales, coloca una plantación simple (como siempre) y, en lugar del mercado de precio de venta \"2\", un cenote.';

  @override
  String get initialTilesWaterRationale =>
      'El módulo de irrigación cambia el mercado inicial por un cenote.';

  @override
  String get chocolateBarsLabel => 'Prepara las 20 tabletas de chocolate';

  @override
  String get chocolateBarsDetail =>
      'Deja las tabletas de chocolate formando una reserva al lado de los frutos del cacao.';

  @override
  String get hutsMarketLabel => 'Deja caer las 12 losetas de bohío';

  @override
  String get hutsMarketDetail =>
      'Sostén las 12 losetas de bohío con las manos, a una cierta altura sobre la mesa, y déjalas caer. Las caras que muestren serán las que se usen en esta partida. Luego, cuidando de no voltear ninguna, colócalas al lado de la banca, ordenadas según su coste.';

  @override
  String get hutsMarketRationale =>
      'Variante: en lugar de determinar al azar las funciones disponibles, los jugadores pueden acordar inicialmente, para cada bohío, cuál de sus dos caras se usa.';

  @override
  String get gemsRemoveLabel => 'Devuelve 8 gemas a la caja';

  @override
  String get gemsRemoveDetail =>
      'Retira 8 gemas (2 de cada color) y devuélvelas a la caja.';

  @override
  String get mineCarLabel => 'Llena y agita la vagoneta';

  @override
  String get mineCarAllDetail =>
      'Mete las 32 gemas en la vagoneta y mézclalas agitándola. Coloca la vagoneta junto a la zona de juego.';

  @override
  String get mineCarRemainingDetail =>
      'Mete las gemas restantes en la vagoneta y mézclalas agitándola. Coloca la vagoneta junto a la zona de juego.';

  @override
  String get masksLabel => 'Ordena las máscaras como reserva';

  @override
  String get masksAllDetail =>
      'Ordena las 7 máscaras por su valor en una fila ascendente y solapada como reserva.';

  @override
  String get masksWithout12Detail =>
      'Ordena las máscaras (sin la de valor 12) por su valor en una fila ascendente y solapada como reserva.';

  @override
  String get gemMinesReminderLabel =>
      'Recordatorio de regla: gemas en las minas nuevas';

  @override
  String get gemMinesReminderDetail =>
      'En cuanto una loseta de mina de gemas se coloque en la selva explorada o en el tablero de mapas, saca 6 gemas de la vagoneta y ponlas sobre la loseta de mina.';

  @override
  String get treeOfLife0004Label => 'Añade tu loseta de recolectores 0-0-0-4';

  @override
  String treeOfLife0004Detail(String color) {
    return 'Módulo El árbol de la vida: el jugador $color coge su loseta de recolectores 0-0-0-4 del módulo Los nuevos recolectores y la añade a sus losetas.';
  }

  @override
  String get treeOfLife0004Rationale =>
      'Con 2 jugadores El árbol de la vida requiere la loseta 0-0-0-4 para que todos los árboles puedan cosecharse por completo (reglamento de Diamante).';

  @override
  String get emperorLabel => 'Coloca la figura del ahau';

  @override
  String get emperorOnMarketDetail =>
      'Después de colocar las losetas iniciales, pon la figura del ahau sobre el mercado de precio de venta \"2\".';

  @override
  String get emperorOnWaterDetail =>
      'Después de colocar las losetas iniciales, pon la figura del ahau sobre el cenote.';

  @override
  String get newWorkersSelectionLabel => 'Elige las losetas de recolectores';

  @override
  String get newWorkersSelectionDetail =>
      'Selecciona qué losetas de recolectores queréis usar en esta partida.';

  @override
  String get returnToBoxTitle => 'Devolver a la caja';

  @override
  String get returnToBoxSubtitle => 'Estas losetas no se usan en esta partida';

  @override
  String get allSetTitle => '¡Todo listo!';

  @override
  String get allSetMessage =>
      'La mesa está preparada. ¡Que gane el mejor cultivador de cacao!';

  @override
  String get drawFirstPlayerAction => 'Sortearlo al azar';

  @override
  String get drawAgainAction => 'Volver a sortear';

  @override
  String startsFirst(String name) {
    return '¡Empieza $name!';
  }

  @override
  String get backToGameAction => 'Volver a la partida';

  @override
  String get menuHome => 'Inicio';

  @override
  String get menuGameSetup => 'Nueva partida';

  @override
  String get menuTiles => 'Losetas';

  @override
  String get menuScores => 'Puntuaciones';

  @override
  String get menuRules => 'Reglas';

  @override
  String get titlePreparation => 'Preparación';

  @override
  String get titleGameDashboard => 'Panel de partida';

  @override
  String get phaseTilePool => 'Losetas en juego';

  @override
  String get phasePlayerSetup => 'Preparación de los jugadores';

  @override
  String get phaseBoardSetup => 'Preparación de la mesa';

  @override
  String get phaseSupplies => 'Reservas';

  @override
  String get playersSection => 'Jugadores';

  @override
  String get expansionsSection => 'Expansiones';

  @override
  String get modulesSection => 'Módulos';

  @override
  String needMorePlayers(int count) {
    return 'Faltan $count+';
  }

  @override
  String get tapColorHint =>
      'Toca un color para añadir un jugador. Mantén pulsado y arrastra para reordenar.';

  @override
  String get selectExpansionsHint =>
      'Selecciona las expansiones con las que jugáis';

  @override
  String get selectModulesHint => 'Selecciona los módulos con los que jugáis';

  @override
  String get noExpansionWithModules =>
      'No hay ninguna expansión con módulos seleccionada';

  @override
  String get noModules => 'Sin módulos';

  @override
  String get startGame => 'Empezar la partida';

  @override
  String get resumeGame => 'Reanudar la partida';

  @override
  String get clearSetup => 'Limpiar todo';

  @override
  String get gameVariant => 'Variante de juego';

  @override
  String get bigGame => 'Big Game';

  @override
  String get bigGameHint =>
      'Usa todas las losetas de todos los módulos, sin sustituciones';

  @override
  String get showAllTiles => 'Mostrar todas las losetas';

  @override
  String get hideTiles => 'Ocultar las losetas';

  @override
  String get tilesInPlay => 'Losetas en juego';

  @override
  String get scoreCalculator => 'Calculadora de puntuación';

  @override
  String get noPlayersSelected => 'Ningún jugador seleccionado';

  @override
  String get noTiles => 'Sin losetas';

  @override
  String get baseGameOnly => 'Solo el juego base';

  @override
  String playerPosition(int position) {
    return 'Jugador $position';
  }

  @override
  String get closeAction => 'Cerrar';

  @override
  String get workerSheetTitle => 'Los nuevos recolectores';

  @override
  String get workerChooseIntro =>
      'Elige qué losetas de recolectores usará cada jugador. Todos los jugadores usan el mismo conjunto.';

  @override
  String get workerHowItWorks => '¿Cómo funciona?';

  @override
  String get workerHelpBody =>
      '• Los nuevos recolectores añade 4 losetas de recolectores nuevas con distribuciones diferentes a las del juego base.\n• Puedes usar un ajuste rápido o regular manualmente la cantidad de cada loseta.\n• El equilibrio entre recolectores y losetas de selva importa: si la diferencia queda fuera del margen indicado, la partida puede quedar desequilibrada.\n• Por defecto, el juego recomienda mantener 11 losetas por jugador, pero puedes añadir más para una partida más larga.';

  @override
  String get workerPresetsSection => 'Ajustes rápidos';

  @override
  String get workerRandomSection => 'Azar';

  @override
  String get workerPresetBaseOnly => 'Solo base';

  @override
  String get workerPresetReplace => 'Sustituir';

  @override
  String get workerPresetBase0004 => 'Base + 0-0-0-4';

  @override
  String get workerPresetAddAll => 'Añadirlas todas';

  @override
  String get workerAddAllDefault => 'Añadirlas todas (por defecto)';

  @override
  String get workerManual => 'Manual';

  @override
  String get workerSurprise => 'Sorpresa';

  @override
  String get workerSurpriseChip => 'Sorpresa +2';

  @override
  String get workerSurpriseTooltip =>
      'Base + 2 losetas nuevas elegidas al azar. Vuelve a tocar para una pareja diferente.';

  @override
  String get workerDescBaseOnly =>
      'Usa solo las losetas del juego base (11 por jugador). Las losetas nuevas de Diamante no se añaden.';

  @override
  String get workerDescReplace =>
      'Sustituye 4 losetas base (1-1-1-1) por las 4 nuevas de Diamante. Total: 11 por jugador.';

  @override
  String get workerDescBase0004 =>
      'Añade solo la loseta 0-0-0-4 a las 11 de base. Total: 12 por jugador. Recomendado por la comunidad (BGG).';

  @override
  String get workerDescAddAll =>
      'Añade las 4 losetas nuevas de Diamante a las 11 de base. Total: 15 por jugador.';

  @override
  String get workerDescManual =>
      'Selección manual: regula la cantidad de cada loseta individualmente.';

  @override
  String get workerDescSurprise =>
      'Sorpresa: losetas base + 2 nuevas de Diamante elegidas al azar. Vuelve a tocar para una pareja diferente.';

  @override
  String workerCustomPreset(String name) {
    return 'Ajuste personalizado: $name';
  }

  @override
  String workerSummaryLine(String label, int count) {
    return '$label · $count losetas/jugador';
  }

  @override
  String get workerBaseTiles => 'Losetas base';

  @override
  String get workerNewTiles => 'Losetas nuevas (Diamante)';

  @override
  String get workerBalanceOk => 'El equilibrio es correcto';

  @override
  String get workerBalanceOut => 'Fuera del margen recomendado';

  @override
  String get workerBalanceValid => 'Válido';

  @override
  String get workerBalanceOutShort => 'Fuera de margen';

  @override
  String get workerBalanceHint =>
      'El reglamento recomienda este margen para mantener la partida equilibrada, pero puedes aplicar la selección igualmente.';

  @override
  String get workerBalanceWorkersWord => 'recolectores';

  @override
  String get workerBalanceJungleWord => 'selva';

  @override
  String workerBalanceRange(int min, int max) {
    return '(margen: $min–$max)';
  }

  @override
  String workerTilesPerPlayerLine(int count) {
    return 'Losetas por jugador: $count';
  }

  @override
  String get workerLockedTooltip =>
      'Obligatoria con El árbol de la vida (2 jugadores)';

  @override
  String get resetAction => 'Restablecer';

  @override
  String get applyAction => 'Aplicar';

  @override
  String get saveAction => 'Guardar';

  @override
  String get deleteAction => 'Eliminar';

  @override
  String get savePresetTitle => 'Guardar como ajuste';

  @override
  String get presetNameLabel => 'Nombre del ajuste';

  @override
  String get presetNameHint => 'p. ej. Nuestro favorito';

  @override
  String get deletePresetTitle => 'Eliminar el ajuste';

  @override
  String deletePresetConfirm(String name) {
    return '¿Eliminar \'$name\'?';
  }

  @override
  String get errorLoadingPresets =>
      'Error al cargar los ajustes personalizados';

  @override
  String get errorSavingPresets =>
      'Error al guardar los ajustes personalizados';

  @override
  String get hutRegisterTitle => 'Registra la tirada de bohíos';

  @override
  String get hutRegisterHint =>
      'Toca una loseta para elegir la cara que ha quedado boca arriba; vuelve a tocarla para girarla.';

  @override
  String get hutRegisterAction => 'Registra qué bohíos han quedado boca arriba';

  @override
  String get hutRegisteredEdit => 'Tirada registrada · toca para editar';

  @override
  String get forgetThrowAction => 'Olvidar la tirada';

  @override
  String get hutMarketCrier => 'El voceador del mercado';

  @override
  String get hutHermit => 'El curandero';

  @override
  String get hutRoadWorker => 'El cuidador de sacbeob';

  @override
  String get hutTrader => 'El comerciante';

  @override
  String get hutFarmer => 'El agricultor';

  @override
  String get hutShaman => 'El chamán';

  @override
  String get hutMonk => 'El uay';

  @override
  String get hutMasterBuilder => 'El constructor';

  @override
  String get hutForeman => 'El capataz';

  @override
  String get hutFountainMaster => 'El brujo rabdomante';

  @override
  String get hutChiefsDaughter => 'La hija del jefe';

  @override
  String get hutChiefsSon => 'El hijo del jefe';

  @override
  String get hutChiefsWife => 'La mujer del jefe';

  @override
  String get hutChief => 'El jefe';

  @override
  String get menuTitle => 'Menú';

  @override
  String get summaryTiles => 'Losetas';

  @override
  String get summaryWorkers => 'Recolectores';

  @override
  String get summaryJungle => 'Selva';

  @override
  String get summaryHuts => 'Bohíos';

  @override
  String get tileMarketSelling4 => 'Mercado, precio de venta 4';

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
  String get moduleMaps => 'Mapas';

  @override
  String get moduleWatering => 'Irrigación';

  @override
  String get moduleChocolate => 'Chocolate';

  @override
  String get moduleHuts => 'Bohíos';

  @override
  String get moduleGemMines => 'Las minas de gemas';

  @override
  String get moduleTreeOfLife => 'El árbol de la vida';

  @override
  String get moduleEmperorsFavor => 'El favor del ahau';

  @override
  String get moduleNewWorkers => 'Los nuevos recolectores';

  @override
  String get moduleDescMaps =>
      'Dos losetas de selva adicionales quedan boca arriba en el tablero de mapas, junto a la pila de la selva. Al rellenar espacios de selva, puedes devolver 1 de tus fichas de mapa a la caja para elegir una loseta del tablero de mapas en lugar de la selva explorada.';

  @override
  String get moduleDescWatering =>
      'Tres losetas de irrigación sustituyen plantaciones: sus recolectores hacen retroceder a tu aguador y dan 4 frutos de cacao por remanso. Un cenote sustituye al mercado como segunda loseta inicial.';

  @override
  String get moduleDescChocolate =>
      'Las chocolateras y los mercados de chocolate sustituyen minas de oro y mercados de precio 3: convierte frutos de cacao en tabletas de chocolate y véndelas por hasta 7 monedas de oro.';

  @override
  String get moduleDescHuts =>
      '12 losetas de bohío de doble cara esperan junto a la banca, ordenadas por coste. Al final de tu turno puedes construir uno pagando oro que ya tengas; al final de la partida cada bohío devuelve su coste y da su bonificación.';

  @override
  String get moduleDescGemMines =>
      'Cinco minas de gemas sustituyen a los templos. Los recolectores activados recogen gemas de la vagoneta; un juego de los 4 colores se cambia de inmediato por la máscara de menor valor. Las máscaras y las gemas sobrantes valen oro.';

  @override
  String get moduleDescTreeOfLife =>
      'Tres árboles de la vida sustituyen a las minas de oro: cada recolector adyacente toma 1 moneda de oro — pero la fuerza está en la serenidad: un lado adyacente sin recolectores toma 3.';

  @override
  String get moduleDescEmperorsFavor =>
      'El ahau empieza en el mercado de precio de venta «2». Colocar una loseta de recolectores en su fila o columna lo mueve sobre ella y da 1 moneda de oro — y 1 más al comienzo de cada turno tuyo mientras siga allí.';

  @override
  String get moduleDescNewWorkers =>
      '16 losetas de recolectores con distribuciones nuevas (0-0-2-2, 0-2-0-2, 0-1-0-3, 0-0-0-4). Acordad cualquier combinación con las losetas del juego base — todos los jugadores usan el mismo conjunto.';

  @override
  String tileDescWorker(String distribution, String color) {
    return 'Loseta de recolectores $distribution del jugador $color.';
  }

  @override
  String get tileDesc_base_jungle_single_plantation =>
      'Por cada recolector tuyo activado en el lado adyacente de la loseta, puedes tomar **1 fruto de cacao** de la reserva. Colócalos individualmente en 1 almacén libre de tu tablero de aldea. Cada jugador tiene 5 almacenes y nunca puede almacenar más de *5 frutos de cacao*; los frutos adicionales que obtengas se pierden.\n\n![Toma el cacao](resource:assets/images/tiles/description/plantation.webp)';

  @override
  String get tileDesc_base_jungle_double_plantation =>
      'Por cada recolector tuyo activado en el lado adyacente de la loseta, puedes tomar **2 frutos de cacao** de la reserva. Colócalos individualmente en 1 almacén libre de tu tablero de aldea. Cada jugador tiene 5 almacenes y nunca puede almacenar más de *5 frutos de cacao*; los frutos adicionales que obtengas se pierden.\n\n![Toma el cacao](resource:assets/images/tiles/description/plantation.webp)';

  @override
  String get tileDesc_base_jungle_market_selling_2 =>
      'Por cada recolector tuyo activado en el lado adyacente de la loseta, puedes vender **1 fruto de cacao** de tu almacén al precio que indica el mercado. Devuelve el fruto de cacao a la reserva y toma **2 monedas de oro** de la banca.\n\n![Devuelve el cacao](resource:assets/images/tiles/description/market1.webp)\n\n![Toma las monedas](resource:assets/images/tiles/description/market2.webp)';

  @override
  String get tileDesc_base_jungle_market_selling_3 =>
      'Por cada recolector tuyo activado en el lado adyacente de la loseta, puedes vender **1 fruto de cacao** de tu almacén al precio que indica el mercado. Devuelve el fruto de cacao a la reserva y toma **3 monedas de oro** de la banca.\n\n![Devuelve el cacao](resource:assets/images/tiles/description/market1.webp)\n\n![Toma las monedas](resource:assets/images/tiles/description/market2.webp)';

  @override
  String get tileDesc_base_jungle_market_selling_4 =>
      'Por cada recolector tuyo activado en el lado adyacente de la loseta, puedes vender **1 fruto de cacao** de tu almacén al precio que indica el mercado. Devuelve el fruto de cacao a la reserva y toma **4 monedas de oro** de la banca.\n\n![Devuelve el cacao](resource:assets/images/tiles/description/market1.webp)\n\n![Toma las monedas](resource:assets/images/tiles/description/market2.webp)';

  @override
  String get tileDesc_base_jungle_gold_mine_value_1 =>
      'Por cada recolector tuyo activado en el lado adyacente de la loseta, puedes tomar de la banca el valor indicado, es decir, **1 moneda de oro**.\n\n![Toma las monedas](resource:assets/images/tiles/description/gold_mine.webp)';

  @override
  String get tileDesc_base_jungle_gold_mine_value_2 =>
      'Por cada recolector tuyo activado en el lado adyacente de la loseta, puedes tomar de la banca el valor indicado, es decir, **2 monedas de oro**.\n\n![Toma las monedas](resource:assets/images/tiles/description/gold_mine.webp)';

  @override
  String get tileDesc_base_jungle_water =>
      'Por cada recolector tuyo activado en el lado adyacente de la loseta, puedes avanzar el aguador de tu tablero de aldea 1 remanso en sentido horario. Si el aguador llega al remanso de valor \"16\", se detiene allí; los pasos que sobren se pierden.\n\nAl final de la partida, sumas a tus monedas de oro el valor del remanso donde está tu aguador. Si el aguador sigue en un remanso de valor negativo, debes restar el número correspondiente.\n\n![Mueve al aguador](resource:assets/images/tiles/description/water.webp)';

  @override
  String get tileDesc_base_jungle_sun_worshiping_site =>
      'Por cada recolector tuyo activado en el lado adyacente de la loseta, puedes tomar 1 ficha de Sol de la reserva. Colócala en un lugar de adoración al Sol libre de tu tablero de aldea. Cada jugador tiene 3 lugares de adoración al Sol y nunca puede tener más de 3 fichas de Sol. Las fichas de Sol que obtengas de más se pierden.\n\nHacia el final de la partida, puedes usar las fichas de Sol para \"sobreedificar\" una de tus **propias** losetas de recolectores. Al final de la partida, recibes 1 moneda de oro de la banca por cada ficha de Sol que no hayas usado.\n\n![Toma una ficha de Sol](resource:assets/images/tiles/description/sun_worshiping_site1.webp)\n\n**SOBREEDIFICAR UNA LOSETA DE RECOLECTORES**\n\nCuando la pila de la selva se haya agotado hacia el final de la partida y no queden losetas de selva en la selva explorada, a partir de entonces puedes sobreedificar una de tus **propias** losetas de recolectores, en lugar de añadirla a la zona de juego del modo habitual; para ello, debes devolver 1 ficha de Sol a la reserva. Elige 1 loseta de recolectores de tu mano y colócala **encima** de una de tus **propias** losetas colocadas anteriormente. Después, llevas a cabo las acciones de las losetas de selva adyacentes para los recolectores activados. Si no tienes ninguna ficha de Sol, no puedes sobreedificar y debes colocar la nueva loseta del modo habitual.\n\n**Importante:** cada loseta de recolectores solo puede sobreedificarse **una vez**. ***Ejemplo:***\n\n*Es el turno del rojo. La pila de la selva se ha agotado y la selva explorada está vacía. Por tanto, puede sobreedificar: devuelve a la reserva 1 ficha de Sol de uno de sus lugares de adoración al Sol; después, sobreedifica 1 de sus losetas de recolectores. Coloca la loseta nueva encima de la loseta colocada en un turno anterior y lleva a cabo las acciones de las losetas de selva adyacentes. Primero, toma 2 frutos de cacao por el recolector de la plantación doble y los coloca en dos de sus almacenes. Después, vende los dos frutos de cacao en el mercado por 2x4 = 8 monedas de oro. Finalmente, avanza su aguador 1 remanso.*';

  @override
  String get tileDesc_base_jungle_temple =>
      'Los templos no tienen ningún efecto directo durante la partida. Solo al final de la partida se puntúan los templos, individualmente, uno tras otro. El jugador que tiene más recolectores adyacentes al templo correspondiente recibe 6 monedas de oro de la banca. El jugador con el segundo número más alto de recolectores adyacentes obtiene 3. Si hay empate en el primer puesto, las 6 monedas de oro se reparten equitativamente entre los jugadores implicados (redondeando hacia abajo si es necesario). En ese caso, no se da oro por el segundo puesto. Si el primer puesto está claro pero hay empate en el segundo, las 3 monedas de oro se reparten equitativamente entre los jugadores implicados (redondeando hacia abajo si es necesario).\n\n**Atención:** si alguna loseta de recolectores adyacente al templo ha sido sobreedificada, solo cuentan para la puntuación las losetas de arriba.\n\n**Nota:** si solo hay 1 jugador con recolectores adyacentes al templo, recibe 6 monedas de oro de la banca, como es habitual; no se da oro por el segundo puesto. Hay que tener al menos 1 recolector adyacente al templo para puntuar en él.\n\n***Ejemplo:***\n\n*El amarillo y el rojo tienen 2 recolectores cada uno en este templo. Por tanto, se reparten las 6 monedas de oro del primer puesto; cada uno recibe 3 monedas de oro de la banca. El violeta tiene 1 recolector en este templo; sin embargo, se va con las manos vacías, porque en este caso el segundo puesto no se premia.*\n\n![Templo](resource:assets/images/tiles/description/temple.webp)';

  @override
  String get tileDesc_chocolatl_jungle_watering =>
      'Por cada recolector tuyo activado en el lado adyacente de la loseta, puedes hacer retroceder el aguador de tu tablero de aldea 1 remanso en sentido antihorario. Por cada remanso que hagas retroceder a tu aguador, tomas 4 frutos de cacao de la reserva y los colocas en almacenes libres de tu tablero de aldea. Si tu aguador está en el remanso de valor “-10”, no puedes obtener ningún fruto.\n\n**Atención:** los frutos de cacao adicionales que obtendrías se pierden, como es habitual. Por eso no tiene sentido conectar a una loseta de irrigación lados de loseta con más de 1 recolector.';

  @override
  String get tileDesc_chocolatl_jungle_chocolate_kitchen =>
      'Por cada recolector tuyo activado en el lado adyacente de la loseta, puedes convertir 1 fruto de cacao de tu almacén en 1 tableta de chocolate. Devuelve el fruto de cacao a la reserva. Después, toma la tableta de chocolate de la reserva y colócala en un almacén libre de tu tablero de aldea.\nCada almacén puede contener o bien 1 fruto de cacao o bien 1 tableta de chocolate.\n\n**FINAL DE LA PARTIDA**\n**Atención:** las tabletas de chocolate sobrantes no dan ninguna moneda de oro al final de la partida.';

  @override
  String get tileDesc_chocolatl_jungle_chocolate_market =>
      'Por cada recolector tuyo activado en el lado adyacente de la loseta, puedes vender 1 fruto de cacao de tu almacén por 3 monedas de oro, o 1 tableta de chocolate de tu almacén por 7 monedas de oro. Devuelve el fruto de cacao o la tableta de chocolate a la reserva y toma de la banca la cantidad de oro correspondiente.\nSi has activado más de 1 recolector, puedes elegir individualmente para cada recolector activado si quieres vender 1 fruto de cacao o 1 tableta de chocolate.';

  @override
  String get tileDesc_diamante_jungle_gem_mine =>
      'Por cada recolector tuyo activado en el lado adyacente de la loseta, puedes tomar 1 gema a tu elección de esta mina de gemas. Coloca las gemas junto a tu tablero de aldea.\n\nEn cuanto tengas al menos 1 gema de cada uno de los 4 colores, **debes cambiar inmediatamente** este juego de 4 gemas por la máscara de menor valor disponible en la reserva. Retira de la partida las gemas cambiadas y devuélvelas a la caja.';

  @override
  String get tileDesc_diamante_jungle_tree_of_life =>
      'Por cada recolector tuyo activado en el lado adyacente de la loseta, puedes tomar 1 moneda de oro de la banca.\n\nPero la fuerza está en la serenidad: si no hay ningún recolector representado en el lado adyacente de la loseta, puedes tomar incluso 3 monedas de oro de la banca.';

  @override
  String get tileDesc_chocolatl_hut_market_crier =>
      '**Coste de construcción:** 4 de oro\n\n**Función:** durante toda la partida, vendes tus frutos de cacao en los mercados adyacentes de precio de venta 2 por 3 monedas de oro en lugar de 2.\n\n**Final de la partida:** suma el coste de construcción (4 de oro) a tu oro total.';

  @override
  String get tileDesc_chocolatl_hut_hermit =>
      '**Coste de construcción:** 6 de oro\n\n**Función:** 1 moneda de oro por cada recolector tuyo que no tenga ninguna loseta de selva adyacente al final de la partida.\n\n**Final de la partida:** suma el coste de construcción (6 de oro) más la bonificación a tu oro total.';

  @override
  String get tileDesc_chocolatl_hut_road_worker =>
      '**Coste de construcción:** 6 de oro\n\n**Función:** al final de la partida, obtienes 1 moneda de oro por cada loseta de recolectores tuya en la fila o columna donde tengas más losetas de recolectores.\n\n**Final de la partida:** suma el coste de construcción (6 de oro) más la bonificación a tu oro total.';

  @override
  String get tileDesc_chocolatl_hut_trader =>
      '**Coste de construcción:** 6 de oro\n\n**Función:** los frutos de cacao sobrantes en tu almacén te dan 1 moneda de oro cada uno al final de la partida.\n\n**Final de la partida:** suma el coste de construcción (6 de oro) más la bonificación a tu oro total.';

  @override
  String get tileDesc_chocolatl_hut_farmer =>
      '**Coste de construcción:** 8 de oro\n\n**Función:** siempre que obtengas exactamente 4 frutos de cacao en un mismo turno durante la partida, recibes 1 fruto de cacao adicional, siempre que te quede espacio en el almacén.\n\n**Final de la partida:** suma el coste de construcción (8 de oro) a tu oro total.';

  @override
  String get tileDesc_chocolatl_hut_shaman =>
      '**Coste de construcción:** 8 de oro\n\n**Función:** si sobreedificas una de tus losetas de recolectores durante la partida, no tienes que devolver ninguna ficha de Sol a la reserva para hacerlo.\n\n**Final de la partida:** suma el coste de construcción (8 de oro) a tu oro total.';

  @override
  String get tileDesc_chocolatl_hut_monk =>
      '**Coste de construcción:** 10 de oro\n\n**Función:** 1 moneda de oro al final de la partida por cada templo donde tengas al menos 1 recolector adyacente.\n\n**Final de la partida:** suma el coste de construcción (10 de oro) más la bonificación a tu oro total.';

  @override
  String get tileDesc_chocolatl_hut_master_builder =>
      '**Coste de construcción:** 10 de oro\n\n**Función:** al final de la partida, obtienes 1 moneda de oro por cada uno de tus otros bohíos.\n\n**Final de la partida:** suma el coste de construcción (10 de oro) más la bonificación a tu oro total.';

  @override
  String get tileDesc_chocolatl_hut_foreman =>
      '**Coste de construcción:** 12 de oro\n\n**Función:** cuando colocas una loseta de recolectores con 3 recolectores en un lado durante la partida, se cuenta como si tuviera un 4.º recolector adicional en ese lado.\n\n**Final de la partida:** suma el coste de construcción (12 de oro) a tu oro total.';

  @override
  String get tileDesc_chocolatl_hut_fountain_master =>
      '**Coste de construcción:** 12 de oro\n\n**Función:** 4 monedas de oro al final de la partida si tu aguador está en el remanso de valor “16”.\n\n**Final de la partida:** suma el coste de construcción (12 de oro) más la bonificación (si procede) a tu oro total.';

  @override
  String get tileDesc_chocolatl_hut_chiefs_daughter =>
      '**Coste de construcción:** 14 de oro\n\n**Función:** 4 monedas de oro al final de la partida.\n\n**Final de la partida:** suma el coste de construcción (14 de oro) más la bonificación (4 de oro) a tu oro total.';

  @override
  String get tileDesc_chocolatl_hut_chiefs_son =>
      '**Coste de construcción:** 16 de oro\n\n**Función:** 4 monedas de oro al final de la partida.\n\n**Final de la partida:** suma el coste de construcción (16 de oro) más la bonificación (4 de oro) a tu oro total.';

  @override
  String get tileDesc_chocolatl_hut_chiefs_wife =>
      '**Coste de construcción:** 20 de oro\n\n**Función:** 5 monedas de oro al final de la partida.\n\n**Final de la partida:** suma el coste de construcción (20 de oro) más la bonificación (5 de oro) a tu oro total.';

  @override
  String get tileDesc_chocolatl_hut_chief =>
      '**Coste de construcción:** 24 de oro\n\n**Función:** 6 monedas de oro al final de la partida.\n\n**Final de la partida:** suma el coste de construcción (24 de oro) más la bonificación (6 de oro) a tu oro total.';

  @override
  String get tileTypePlayer => 'Jugador';

  @override
  String get tileTypeMarket => 'Mercado';

  @override
  String get tileTypePlantation => 'Plantación';

  @override
  String get tileTypeGoldMine => 'Mina de oro';

  @override
  String get tileTypeWater => 'Cenote';

  @override
  String get tileTypeTemple => 'Templo';

  @override
  String get tileTypeSunWorshipingSite => 'Adoración al Sol';

  @override
  String get tileTypeWatering => 'Irrigación';

  @override
  String get tileTypeChocolateKitchen => 'Chocolatera';

  @override
  String get tileTypeChocolateMarket => 'Mercado de chocolate';

  @override
  String get tileTypeMapTile => 'Loseta de mapa';

  @override
  String get tileTypeHut => 'Bohío';

  @override
  String get tileTypeGemMine => 'Mina de gemas';

  @override
  String get tileTypeTreeOfLife => 'Árbol de la vida';

  @override
  String get filterSheetTitle => 'Filtros';

  @override
  String get clearAllAction => 'Borrar todo';

  @override
  String get searchTileHint => 'Busca una loseta por nombre...';

  @override
  String get tileTypesSection => 'Tipos de loseta';

  @override
  String get filterTilesTooltip => 'Filtrar las losetas';

  @override
  String get displaySettingsTooltip => 'Opciones de visualización';

  @override
  String activeFiltersCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count filtros activos',
      one: '1 filtro activo',
    );
    return '$_temp0';
  }

  @override
  String costLabel(int cost) {
    return 'Coste: $cost';
  }

  @override
  String get settingsSheetTitle => 'Opciones';

  @override
  String get settingsGeneralSection => 'General';

  @override
  String get settingsBadgesSection => 'Insignias';

  @override
  String get settingsPlayerColorsSection => 'Colores de jugador';

  @override
  String get settingBoardgameTitle => 'Título del juego';

  @override
  String get settingShowQuantity => 'Mostrar la cantidad';

  @override
  String get settingCompactLayout => 'Disposición compacta';

  @override
  String get settingBadgeTypeInText => 'Tipo de loseta en texto';

  @override
  String get settingBadgeTypeInImage => 'Tipo de loseta en la imagen';

  @override
  String get settingPlayerColorInBorder => 'Color del jugador en el borde';

  @override
  String get settingPlayerColorInCircle => 'Color del jugador en círculo';

  @override
  String get scoreStepSetup => 'Jugadores y módulos';

  @override
  String get scoreCatGold => 'Oro acumulado';

  @override
  String get scoreCatWater => 'Remansos del aguador';

  @override
  String get scoreCatTemples => 'Templos';

  @override
  String get scoreCatSun => 'Fichas de Sol';

  @override
  String get scoreCatCacao => 'Cacao sobrante';

  @override
  String get scoreCatHuts => 'Bohíos';

  @override
  String get scoreCatGemMines => 'Minas de gemas';

  @override
  String get startOverAction => 'Empezar de nuevo';

  @override
  String get startOverTitle => '¿Empezar de nuevo?';

  @override
  String get startOverBody =>
      'Esto descarta todas las puntuaciones introducidas y vuelve a cargar los jugadores y módulos de la partida configurada.';

  @override
  String get backAction => 'Atrás';

  @override
  String get nextAction => 'Siguiente';

  @override
  String get resultsAction => 'Resultados';

  @override
  String get needTwoPlayers => 'Selecciona al menos 2 jugadores';

  @override
  String get scoreSetupIntro =>
      'Selecciona los jugadores de la partida terminada.';

  @override
  String get scoreModulesIntro => 'Módulos que cambian la puntuación final:';

  @override
  String get scoreHutModuleSubtitle =>
      'Xocolatl: los bohíos construidos devuelven su coste y dan bonificaciones';

  @override
  String get scoreGemModuleSubtitle =>
      'Diamante: las minas de gemas sustituyen a los templos';

  @override
  String get scoreGoldIntro =>
      'Cuenta las monedas de oro de cada jugador. Toca el número para introducirlo directamente.';

  @override
  String get scoreWaterIntro =>
      'Selecciona el remanso donde ha terminado la partida cada aguador. Los remansos negativos restan oro.';

  @override
  String get scoreTemplesIntro =>
      'Añade una entrada por templo y cuenta los recolectores adyacentes. El oro se otorga automáticamente: 6 por el primer puesto, 3 por el segundo, y los empates se reparten redondeando hacia abajo.';

  @override
  String get scoreSunIntro =>
      'Las fichas de Sol no usadas para sobreedificar valen 1 moneda de oro cada una (máximo 3).';

  @override
  String get scoreCacaoIntro =>
      'Los frutos de cacao sobrantes no dan oro, pero deciden los empates: con el mismo oro, gana el jugador con más cacao sobrante.';

  @override
  String get scoreHutsIntro =>
      'Marca los bohíos que ha construido cada jugador. Los costes de construcción se devuelven y las bonificaciones se añaden automáticamente. Los bohíos son losetas físicas limitadas: un bohío en gris no tiene ninguna loseta disponible (deselecciónalo de su propietario para reasignarlo).';

  @override
  String get scoreGemsIntro =>
      'Toca una máscara y elige de quién es. Las máscaras suman su valor en oro.';

  @override
  String get scoreGemsLeftoverIntro =>
      'Gemas sobrantes junto a cada tablero de aldea (1 moneda de oro cada una):';

  @override
  String get addTempleAction => 'Añadir templo';

  @override
  String get removeTempleTooltip => 'Eliminar el templo';

  @override
  String templeNumber(int number) {
    return 'Templo $number';
  }

  @override
  String hutsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bohíos',
      one: '1 bohío',
    );
    return '$_temp0';
  }

  @override
  String scoreHermitCount(String hutName) {
    return '$hutName: recolectores propios sin ninguna loseta de selva adyacente';
  }

  @override
  String scoreRoadWorkerCount(String hutName) {
    return '$hutName: losetas de recolectores en tu mejor fila o columna';
  }

  @override
  String get assignMaskTooltip => 'Asignar la máscara';

  @override
  String get nobodyOption => 'Nadie';

  @override
  String get enterValueTitle => 'Introduce el valor';

  @override
  String get okAction => 'Aceptar';

  @override
  String get finalScoreTitle => 'Puntuación final';

  @override
  String get winsTheGameSingle => '¡gana la partida!';

  @override
  String get winsTheGameShared => '¡ganan la partida!';

  @override
  String get sharedVictorySubtitle =>
      '¡Victoria compartida! Empate en oro y en cacao sobrante.';

  @override
  String get tiebreakSubtitle =>
      'Empate en oro resuelto por el cacao sobrante.';

  @override
  String get leftoverCacaoTiebreaker => 'Cacao sobrante (desempate)';

  @override
  String get homeIntro =>
      'Companion for Cacao es una aplicación móvil desarrollada con Flutter pensada para ayudar a los jugadores del juego de mesa Cacao y sus expansiones. El objetivo es ofrecer herramientas digitales que mejoren la experiencia de juego facilitando el recuento de puntos, la consulta de reglas y la gestión de la partida.';

  @override
  String get homeCompletedFeaturesTitle => 'Funcionalidades completadas';

  @override
  String get homePendingFeaturesTitle => 'Funcionalidades pendientes';

  @override
  String get homeCompletedFeatures =>
      '🏠 Menú principal: acceso rápido a todas las funcionalidades.\n🗂 Base de datos de losetas: catálogo completo de losetas.\n🔍 Filtro de losetas: busca y filtra por múltiples criterios.\n🌴 Juego base Cacao: soporte completo y preparación de la partida.\n🍫 Expansión Xocolatl: soporte completo con los 4 módulos.\n🚀 Expansión Diamante: soporte completo con los 4 módulos.\n🎲 Panel de partida: resumen, preparación y losetas en juego.\n🌟 Variante Big Game: integración de todos los módulos y expansiones.\n📖 Manuales integrados: consulta las reglas del juego.\n🏆 Calculadora de puntuación: puntuación final automática con las reglas oficiales de desempate.\n🌐 Multi idioma: catalán, castellano e inglés.\n📊 Interfaz adaptativa: diseño optimizado para distintos tamaños de pantalla.\n🔄 Actualizador automático: detección automática de nuevas versiones.';

  @override
  String get homePendingFeatures =>
      '🕒 Temporizador de turnos: controla la duración de cada turno.\n📜 Historial de partidas: registro de partidas terminadas y estadísticas de jugadores.\n⚙️ Configuración personalizada: ajusta la experiencia de juego.';

  @override
  String get homeContactTitle => 'Contacto';

  @override
  String get homeContactBody =>
      'Para sugerencias, mejoras, informes de errores o cualquier otra consulta, puedes visitar nuestro repositorio de GitHub. La aplicación es de código abierto y siempre buscamos colaboradores que ayuden a mejorarla.';

  @override
  String get homeVisitRepo => 'Visita nuestro repositorio de GitHub:';

  @override
  String get homeGithubBody =>
      'En GitHub puedes abrir «issues» para informar de errores, proponer nuevas funcionalidades o incluso enviar «pull requests» con tus propias contribuciones. ¡Trabajamos por mejorar la aplicación constantemente y agradecemos cualquier ayuda!';

  @override
  String get rulesBaseGame => 'Juego base';

  @override
  String get rulesInstructions => 'Instrucciones';

  @override
  String get rulesOverview => 'Referencia rápida';

  @override
  String rulesExpansionHeader(String name) {
    return 'Expansión: $name';
  }

  @override
  String rulesExpansionRules(String name) {
    return 'Reglas de $name';
  }

  @override
  String get openMenuTooltip => 'Abrir el menú';

  @override
  String get quantityAll => 'TODAS';

  @override
  String get errorGenericRetry => 'Algo ha fallado. Vuelve a intentarlo.';

  @override
  String get pageNotFoundTitle => 'Página no encontrada';

  @override
  String routeNotFound(String uri) {
    return 'Ruta no encontrada: $uri';
  }

  @override
  String get invalidDataMessage => 'Datos no válidos para esta pantalla.';

  @override
  String get retryAction => 'Reintentar';

  @override
  String get playerNameHint => 'Nombre';
}
