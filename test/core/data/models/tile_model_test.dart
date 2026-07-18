import 'package:companion_for_cacao/core/data/database/app_database.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Tile driftRow({String? type, String? color}) => Tile(
    id: 'base.worker_red_1-1-1-1',
    name: '1-1-1-1',
    description: 'A worker tile',
    filenameImage: 'worker.webp',
    quantity: 4,
    type: type,
    color: color,
    boardgameId: 1,
  );

  group('TileModel.fromDrift', () {
    test('parses valid type and color', () {
      final model = TileModel.fromDrift(driftRow(type: 'player', color: 'red'));
      expect(model.type, TileType.player);
      expect(model.color, TileColor.red);
      expect(model.id, 'base.worker_red_1-1-1-1');
      expect(model.quantity, 4);
    });

    test('parses null type and color as null', () {
      final model = TileModel.fromDrift(driftRow());
      expect(model.type, isNull);
      expect(model.color, isNull);
    });

    test('unknown type does not throw and yields null type', () {
      final model = TileModel.fromDrift(
        driftRow(type: 'goldmine', color: 'red'),
      );
      expect(model.type, isNull);
      expect(model.color, TileColor.red);
      expect(model.name, '1-1-1-1');
    });

    test('unknown color does not throw and yields null color', () {
      final model = TileModel.fromDrift(
        driftRow(type: 'player', color: 'green'),
      );
      expect(model.type, TileType.player);
      expect(model.color, isNull);
    });
  });

  group('TileModel enum name parsers', () {
    test('every TileType round-trips through typeFromName', () {
      for (final type in TileType.values) {
        expect(TileModel.typeFromName(type.name), type);
      }
    });

    test('every TileColor round-trips through colorFromName', () {
      for (final color in TileColor.values) {
        expect(TileModel.colorFromName(color.name), color);
      }
    });
  });
}
