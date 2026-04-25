import 'package:companion_for_cacao/shared/widgets/adaptive_shell_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const destinations = <NavigationDestinationData>[
    NavigationDestinationData(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: 'Home',
    ),
    NavigationDestinationData(
      icon: Icons.search_outlined,
      selectedIcon: Icons.search,
      label: 'Search',
    ),
    NavigationDestinationData(
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      label: 'Settings',
    ),
  ];

  Future<void> pumpAdaptiveShell(
    WidgetTester tester, {
    required double width,
    int selectedIndex = 0,
    ValueChanged<int>? onDestinationSelected,
  }) async {
    await tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(size: Size(width, 800)),
        child: MaterialApp(
          theme: ThemeData(useMaterial3: true),
          home: AdaptiveShellWidget(
            body: const Text('Body content'),
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected ?? (_) {},
            destinations: destinations,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('AdaptiveShellWidget Widget Tests', () {
    testWidgets('renders NavigationBar when width is compact', (
      WidgetTester tester,
    ) async {
      await pumpAdaptiveShell(tester, width: 500);

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
    });

    testWidgets('renders NavigationRail when width is medium', (
      WidgetTester tester,
    ) async {
      await pumpAdaptiveShell(tester, width: 700);

      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
    });

    testWidgets('extends NavigationRail when width is expanded', (
      WidgetTester tester,
    ) async {
      await pumpAdaptiveShell(tester, width: 900);

      final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));

      expect(rail.extended, isTrue);
    });

    testWidgets('uses all labels on NavigationRail when width is medium', (
      WidgetTester tester,
    ) async {
      await pumpAdaptiveShell(tester, width: 700);

      final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));

      expect(rail.labelType, NavigationRailLabelType.all);
    });

    testWidgets('uses no labels on NavigationRail when width is expanded', (
      WidgetTester tester,
    ) async {
      await pumpAdaptiveShell(tester, width: 900);

      final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));

      expect(rail.labelType, NavigationRailLabelType.none);
    });

    testWidgets('displays correct number of destinations', (
      WidgetTester tester,
    ) async {
      await pumpAdaptiveShell(tester, width: 500);

      final navigationBar = tester.widget<NavigationBar>(
        find.byType(NavigationBar),
      );

      expect(navigationBar.destinations, hasLength(destinations.length));
      for (final destination in destinations) {
        expect(find.text(destination.label), findsOneWidget);
      }
    });

    testWidgets(
      'fires onDestinationSelected callback when destination tapped',
      (WidgetTester tester) async {
        int? tappedIndex;

        await pumpAdaptiveShell(
          tester,
          width: 500,
          onDestinationSelected: (index) => tappedIndex = index,
        );

        await tester.tap(find.text('Search'));
        await tester.pumpAndSettle();

        expect(tappedIndex, 1);
      },
    );

    testWidgets('selectedIndex highlights correct destination', (
      WidgetTester tester,
    ) async {
      await pumpAdaptiveShell(tester, width: 700, selectedIndex: 2);

      final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));

      expect(rail.selectedIndex, 2);
    });
  });
}
