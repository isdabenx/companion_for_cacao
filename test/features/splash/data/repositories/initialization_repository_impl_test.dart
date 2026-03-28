import 'dart:convert';

import 'package:companion_for_cacao/core/data/database/app_database.dart';
import 'package:companion_for_cacao/features/splash/data/repositories/initialization_repository_impl.dart';
import 'package:drift/drift.dart' hide isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Creates an in-memory AppDatabase for testing (avoids path_provider dependency).
AppDatabase _createTestDatabase() => AppDatabase(NativeDatabase.memory());

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('InitializationRepositoryImpl', () {
    late InitializationRepositoryImpl repository;
    late AppDatabase testDb;

    setUp(() {
      // Clear asset cache to prevent mock data leaking between tests
      rootBundle.clear();
      testDb = _createTestDatabase();
      repository = InitializationRepositoryImpl(database: testDb);
      SharedPreferences.setMockInitialValues({});
    });

    tearDown(() async {
      // Reset any mock message handlers
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler('flutter/assets', null);
      await testDb.close();
    });

    group('initialize', () {
      test('should initialize database successfully', () async {
        _mockAssetBundle(
          boardgames:
              '[{"id": 1, "name": "Cacao", "description": "Base game", "filenameImage": "cacao.webp"}]',
          modules: '[]',
          tiles: '[]',
        );

        await repository.initialize();

        final db = repository.getDatabase();
        expect(db, isNotNull);
        expect(db, isA<AppDatabase>());
      });

      test('should populate database with seed data on first run', () async {
        _mockAssetBundle(
          boardgames:
              '[{"id": 1, "name": "Cacao", "description": "Base game", "filenameImage": "cacao.webp"}]',
          modules:
              '[{"id": 1, "name": "Module A", "description": "Test module", "boardgame": 1}]',
          tiles:
              '[{"id": "base.test_tile", "name": "Test Tile", "description": "A test tile", "filenameImage": "test.webp", "quantity": 5, "type": "market", "boardgame": 1}]',
        );

        await repository.initialize();

        final db = repository.getDatabase();
        final boardgames = await db.getAllBoardgames();
        expect(boardgames, isNotEmpty);
        expect(boardgames.first.name, equals('Cacao'));
      });
    });

    group('migration and re-seeding logic', () {
      test(
        'should not re-seed if database is already populated and version is current',
        () async {
          SharedPreferences.setMockInitialValues({'db_seed_version': 2});

          _mockAssetBundle(
            boardgames:
                '[{"id": 99, "name": "ShouldNotAppear", "description": "New data", "filenameImage": "new.webp"}]',
            modules: '[]',
            tiles: '[]',
          );

          // Pre-populate database with existing data
          await testDb
              .into(testDb.boardgames)
              .insert(
                BoardgamesCompanion.insert(
                  id: const Value(1),
                  name: 'Cacao',
                  description: 'Base game',
                  filenameImage: 'cacao.webp',
                ),
              );

          await repository.initialize();

          final prefs = await SharedPreferences.getInstance();
          final version = prefs.getInt('db_seed_version');
          expect(version, equals(2));

          // Verify old data is still there (not re-seeded)
          final db = repository.getDatabase();
          final boardgames = await db.getAllBoardgames();
          expect(boardgames.length, equals(1));
          expect(boardgames.first.name, equals('Cacao'));
        },
      );

      test(
        'should wipe and re-seed database when upgrading from older version',
        () async {
          SharedPreferences.setMockInitialValues({'db_seed_version': 1});

          // Set up mock assets FIRST
          _mockAssetBundle(
            boardgames:
                '[{"id": 5, "name": "Cacao Fresh", "description": "Fresh base game", "filenameImage": "cacao.webp"}]',
            modules: '[]',
            tiles: '[]',
          );

          // Pre-populate with old data
          await testDb
              .into(testDb.boardgames)
              .insert(
                BoardgamesCompanion.insert(
                  id: const Value(1),
                  name: 'Cacao Old',
                  description: 'Old base game',
                  filenameImage: 'cacao.webp',
                ),
              );

          await repository.initialize();

          final prefs = await SharedPreferences.getInstance();
          final version = prefs.getInt('db_seed_version');
          expect(version, equals(2));

          final db = repository.getDatabase();
          final boardgames = await db.getAllBoardgames();
          expect(boardgames.length, equals(1));
          // Should have the re-seeded data, not the old one
          expect(boardgames.first.name, equals('Cacao Fresh'));
        },
      );

      test('should trigger re-seed when version is 0 (first install)', () async {
        SharedPreferences.setMockInitialValues({});

        _mockAssetBundle(
          boardgames:
              '[{"id": 1, "name": "Cacao", "description": "Base game", "filenameImage": "cacao.webp"}]',
          modules: '[]',
          tiles: '[]',
        );

        await repository.initialize();

        final prefs = await SharedPreferences.getInstance();
        final version = prefs.getInt('db_seed_version');
        expect(version, equals(2));
      });

      test('should preserve version key logic correctly', () async {
        SharedPreferences.setMockInitialValues({});

        _mockAssetBundle(
          boardgames:
              '[{"id": 1, "name": "Test", "description": "Test", "filenameImage": "test.webp"}]',
          modules: '[]',
          tiles: '[]',
        );

        await repository.initialize();

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.containsKey('db_seed_version'), isTrue);
        expect(prefs.getInt('db_seed_version'), equals(2));
      });
    });

    group('getDatabase', () {
      test('should return the initialized database instance', () async {
        _mockAssetBundle(
          boardgames:
              '[{"id": 1, "name": "Test", "description": "Test", "filenameImage": "test.webp"}]',
          modules: '[]',
          tiles: '[]',
        );

        await repository.initialize();

        final db = repository.getDatabase();
        expect(db, isNotNull);
        expect(db, isA<AppDatabase>());
      });

      test('should return same database instance on multiple calls', () async {
        _mockAssetBundle(
          boardgames:
              '[{"id": 1, "name": "Test", "description": "Test", "filenameImage": "test.webp"}]',
          modules: '[]',
          tiles: '[]',
        );

        await repository.initialize();

        final db1 = repository.getDatabase();
        final db2 = repository.getDatabase();
        expect(identical(db1, db2), isTrue);
      });
    });

    group('database deletion logic', () {
      test('should delete all seed data tables during migration', () async {
        SharedPreferences.setMockInitialValues({'db_seed_version': 1});

        _mockAssetBundle(
          boardgames:
              '[{"id": 1, "name": "Cacao", "description": "Base game", "filenameImage": "cacao.webp"}]',
          modules: '[]',
          tiles: '[]',
        );

        // Pre-populate with old data
        await testDb
            .into(testDb.boardgames)
            .insert(
              BoardgamesCompanion.insert(
                id: const Value(1),
                name: 'Old Cacao',
                description: 'Old base game',
                filenameImage: 'cacao.webp',
              ),
            );

        await repository.initialize();

        // Verify database was re-populated with fresh seed data
        final db = repository.getDatabase();
        final boardgames = await db.getAllBoardgames();
        expect(boardgames, isNotEmpty);
        // Should have the re-seeded "Cacao", not "Old Cacao"
        expect(boardgames.first.name, equals('Cacao'));
      });

      test(
        'should only delete seed tables (tiles, modules, boardgames) not user data',
        () async {
          SharedPreferences.setMockInitialValues({'db_seed_version': 1});

          _mockAssetBundle(
            boardgames:
                '[{"id": 1, "name": "Test", "description": "Test", "filenameImage": "test.webp"}]',
            modules: '[]',
            tiles: '[]',
          );

          // Pre-populate
          await testDb
              .into(testDb.boardgames)
              .insert(
                BoardgamesCompanion.insert(
                  id: const Value(1),
                  name: 'Old',
                  description: 'Old',
                  filenameImage: 'old.webp',
                ),
              );

          await repository.initialize();

          final prefs = await SharedPreferences.getInstance();
          expect(prefs.getInt('db_seed_version'), equals(2));
        },
      );
    });
  });
}

/// Helper to mock the Flutter asset bundle for tests.
void _mockAssetBundle({
  required String boardgames,
  required String modules,
  required String tiles,
}) {
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler('flutter/assets', (ByteData? message) async {
        // Decode the asset key from the message
        if (message == null) return null;
        final assetKey = utf8.decode(
          message.buffer.asUint8List(
            message.offsetInBytes,
            message.lengthInBytes,
          ),
        );

        String? response;
        if (assetKey.contains('boardgames.json')) {
          response = boardgames;
        } else if (assetKey.contains('modules.json')) {
          response = modules;
        } else if (assetKey.contains('tiles.json')) {
          response = tiles;
        }

        if (response != null) {
          final encoded = utf8.encode(response);
          return ByteData.sublistView(Uint8List.fromList(encoded));
        }
        return null;
      });
}
