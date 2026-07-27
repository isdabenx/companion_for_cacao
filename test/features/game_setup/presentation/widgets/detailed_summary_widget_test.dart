import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/module_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/detailed_summary_widget.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
          BoardgameEntity(
            id: 1,
            name: 'Cacao',
            description: '',
            filenameImage: '',
          ),
          BoardgameEntity(
            id: 2,
            name: 'Chocolatl',
            description: '',
            filenameImage: '',
          ),
        ],
        modules: [
          ModuleEntity(id: 3, name: 'Huts', description: '', boardgameId: 1),
        ],
        tiles: [
          TileEntity(
            id: 'base.jungle_single_plantation',
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
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: DetailedSummaryWidget(gameSetup: dummyGameSetup),
            ),
          ),
        ),
      );

      // Verify sections are visible
      expect(find.text('Players'), findsOneWidget);
      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Bob'), findsOneWidget);

      expect(find.text('Expansions'), findsOneWidget);
      // Catalog ids resolve through the ARB: boardgame 2 is Chocolatl.
      expect(find.text('Cacao: Chocolatl'), findsOneWidget); // id != 1

      expect(find.text('Modules'), findsOneWidget);
      expect(find.text('Chocolate Module'), findsOneWidget); // module id 3

      // Tiles section should be hidden initially (AnimatedSize hides it)
      // "Show All Tiles" button should be visible
      expect(find.text('Show All Tiles'), findsOneWidget);
      expect(find.text('Jungle'), findsNothing); // Should be hidden
    });

    testWidgets('expands and shows tiles when toggle button is pressed', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: DetailedSummaryWidget(gameSetup: dummyGameSetup),
            ),
          ),
        ),
      );

      // Tap to expand
      await tester.tap(find.text('Show All Tiles'));
      await tester.pumpAndSettle();

      // Verify tiles are now visible. The tile chip shows the localized
      // catalog name for its stable id, not the seeded name.
      expect(find.text('Hide Tiles'), findsOneWidget);
      expect(find.text('Jungle'), findsOneWidget);
      expect(find.text('Single Plantation'), findsOneWidget);

      // Tap to hide
      await tester.tap(find.text('Hide Tiles'));
      await tester.pumpAndSettle();

      expect(find.text('Show All Tiles'), findsOneWidget);
      expect(find.text('Single Plantation'), findsNothing);
    });
  });
}
