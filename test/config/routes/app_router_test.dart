import 'package:companion_for_cacao/config/routes/app_router.dart';
import 'package:companion_for_cacao/config/routes/app_routes.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
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

/// A game that has been started, so the exit guard has something to protect.
class _StartedGameNotifier extends GameSetupNotifier {
  @override
  Future<GameSetupStateEntity> build() async =>
      GameSetupStateEntity(isStarted: true);
}

void main() {
  late ProviderContainer container;

  GoRouter buildRouter() {
    container = ProviderContainer.test(
      overrides: [splashProvider.overrideWith(_StubSplashNotifier.new)],
    );
    return container.read(goRouterProvider);
  }

  /// Every path the router can match, rebuilt from the tree.
  ///
  /// Destinations live in shell branches now and their sub-screens hang off
  /// them with relative paths, so a flat sweep of the top level would see only
  /// the splash. Walking and re-joining is what keeps this assertion honest
  /// about what is actually reachable.
  Set<String> declaredPaths(GoRouter router) {
    final paths = <String>{};

    void walk(List<RouteBase> routes, String prefix) {
      for (final route in routes) {
        if (route is GoRoute) {
          final full = route.path.startsWith('/')
              ? route.path
              : '$prefix/${route.path}';
          paths.add(full);
          walk(route.routes, full);
        } else {
          walk(route.routes, prefix);
        }
      }
    }

    walk(router.configuration.routes, '');
    return paths;
  }

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
        // The Home route guards the exit against a game in progress, so it
        // reads a provider: mounting the router needs a scope, as it does in
        // main.dart.
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );
      await tester.pumpAndSettle();

      router.go(AppRoutes.tileDetail);
      await tester.pumpAndSettle();

      expect(find.text('Error'), findsOneWidget);
      expect(find.text('Invalid data for this screen.'), findsOneWidget);
    });

    // Home and the drawer navigate with `go`, which replaces the stack, so
    // back from a section had nothing to pop and left the app — destroying
    // the in-memory game on the way out.
    testWidgets('back from a root section walks up to Home', (tester) async {
      final router = buildRouter();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );
      await tester.pumpAndSettle();

      router.go(AppRoutes.rules);
      await tester.pumpAndSettle();
      expect(
        router.routerDelegate.currentConfiguration.uri.path,
        AppRoutes.rules,
      );

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(
        router.routerDelegate.currentConfiguration.uri.path,
        AppRoutes.home,
      );
    });

    // Home is the one root where leaving is the right outcome — but the game
    // it would take with it exists only in memory, and pressing HOME instead
    // of back keeps everything, which is the confusion worth interrupting.
    testWidgets('back on Home asks first when a game is in progress', (
      tester,
    ) async {
      container = ProviderContainer.test(
        overrides: [
          splashProvider.overrideWith(_StubSplashNotifier.new),
          gameSetupProvider.overrideWith(_StartedGameNotifier.new),
        ],
      );
      final router = container.read(goRouterProvider);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );
      await tester.pumpAndSettle();
      router.go(AppRoutes.home);
      await tester.pumpAndSettle();

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(find.text('Leave the app?'), findsOneWidget);
      expect(find.text('Leave and discard'), findsOneWidget);
    });

    // The board takes the game as a typed `extra` and shows an error screen
    // without one, so Home's resume card has to carry it. It shipped once
    // using a bare `go`, which put "Invalid data for this screen" behind the
    // most inviting button on the launchpad.
    testWidgets('resuming from Home reaches the board, not the error screen', (
      tester,
    ) async {
      container = ProviderContainer.test(
        overrides: [
          splashProvider.overrideWith(_StubSplashNotifier.new),
          gameSetupProvider.overrideWith(_StartedGameNotifier.new),
        ],
      );
      final router = container.read(goRouterProvider);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(
            routerConfig: router,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
          ),
        ),
      );
      await tester.pumpAndSettle();
      router.go(AppRoutes.home);
      await tester.pumpAndSettle();

      await tester.tap(find.text('Resume Game'));
      await tester.pumpAndSettle();

      // Asserted on what is on screen rather than the location: the point of
      // the bug was that the route resolved fine and then refused to build.
      expect(find.text('GAME DASHBOARD'), findsOneWidget);
      expect(find.text('Invalid data for this screen.'), findsNothing);
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
