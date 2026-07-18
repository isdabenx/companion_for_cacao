import 'package:companion_for_cacao/core/data/database/app_database.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/core/data/repositories/boardgame_repository_impl.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BoardgameRepositoryImpl', () {
    late AppDatabase db;
    late BoardgameRepositoryImpl repository;

    setUp(() {
      db = AppDatabase(NativeDatabase.memory());
      repository = BoardgameRepositoryImpl(db);
    });

    tearDown(() async {
      await db.close();
    });

    Future<void> insertBoardgame({
      required int id,
      required String name,
      int? requireId,
    }) {
      return db
          .into(db.boardgames)
          .insert(
            BoardgamesCompanion.insert(
              id: Value(id),
              name: name,
              description: 'Description of $name',
              filenameImage: '$name.webp',
              requireId: Value(requireId),
            ),
          );
    }

    group('getAllBoardgames', () {
      test('returns empty list when no boardgames exist', () async {
        final result = await repository.getAllBoardgames();

        expect(result, isEmpty);
      });

      test('returns correctly mapped BoardgameEntities', () async {
        await insertBoardgame(id: 1, name: 'Cacao');
        await insertBoardgame(id: 2, name: 'Chocolatl', requireId: 1);

        final result = await repository.getAllBoardgames();

        expect(result, hasLength(2));
        final base = result.firstWhere((b) => b.id == 1);
        expect(base.name, 'Cacao');
        expect(base.description, 'Description of Cacao');
        expect(base.filenameImage, 'Cacao.webp');
        expect(base.requireId, isNull);

        final expansion = result.firstWhere((b) => b.id == 2);
        expect(expansion.name, 'Chocolatl');
        expect(expansion.requireId, 1);
      });
    });

    group('getAllModules', () {
      test('returns empty list when no modules exist', () async {
        final result = await repository.getAllModules();

        expect(result, isEmpty);
      });

      test('returns correctly mapped ModuleEntities', () async {
        await insertBoardgame(id: 2, name: 'Chocolatl');
        await db
            .into(db.modules)
            .insert(
              ModulesCompanion.insert(
                id: const Value(4),
                name: 'Huts',
                description: 'Hut module',
                boardgameId: const Value(2),
              ),
            );

        final result = await repository.getAllModules();

        expect(result, hasLength(1));
        expect(result.single.id, 4);
        expect(result.single.name, 'Huts');
        expect(result.single.description, 'Hut module');
        expect(result.single.boardgameId, 2);
      });
    });

    group('getAllTiles', () {
      test('returns correctly mapped TileEntities with parsed enums', () async {
        await insertBoardgame(id: 1, name: 'Cacao');
        await db
            .into(db.tiles)
            .insert(
              TilesCompanion.insert(
                id: 'base.worker_red_1-1-1-1',
                name: '1-1-1-1',
                description: 'Worker tile',
                filenameImage: 'worker.webp',
                quantity: 4,
                type: const Value('player'),
                color: const Value('red'),
                boardgameId: 1,
              ),
            );
        await db
            .into(db.tiles)
            .insert(
              TilesCompanion.insert(
                id: 'chocolatl.hut_chief',
                name: 'Chief',
                description: 'Hut tile',
                filenameImage: 'hut_chief.webp',
                quantity: 1,
                type: const Value('hut'),
                boardgameId: 1,
                moduleId: const Value(4),
                hutCost: const Value(24),
              ),
            );

        final result = await repository.getAllTiles();

        expect(result, hasLength(2));
        final worker = result.firstWhere(
          (t) => t.id == 'base.worker_red_1-1-1-1',
        );
        expect(worker.type, TileType.player);
        expect(worker.color, TileColor.red);
        expect(worker.quantity, 4);
        expect(worker.boardgameId, 1);
        expect(worker.moduleId, isNull);
        expect(worker.hutCost, isNull);

        final hut = result.firstWhere((t) => t.id == 'chocolatl.hut_chief');
        expect(hut.type, TileType.hut);
        expect(hut.color, isNull);
        expect(hut.moduleId, 4);
        expect(hut.hutCost, 24);
      });

      test('maps unknown type and color strings to null without '
          'throwing', () async {
        await insertBoardgame(id: 1, name: 'Cacao');
        await db
            .into(db.tiles)
            .insert(
              TilesCompanion.insert(
                id: 'base.mystery_tile',
                name: 'Mystery',
                description: 'Unknown type tile',
                filenameImage: 'mystery.webp',
                quantity: 1,
                type: const Value('notARealType'),
                color: const Value('notARealColor'),
                boardgameId: 1,
              ),
            );

        final result = await repository.getAllTiles();

        expect(result, hasLength(1));
        expect(result.single.type, isNull);
        expect(result.single.color, isNull);
        expect(result.single.name, 'Mystery');
      });
    });
  });
}
