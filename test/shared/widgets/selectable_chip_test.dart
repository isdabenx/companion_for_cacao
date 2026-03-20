import 'package:companion_for_cacao/shared/widgets/selectable_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SelectableChip Widget Tests', () {
    testWidgets('renders correctly when unselected', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SelectableChip(isSelected: false, child: Text('Chip Text')),
          ),
        ),
      );

      expect(find.byType(SelectableChip), findsOneWidget);
      expect(find.text('Chip Text'), findsOneWidget);

      final containerFinder = find
          .descendant(
            of: find.byType(SelectableChip),
            matching: find.byType(Container),
          )
          .first;

      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;

      // Should not have shadow when unselected
      expect(decoration.boxShadow, isEmpty);
    });

    testWidgets('renders correctly when selected', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: SelectableChip(
              isSelected: true,
              child: Text('Selected Chip'),
            ),
          ),
        ),
      );

      expect(find.text('Selected Chip'), findsOneWidget);

      final containerFinder = find
          .descendant(
            of: find.byType(SelectableChip),
            matching: find.byType(Container),
          )
          .first;

      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;

      // Should have shadow when selected
      expect(decoration.boxShadow, isNotEmpty);
    });

    testWidgets('fires onTap callback', (WidgetTester tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SelectableChip(
              onTap: () {
                tapped = true;
              },
              child: const Text('Tap Me'),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(SelectableChip));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });
}
