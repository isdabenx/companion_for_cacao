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
  String get colorPurple => 'lila';

  @override
  String get colorYellow => 'amarillo';

  @override
  String get villageBoardLabel => 'Coge tu tablero de poblado';

  @override
  String villageBoardDetail(String color) {
    return 'Coge el tablero de poblado de color $color y ponlo delante de ti. Ahí irán tu pila de trabajadores y el track del portador de agua.';
  }

  @override
  String get waterCarrierLabel =>
      'Pon el portador de agua en la casilla \"-10\"';

  @override
  String waterCarrierDetail(String color) {
    return 'Coge el portador de agua de color $color y colócalo en la casilla de agua con valor \"-10\" de tu tablero de poblado.';
  }

  @override
  String get ownTilesLabel => 'Coge todas tus losetas de trabajador';

  @override
  String ownTilesDetail(String color) {
    return 'Reúne todas las losetas de trabajador con el dorso de color $color; son tu reserva personal para toda la partida.';
  }

  @override
  String removeWorkerLabel(String distribution) {
    return 'Devuelve una loseta de trabajador $distribution a la caja';
  }

  @override
  String removeWorkerDetail(String distribution) {
    return 'Busca entre tus losetas de trabajador una de las $distribution y devuélvela a la caja del juego.';
  }

  @override
  String get removeWorkerRationale =>
      'Con 3 o más jugadores cada uno usa menos losetas de trabajador para que la jungla no se agote antes de acabar la partida.';

  @override
  String get shuffleWorkersLabel => 'Baraja tus trabajadores y roba 3';

  @override
  String get shuffleWorkersDetail =>
      'Cada jugador baraja sus losetas de trabajador y las coloca como pila de robo boca abajo junto a su tablero de poblado. Después roba las 3 losetas superiores de su pila y las toma en la mano.';

  @override
  String get initialTilesMarketLabel =>
      'Coloca las 2 losetas iniciales en diagonal';

  @override
  String get initialTilesMarketDetail =>
      'De las losetas de jungla, coge la \"plantación simple\" y el \"mercado de precio 2\" y colócalas boca arriba en el centro de la mesa, en diagonal una respecto de la otra; forman las losetas iniciales de la zona de juego.';

  @override
  String get junglePileLabel => 'Monta la pila de jungla';

  @override
  String get junglePileDetail =>
      'Mezcla las losetas de jungla restantes y colócalas como pila de robo boca abajo.';

  @override
  String get jungleDisplayLabel => 'Revela 2 losetas de jungla';

  @override
  String get jungleDisplayDetail =>
      'Roba las 2 losetas superiores de la pila de jungla y colócalas junto a la pila como muestra de jungla boca arriba.';

  @override
  String get resourcesBankLabel => 'Prepara el cacao, los soles y la banca';

  @override
  String get resourcesBankDetail =>
      'Coloca los frutos de cacao y las fichas de sol como pilas de reserva separadas. Pon al lado las monedas de oro como banca.';

  @override
  String removeTilesLabel(int quantity, String tileName) {
    return 'Devuelve ${quantity}x $tileName a la caja';
  }

  @override
  String removeTilesDetail(num quantity, String tileName) {
    String _temp0 = intl.Intl.pluralLogic(
      quantity,
      locale: localeName,
      other: 'Aparta ${quantity}x $tileName y devuélvelo a la caja.',
      one: 'Aparta ${quantity}x $tileName y devuélvelo a la caja.',
    );
    return '$_temp0';
  }

  @override
  String removeAllTilesLabel(String tileName) {
    return 'Devuelve todas las losetas de $tileName a la caja';
  }

  @override
  String removeAllTilesDetail(String tileName) {
    return 'Aparta todas las losetas de $tileName y devuélvelas a la caja.';
  }

  @override
  String addTilesLabel(int quantity, String tileName) {
    return 'Añade ${quantity}x $tileName a la jungla';
  }

  @override
  String addTilesDetail(int quantity, String tileName) {
    return 'Añade ${quantity}x $tileName a las losetas de jungla antes de montar la pila de robo.';
  }

  @override
  String get twoPlayerRemovalRationale =>
      'Con 2 jugadores la jungla se reduce para que la zona de juego quede recogida y la partida mantenga el ritmo.';

  @override
  String get bigGame3pRemovalRationale =>
      'El Big Game con 3 jugadores retira unas cuantas losetas para que el gran conjunto de losetas quede equilibrado.';

  @override
  String get tileSinglePlantation => 'Plantación simple';

  @override
  String get tileDoublePlantation => 'Plantación doble';

  @override
  String get tileMarketSelling2 => 'Mercado de precio 2';

  @override
  String get tileMarketSelling3 => 'Mercado de precio 3';

  @override
  String get tileGoldMineV1 => 'Mina de oro de valor 1';

  @override
  String get tileGoldMineV2 => 'Mina de oro de valor 2';

  @override
  String get tileWater => 'Agua';

  @override
  String get tileSunWorshipingSite => 'Lugar de adoración del sol';

  @override
  String get tileTemple => 'Templo';

  @override
  String get tileWatering => 'Riego';

  @override
  String get tileChocolateKitchen => 'Cocina de chocolate';

  @override
  String get tileChocolateMarket => 'Mercado de chocolate';

  @override
  String get tileGemMine => 'Mina de gemas';

  @override
  String get tileTreeOfLife => 'Árbol de la Vida';

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
      'Devuelve las fichas de mapa sobrantes a la caja.';

  @override
  String get mapBoardLabel => 'Coloca el tablero de mapa';

  @override
  String get mapBoardDetail =>
      'Coloca el tablero de mapa justo al lado de la pila de jungla.';

  @override
  String get jungleDisplayMapLabel =>
      'Revela 4 losetas de jungla (tablero de mapa + muestra)';

  @override
  String get jungleDisplayMapDetail =>
      'Roba las 4 losetas superiores de la pila de jungla. Coloca las dos primeras boca arriba en los espacios marcados del tablero de mapa. Coloca las otras dos como muestra de jungla boca arriba junto al tablero de mapa.';

  @override
  String get initialTilesWaterLabel =>
      'Coloca las 2 losetas iniciales en diagonal';

  @override
  String get initialTilesWaterDetail =>
      'De las losetas de jungla, coge la \"plantación simple\" y el \"agua\" y colócalas boca arriba en el centro de la mesa, en diagonal una respecto de la otra; forman las losetas iniciales de la zona de juego.';

  @override
  String get initialTilesWaterRationale =>
      'El módulo de Riego cambia el mercado inicial por una loseta de agua.';

  @override
  String get chocolateBarsLabel => 'Prepara las 20 losetas de chocolate';

  @override
  String get chocolateBarsDetail =>
      'Coloca las 20 losetas de chocolate como pila de reserva separada junto a los frutos de cacao.';

  @override
  String get hutsMarketLabel => 'Lanza las 12 losetas de cabaña';

  @override
  String get hutsMarketDetail =>
      'Coge las 12 losetas de cabaña, déjalas caer desde poca altura para determinar al azar qué cara queda arriba, y ordénalas por coste de construcción junto a la banca como reserva.';

  @override
  String get hutsMarketRationale =>
      'Variante: alternativamente, los jugadores pueden acordar una selección concreta de cabañas en lugar de un surtido aleatorio.';

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
      'En cuanto una loseta de mina de gemas se coloque en la muestra de jungla o en el tablero de mapa, saca 6 gemas de la vagoneta y ponlas sobre la loseta de mina.';

  @override
  String get treeOfLife0004Label => 'Añade tu loseta de trabajador 0-0-0-4';

  @override
  String treeOfLife0004Detail(String color) {
    return 'Módulo Árbol de la Vida: el jugador $color coge su loseta de trabajador 0-0-0-4 del módulo Nuevos Trabajadores y la añade a sus losetas.';
  }

  @override
  String get treeOfLife0004Rationale =>
      'Con 2 jugadores el Árbol de la Vida requiere la loseta 0-0-0-4 para que todos los árboles puedan cosecharse por completo (reglamento de Diamante).';

  @override
  String get emperorLabel => 'Coloca la figura del Emperador';

  @override
  String get emperorOnMarketDetail =>
      'Después de colocar las losetas iniciales, pon la figura del Emperador sobre el mercado de precio 2.';

  @override
  String get emperorOnWaterDetail =>
      'Después de colocar las losetas iniciales, pon la figura del Emperador sobre la loseta de agua.';

  @override
  String get newWorkersSelectionLabel => 'Elige las losetas de trabajador';

  @override
  String get newWorkersSelectionDetail =>
      'Selecciona qué losetas de trabajador queréis usar en esta partida.';

  @override
  String get returnToBoxTitle => 'Devolver a la caja';

  @override
  String get returnToBoxSubtitle => 'Estas losetas no se usan en esta partida';

  @override
  String get allSetTitle => '¡Todo listo!';

  @override
  String get allSetMessage =>
      'La mesa está preparada. ¡Que gane el mejor plantador de cacao!';

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
}
