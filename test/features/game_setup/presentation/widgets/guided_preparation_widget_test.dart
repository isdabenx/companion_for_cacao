// Root-level test overrides don't need provider `dependencies` declarations.
// ignore_for_file: riverpod_lint/scoped_providers_should_specify_dependencies

import 'dart:async';

import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/guided_preparation_widget.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../support/preparation_fixtures.dart';

class FakeGameSetupNotifier extends GameSetupNotifier {
  FakeGameSetupNotifier(this.initial);

  final GameSetupStateEntity initial;

  @override
  FutureOr<GameSetupStateEntity> build() => initial;
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  List<PreparationEntity> threeSteps({bool firstCompleted = true}) => [
    makePrepStep(id: 'one', label: 'Step one', isCompleted: firstCompleted),
    makePrepStep(id: 'two', label: 'Step two'),
    makePrepStep(id: 'three', label: 'Step three'),
  ];

  Future<ProviderContainer> pump(
    WidgetTester tester,
    List<PreparationEntity> preparation,
  ) async {
    final container = ProviderContainer.test(
      overrides: [
        gameSetupProvider.overrideWith(
          () => FakeGameSetupNotifier(
            GameSetupStateEntity(
              players: [
                PlayerEntity(name: 'Anna', color: 'red', isSelected: true),
              ],
              preparation: preparation,
            ),
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: GuidedPreparationWidget(preparation: preparation),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  group('GuidedPreparationWidget', () {
    testWidgets('opens on the first incomplete unit', (tester) async {
      await pump(tester, threeSteps());

      // Step one is already done: the pager starts on step two.
      expect(find.text('2 / 3'), findsOneWidget);
      expect(find.text('Step two'), findsOneWidget);
    });

    testWidgets('next and back navigate between pages', (tester) async {
      await pump(tester, threeSteps());

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('3 / 3'), findsOneWidget);

      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();
      expect(find.text('2 / 3'), findsOneWidget);
    });

    // The page counter counts pages, not completion, so "3 / 3" with a
    // disabled Next used to be the whole end-of-flow signal whether you had
    // ticked everything or skipped past it.
    testWidgets('the last page offers a way back to what was skipped', (
      tester,
    ) async {
      await pump(tester, threeSteps());

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('3 / 3'), findsOneWidget);

      // Steps two and three are still open, so Next gives way to the count.
      expect(find.widgetWithText(FilledButton, 'Next'), findsNothing);
      expect(find.text('2 steps left — go to the first'), findsOneWidget);

      // It has to take the width left over, not whatever a Spacer leaves it.
      // Squeezed to its minimum the label wraps to one word per line, which
      // throws nothing and so needs measuring rather than catching.
      final pending = tester.getSize(
        find.widgetWithText(FilledButton, '2 steps left — go to the first'),
      );
      expect(pending.width, greaterThan(300));

      await tester.tap(find.text('2 steps left — go to the first'));
      await tester.pumpAndSettle();
      expect(find.text('2 / 3'), findsOneWidget);
      expect(find.text('Step two'), findsOneWidget);
    });

    testWidgets('with nothing skipped the last page just disables Next', (
      tester,
    ) async {
      final container = await pump(tester, threeSteps());
      final notifier = container.read(gameSetupProvider.notifier);

      // Only step three left open: reaching it means nothing was skipped.
      notifier.togglePreparationCompletion('two');
      await tester.pump();
      // Auto-advance waits a beat, then animates to the next page.
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(find.text('3 / 3'), findsOneWidget);

      final next = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Next'),
      );
      expect(next.onPressed, isNull);
      expect(find.textContaining('go to the first'), findsNothing);
    });

    testWidgets('completing the current unit auto-advances', (tester) async {
      final container = await pump(tester, threeSteps());

      expect(find.text('2 / 3'), findsOneWidget);

      container
          .read(gameSetupProvider.notifier)
          .togglePreparationCompletion('two');
      await tester.pump();
      // Auto-advance waits a beat, then animates to the next page.
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();

      expect(find.text('3 / 3'), findsOneWidget);
    });

    testWidgets('completing everything shows the celebration', (tester) async {
      final container = await pump(tester, threeSteps());

      container
          .read(gameSetupProvider.notifier)
          .togglePreparationCompletion('two');
      await tester.pump(const Duration(milliseconds: 500));
      container
          .read(gameSetupProvider.notifier)
          .togglePreparationCompletion('three');
      // The confetti animation loops, so settle with fixed pumps.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));

      // The celebration overlay announces the first player.
      expect(find.textContaining('Anna'), findsWidgets);
    });
  });
}
