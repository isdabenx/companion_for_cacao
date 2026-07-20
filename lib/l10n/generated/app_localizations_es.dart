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
}
