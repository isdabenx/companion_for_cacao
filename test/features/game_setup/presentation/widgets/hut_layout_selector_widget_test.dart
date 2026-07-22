// Root-level test overrides don't need provider `dependencies` declarations.
// ignore_for_file: riverpod_lint/scoped_providers_should_specify_dependencies
import 'package:companion_for_cacao/core/domain/services/hut_tile_supply.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/hut_layout_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/hut_layout_selector_widget.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeGameSetupNotifier extends GameSetupNotifier {
  _FakeGameSetupNotifier(this.initial);

  final GameSetupStateEntity initial;

  @override
  Future<GameSetupStateEntity> build() async => initial;
}

void main() {
  Widget wrap(GameSetupStateEntity setup) {
    return ProviderScope(
      overrides: [
        gameSetupProvider.overrideWith(() => _FakeGameSetupNotifier(setup)),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: HutThrowRegisterRow()),
      ),
    );
  }

  group('HutThrowRegisterRow', () {
    testWidgets('shows the unregistered state by default', (tester) async {
      await tester.pumpWidget(wrap(GameSetupStateEntity()));
      await tester.pumpAndSettle();

      expect(find.text('Register which huts landed face up'), findsOneWidget);
      expect(find.byIcon(Icons.app_registration), findsOneWidget);
    });

    testWidgets('shows the registered state when a layout exists', (
      tester,
    ) async {
      final layout = HutLayoutEntity(
        faceUp: [for (final (sideA, _) in HutTileSupply.tiles) sideA],
      );
      await tester.pumpWidget(wrap(GameSetupStateEntity(hutLayout: layout)));
      await tester.pumpAndSettle();

      expect(find.textContaining('Throw registered'), findsOneWidget);
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
    });

    testWidgets('opens the editor sheet with Apply disabled until complete', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(GameSetupStateEntity()));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(HutThrowRegisterRow));
      await tester.pumpAndSettle();

      expect(find.text('Register the hut throw'), findsOneWidget);
      expect(find.text('0 / ${HutTileSupply.tiles.length}'), findsOneWidget);
      final apply = tester.widget<FilledButton>(
        find.widgetWithText(FilledButton, 'Apply'),
      );
      expect(apply.onPressed, isNull);

      // Marking a face-up function bumps the counter.
      await tester.tap(find.text('Market Crier').first);
      await tester.pumpAndSettle();
      expect(find.text('1 / ${HutTileSupply.tiles.length}'), findsOneWidget);
    });

    testWidgets('filling a function makes its impossible pair disappear', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(GameSetupStateEntity()));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(HutThrowRegisterRow));
      await tester.pumpAndSettle();

      // Market Crier and Hermit share the same two tiles, so both start with
      // two open cells each.
      expect(find.text('Market Crier'), findsNWidgets(2));
      expect(find.text('Hermit'), findsNWidgets(2));

      // Recording ONE Market Crier consumes one shared tile, so one Hermit
      // slot disappears immediately (tile-mates are linked).
      await tester.tap(find.text('Market Crier').first);
      await tester.pumpAndSettle();
      expect(find.text('Hermit'), findsOneWidget);

      // Recording the second Market Crier uses the last shared tile: Hermit
      // can no longer land at all.
      await tester.tap(find.text('Market Crier').last);
      await tester.pumpAndSettle();
      expect(find.text('2 / ${HutTileSupply.tiles.length}'), findsOneWidget);
      expect(find.text('Hermit'), findsNothing);

      // Undoing one Market Crier frees a tile, so Hermit reappears.
      await tester.tap(find.text('Market Crier').last);
      await tester.pumpAndSettle();
      expect(find.text('Hermit'), findsWidgets);
    });

    testWidgets('tapping the second copy marks that copy, not the first', (
      tester,
    ) async {
      await tester.pumpWidget(wrap(GameSetupStateEntity()));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(HutThrowRegisterRow));
      await tester.pumpAndSettle();

      final copy0 = find.byKey(const ValueKey('hut_cell_marketCrier_0'));
      final copy1 = find.byKey(const ValueKey('hut_cell_marketCrier_1'));
      Finder checkIn(Finder cell) =>
          find.descendant(of: cell, matching: find.byIcon(Icons.check));

      // Tapping the second copy marks the second copy — not the first.
      await tester.tap(copy1);
      await tester.pumpAndSettle();
      expect(checkIn(copy1), findsOneWidget);
      expect(checkIn(copy0), findsNothing);
    });

    testWidgets('editor of a registered layout can forget the throw', (
      tester,
    ) async {
      final layout = HutLayoutEntity(
        faceUp: [for (final (sideA, _) in HutTileSupply.tiles) sideA],
      );
      await tester.pumpWidget(wrap(GameSetupStateEntity(hutLayout: layout)));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(HutThrowRegisterRow));
      await tester.pumpAndSettle();

      // Complete layout: counter full and Apply enabled.
      expect(
        find.text(
          '${HutTileSupply.tiles.length} / ${HutTileSupply.tiles.length}',
        ),
        findsOneWidget,
      );
      expect(find.text('Forget throw'), findsOneWidget);
    });
  });
}
