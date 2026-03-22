import 'package:companion_for_cacao/config/routes/app_routes.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/screens/game_setup_detail_screen.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/screens/game_setup_preparation_screen.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/screens/game_setup_screen.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/screens/game_setup_tiles_screen.dart';
import 'package:companion_for_cacao/features/home/presentation/screens/home_screen.dart';
import 'package:companion_for_cacao/features/rule/presentation/rule_pdf_screen.dart';
import 'package:companion_for_cacao/features/rule/presentation/rule_screen.dart';
import 'package:companion_for_cacao/features/splash/presentation/providers/splash_provider.dart';
import 'package:companion_for_cacao/features/splash/presentation/screens/splash_screen.dart';
import 'package:companion_for_cacao/features/tile/presentation/screens/tile_detail_screen.dart';
import 'package:companion_for_cacao/features/tile/presentation/screens/tile_list_screen.dart';
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
  ref.listen(splashScreenProvider, (_, _) {
    refreshNotifier.notify();
  });

  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshNotifier,
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(title: const Text('Page Not Found')),
      body: Center(child: Text('Route not found: ${state.uri}')),
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
          if (tile is! TileModel) {
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: const Center(child: Text('Invalid tile data')),
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
              body: const Center(child: Text('Invalid PDF data')),
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
              body: const Center(child: Text('Invalid game setup data')),
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
              body: const Center(child: Text('Invalid game setup data')),
            );
          }
          return GameSetupPreparationScreen(gameSetup: gameSetup);
        },
      ),
      GoRoute(
        path: AppRoutes.gameSetupTiles,
        builder: (context, state) {
          final gameSetup = state.extra;
          if (gameSetup is! GameSetupStateEntity) {
            return Scaffold(
              appBar: AppBar(title: const Text('Error')),
              body: const Center(child: Text('Invalid game setup data')),
            );
          }
          return GameSetupTilesScreen(gameSetup: gameSetup);
        },
      ),
    ],
    redirect: (context, state) {
      final splashState = ref.read(splashScreenProvider);
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
}
