import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/services/base_game_handler.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BaseGameHandler', () {
    late BaseGameHandler handler;
    late BoardgameModel baseGame;
    late List<TileModel> allTiles;

    setUp(() {
      // Mock Data
      allTiles = [
        // Jungle Tiles
        _createTile(name: 'Single Plantation', quantity: 8, isJungle: true),
        _createTile(name: 'Selling price 3', quantity: 2, isJungle: true),
        _createTile(name: 'Water', quantity: 3, isJungle: true),
        // Player Tiles (Red)
        _createTile(name: '1-1-1-1', quantity: 4, color: 'red'),
        _createTile(name: '2-1-0-1', quantity: 5, color: 'red'),
      ];

      baseGame = BoardgameModel(
        id: 1,
        name: 'Cacao',
        description: 'Base',
        filenameImage: '',
        tiles: allTiles,
      );
    });

    test(
      'adjustTiles should return only selected color tiles and jungle tiles',
      () {
        handler = BaseGameHandler(
          baseGame: baseGame,
          activeExpansions: [
            baseGame,
          ], // Simulating base game as expansion source too
          selectedColors: ['red'],
        );

        final result = handler.adjustTiles(allTiles, 4);

        // Should contain Red tiles and Jungle tiles
        expect(result.any((t) => t.color.toString().contains('red')), isTrue);
        expect(result.any((t) => t.color == null), isTrue);
      },
    );

    test('adjustTiles should reduce jungle tiles for 2 players', () {
      handler = BaseGameHandler(
        baseGame: baseGame,
        activeExpansions: [baseGame],
        selectedColors: ['red', 'purple'],
      );

      // 2 Players -> reduce specific tiles
      final result = handler.adjustTiles(allTiles, 2);

      // 'Single Plantation' starts with 8. 2-player rule reduces by 2. Expect 6.
      final plantation = result.firstWhere(
        (t) => t.name == 'Single Plantation',
      );
      expect(plantation.quantity, 6);

      // 'Selling price 3' starts with 2. 2-player rule reduces by 1. Expect 1.
      final market = result.firstWhere((t) => t.name == 'Selling price 3');
      expect(market.quantity, 1);
    });

    test('adjustTiles should reduce player tiles for >2 players', () {
      handler = BaseGameHandler(
        baseGame: baseGame,
        activeExpansions: [baseGame],
        selectedColors: ['red', 'purple', 'white'],
      );

      // 3 Players -> '1-1-1-1' reduced by 1
      final result = handler.adjustTiles(allTiles, 3);

      final tile1111 = result.firstWhere(
        (t) => t.name == '1-1-1-1' && t.color.toString().contains('red'),
      );
      // Original 4. Reduced by 1 -> 3.
      expect(tile1111.quantity, 3);
    });
  });
}

TileModel _createTile({
  required String name,
  required int quantity,
  bool isJungle = false,
  String? color,
}) {
  return TileModel(
    id: name.hashCode,
    name: name,
    description: 'desc',
    filenameImage: 'img.png',
    quantity: quantity,
    color: color != null
        ? TileColor.values.firstWhere((c) => c.name == color)
        : null,
    boardgameId: 1,
  );
}
