import 'package:companion_for_cacao/core/domain/services/hut_tile_supply.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/hut_layout_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/hut_layout_selector_widget.dart';
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
      child: const MaterialApp(home: Scaffold(body: HutThrowRegisterRow())),
    );
  }

  group('HutThrowRegisterRow', () {
    testWidgets('shows the unregistered state by default', (tester) async {
      await tester.pumpWidget(wrap(GameSetupStateEntity()));
      await tester.pumpAndSettle();

      expect(find.text('Register throw result (optional)'), findsOneWidget);
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

      // Choosing a side updates the counter.
      await tester.tap(find.text('Market Crier (4)').first);
      await tester.pump();
      expect(find.text('1 / ${HutTileSupply.tiles.length}'), findsOneWidget);
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
