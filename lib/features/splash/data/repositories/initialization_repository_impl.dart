import 'dart:convert';

import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/core/data/database/app_database.dart';
import 'package:companion_for_cacao/features/splash/domain/repositories/initialization_repository.dart';
import 'package:drift/drift.dart';
import 'package:flutter/services.dart';

class InitializationRepositoryImpl implements InitializationRepository {
  late final AppDatabase _db;

  @override
  Future<void> initialize() async {
    await _initializeDatabase();
    await _populateDatabase();
  }

  @override
  AppDatabase getDatabase() {
    return _db;
  }

  Future<void> _initializeDatabase() async {
    _db = AppDatabase();
  }

  Future<void> _populateDatabase() async {
    final existing = await _db.getAllBoardgames();
    if (existing.isNotEmpty) {
      return;
    }

    final boardgamesJson = await rootBundle.loadString(Assets.boardgamesJson);
    final boardgamesData = json.decode(boardgamesJson) as List<dynamic>;

    final modulesJson = await rootBundle.loadString(Assets.modulesJson);
    final modulesData = json.decode(modulesJson) as List<dynamic>;

    final tilesJson = await rootBundle.loadString(Assets.tilesJson);
    final tilesData = json.decode(tilesJson) as List<dynamic>;

    await _db.batch((batch) {
      batch
        ..insertAll(
          _db.boardgames,
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
          _db.modules,
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
          _db.tiles,
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
            ),
          ),
        );
    });
  }
}
