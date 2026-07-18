import 'package:companion_for_cacao/core/data/database/app_database.dart';
import 'package:companion_for_cacao/core/data/mappers/drift_entity_mappers.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
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

  group('Tile row toEntity', () {
    test('parses valid type and color', () {
      final entity = driftRow(type: 'player', color: 'red').toEntity();
      expect(entity.type, TileType.player);
      expect(entity.color, TileColor.red);
      expect(entity.id, 'base.worker_red_1-1-1-1');
      expect(entity.quantity, 4);
    });

    test('parses null type and color as null', () {
      final entity = driftRow().toEntity();
      expect(entity.type, isNull);
      expect(entity.color, isNull);
    });

    test('unknown type does not throw and yields null type', () {
      final entity = driftRow(type: 'goldmine', color: 'red').toEntity();
      expect(entity.type, isNull);
      expect(entity.color, TileColor.red);
      expect(entity.name, '1-1-1-1');
    });

    test('unknown color does not throw and yields null color', () {
      final entity = driftRow(type: 'player', color: 'green').toEntity();
      expect(entity.type, TileType.player);
      expect(entity.color, isNull);
    });
  });

  group('TileEntity enum name parsers', () {
    test('every TileType round-trips through typeFromName', () {
      for (final type in TileType.values) {
        expect(TileEntity.typeFromName(type.name), type);
      }
    });

    test('every TileColor round-trips through colorFromName', () {
      for (final color in TileColor.values) {
        expect(TileEntity.colorFromName(color.name), color);
      }
    });
  });
}
