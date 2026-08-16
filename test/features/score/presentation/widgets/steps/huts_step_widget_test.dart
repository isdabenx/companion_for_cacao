// Root-level test overrides don't need provider `dependencies` declarations.
// ignore_for_file: riverpod_lint/scoped_providers_should_specify_dependencies
import 'package:companion_for_cacao/core/domain/entities/hut_type.dart';
import 'package:companion_for_cacao/core/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/score/domain/entities/score_state_entity.dart';
import 'package:companion_for_cacao/features/score/presentation/providers/score_notifier.dart';
import 'package:companion_for_cacao/features/score/presentation/widgets/steps/huts_step_widget.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeScoreNotifier extends ScoreNotifier {
  _FakeScoreNotifier(this.initial);

  final ScoreStateEntity initial;

  @override
  ScoreStateEntity build() => initial;
}

void main() {
  Widget wrap(ScoreStateEntity state) {
    return ProviderScope(
      overrides: [scoreProvider.overrideWith(() => _FakeScoreNotifier(state))],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: SingleChildScrollView(child: HutsStepWidget()),
        ),
      ),
    );
  }

  testWidgets('hides huts that are not in the registered throw', (
    tester,
  ) async {
    // Registered throw: only Market Crier landed face up.
    final state = ScoreStateEntity(
      players: [PlayerEntity(name: 'A', color: 'red', isSelected: true)],
      hutModuleActive: true,
      availableHutCounts: const {HutType.marketCrier: 1},
    );

    await tester.pumpWidget(wrap(state));
    await tester.pumpAndSettle();

    // Expand the player's panel.
    await tester.tap(find.text('A'));
    await tester.pumpAndSettle();

    // The in-game hut is offered; the ones that never landed are gone
    // entirely (not shown greyed out).
    expect(find.text('Market Crier (4)'), findsOneWidget);
    expect(find.textContaining('Hermit'), findsNothing);
    expect(find.textContaining('Chief'), findsNothing);
  });

  testWidgets('shows every hut when no throw was registered', (tester) async {
    // No availableHutCounts → supply unknown, so all functions are possible.
    final state = ScoreStateEntity(
      players: [PlayerEntity(name: 'A', color: 'red', isSelected: true)],
      hutModuleActive: true,
    );

    await tester.pumpWidget(wrap(state));
    await tester.pumpAndSettle();

    await tester.tap(find.text('A'));
    await tester.pumpAndSettle();

    expect(find.text('Market Crier (4)'), findsOneWidget);
    expect(find.textContaining('Hermit'), findsWidgets);
  });
}
