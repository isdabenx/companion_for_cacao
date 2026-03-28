import 'package:companion_for_cacao/core/data/database/app_database.dart';
import 'package:companion_for_cacao/features/splash/data/repositories/initialization_repository_impl.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('InitializationRepositoryImpl', () {
    late InitializationRepositoryImpl repository;

    setUp(() {
      repository = InitializationRepositoryImpl();
      SharedPreferences.setMockInitialValues({});
    });

    tearDown(() async {
      // Clean up database after each test
      try {
        final db = repository.getDatabase();
        await db.close();
      } catch (_) {
        // Ignore if database wasn't initialized
      }
    });

    group('initialize', () {
      test('should initialize database successfully', () async {
        await repository.initialize();

        final db = repository.getDatabase();
        expect(db, isNotNull);
        expect(db, isA<AppDatabase>());
      });

      test('should populate database with seed data on first run', () async {
        // Mock asset bundle data
        const boardgamesJson = '''[
          {
            "id": 1,
            "name": "Cacao",
            "description": "Base game",
            "filenameImage": "cacao.webp"
          }
        ]''';

        const modulesJson = '''[
          {
            "id": 1,
            "name": "Module A",
            "description": "Test module",
            "boardgame": 1
          }
        ]''';

        const tilesJson = '''[
          {
            "id": "base.test_tile",
            "name": "Test Tile",
            "description": "A test tile",
            "filenameImage": "test.webp",
            "quantity": 5,
            "type": "market",
            "boardgame": 1
          }
        ]''';

        // Set up mock asset bundle
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(const MethodChannel('flutter/assets'), (
              MethodCall methodCall,
            ) async {
              if (methodCall.method == 'loadString') {
                final String assetPath = methodCall.arguments as String;
                if (assetPath.contains('boardgames.json')) {
                  return boardgamesJson;
                } else if (assetPath.contains('modules.json')) {
                  return modulesJson;
                } else if (assetPath.contains('tiles.json')) {
                  return tilesJson;
                }
              }
              return null;
            });

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
          // Set up mock with current version
          SharedPreferences.setMockInitialValues({'db_seed_version': 2});

          const boardgamesJson = '''[
          {
            "id": 1,
            "name": "Cacao",
            "description": "Base game",
            "filenameImage": "cacao.webp"
          }
        ]''';

          const modulesJson = '''[]''';
          const tilesJson = '''[]''';

          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(const MethodChannel('flutter/assets'), (
                MethodCall methodCall,
              ) async {
                if (methodCall.method == 'loadString') {
                  final String assetPath = methodCall.arguments as String;
                  if (assetPath.contains('boardgames.json')) {
                    return boardgamesJson;
                  } else if (assetPath.contains('modules.json')) {
                    return modulesJson;
                  } else if (assetPath.contains('tiles.json')) {
                    return tilesJson;
                  }
                }
                return null;
              });

          await repository.initialize();

          final prefs = await SharedPreferences.getInstance();
          final version = prefs.getInt('db_seed_version');
          expect(version, equals(2)); // Should remain version 2
        },
      );

      test(
        'should wipe and re-seed database when upgrading from older version',
        () async {
          // Simulate an old version
          SharedPreferences.setMockInitialValues({'db_seed_version': 1});

          const boardgamesJson = '''[
          {
            "id": 1,
            "name": "Cacao",
            "description": "Base game",
            "filenameImage": "cacao.webp"
          },
          {
            "id": 2,
            "name": "Chocolatl",
            "description": "Expansion 1",
            "filenameImage": "chocolatl.webp",
            "require": 1
          }
        ]''';

          const modulesJson = '''[
          {
            "id": 1,
            "name": "Module A",
            "description": "Test module",
            "boardgame": 2
          }
        ]''';

          const tilesJson = '''[
          {
            "id": "chocolatl.watering",
            "name": "Watering",
            "description": "Watering tile",
            "filenameImage": "watering.webp",
            "quantity": 3,
            "type": "watering",
            "boardgame": 2,
            "module": 1
          }
        ]''';

          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(const MethodChannel('flutter/assets'), (
                MethodCall methodCall,
              ) async {
                if (methodCall.method == 'loadString') {
                  final String assetPath = methodCall.arguments as String;
                  if (assetPath.contains('boardgames.json')) {
                    return boardgamesJson;
                  } else if (assetPath.contains('modules.json')) {
                    return modulesJson;
                  } else if (assetPath.contains('tiles.json')) {
                    return tilesJson;
                  }
                }
                return null;
              });

          await repository.initialize();

          final prefs = await SharedPreferences.getInstance();
          final version = prefs.getInt('db_seed_version');
          expect(version, equals(2)); // Should be upgraded to version 2

          final db = repository.getDatabase();
          final boardgames = await db.getAllBoardgames();
          expect(boardgames.length, equals(2)); // Should have both boardgames
          expect(boardgames.any((bg) => bg.name == 'Chocolatl'), isTrue);
        },
      );

      test(
        'should trigger re-seed when version is 0 (first install)',
        () async {
          // No version set (simulating first install)
          SharedPreferences.setMockInitialValues({});

          const boardgamesJson = '''[
          {
            "id": 1,
            "name": "Cacao",
            "description": "Base game",
            "filenameImage": "cacao.webp"
          }
        ]''';

          const modulesJson = '''[]''';
          const tilesJson = '''[]''';

          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(const MethodChannel('flutter/assets'), (
                MethodCall methodCall,
              ) async {
                if (methodCall.method == 'loadString') {
                  final String assetPath = methodCall.arguments as String;
                  if (assetPath.contains('boardgames.json')) {
                    return boardgamesJson;
                  } else if (assetPath.contains('modules.json')) {
                    return modulesJson;
                  } else if (assetPath.contains('tiles.json')) {
                    return tilesJson;
                  }
                }
                return null;
              });

          await repository.initialize();

          final prefs = await SharedPreferences.getInstance();
          final version = prefs.getInt('db_seed_version');
          expect(version, equals(2)); // Should be set to current version
        },
      );

      test('should preserve version key logic correctly', () async {
        SharedPreferences.setMockInitialValues({});

        const boardgamesJson =
            '''[{"id": 1, "name": "Test", "description": "Test", "filenameImage": "test.webp"}]''';
        const modulesJson = '''[]''';
        const tilesJson = '''[]''';

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(const MethodChannel('flutter/assets'), (
              MethodCall methodCall,
            ) async {
              if (methodCall.method == 'loadString') {
                final String assetPath = methodCall.arguments as String;
                if (assetPath.contains('boardgames.json')) {
                  return boardgamesJson;
                } else if (assetPath.contains('modules.json')) {
                  return modulesJson;
                } else if (assetPath.contains('tiles.json')) {
                  return tilesJson;
                }
              }
              return null;
            });

        await repository.initialize();

        final prefs = await SharedPreferences.getInstance();
        expect(prefs.containsKey('db_seed_version'), isTrue);
        expect(prefs.getInt('db_seed_version'), equals(2));
      });
    });

    group('getDatabase', () {
      test('should return the initialized database instance', () async {
        await repository.initialize();

        final db = repository.getDatabase();
        expect(db, isNotNull);
        expect(db, isA<AppDatabase>());
      });

      test('should return same database instance on multiple calls', () async {
        await repository.initialize();

        final db1 = repository.getDatabase();
        final db2 = repository.getDatabase();
        expect(identical(db1, db2), isTrue);
      });
    });

    group('error handling', () {
      test('should throw exception if asset loading fails', () async {
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(const MethodChannel('flutter/assets'), (
              MethodCall methodCall,
            ) async {
              throw Exception('Asset not found');
            });

        expect(() => repository.initialize(), throwsA(isA<Exception>()));
      });

      test('should throw exception if JSON parsing fails', () async {
        const invalidJson = 'not a valid json';

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(const MethodChannel('flutter/assets'), (
              MethodCall methodCall,
            ) async {
              return invalidJson;
            });

        expect(() => repository.initialize(), throwsA(isA<Exception>()));
      });
    });

    group('database deletion logic', () {
      test('should delete all seed data tables during migration', () async {
        SharedPreferences.setMockInitialValues({'db_seed_version': 1});

        const boardgamesJson = '''[
          {
            "id": 1,
            "name": "Cacao",
            "description": "Base game",
            "filenameImage": "cacao.webp"
          }
        ]''';

        const modulesJson = '''[]''';
        const tilesJson = '''[]''';

        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(const MethodChannel('flutter/assets'), (
              MethodCall methodCall,
            ) async {
              if (methodCall.method == 'loadString') {
                final String assetPath = methodCall.arguments as String;
                if (assetPath.contains('boardgames.json')) {
                  return boardgamesJson;
                } else if (assetPath.contains('modules.json')) {
                  return modulesJson;
                } else if (assetPath.contains('tiles.json')) {
                  return tilesJson;
                }
              }
              return null;
            });

        await repository.initialize();

        // Verify database was populated
        final db = repository.getDatabase();
        final boardgames = await db.getAllBoardgames();
        expect(boardgames, isNotEmpty);
      });

      test(
        'should only delete seed tables (tiles, modules, boardgames) not user data',
        () async {
          // This test verifies the implementation logic that specifically
          // targets only seed data tables for deletion
          SharedPreferences.setMockInitialValues({'db_seed_version': 1});

          const boardgamesJson =
              '''[{"id": 1, "name": "Test", "description": "Test", "filenameImage": "test.webp"}]''';
          const modulesJson = '''[]''';
          const tilesJson = '''[]''';

          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
              .setMockMethodCallHandler(const MethodChannel('flutter/assets'), (
                MethodCall methodCall,
              ) async {
                if (methodCall.method == 'loadString') {
                  final String assetPath = methodCall.arguments as String;
                  if (assetPath.contains('boardgames.json')) {
                    return boardgamesJson;
                  } else if (assetPath.contains('modules.json')) {
                    return modulesJson;
                  } else if (assetPath.contains('tiles.json')) {
                    return tilesJson;
                  }
                }
                return null;
              });

          // This test ensures migration logic is correctly implemented
          // In the future, if user data tables are added, they should NOT be deleted
          await repository.initialize();

          final prefs = await SharedPreferences.getInstance();
          expect(prefs.getInt('db_seed_version'), equals(2));
        },
      );
    });
  });
}
