import 'package:companion_for_cacao/config/navigation/app_destinations.dart';
import 'package:companion_for_cacao/config/navigation/app_shell_scope.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:companion_for_cacao/shared/widgets/brand_mark_widget.dart';
import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  /// Sizes are logical pixels, so they map straight onto the window classes:
  /// 411x923 is the phone in portrait, 923x411 the same phone turned, and
  /// 1280x800 a tablet in landscape.
  var selected = <int>[];

  /// [branch] is the destination index the shell reports, or `null` for "no
  /// shell above me at all" — a screen pumped on its own in a test.
  Future<void> pumpAt(
    WidgetTester tester,
    Size size, {
    int? branch = 0,
    bool showBackButton = false,
    ContentWidth contentWidth = ContentWidth.readable,
    List<Widget>? actions,
  }) async {
    selected = <int>[];
    tester.view
      ..physicalSize = size
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final scaffold = CustomScaffoldWidget(
      title: 'Title',
      actions: actions,
      showBackButton: showBackButton,
      contentWidth: contentWidth,
      body: const SizedBox(key: Key('body'), height: 100),
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: branch == null
            ? scaffold
            : AppShellScope(
                currentIndex: branch,
                onSelect: selected.add,
                child: scaffold,
              ),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// The locale the tests read labels in.
  final enUs = lookupAppLocalizations(const Locale('en'));

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

    testWidgets('every destination is offered in every window class', (
      tester,
    ) async {
      // A destination missing from the bar has no chrome pointing at it in a
      // compact window, so landing on one strands you with no visible way
      // out. They all fit today, so they are all there.
      await pumpAt(tester, compact);
      final bar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(bar.destinations, hasLength(appDestinations.length));

      await pumpAt(tester, expanded);
      final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
      expect(rail.destinations, hasLength(appDestinations.length));
    });

    testWidgets('the bar never grows past what it can hold', (tester) async {
      // The day a sixth destination arrives this fails, which is the moment
      // to give the secondary ones a path from content before dropping them
      // out of the bar.
      expect(barDestinations().length, lessThanOrEqualTo(maxBarDestinations));
    });

    testWidgets('a secondary destination is still reachable in compact', (
      tester,
    ) async {
      final scores = appDestinations.indexWhere(
        (d) => d.id == AppDestinationId.scores,
      );
      await pumpAt(tester, compact, branch: scores);

      // It is a destination, so it gets navigation — not a dead end.
      expect(find.byType(NavigationBar), findsOneWidget);
      final bar = tester.widget<NavigationBar>(find.byType(NavigationBar));
      expect(bar.selectedIndex, scores);
    });

    testWidgets('tapping a destination asks the shell to switch branch', (
      tester,
    ) async {
      await pumpAt(tester, compact);

      await tester.tap(find.text(appDestinations[2].label(enUs)));
      await tester.pump();

      expect(selected, [2]);
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

    // Going deeper into a section must not cost you the menu: the section is
    // still where you are, so it stays marked and stays reachable. Before the
    // branches existed a detail belonged to no destination and the chrome
    // vanished on every pushed screen.
    testWidgets('a screen pushed inside a section keeps the menu', (
      tester,
    ) async {
      await pumpAt(tester, expanded, branch: 2, showBackButton: true);

      final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
      expect(rail.selectedIndex, 2);
    });

    testWidgets('with no shell above it there is no navigation to draw', (
      tester,
    ) async {
      await pumpAt(tester, expanded, branch: null);

      expect(find.byType(NavigationRail), findsNothing);
      expect(find.byType(NavigationBar), findsNothing);
      expect(find.byKey(const Key('body')), findsOneWidget);
    });
  });

  // The mark used to sit in the app bar's leading slot and at the top of the
  // rail. It was not tappable — a button-shaped thing that did nothing, in the
  // one slot where everything else is a control — and it named the app you
  // were already inside. It lives in About now, beside the product name.
  group('CustomScaffoldWidget chrome', () {
    testWidgets('carries no brand mark, in either layout', (tester) async {
      await pumpAt(tester, compact);
      expect(find.byType(BrandMarkWidget), findsNothing);

      await pumpAt(tester, expanded);
      expect(find.byType(BrandMarkWidget), findsNothing);
    });

    testWidgets('leaves the leading slot free on a detail', (tester) async {
      // Free, not filled with something of ours: a null leading is what lets
      // the app bar put its own back arrow there.
      await pumpAt(tester, compact, showBackButton: true);
      final bar = tester.widget<AppBar>(find.byType(AppBar));
      expect(bar.leading, isNull);
      // And the title is drawn, because on a detail it is the only thing
      // saying where you are.
      expect(bar.title, isNotNull);
    });

    testWidgets('a destination with nothing to offer has no bar at all', (
      tester,
    ) async {
      // ~50 dp of band for a 12 dp word the menu is already showing, lit up.
      await pumpAt(tester, compact);

      expect(find.byType(AppBar), findsNothing);
    });

    testWidgets('a destination with actions keeps its bar, title and all', (
      tester,
    ) async {
      // Once the band exists for the actions, the title costs nothing and
      // stops one icon looking adrift in an empty green strip.
      await pumpAt(tester, compact, actions: const [Icon(Icons.refresh)]);

      final bar = tester.widget<AppBar>(find.byType(AppBar));
      expect(bar.title, isNotNull);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
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
