import 'package:companion_for_cacao/config/navigation/app_destinations.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:companion_for_cacao/shared/widgets/brand_mark_widget.dart';
import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// Sizes are logical pixels, so they map straight onto the window classes:
  /// 411x923 is the phone in portrait, 923x411 the same phone turned, and
  /// 1280x800 a tablet in landscape.
  Future<void> pumpAt(
    WidgetTester tester,
    Size size, {
    AppDestinationId? destination = AppDestinationId.home,
    bool showBackButton = false,
    ContentWidth contentWidth = ContentWidth.readable,
  }) async {
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: CustomScaffoldWidget(
          title: 'Title',
          destination: destination,
          showBackButton: showBackButton,
          contentWidth: contentWidth,
          body: const SizedBox(key: Key('body'), height: 100),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  const compact = Size(411, 923);
  const expanded = Size(923, 411);
  const large = Size(1280, 800);

  group('CustomScaffoldWidget navigation', () {
    testWidgets('compact puts navigation in a bottom bar', (tester) async {
      await pumpAt(tester, compact);

      expect(find.byType(NavigationBar), findsOneWidget);
      expect(find.byType(NavigationRail), findsNothing);
    });

    testWidgets('expanded moves navigation to a rail', (tester) async {
      await pumpAt(tester, expanded);

      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
    });

    testWidgets('the bar carries primary destinations only, the rail all', (
      tester,
    ) async {
      await pumpAt(tester, compact);
      final bar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      final primaryCount = appDestinations
          .where((d) => d.tier == DestinationTier.primary)
          .length;
      expect(bar.destinations, hasLength(primaryCount));

      await pumpAt(tester, expanded);
      final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
      expect(rail.destinations, hasLength(appDestinations.length));
      // The extra ones are the secondary tier, not padding.
      expect(rail.destinations.length, greaterThan(primaryCount));
    });

    testWidgets('the rail extends only once there is width for labels', (
      tester,
    ) async {
      await pumpAt(tester, expanded);
      expect(
        tester.widget<NavigationRail>(find.byType(NavigationRail)).extended,
        isFalse,
      );

      await pumpAt(tester, large);
      expect(
        tester.widget<NavigationRail>(find.byType(NavigationRail)).extended,
        isTrue,
      );
    });

    testWidgets('a pushed detail gets no navigation at all', (tester) async {
      await pumpAt(tester, expanded, destination: null, showBackButton: true);

      expect(find.byType(NavigationRail), findsNothing);
      expect(find.byType(NavigationBar), findsNothing);
    });

    testWidgets('renders without a router, so screens stay testable alone', (
      tester,
    ) async {
      await pumpAt(tester, compact);

      // No GoRouter above this widget anywhere in the test; reaching this
      // line at all is the assertion.
      expect(find.byKey(const Key('body')), findsOneWidget);
    });
  });

  group('CustomScaffoldWidget brand mark', () {
    testWidgets('sits in the app bar when there is no rail to hold it', (
      tester,
    ) async {
      await pumpAt(tester, compact);
      expect(find.byType(BrandMarkWidget), findsOneWidget);
    });

    testWidgets('appears once, not twice, when the rail shows it', (
      tester,
    ) async {
      await pumpAt(tester, expanded);
      expect(find.byType(BrandMarkWidget), findsOneWidget);
    });

    testWidgets('yields the slot to the back arrow on a detail', (
      tester,
    ) async {
      await pumpAt(tester, compact, destination: null, showBackButton: true);

      expect(find.byType(BrandMarkWidget), findsNothing);
    });
  });

  group('CustomScaffoldWidget content width', () {
    testWidgets('caps readable content well short of a wide window', (
      tester,
    ) async {
      await pumpAt(tester, large);

      final width = tester.getSize(find.byKey(const Key('body'))).width;
      expect(width, lessThan(large.width));
      expect(width, lessThanOrEqualTo(680));
    });

    testWidgets('lets a grid have the whole pane', (tester) async {
      await pumpAt(tester, large, contentWidth: ContentWidth.full);

      final width = tester.getSize(find.byKey(const Key('body'))).width;
      // Everything but the rail, so a grid turns width into columns.
      expect(width, greaterThan(680));
    });
  });
}
