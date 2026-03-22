import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/core/data/models/module_model.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/screens/game_setup_detail_screen.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/detailed_summary_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  group('GameSetupDetailScreen', () {
    late GameSetupStateEntity dummyGameSetup;
    late MockGoRouter mockGoRouter;

    setUp(() {
      mockGoRouter = MockGoRouter();
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
        ],
        modules: [
          ModuleModel(id: 3, name: 'Huts', description: '', boardgameId: 1),
        ],
        tiles: [
          TileModel(
            id: 'base.jungle_single_plantation',
            name: '1-1-1-1',
            description: '',
            quantity: 4,
            filenameImage: '1-1-1-1.png',
            boardgameId: 1,
            color: null,
          ),
        ],
        isStarted: true,
      );
    });

    testWidgets('displays dashboard UI elements', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: InheritedGoRouter(
            goRouter: mockGoRouter,
            child: Scaffold(
              body: GameSetupDetailScreen(gameSetup: dummyGameSetup),
            ),
          ),
        ),
      );

      // Verify the title
      expect(find.text('Game Dashboard'), findsOneWidget);

      // Verify DetailedSummaryWidget is present
      expect(find.byType(DetailedSummaryWidget), findsOneWidget);

      // Verify the dashboard cards
      expect(find.text('Preparation'), findsOneWidget);
      expect(find.text('Tiles in Play'), findsOneWidget);

      // Look for the card icons
      expect(find.byIcon(Icons.list_alt), findsOneWidget);
      expect(find.byIcon(Icons.grid_view), findsOneWidget);
    });
  });
}
