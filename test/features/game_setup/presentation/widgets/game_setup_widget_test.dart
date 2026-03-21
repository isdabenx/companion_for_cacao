import 'package:companion_for_cacao/core/data/models/boardgame_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
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
          gameSetupProvider.overrideWith(
            () => FakeGameSetupNotifier(isStarted: false),
          ),
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
          gameSetupProvider.overrideWith(
            () => FakeGameSetupNotifier(isStarted: false),
          ),
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
          gameSetupProvider.overrideWith(
            () => FakeGameSetupNotifier(isStarted: false),
          ),
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

    testWidgets('Stepper should be interactive when isStarted is false', (
      tester,
    ) async {
      final container = ProviderContainer(
        overrides: [
          boardgameProvider.overrideWith(() => FakeBoardgameNotifier()),
          gameSetupProvider.overrideWith(
            () => FakeGameSetupNotifier(isStarted: false),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: Scaffold(body: GameSetupWidget())),
        ),
      );

      await tester.pumpAndSettle();

      // Find the Column that contains the IgnorePointer and Stepper
      final columnFinder = find.descendant(
        of: find.byType(GameSetupWidget),
        matching: find.byType(Column),
      );

      expect(columnFinder, findsWidgets);

      // Find the IgnorePointer that's a direct child of the Column's Expanded
      final ignorePointerWidgets = tester.widgetList<IgnorePointer>(
        find.byType(IgnorePointer),
      );

      // The IgnorePointer wrapping the Stepper should have ignoring: false
      final stepperIgnorePointer = ignorePointerWidgets.firstWhere(
        (widget) => widget.child is Opacity,
      );

      expect(stepperIgnorePointer.ignoring, isFalse);

      // Find the Opacity widget
      final opacityWidgets = tester.widgetList<Opacity>(find.byType(Opacity));

      final stepperOpacity = opacityWidgets.firstWhere(
        (widget) => widget.child is Stepper,
      );

      expect(stepperOpacity.opacity, equals(1.0));
    });

    testWidgets('Stepper should be blocked when isStarted is true', (
      tester,
    ) async {
      final container = ProviderContainer(
        overrides: [
          boardgameProvider.overrideWith(() => FakeBoardgameNotifier()),
          gameSetupProvider.overrideWith(
            () => FakeGameSetupNotifier(isStarted: true),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(home: Scaffold(body: GameSetupWidget())),
        ),
      );

      await tester.pumpAndSettle();

      // Find the IgnorePointer widgets
      final ignorePointerWidgets = tester.widgetList<IgnorePointer>(
        find.byType(IgnorePointer),
      );

      // The IgnorePointer wrapping the Stepper should have ignoring: true
      final stepperIgnorePointer = ignorePointerWidgets.firstWhere(
        (widget) => widget.child is Opacity,
      );

      expect(stepperIgnorePointer.ignoring, isTrue);

      // Find the Opacity widgets
      final opacityWidgets = tester.widgetList<Opacity>(find.byType(Opacity));

      final stepperOpacity = opacityWidgets.firstWhere(
        (widget) => widget.child is Stepper,
      );

      expect(stepperOpacity.opacity, equals(0.6));
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

class FakeGameSetupNotifier extends GameSetupNotifier {
  FakeGameSetupNotifier({required this.isStarted});

  final bool isStarted;

  @override
  Future<GameSetupStateEntity> build() async {
    return GameSetupStateEntity(players: [], isStarted: isStarted);
  }
}
