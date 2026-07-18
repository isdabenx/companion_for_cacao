import 'package:companion_for_cacao/core/data/database/app_database.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/features/tile/data/repositories/tile_repository_impl.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TileRepositoryImpl', () {
    late AppDatabase db;
    late TileRepositoryImpl repository;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      repository = TileRepositoryImpl(db);

      await db
          .into(db.boardgames)
          .insert(
            BoardgamesCompanion.insert(
              id: const Value(1),
              name: 'Cacao',
              description: 'Base game',
              filenameImage: 'cacao.webp',
            ),
          );
    });

    tearDown(() async {
      await db.close();
    });

    Future<void> insertTile({
      required String id,
      required String name,
      int quantity = 1,
      String? type,
      String? color,
    }) {
      return db
          .into(db.tiles)
          .insert(
            TilesCompanion.insert(
              id: id,
              name: name,
              description: 'Description of $name',
              filenameImage: '$name.webp',
              quantity: quantity,
              type: Value(type),
              color: Value(color),
              boardgameId: 1,
            ),
          );
    }

    group('getAllTiles', () {
      test('returns empty list when no tiles exist', () async {
        final result = await repository.getAllTiles();

        expect(result, isEmpty);
      });

      test('returns correctly mapped TileEntities', () async {
        await insertTile(
          id: 'base.jungle_temple',
          name: 'Temple',
          quantity: 5,
          type: 'temple',
        );
        await insertTile(
          id: 'base.worker_yellow_2-1-0-1',
          name: '2-1-0-1',
          quantity: 5,
          type: 'player',
          color: 'yellow',
        );

        final result = await repository.getAllTiles();

        expect(result, hasLength(2));
        final temple = result.firstWhere((t) => t.id == 'base.jungle_temple');
        expect(temple.name, 'Temple');
        expect(temple.quantity, 5);
        expect(temple.type, TileType.temple);
        expect(temple.color, isNull);
        expect(temple.boardgameId, 1);

        final worker = result.firstWhere(
          (t) => t.id == 'base.worker_yellow_2-1-0-1',
        );
        expect(worker.type, TileType.player);
        expect(worker.color, TileColor.yellow);
      });

      test('maps unknown type string to null type without throwing', () async {
        await insertTile(
          id: 'base.strange_tile',
          name: 'Strange',
          type: 'somethingNew',
        );

        final result = await repository.getAllTiles();

        expect(result.single.type, isNull);
        expect(result.single.id, 'base.strange_tile');
      });
    });

    group('getTilesByIds', () {
      setUp(() async {
        await insertTile(
          id: 'base.jungle_water',
          name: 'Water',
          quantity: 3,
          type: 'water',
        );
        await insertTile(
          id: 'base.jungle_temple',
          name: 'Temple',
          quantity: 5,
          type: 'temple',
        );
        await insertTile(
          id: 'base.jungle_single_plantation',
          name: 'Single Plantation',
          quantity: 6,
          type: 'plantation',
        );
      });

      test('returns only the tiles matching the given ids', () async {
        final result = await repository.getTilesByIds([
          'base.jungle_water',
          'base.jungle_temple',
        ]);

        expect(result, hasLength(2));
        expect(
          result.map((t) => t.id),
          containsAll(['base.jungle_water', 'base.jungle_temple']),
        );
        expect(
          result.firstWhere((t) => t.id == 'base.jungle_water').type,
          TileType.water,
        );
      });

      test('ignores ids that do not exist', () async {
        final result = await repository.getTilesByIds([
          'base.jungle_water',
          'base.does_not_exist',
        ]);

        expect(result, hasLength(1));
        expect(result.single.id, 'base.jungle_water');
      });

      test('returns empty list for empty ids input', () async {
        final result = await repository.getTilesByIds([]);

        expect(result, isEmpty);
      });
    });
  });
}
