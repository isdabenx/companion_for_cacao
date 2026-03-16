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
  IntColumn get id => integer().named('id')();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get filenameImage => text()();
  IntColumn get quantity => integer()();
  TextColumn get type => text().nullable()();
  TextColumn get color => text().nullable()();
  IntColumn get boardgameId => integer().references(Boardgames, #id)();
  IntColumn get moduleId => integer().nullable().references(Modules, #id)();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [Boardgames, Modules, Tiles])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

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

  Future<List<Tile>> getTilesByIds(List<int> ids) {
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
