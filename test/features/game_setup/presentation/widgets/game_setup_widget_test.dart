import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/game_setup_widget.dart';
import 'package:companion_for_cacao/shared/providers/boardgame_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GameSetupWidget', () {
    testWidgets('should display Stepper with 3 steps', (tester) async {
      final container = ProviderContainer(
        overrides: [
          boardgameProvider.overrideWith(() => FakeBoardgameNotifier()),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: Scaffold(body: GameSetupWidget())),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(Stepper), findsOneWidget);
      expect(find.text('Players'), findsOneWidget);
      expect(find.text('Expansions (work in progress)'), findsOneWidget);
      expect(find.text('Modules (work in progress)'), findsOneWidget);
    });

    testWidgets('should display Start Game button', (tester) async {
      final container = ProviderContainer(
        overrides: [
          boardgameProvider.overrideWith(() => FakeBoardgameNotifier()),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: Scaffold(body: GameSetupWidget())),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Start Game'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('should navigate to different steps', (tester) async {
      final container = ProviderContainer(
        overrides: [
          boardgameProvider.overrideWith(() => FakeBoardgameNotifier()),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: Scaffold(body: GameSetupWidget())),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on Expansions step header
      await tester.tap(find.text('Expansions (work in progress)'));
      await tester.pumpAndSettle();

      // Tap on Modules step header
      await tester.tap(find.text('Modules (work in progress)'));
      await tester.pumpAndSettle();

      // Tap on Players step header
      await tester.tap(find.text('Players'));
      await tester.pumpAndSettle();

      // All steps should still be visible
      expect(find.text('Players'), findsOneWidget);
      expect(find.text('Expansions (work in progress)'), findsOneWidget);
      expect(find.text('Modules (work in progress)'), findsOneWidget);
    });
  });
}

class FakeBoardgameNotifier extends BoardgameNotifier {
  @override
  Future<List<BoardgameModel>> build() async {
    return [
      BoardgameModel(
        id: 1,
        name: 'Cacao',
        description: 'Base Game',
        filenameImage: '',
      ),
    ];
  }
}
