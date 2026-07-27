import 'package:companion_for_cacao/config/routes/app_routes.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/screens/game_setup_detail_screen.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/screens/game_setup_preparation_screen.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/screens/game_setup_screen.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/screens/game_setup_tiles_screen.dart';
import 'package:companion_for_cacao/features/home/presentation/screens/home_screen.dart';
import 'package:companion_for_cacao/features/rule/presentation/rule_pdf_screen.dart';
import 'package:companion_for_cacao/features/score/presentation/screens/score_calculator_screen.dart';
import 'package:companion_for_cacao/features/score/presentation/screens/score_result_screen.dart';
import 'package:companion_for_cacao/features/rule/presentation/rule_screen.dart';
import 'package:companion_for_cacao/features/splash/presentation/providers/splash_provider.dart';
import 'package:companion_for_cacao/features/splash/presentation/screens/splash_screen.dart';
import 'package:companion_for_cacao/features/tile/presentation/screens/tile_detail_screen.dart';
import 'package:companion_for_cacao/features/tile/presentation/screens/tile_list_screen.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// A [ChangeNotifier] bridge that allows Riverpod providers to trigger
/// GoRouter's redirect re-evaluation via [refreshListenable].
class _RouterRefreshNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final refreshNotifier = _RouterRefreshNotifier();

  // Listen for splash state changes and notify the router to re-evaluate redirects
  ref.listen(splashProvider, (_, _) {
    refreshNotifier.notify();
  });

  final router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshNotifier,
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).pageNotFoundTitle),
      ),
      body: Center(
        child: Text(AppLocalizations.of(context).routeNotFound('${state.uri}')),
      ),
    ),
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.tiles,
        builder: (context, state) => const TileListScreen(),
      ),
      GoRoute(
        path: AppRoutes.tileDetail,
        builder: (context, state) {
          final tile = state.extra;
          if (tile is! TileEntity) {
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: Center(
                child: Text(AppLocalizations.of(context).invalidDataMessage),
              ),
            );
          }
          return TileDetailScreen(tile: tile);
        },
      ),
      GoRoute(
        path: AppRoutes.rules,
        builder: (context, state) => const RuleScreen(),
      ),
      GoRoute(
        path: AppRoutes.rulePdf,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! Map<String, String>) {
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: Center(
                child: Text(AppLocalizations.of(context).invalidDataMessage),
              ),
            );
          }
          return RulePdfScreen(
            title: extra['title'] ?? '',
            pdfPath: extra['pdfPath'] ?? '',
          );
        },
      ),
      GoRoute(
        path: AppRoutes.gameSetup,
        builder: (context, state) => const GameSetupScreen(),
      ),
      GoRoute(
        path: AppRoutes.gameSetupDetail,
        builder: (context, state) {
          final gameSetup = state.extra;
          if (gameSetup is! GameSetupStateEntity) {
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: Center(
                child: Text(AppLocalizations.of(context).invalidDataMessage),
              ),
            );
          }
          return GameSetupDetailScreen(gameSetup: gameSetup);
        },
      ),
      GoRoute(
        path: AppRoutes.gameSetupPreparation,
        builder: (context, state) {
          final gameSetup = state.extra;
          if (gameSetup is! GameSetupStateEntity) {
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: Center(
                child: Text(AppLocalizations.of(context).invalidDataMessage),
              ),
            );
          }
          return GameSetupPreparationScreen(gameSetup: gameSetup);
        },
      ),
      GoRoute(
        path: AppRoutes.scoreCalculator,
        builder: (context, state) => const ScoreCalculatorScreen(),
      ),
      GoRoute(
        path: AppRoutes.scoreResult,
        builder: (context, state) => const ScoreResultScreen(),
      ),
      GoRoute(
        path: AppRoutes.gameSetupTiles,
        builder: (context, state) {
          final gameSetup = state.extra;
          if (gameSetup is! GameSetupStateEntity) {
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: Center(
                child: Text(AppLocalizations.of(context).invalidDataMessage),
              ),
            );
          }
          return GameSetupTilesScreen(gameSetup: gameSetup);
        },
      ),
    ],
    redirect: (context, state) {
      final splashState = ref.read(splashProvider);
      final isSplashDone = splashState is AsyncData<void>;
      final isSplashRoute = state.matchedLocation == AppRoutes.splash;

      if (!isSplashDone && !isSplashRoute) {
        return AppRoutes.splash;
      }

      if (isSplashDone && isSplashRoute) {
        return AppRoutes.home;
      }

      return null;
    },
  );

  // The router owns platform listeners of its own, so disposing the refresh
  // bridge alone leaks it — in the app it lives as long as the process, but
  // every test that builds one leaves it behind.
  ref.onDispose(() {
    router.dispose();
    refreshNotifier.dispose();
  });

  return router;
}
