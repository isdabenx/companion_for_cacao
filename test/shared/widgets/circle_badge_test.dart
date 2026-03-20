import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/shared/widgets/circle_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CircleBadge Widget Tests', () {
    testWidgets('renders correctly with text', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CircleBadge(color: Colors.red, text: '1'),
          ),
        ),
      );

      expect(find.byType(CircleBadge), findsOneWidget);
      expect(find.text('1'), findsOneWidget);

      final containerFinder = find
          .descendant(
            of: find.byType(CircleBadge),
            matching: find.byType(Container),
          )
          .first;

      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.color, Colors.red);
      expect(decoration.shape, BoxShape.circle);
    });

    testWidgets('renders correctly with icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CircleBadge(color: Colors.blue, icon: Icons.star),
          ),
        ),
      );

      expect(find.byType(CircleBadge), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('applies custom size and border', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CircleBadge(
              color: Colors.green,
              size: 50,
              borderColor: Colors.black,
              borderWidth: 4.0,
            ),
          ),
        ),
      );

      final containerFinder = find
          .descendant(
            of: find.byType(CircleBadge),
            matching: find.byType(Container),
          )
          .first;

      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;

      expect(container.constraints?.maxWidth, 50);
      expect(container.constraints?.maxHeight, 50);

      final border = decoration.border as Border;
      expect(border.top.color, Colors.black);
      expect(border.top.width, 4.0);
    });
  });
}
