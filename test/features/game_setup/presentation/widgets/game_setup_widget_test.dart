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
      List<BoardgameEntity>? boardgames,
    }) async {
      final container = ProviderContainer(
        overrides: [
          boardgameProvider.overrideWith(
            () => FakeBoardgameNotifier(boardgames ?? testBoardgames),
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

    testWidgets('shows the players and expansions+modules sections', (
      tester,
    ) async {
      // Phone-shaped logical viewport (dpr 1) so the player cells get a
      // realistic width and the lazy ListView builds every section — the
      // 2×2 player grid is taller than a single row.
      tester.view.physicalSize = const Size(400, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });
      await pump(tester);

      expect(find.byType(Stepper), findsNothing);
      expect(find.text('Players'), findsOneWidget);
      // Expansions and modules are now one combined section.
      expect(find.text('Expansions and modules'), findsOneWidget);
    });

    testWidgets('should display Start Game button', (tester) async {
      await pump(tester);

      expect(find.text('Start Game'), findsOneWidget);
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('a selected expansion opens to reveal its modules', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(430, 1800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      final chocolatl = BoardgameEntity(
        id: 2,
        name: 'Cacao: Chocolatl',
        description: '',
        filenameImage: '',
        modules: [ModuleEntity(id: 4, name: 'Huts', description: '')],
      );
      // The expansion is both in the catalog (so its card renders) and in the
      // setup state (so the card is selected → expanded, showing its modules).
      await pump(
        tester,
        boardgames: [...testBoardgames, chocolatl],
        state: GameSetupStateEntity(players: [], expansions: [chocolatl]),
      );

      // The card header shows the localized expansion name, and its opened
      // body reveals the module (resolved by stable id: "Hut Module").
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
