import 'package:companion_for_cacao/shared/widgets/responsive_grid_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResponsiveGridBuilder Widget Tests', () {
    testWidgets('renders correct number of items', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveGridBuilder(
              itemCount: 5,
              minItemWidth: 100,
              itemBuilder: (context, index) {
                return Text('Item $index');
              },
            ),
          ),
        ),
      );

      expect(find.byType(ResponsiveGridBuilder), findsOneWidget);
      for (int i = 0; i < 5; i++) {
        expect(find.text('Item $i'), findsOneWidget);
      }
    });

    testWidgets('calculates columns based on width constraints', (
      WidgetTester tester,
    ) async {
      // Set a specific screen size
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveGridBuilder(
              itemCount: 4,
              minItemWidth: 150, // 400 / 150 = 2.66 -> 2 columns
              itemBuilder: (context, index) {
                return Container(
                  height: 50,
                  color: Colors.blue,
                  child: Text('Item $index'),
                );
              },
            ),
          ),
        ),
      );

      final tableFinder = find.byType(Table);
      expect(tableFinder, findsOneWidget);

      final table = tester.widget<Table>(tableFinder);
      // 4 items with 2 columns should result in 2 rows
      expect(table.children.length, 2);
      // Each row should have 2 columns
      expect(table.children.first.children.length, 2);
    });

    testWidgets('respects min and max columns', (WidgetTester tester) async {
      // Set a large screen size
      tester.view.physicalSize = const Size(1000, 800);
      tester.view.devicePixelRatio = 1.0;

      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveGridBuilder(
              itemCount: 6,
              minItemWidth: 100, // 1000 / 100 = 10 columns
              maxColumns: 4, // Should be clamped to 4
              itemBuilder: (context, index) {
                return Text('Item $index');
              },
            ),
          ),
        ),
      );

      final tableFinder = find.byType(Table);
      final table = tester.widget<Table>(tableFinder);

      // 6 items with max 4 columns should result in 2 rows
      expect(table.children.length, 2);
      // The first row should have 4 columns
      expect(table.children.first.children.length, 4);
    });

    testWidgets('returns empty widget when itemCount is 0', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ResponsiveGridBuilder(
              itemCount: 0,
              minItemWidth: 100,
              itemBuilder: (context, index) {
                return Text('Item $index');
              },
            ),
          ),
        ),
      );

      expect(find.byType(Table), findsNothing);
      expect(find.byType(SizedBox), findsWidgets);
    });
  });
}
