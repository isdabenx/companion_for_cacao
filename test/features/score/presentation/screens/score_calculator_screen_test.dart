// Root-level test overrides don't need provider `dependencies` declarations.
// ignore_for_file: riverpod_lint/scoped_providers_should_specify_dependencies
import 'package:companion_for_cacao/config/routes/app_routes.dart';
import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/score/domain/entities/score_state_entity.dart';
import 'package:companion_for_cacao/features/score/presentation/providers/score_notifier.dart';
import 'package:companion_for_cacao/features/score/presentation/screens/score_calculator_screen.dart';
import 'package:companion_for_cacao/features/score/presentation/screens/score_result_screen.dart';
import 'package:companion_for_cacao/features/score/presentation/widgets/count_stepper_widget.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:companion_for_cacao/shared/providers/boardgame_notifier.dart';
import 'package:companion_for_cacao/shared/widgets/safe_asset_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../support/fakes.dart';

class MockGoRouter extends Mock implements GoRouter {}

class _FakeGameSetupNotifier extends GameSetupNotifier {
  _FakeGameSetupNotifier(this.initial);

  final GameSetupStateEntity initial;

  @override
  Future<GameSetupStateEntity> build() async => initial;
}

void main() {
  late MockGoRouter mockGoRouter;

  setUp(() {
    mockGoRouter = MockGoRouter();
    when(() => mockGoRouter.push(any())).thenAnswer((_) async => null);
    // The screen asks the router whether it can pop to decide between a back
    // arrow and the menu; these tests exercise the root (menu) case.
    when(() => mockGoRouter.canPop()).thenReturn(false);
  });

  /// [gameStarted] gives the calculator a running two-player game to attach
  /// to, which is what makes "start over" ambiguous.
  Widget wrap(Widget child, {bool gameStarted = false}) {
    return ProviderScope(
      overrides: [
        boardgameProvider.overrideWith(
          () => FakeBoardgameNotifier([
            BoardgameEntity(
              id: 1,
              name: 'Cacao',
              description: '',
              filenameImage: '',
            ),
          ]),
        ),
        if (gameStarted)
          gameSetupProvider.overrideWith(
            () => _FakeGameSetupNotifier(
              GameSetupStateEntity(
                players: [
                  PlayerEntity(name: 'Alice', color: 'red', isSelected: true),
                  PlayerEntity(name: 'Bob', color: 'white', isSelected: true),
                ],
                isStarted: true,
              ),
            ),
          ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: InheritedGoRouter(goRouter: mockGoRouter, child: child),
      ),
    );
  }

  group('ScoreCalculatorScreen', () {
    testWidgets('starts on the setup step and asks for players', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const ScoreCalculatorScreen()));
      await tester.pump();

      // The bar exists for the "start over" action; once it does, the title
      // rides along.
      expect(find.text('SCORE CALCULATOR'), findsOneWidget);
      expect(find.text('Players & Modules'), findsOneWidget);
      expect(find.text('1 / 6'), findsOneWidget);
      expect(find.text('Select at least 2 players'), findsOneWidget);
      expect(find.text('Hut Module'), findsOneWidget);
      expect(find.text('The Gem Mines'), findsOneWidget);
    });

    testWidgets('selecting 2 players enables Next and advances to gold step', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const ScoreCalculatorScreen()));
      await tester.pump();

      await tester.tap(find.text('White'));
      await tester.pump();

      // Activating a player focuses its name field right away.
      final nameField = tester.widget<TextField>(find.byType(TextField).first);
      expect(nameField.focusNode?.hasFocus, isTrue);

      await tester.tap(find.text('Red'));
      await tester.pump();

      expect(find.text('Select at least 2 players'), findsNothing);
      await tester.tap(find.text('Next'));
      await tester.pump();

      expect(find.text('Accumulated Gold'), findsOneWidget);
      expect(find.text('2 / 6'), findsOneWidget);
      expect(find.byType(CountStepperWidget), findsNWidgets(2));
    });

    /// Puts the calculator on a counting step, which is the first step with a
    /// reference picture and therefore the one with something to lay out.
    Future<void> pumpOnGoldStep(WidgetTester tester, Size size) async {
      tester.view
        ..physicalSize = size
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(wrap(const ScoreCalculatorScreen()));
      await tester.pump();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(ScoreCalculatorScreen)),
      );
      container.read(scoreProvider.notifier)
        ..addPlayer('Alice', 'red')
        ..addPlayer('Bob', 'white')
        ..nextStep();
      await tester.pumpAndSettle();

      expect(find.text('Accumulated Gold'), findsOneWidget);
    }

    // What to count on one side, what you type on the other. Stacked, the
    // picture pushed the second player below the fold on a phone in
    // landscape, which is the whole reason this layout exists.
    testWidgets('a wide step puts the picture beside the inputs', (
      tester,
    ) async {
      await pumpOnGoldStep(tester, const Size(923, 411));

      final image = tester.getRect(find.byType(SafeAssetImage));
      final firstStepper = tester.getRect(
        find.byType(CountStepperWidget).first,
      );
      final lastStepper = tester.getRect(find.byType(CountStepperWidget).last);

      // Beside, not above.
      expect(image.right, lessThanOrEqualTo(firstStepper.left));
      // And with both players actually on screen, not clipped away.
      expect(lastStepper.bottom, lessThanOrEqualTo(411));
    });

    testWidgets('a narrow step stacks the picture above the inputs', (
      tester,
    ) async {
      await pumpOnGoldStep(tester, const Size(411, 923));

      final image = tester.getRect(find.byType(SafeAssetImage));
      final firstStepper = tester.getRect(
        find.byType(CountStepperWidget).first,
      );

      expect(image.bottom, lessThanOrEqualTo(firstStepper.top));
    });

    testWidgets('temples step is replaced by gem mines when active', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const ScoreCalculatorScreen()));
      await tester.pump();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(ScoreCalculatorScreen)),
      );
      final notifier = container.read(scoreProvider.notifier)
        ..addPlayer('Alice', 'red')
        ..addPlayer('Bob', 'white')
        ..setGemMinesActive(true);
      await tester.pump();

      final steps = container.read(scoreProvider).steps;
      expect(steps, isNot(contains(ScoreStep.temples)));
      expect(steps, contains(ScoreStep.gemMines));

      // Walk to the last step and check the gems UI is shown.
      while (!container.read(scoreProvider).isLastStep) {
        notifier.nextStep();
      }
      await tester.pump();
      expect(find.text('Gem Mines'), findsOneWidget);
      expect(find.text('Results'), findsOneWidget);
    });

    testWidgets('steps show a reference image of the component to count', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const ScoreCalculatorScreen()));
      await tester.pump();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(ScoreCalculatorScreen)),
      );
      container.read(scoreProvider.notifier)
        ..addPlayer('Alice', 'red')
        ..addPlayer('Bob', 'white');

      // The setup step has no reference image.
      expect(find.byType(SafeAssetImage), findsNothing);
      container.read(scoreProvider.notifier).nextStep(); // gold
      await tester.pump();
      // Gold shows the coin pile.
      expect(find.byType(SafeAssetImage), findsOneWidget);
      container.read(scoreProvider.notifier).nextStep(); // water track
      await tester.pump();
      // Water track shows the village board.
      expect(find.byType(SafeAssetImage), findsOneWidget);
    });

    testWidgets('Results button pushes the result route', (tester) async {
      await tester.pumpWidget(wrap(const ScoreCalculatorScreen()));
      await tester.pump();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(ScoreCalculatorScreen)),
      );
      final notifier = container.read(scoreProvider.notifier)
        ..addPlayer('Alice', 'red')
        ..addPlayer('Bob', 'white');
      while (!container.read(scoreProvider).isLastStep) {
        notifier.nextStep();
      }
      await tester.pump();

      await tester.tap(find.text('Results'));
      await tester.pump();

      verify(() => mockGoRouter.push(AppRoutes.scoreResult)).called(1);
    });

    // Start over means different things depending on how you got here: from
    // the board this screen IS the game's scoreboard, so emptying it would
    // throw away the game the player navigated in from.
    group('start over', () {
      testWidgets('from the game board offers only rescoring the game', (
        tester,
      ) async {
        when(() => mockGoRouter.canPop()).thenReturn(true);
        await tester.pumpWidget(
          wrap(const ScoreCalculatorScreen(), gameStarted: true),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.refresh));
        await tester.pumpAndSettle();

        expect(find.text('Start over?'), findsOneWidget);
        expect(find.text('Reset the game scoring'), findsOneWidget);
        expect(
          find.text('Clear everything (separate calculation)'),
          findsNothing,
        );
      });

      testWidgets('confirming from the board keeps the game attached', (
        tester,
      ) async {
        when(() => mockGoRouter.canPop()).thenReturn(true);
        await tester.pumpWidget(
          wrap(const ScoreCalculatorScreen(), gameStarted: true),
        );
        await tester.pumpAndSettle();

        final container = ProviderScope.containerOf(
          tester.element(find.byType(ScoreCalculatorScreen)),
        );
        container.read(scoreProvider.notifier).setAccumulatedGold('red', 30);
        await tester.pump();

        await tester.tap(find.byIcon(Icons.refresh));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Reset the game scoring'));
        await tester.pumpAndSettle();

        final state = container.read(scoreProvider);
        expect(state.prefilledFromGame, isTrue, reason: 'still on the game');
        expect(state.players, hasLength(2));
        expect(
          state.inputOf('red').accumulatedGold,
          0,
          reason: 'entered scores cleared',
        );
      });

      testWidgets('from Home with a game running still offers both', (
        tester,
      ) async {
        when(() => mockGoRouter.canPop()).thenReturn(false);
        await tester.pumpWidget(
          wrap(const ScoreCalculatorScreen(), gameStarted: true),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.refresh));
        await tester.pumpAndSettle();

        expect(find.text('Reset the game scoring'), findsOneWidget);
        expect(
          find.text('Clear everything (separate calculation)'),
          findsOneWidget,
        );
      });

      testWidgets('with no game running it just empties the calculator', (
        tester,
      ) async {
        await tester.pumpWidget(wrap(const ScoreCalculatorScreen()));
        await tester.pumpAndSettle();

        await tester.tap(find.byIcon(Icons.refresh));
        await tester.pumpAndSettle();

        // The body must not promise reloading from a game that isn't there.
        expect(
          find.text(
            'This discards all entered scores and leaves the calculator empty.',
          ),
          findsOneWidget,
        );
        expect(
          find.text('Clear everything (separate calculation)'),
          findsNothing,
        );
      });
    });
  });

  group('ScoreResultScreen', () {
    testWidgets('shows the winner and the breakdown', (tester) async {
      await tester.pumpWidget(wrap(const ScoreResultScreen()));
      await tester.pump();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(ScoreResultScreen)),
      );
      container.read(scoreProvider.notifier)
        ..addPlayer('Alice', 'red')
        ..addPlayer('Bob', 'white')
        ..setAccumulatedGold('red', 30)
        ..setAccumulatedGold('white', 20)
        // Both on water field 0 (value -10).
        ..setSunTokens('red', 2);
      // pumpAndSettle so the result cards' entrance animation completes.
      await tester.pumpAndSettle();

      // Winner banner + standings card.
      expect(find.text('Alice'), findsNWidgets(2));
      expect(find.text('wins the game!'), findsOneWidget);
      expect(find.text('#1'), findsOneWidget);
      expect(find.text('#2'), findsOneWidget);
      // Alice: 30 - 10 + 0 (temples) + 2 = 22; Bob: 20 - 10 = 10.
      expect(find.text('22'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
      expect(find.text('Water Track'), findsNWidgets(2));
    });

    testWidgets('announces a shared win when gold and cacao tie', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(const ScoreResultScreen()));
      await tester.pump();

      final container = ProviderScope.containerOf(
        tester.element(find.byType(ScoreResultScreen)),
      );
      container.read(scoreProvider.notifier)
        ..addPlayer('Alice', 'red')
        ..addPlayer('Bob', 'white')
        ..setAccumulatedGold('red', 15)
        ..setAccumulatedGold('white', 15);
      await tester.pumpAndSettle();

      expect(find.text('win the game!'), findsOneWidget);
      expect(
        find.text('Shared victory! Tied on gold and leftover cacao.'),
        findsOneWidget,
      );
    });
  });
}
