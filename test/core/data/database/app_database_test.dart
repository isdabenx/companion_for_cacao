import 'package:companion_for_cacao/core/data/database/app_database.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

/// SQLite disables foreign keys per connection, so the `references()` on the
/// tables are only worth anything if `beforeOpen` turns them on. These tests
/// are the guard: without the pragma every one of them passes silently by
/// letting the bad write through.
void main() {
  late AppDatabase db;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    // Opening is lazy — force it so `beforeOpen` has run before the checks.
    await db.getAllBoardgames();
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> insertBaseGame() {
    return db
        .into(db.boardgames)
        .insert(
          BoardgamesCompanion.insert(
            id: const Value(1),
            name: 'Cacao',
            description: '',
            filenameImage: '',
          ),
        );
  }

  test('foreign keys are enforced on the connection', () async {
    final pragma = await db.customSelect('PRAGMA foreign_keys').getSingle();
    expect(pragma.data.values.first, 1);
  });

  test('rejects a tile pointing at a boardgame that does not exist', () async {
    expect(
      () => db
          .into(db.tiles)
          .insert(
            TilesCompanion.insert(
              id: 'orphan',
              name: 'Orphan',
              description: '',
              filenameImage: '',
              quantity: 1,
              boardgameId: 999,
            ),
          ),
      throwsA(isA<SqliteException>()),
    );
  });

  test('rejects a module pointing at a boardgame that does not exist', () {
    expect(
      () => db
          .into(db.modules)
          .insert(
            ModulesCompanion.insert(
              id: const Value(1),
              name: 'Orphan module',
              description: '',
              boardgameId: const Value(999),
            ),
          ),
      throwsA(isA<SqliteException>()),
    );
  });

  test('rejects deleting a boardgame while its tiles reference it', () async {
    await insertBaseGame();
    await db
        .into(db.tiles)
        .insert(
          TilesCompanion.insert(
            id: 'plantation-1',
            name: 'Plantation',
            description: '',
            filenameImage: '',
            quantity: 6,
            boardgameId: 1,
          ),
        );

    expect(
      () => db.delete(db.boardgames).go(),
      throwsA(isA<SqliteException>()),
    );
  });

  test(
    'accepts the seeder order: boardgames, then modules, then tiles',
    () async {
      await insertBaseGame();
      await db
          .into(db.modules)
          .insert(
            ModulesCompanion.insert(
              id: const Value(1),
              name: 'Huts',
              description: '',
              boardgameId: const Value(1),
            ),
          );
      await db
          .into(db.tiles)
          .insert(
            TilesCompanion.insert(
              id: 'hut-1',
              name: 'Hut',
              description: '',
              filenameImage: '',
              quantity: 1,
              boardgameId: 1,
              moduleId: const Value(1),
            ),
          );

      expect(await db.getAllTiles(), hasLength(1));
    },
  );
}
