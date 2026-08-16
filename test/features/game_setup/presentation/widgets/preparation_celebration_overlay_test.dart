// Root-level test overrides don't need provider `dependencies` declarations.
// ignore_for_file: riverpod_lint/scoped_providers_should_specify_dependencies

import 'dart:async';

import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/preparation_celebration_overlay.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeGameSetupNotifier extends GameSetupNotifier {
  FakeGameSetupNotifier(this.initial);

  final GameSetupStateEntity initial;

  @override
  FutureOr<GameSetupStateEntity> build() => initial;
}

void main() {
  GameSetupStateEntity buildState() {
    return GameSetupStateEntity(
      players: [
        PlayerEntity(name: 'Anna', color: 'white', isSelected: true),
        PlayerEntity(name: 'Marc', color: 'red', isSelected: true),
      ],
      isStarted: true,
    );
  }

  Widget buildTestApp(GameSetupStateEntity state, {VoidCallback? onClose}) {
    return ProviderScope(
      overrides: [
        gameSetupProvider.overrideWith(() => FakeGameSetupNotifier(state)),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Stack(
            children: [
              PreparationCelebrationOverlay(onClose: onClose ?? () {}),
            ],
          ),
        ),
      ),
    );
  }

  testWidgets(
    'announces the first player from the setup order and only redraws '
    'on explicit request',
    (tester) async {
      await tester.pumpWidget(buildTestApp(buildState()));
      // Confetti keeps animating, so pump fixed frames instead of settle.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('All set!'), findsOneWidget);
      // The order dragged in Game Setup is respected: white (Anna) is
      // first in the default color order — no draw needed.
      expect(find.text('Anna starts!'), findsOneWidget);
      expect(find.text('Draw randomly instead'), findsOneWidget);

      await tester.tap(find.text('Draw randomly instead'));
      await tester.pump(const Duration(milliseconds: 50));

      // Still exactly one announcement (whoever the redraw picked).
      expect(find.textContaining('starts!'), findsOneWidget);
      expect(find.text('Draw again'), findsOneWidget);
    },
  );

  testWidgets('close button invokes onClose', (tester) async {
    var closed = false;
    await tester.pumpWidget(
      buildTestApp(buildState(), onClose: () => closed = true),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    await tester.tap(find.byIcon(Icons.close));
    await tester.pump(const Duration(milliseconds: 50));

    expect(closed, isTrue);
  });
}
