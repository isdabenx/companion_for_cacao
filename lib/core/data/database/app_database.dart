import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class Boardgames extends Table {
  IntColumn get id => integer().named('id')();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get filenameImage => text()();
  IntColumn get requireId => integer().nullable().references(Boardgames, #id)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Modules extends Table {
  IntColumn get id => integer().named('id')();
  TextColumn get name => text()();
  TextColumn get description => text()();
  IntColumn get boardgameId =>
      integer().nullable().references(Boardgames, #id)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class Tiles extends Table {
  TextColumn get id => text().named('id')();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get filenameImage => text()();
  IntColumn get quantity => integer()();
  TextColumn get type => text().nullable()();
  TextColumn get color => text().nullable()();
  IntColumn get boardgameId => integer().references(Boardgames, #id)();
  IntColumn get moduleId => integer().nullable().references(Modules, #id)();
  IntColumn get hutCost => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [Boardgames, Modules, Tiles])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  /// STRUCTURAL schema version, handled by the drift migrations below.
  ///
  /// Bump this (and add a migration) for schema changes: new columns,
  /// tables, or type changes. Refreshes of the bundled SEED DATA are
  /// versioned separately by `_currentDbVersion` in
  /// `InitializationRepositoryImpl` — bump that one instead when only the
  /// assets/initial_data/*.json content changes. Migrations that drop or
  /// recreate a seed table are safe: the seeder re-seeds automatically
  /// whenever a seed table is empty.
  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          // Add the hutCost column to the Tiles table
          await m.addColumn(tiles, tiles.hutCost);
        }
        if (from < 3) {
          // Tiles.id changed from INTEGER to TEXT (stable string ids)
          // without a migration at the time, leaving upgraded installs
          // with the old column affinity. Recreate the table so it
          // matches the declared schema. Tiles are pure seed data: the
          // seeder repopulates the table on next startup because it
          // re-seeds whenever a seed table is empty.
          await m.deleteTable(tiles.actualTableName);
          await m.createTable(tiles);
        }
      },
    );
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'companion_for_cacao');
  }

  Future<List<Boardgame>> getAllBoardgames() => select(boardgames).get();

  Future<Boardgame?> getBoardgameById(int id) {
    return (select(
      boardgames,
    )..where((b) => b.id.equals(id))).getSingleOrNull();
  }

  Future<List<Tile>> getAllTiles() => select(tiles).get();

  Future<List<Tile>> getTilesByIds(List<String> ids) {
    return (select(tiles)..where((t) => t.id.isIn(ids))).get();
  }

  Future<List<Module>> getAllModules() => select(modules).get();

  Future<List<Module>> getModulesByBoardgameId(int boardgameId) {
    return (select(
      modules,
    )..where((m) => m.boardgameId.equals(boardgameId))).get();
  }

  Future<List<Tile>> getTilesByBoardgameId(int boardgameId) {
    return (select(
      tiles,
    )..where((t) => t.boardgameId.equals(boardgameId))).get();
  }
}
