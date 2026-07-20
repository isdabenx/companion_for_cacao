import 'package:companion_for_cacao/config/routes/app_routes.dart';
import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/features/score/presentation/providers/score_notifier.dart';
import 'package:companion_for_cacao/features/score/presentation/screens/score_calculator_screen.dart';
import 'package:companion_for_cacao/features/score/presentation/screens/score_result_screen.dart';
import 'package:companion_for_cacao/features/score/presentation/widgets/count_stepper_widget.dart';
import 'package:companion_for_cacao/shared/providers/boardgame_notifier.dart';
import 'package:companion_for_cacao/shared/widgets/safe_asset_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../support/fakes.dart';

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late MockGoRouter mockGoRouter;

  setUp(() {
    mockGoRouter = MockGoRouter();
    when(() => mockGoRouter.push(any())).thenAnswer((_) async => null);
  });

  Widget wrap(Widget child) {
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
      ],
      child: MaterialApp(
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

      expect(find.text('Score Calculator'), findsOneWidget);
      // The drawer menu uses the short label so it fits on one line.
      expect(find.text('Scores'), findsOneWidget);
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

      final steps = container.read(scoreProvider).steps.map((s) => s.label);
      expect(steps, isNot(contains('Temples')));
      expect(steps, contains('Gem Mines'));

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
      await tester.pump();

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
      await tester.pump();

      expect(find.text('win the game!'), findsOneWidget);
      expect(
        find.text('Shared victory! Tied on gold and leftover cacao.'),
        findsOneWidget,
      );
    });
  });
}
