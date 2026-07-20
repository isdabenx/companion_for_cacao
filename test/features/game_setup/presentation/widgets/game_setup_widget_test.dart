import 'package:companion_for_cacao/core/domain/entities/boardgame_entity.dart';
import 'package:companion_for_cacao/core/domain/entities/module_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/game_setup_widget.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:companion_for_cacao/shared/providers/boardgame_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/fakes.dart';

void main() {
  group('GameSetupWidget', () {
    final testBoardgames = [
      BoardgameEntity(
        id: 1,
        name: 'Cacao',
        description: 'Base Game',
        filenameImage: '',
      ),
    ];

    Future<void> pump(
      WidgetTester tester, {
      bool isStarted = false,
      GameSetupStateEntity? state,
    }) async {
      final container = ProviderContainer(
        overrides: [
          boardgameProvider.overrideWith(
            () => FakeBoardgameNotifier(testBoardgames),
          ),
          gameSetupProvider.overrideWith(
            () => FakeGameSetupNotifier(
              state ?? GameSetupStateEntity(players: [], isStarted: isStarted),
            ),
          ),
        ],
      );

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(body: GameSetupWidget()),
          ),
        ),
      );

      await tester.pumpAndSettle();
    }

    testWidgets('shows all three sections at once on a single page', (
      tester,
    ) async {
      await pump(tester);

      expect(find.byType(Stepper), findsNothing);
      expect(find.text('Players'), findsOneWidget);
      expect(find.text('Expansions'), findsOneWidget);
      expect(find.text('Modules'), findsOneWidget);
    });

    testWidgets('should display Start Game button', (tester) async {
      await pump(tester);

      expect(find.text('Start Game'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('groups modules under the expansion they come from', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(800, 1800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final chocolatl = BoardgameEntity(
        id: 2,
        name: 'Cacao: Chocolatl',
        description: '',
        filenameImage: '',
        modules: [ModuleEntity(id: 4, name: 'Huts', description: '')],
      );
      await pump(
        tester,
        state: GameSetupStateEntity(players: [], expansions: [chocolatl]),
      );

      // The expansion name (localized, English here) heads its module group,
      // and the module resolves by stable id ("Hut Module"), not by the
      // seeded name.
      expect(find.text('Cacao: Chocolatl'), findsOneWidget);
      expect(find.text('Hut Module'), findsOneWidget);
    });

    testWidgets('page is interactive when isStarted is false', (tester) async {
      await pump(tester);

      final ignorePointerWidgets = tester.widgetList<IgnorePointer>(
        find.byType(IgnorePointer),
      );
      final pageIgnorePointer = ignorePointerWidgets.firstWhere(
        (widget) => widget.child is Opacity,
      );
      expect(pageIgnorePointer.ignoring, isFalse);

      final opacityWidgets = tester.widgetList<Opacity>(find.byType(Opacity));
      final pageOpacity = opacityWidgets.firstWhere(
        (widget) => widget.child is ListView,
      );
      expect(pageOpacity.opacity, equals(1.0));
    });

    testWidgets('page is blocked when isStarted is true', (tester) async {
      await pump(tester, isStarted: true);

      final ignorePointerWidgets = tester.widgetList<IgnorePointer>(
        find.byType(IgnorePointer),
      );
      final pageIgnorePointer = ignorePointerWidgets.firstWhere(
        (widget) => widget.child is Opacity,
      );
      expect(pageIgnorePointer.ignoring, isTrue);

      final opacityWidgets = tester.widgetList<Opacity>(find.byType(Opacity));
      final pageOpacity = opacityWidgets.firstWhere(
        (widget) => widget.child is ListView,
      );
      expect(pageOpacity.opacity, equals(0.6));
    });
  });
}

class FakeGameSetupNotifier extends GameSetupNotifier {
  FakeGameSetupNotifier(this.initial);

  final GameSetupStateEntity initial;

  @override
  Future<GameSetupStateEntity> build() async => initial;
}
