import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/module_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/detailed_summary_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DetailedSummaryWidget', () {
    late GameSetupStateEntity dummyGameSetup;

    setUp(() {
      dummyGameSetup = GameSetupStateEntity(
        players: [
          PlayerEntity(name: 'Alice', color: 'red', isSelected: true),
          PlayerEntity(name: 'Bob', color: 'yellow', isSelected: true),
        ],
        expansions: [
          BoardgameModel(
            id: 1,
            name: 'Cacao',
            description: '',
            filenameImage: '',
          ),
          BoardgameModel(
            id: 2,
            name: 'Chocolatl',
            description: '',
            filenameImage: '',
          ),
        ],
        modules: [
          ModuleModel(id: 3, name: 'Huts', description: '', boardgameId: 1),
        ],
        tiles: [
          TileModel(
            id: 1,
            name: '1-1-1-1',
            description: '',
            quantity: 4,
            filenameImage: '1-1-1-1.png',
            boardgameId: 1,
            color: null, // Jungle tile
          ),
        ],
        isStarted: true,
      );
    });

    testWidgets('shows summary sections initially but not tiles', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DetailedSummaryWidget(gameSetup: dummyGameSetup),
          ),
        ),
      );

      // Verify sections are visible
      expect(find.text('Players'), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);

      expect(find.text('Expansions'), findsOneWidget);
      expect(find.text('Chocolatl'), findsOneWidget); // id != 1

      expect(find.text('Modules'), findsOneWidget);
      expect(find.text('Huts'), findsOneWidget);

      // Tiles section should be hidden initially (AnimatedSize hides it)
      // "Show All Tiles" button should be visible
      expect(find.text('Show All Tiles'), findsOneWidget);
      expect(find.text('Jungle'), findsNothing); // Should be hidden
    });

    testWidgets('expands and shows tiles when toggle button is pressed', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DetailedSummaryWidget(gameSetup: dummyGameSetup),
          ),
        ),
      );

      // Tap to expand
      await tester.tap(find.text('Show All Tiles'));
      await tester.pumpAndSettle();

      // Verify tiles are now visible
      expect(find.text('Hide Tiles'), findsOneWidget);
      expect(find.text('Jungle'), findsOneWidget);
      expect(find.text('1-1-1-1'), findsOneWidget);

      // Tap to hide
      await tester.tap(find.text('Hide Tiles'));
      await tester.pumpAndSettle();

      expect(find.text('Show All Tiles'), findsOneWidget);
      expect(find.text('1-1-1-1'), findsNothing);
    });
  });
}
