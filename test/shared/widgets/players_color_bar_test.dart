import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/shared/widgets/players_color_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlayersColorBar', () {
    // The coloured segments: DecoratedBoxes whose decoration has a colour
    // (excludes the outer border-only Container decoration).
    Iterable<DecoratedBox> segmentsOf(WidgetTester tester) => tester
        .widgetList<DecoratedBox>(
          find.descendant(
            of: find.byType(PlayersColorBar),
            matching: find.byType(DecoratedBox),
          ),
        )
        .where((d) => (d.decoration as BoxDecoration).color != null);

    testWidgets('renders nothing when colours are empty', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: PlayersColorBar(colors: [])),
        ),
      );

      expect(find.byType(DecoratedBox), findsNothing);
    });

    testWidgets('renders one full-height segment per colour', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 300,
                child: PlayersColorBar(colors: ['white', 'red', 'purple']),
              ),
            ),
          ),
        ),
      );

      final segments = find.descendant(
        of: find.byType(PlayersColorBar),
        matching: find.byType(Expanded),
      );
      expect(segments, findsNWidgets(3));

      // Regression guard: each segment must fill the bar height (the Row uses
      // CrossAxisAlignment.stretch). A childless DecoratedBox otherwise
      // collapses to zero height and only borders show.
      for (final element in segments.evaluate()) {
        final size = tester.getSize(find.byWidget(element.widget));
        expect(size.height, greaterThan(0));
      }
    });

    testWidgets('resolves each colour name to its palette colour', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: PlayersColorBar(colors: ['red', 'purple'])),
        ),
      );

      final colours = segmentsOf(
        tester,
      ).map((d) => (d.decoration as BoxDecoration).color).toList();

      expect(colours, [AppColors.red, AppColors.purple]);
    });
  });
}
