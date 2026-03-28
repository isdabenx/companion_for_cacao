import 'dart:convert';

import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/core/data/database/app_database.dart';
import 'package:companion_for_cacao/features/splash/domain/repositories/initialization_repository.dart';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InitializationRepositoryImpl implements InitializationRepository {
  InitializationRepositoryImpl({AppDatabase? database}) : _db = database;

  AppDatabase? _db;
  static const String _dbVersionKey = 'db_seed_version';
  static const int _currentDbVersion = 2; // Bumped to 2 for Chocolatl

  @override
  Future<void> initialize() async {
    _initializeDatabase();
    await _populateDatabase();
  }

  @override
  AppDatabase getDatabase() {
    return _db!;
  }

  void _initializeDatabase() {
    _db ??= AppDatabase();
  }

  Future<void> _populateDatabase() async {
    final db = _db!;
    try {
      final prefs = await SharedPreferences.getInstance();
      final seededVersion = prefs.getInt(_dbVersionKey) ?? 0;

      final existing = await db.getAllBoardgames();

      // If we have data and we're at the current version, do nothing
      if (existing.isNotEmpty && seededVersion >= _currentDbVersion) {
        return;
      }

      // If upgrading from an older version, wipe the tables to re-seed fresh data
      if (existing.isNotEmpty && seededVersion < _currentDbVersion) {
        // ⚠️ IMPORTANT: This deletion ONLY targets SEED DATA (tiles, modules, boardgames).
        // ⚠️ Future USER data tables (saved games, history, settings, user profiles, etc.)
        // ⚠️ MUST NOT be deleted here. Create separate cleanup if needed for those tables.
        // ⚠️ Deleting user data will break game history and cause data loss.
        try {
          await db.batch((batch) {
            batch.deleteAll(db.tiles);
            batch.deleteAll(db.modules);
            batch.deleteAll(db.boardgames);
          });
        } catch (e) {
          throw Exception('Error deleting old database data: $e');
        }
      }

      final boardgamesJson = await rootBundle.loadString(Assets.boardgamesJson);
      final boardgamesData = json.decode(boardgamesJson) as List<dynamic>;

      final modulesJson = await rootBundle.loadString(Assets.modulesJson);
      final modulesData = json.decode(modulesJson) as List<dynamic>;

      final tilesJson = await rootBundle.loadString(Assets.tilesJson);
      final tilesData = json.decode(tilesJson) as List<dynamic>;

      try {
        await db.batch((batch) {
          batch
            ..insertAll(
              db.boardgames,
              boardgamesData.map(
                (b) => BoardgamesCompanion.insert(
                  id: Value((b as Map<String, dynamic>)['id'] as int),
                  name: b['name'] as String,
                  description: b['description'] as String,
                  filenameImage: b['filenameImage'] as String,
                  requireId: Value(b['require'] as int?),
                ),
              ),
            )
            ..insertAll(
              db.modules,
              modulesData.map(
                (m) => ModulesCompanion.insert(
                  id: Value((m as Map<String, dynamic>)['id'] as int),
                  name: m['name'] as String,
                  description: m['description'] as String,
                  boardgameId: Value(m['boardgame'] as int?),
                ),
              ),
            )
            ..insertAll(
              db.tiles,
              tilesData.map(
                (t) => TilesCompanion.insert(
                  id: (t as Map<String, dynamic>)['id'] as String,
                  name: t['name'] as String,
                  description: t['description'] as String,
                  filenameImage: t['filenameImage'] as String,
                  quantity: t['quantity'] as int,
                  type: Value(t['type'] as String?),
                  color: Value(t['color'] as String?),
                  boardgameId: t['boardgame'] as int,
                  moduleId: Value(t['module'] as int?),
                  hutCost: Value(t['hutCost'] as int?),
                ),
              ),
            );
        });
      } catch (e) {
        throw Exception('Error inserting seed data into database: $e');
      }

      await prefs.setInt(_dbVersionKey, _currentDbVersion);
    } catch (e) {
      throw Exception('Error populating database: $e');
    }
  }
}
