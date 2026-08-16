// Root-level test overrides don't need provider `dependencies` declarations.
// ignore_for_file: riverpod_lint/scoped_providers_should_specify_dependencies

import 'dart:async';

import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_actor.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/preparation_phase.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/table_zone.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/preparation_group_card.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/preparation_step_row.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/preparation_fixtures.dart';

class FakeGameSetupNotifier extends GameSetupNotifier {
  FakeGameSetupNotifier(this.initial);

  final GameSetupStateEntity initial;

  @override
  FutureOr<GameSetupStateEntity> build() => initial;
}

void main() {
  const groupId = 'group_player_red';

  List<PreparationEntity> playerSteps() => [
    makePrepStep(
      id: 'setup_village_board_red',
      label: 'Take your village board',
      detail: 'Take the village board of color red.',
      phase: PreparationPhase.playerSetup,
      actor: PreparationActor.player,
      tableZone: TableZone.playerArea,
      groupId: groupId,
      color: 'red',
    ),
    makePrepStep(
      id: 'setup_water_carrier_red',
      label: 'Put your water carrier on the "-10" field',
      detail: 'Place it on the water field with the value "-10".',
      rationale: 'The track starts below zero on purpose.',
      phase: PreparationPhase.playerSetup,
      actor: PreparationActor.player,
      tableZone: TableZone.playerArea,
      groupId: groupId,
      color: 'red',
    ),
  ];

  List<PreparationEntity> removalSteps() => [
    makePrepStep(
      id: 'removal_plantation',
      label: 'Return 2x Single Plantation to the box',
      detail: 'Sort out 2x Single Plantation.',
      tableZone: TableZone.box,
      groupId: 'group_return_to_box',
      quantity: 2,
      imageKey: 'jungle_single_plantation',
    ),
    makePrepStep(
      id: 'removal_temple',
      label: 'Return all Temple tiles to the box',
      detail: 'Sort out all Temple tiles.',
      tableZone: TableZone.box,
      groupId: 'group_return_to_box',
      imageKey: 'jungle_temple',
    ),
  ];

  GameSetupStateEntity buildState(List<PreparationEntity> preparation) {
    return GameSetupStateEntity(
      players: [PlayerEntity(name: 'Anna', color: 'red', isSelected: true)],
      preparation: preparation,
      isStarted: true,
    );
  }

  Widget buildTestApp(GameSetupStateEntity state, Widget child) {
    return ProviderScope(
      overrides: [
        gameSetupProvider.overrideWith(() => FakeGameSetupNotifier(state)),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: SingleChildScrollView(child: child)),
      ),
    );
  }

  group('PreparationStepRow', () {
    testWidgets('shows the label and expands to detail and rationale', (
      tester,
    ) async {
      final step = playerSteps()[1];
      await tester.pumpWidget(
        buildTestApp(buildState([step]), PreparationStepRow(step: step)),
      );
      await tester.pumpAndSettle();

      expect(find.text(step.label), findsOneWidget);
      AnimatedCrossFade crossFade() =>
          tester.widget<AnimatedCrossFade>(find.byType(AnimatedCrossFade));
      expect(crossFade().crossFadeState, CrossFadeState.showFirst);

      await tester.tap(find.text(step.label));
      await tester.pumpAndSettle();

      expect(crossFade().crossFadeState, CrossFadeState.showSecond);
      expect(find.text(step.detail), findsOneWidget);
      expect(find.text(step.rationale!), findsOneWidget);
    });

    testWidgets('check toggles the step completion', (tester) async {
      final step = playerSteps()[0];
      await tester.pumpWidget(
        buildTestApp(buildState([step]), PreparationStepRow(step: step)),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.circle_outlined), findsOneWidget);
      await tester.tap(find.byIcon(Icons.circle_outlined));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.byIcon(Icons.circle_outlined), findsNothing);
    });
  });

  group('PreparationGroupCard', () {
    testWidgets('renders the player title and one row per step', (
      tester,
    ) async {
      final steps = playerSteps();
      await tester.pumpWidget(
        buildTestApp(
          buildState(steps),
          PreparationGroupCard(
            groupId: groupId,
            title: 'Anna',
            colorName: 'red',
            steps: steps,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Anna'), findsOneWidget);
      expect(find.byType(PreparationStepRow), findsNWidgets(2));
      expect(find.text('0/2'), findsOneWidget);
    });

    testWidgets('master check completes every member of the group', (
      tester,
    ) async {
      final steps = playerSteps();
      await tester.pumpWidget(
        buildTestApp(
          buildState(steps),
          PreparationGroupCard(
            groupId: groupId,
            title: 'Anna',
            colorName: 'red',
            steps: steps,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // The header check is built before the row checks.
      await tester.tap(find.byIcon(Icons.circle_outlined).first);
      await tester.pumpAndSettle();

      // Master + 2 rows now completed.
      expect(find.byIcon(Icons.check_circle), findsNWidgets(3));
      expect(find.text('2/2'), findsOneWidget);
    });

    testWidgets('an individual check completes only its step', (tester) async {
      final steps = playerSteps();
      await tester.pumpWidget(
        buildTestApp(
          buildState(steps),
          PreparationGroupCard(
            groupId: groupId,
            title: 'Anna',
            colorName: 'red',
            steps: steps,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Last circle = second row's check.
      await tester.tap(find.byIcon(Icons.circle_outlined).last);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      expect(find.text('1/2'), findsOneWidget);
    });
  });

  group('ReturnToBoxCard', () {
    testWidgets('renders a cell per removal with its quantity badge', (
      tester,
    ) async {
      final steps = removalSteps();
      await tester.pumpWidget(
        buildTestApp(
          buildState(steps),
          ReturnToBoxCard(
            groupId: 'group_return_to_box',
            title: 'Return to the box',
            subtitle: 'These tiles are not used in this game',
            steps: steps,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Return to the box'), findsOneWidget);
      expect(find.text('×2'), findsOneWidget);
      // A removal without a fixed quantity shows the ALL badge.
      expect(find.text('ALL'), findsOneWidget);
      expect(find.text('0/2'), findsOneWidget);
    });

    testWidgets('tapping a cell completes that removal only', (tester) async {
      final steps = removalSteps();
      await tester.pumpWidget(
        buildTestApp(
          buildState(steps),
          ReturnToBoxCard(
            groupId: 'group_return_to_box',
            title: 'Return to the box',
            subtitle: 'These tiles are not used in this game',
            steps: steps,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(
        find.byTooltip('Return 2x Single Plantation to the box'),
      );
      await tester.pumpAndSettle();

      expect(find.text('1/2'), findsOneWidget);

      // Master check completes the rest.
      await tester.tap(find.byIcon(Icons.circle_outlined).first);
      await tester.pumpAndSettle();
      expect(find.text('2/2'), findsOneWidget);
    });
  });
}
