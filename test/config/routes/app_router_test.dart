import 'package:companion_for_cacao/config/routes/app_router.dart';
import 'package:companion_for_cacao/config/routes/app_routes.dart';
import 'package:companion_for_cacao/features/splash/presentation/providers/splash_provider.dart';
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
    final container = ProviderContainer(
      overrides: [splashProvider.overrideWith(_StubSplashNotifier.new)],
    );
    addTearDown(container.dispose);
    return container.read(goRouterProvider);
  }

  Set<String> declaredPaths(GoRouter router) => router.configuration.routes
      .whereType<GoRoute>()
      .map((route) => route.path)
      .toSet();

  group('goRouter', () {
    // Every constant in AppRoutes is a navigation target somewhere in the app.
    // One without a matching GoRoute compiles fine and only fails at runtime,
    // on the "page not found" screen — this is the guard against that.
    test('registers a route for every path in AppRoutes', () {
      final paths = declaredPaths(buildRouter());

      for (final route in const [
        AppRoutes.splash,
        AppRoutes.home,
        AppRoutes.tiles,
        AppRoutes.tileDetail,
        AppRoutes.rules,
        AppRoutes.rulePdf,
        AppRoutes.gameSetup,
        AppRoutes.gameSetupDetail,
        AppRoutes.gameSetupPreparation,
        AppRoutes.gameSetupTiles,
        AppRoutes.scoreCalculator,
        AppRoutes.scoreResult,
      ]) {
        expect(
          paths,
          contains(route),
          reason: 'no GoRoute declared for $route',
        );
      }
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
