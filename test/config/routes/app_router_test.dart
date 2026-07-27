import 'package:companion_for_cacao/config/routes/app_router.dart';
import 'package:companion_for_cacao/config/routes/app_routes.dart';
import 'package:companion_for_cacao/features/splash/presentation/providers/splash_provider.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

/// Keeps the router out of app initialization: the real notifier seeds the
/// database, which a routing test has no business doing.
class _StubSplashNotifier extends SplashNotifier {
  @override
  Future<void> build() async {}
}

void main() {
  GoRouter buildRouter() {
    final container = ProviderContainer.test(
      overrides: [splashProvider.overrideWith(_StubSplashNotifier.new)],
    );
    return container.read(goRouterProvider);
  }

  Set<String> declaredPaths(GoRouter router) => router.configuration.routes
      .whereType<GoRoute>()
      .map((route) => route.path)
      .toSet();

  group('goRouter', () {
    // Every constant in AppRoutes is a navigation target somewhere in the app.
    // One without a matching GoRoute compiles fine and only fails at runtime,
    // on the "page not found" screen — this is the guard against that. It
    // reads AppRoutes.all rather than a copy of the list, so a route this
    // file forgot cannot pass by being absent from both places.
    test('registers a route for every path in AppRoutes', () {
      final paths = declaredPaths(buildRouter());

      for (final route in AppRoutes.all) {
        expect(
          paths,
          contains(route),
          reason: 'no GoRoute declared for $route',
        );
      }
    });

    // The inverse: AppRoutes.all is only a useful guard while it stays the
    // full list, and nothing else forces a new constant to be added to it.
    test('AppRoutes.all covers every route the router declares', () {
      expect(
        declaredPaths(buildRouter()).difference(AppRoutes.all.toSet()),
        isEmpty,
        reason: 'a GoRoute exists whose path is missing from AppRoutes.all',
      );
    });

    test('declares no duplicate paths', () {
      final router = buildRouter();
      final all = router.configuration.routes
          .whereType<GoRoute>()
          .map((route) => route.path)
          .toList();

      expect(
        all.length,
        all.toSet().length,
        reason: 'a duplicated path silently shadows the later route',
      );
    });

    // Five routes carry a typed `extra`, and none of them can be reached with
    // the wrong type by tapping — only by the process restarting on top of
    // one, since `extra` does not survive it. So it gets a test instead: they
    // all share one screen, and it must be localized, which is what the
    // hardcoded 'Error' title it replaced was not.
    testWidgets('a route entered without its extra shows the localized '
        'error screen', (tester) async {
      // No teardown of our own: the provider disposes the router when the
      // container goes, and disposing it twice throws.
      final router = buildRouter();

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );
      await tester.pumpAndSettle();

      router.go(AppRoutes.tileDetail);
      await tester.pumpAndSettle();

      expect(find.text('Error'), findsOneWidget);
      expect(find.text('Invalid data for this screen.'), findsOneWidget);
    });

    test('starts on the splash route', () {
      // Read the initial location from the route-information provider: the
      // delegate's configuration is only resolved once the router is mounted
      // in a widget tree, which this test deliberately avoids.
      expect(
        buildRouter().routeInformationProvider.value.uri.path,
        AppRoutes.splash,
      );
    });
  });
}
