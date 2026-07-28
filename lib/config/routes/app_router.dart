import 'package:companion_for_cacao/config/routes/app_routes.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
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
import 'package:companion_for_cacao/shared/widgets/dialog_button_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

/// A [ChangeNotifier] bridge that allows Riverpod providers to trigger
/// GoRouter's redirect re-evaluation via [refreshListenable].
class _RouterRefreshNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}

/// Shown when a route is entered with `extra` of the wrong type — which in
/// practice means the process was restarted while that screen was on top,
/// since `extra` does not survive it. Five routes take a typed `extra` and
/// every one of them needs this, so it lives here once.
Widget _invalidExtraScreen(BuildContext context) {
  final l10n = AppLocalizations.of(context);
  return Scaffold(
    appBar: AppBar(title: Text(l10n.errorTitle)),
    body: Center(child: Text(l10n.invalidDataMessage)),
  );
}

/// Walks the system back gesture up to Home from the root destinations.
///
/// Home and the drawer navigate with `go`, which replaces the stack, so from
/// a section there is nothing to pop and back would leave the app — taking
/// the game with it, since it lives in memory only. Wrapping the route
/// rather than the screen keeps the shared scaffold free of route knowledge,
/// and covers the pushed case too: with something on the stack `canPop` is
/// true and this gets out of the way.
class _BackToHome extends StatelessWidget {
  const _BackToHome({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: context.canPop(),
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && context.mounted) context.go(AppRoutes.home);
      },
      child: child,
    );
  }
}

/// Asks before the back gesture closes the app on top of a game.
///
/// Home is the one root destination where leaving IS the right outcome, so it
/// cannot walk up any further. But a set-up game is 45 minutes of table work
/// held in memory: the activity finishing destroys it, with no warning and
/// nothing on disk to recover from. Pressing HOME keeps everything; only back
/// is destructive, which is exactly the confusion worth interrupting.
class _ExitGuard extends ConsumerWidget {
  const _ExitGuard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameInProgress = ref.watch(
      gameSetupProvider.select((s) => s.value?.isStarted ?? false),
    );

    return PopScope(
      canPop: !gameInProgress,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop || !context.mounted) return;
        final l10n = AppLocalizations.of(context);
        final leave = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(l10n.exitWithGameTitle),
            content: Text(l10n.exitWithGameBody),
            actions: [
              DialogButtonBarWidget(
                onCancel: () => Navigator.of(dialogContext).pop(false),
                onConfirm: () => Navigator.of(dialogContext).pop(true),
                confirmLabel: l10n.exitWithGameAction,
                isDestructive: true,
              ),
            ],
          ),
        );
        if (leave ?? false) await SystemNavigator.pop();
      },
      child: child,
    );
  }
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
        builder: (context, state) => const _ExitGuard(child: HomeScreen()),
      ),
      GoRoute(
        path: AppRoutes.tiles,
        builder: (context, state) => const _BackToHome(child: TileListScreen()),
      ),
      GoRoute(
        path: AppRoutes.tileDetail,
        builder: (context, state) {
          final tile = state.extra;
          if (tile is! TileEntity) {
            return _invalidExtraScreen(context);
          }
          return TileDetailScreen(tile: tile);
        },
      ),
      GoRoute(
        path: AppRoutes.rules,
        builder: (context, state) => const _BackToHome(child: RuleScreen()),
      ),
      GoRoute(
        path: AppRoutes.rulePdf,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is! Map<String, String>) {
            return _invalidExtraScreen(context);
          }
          return RulePdfScreen(
            title: extra['title'] ?? '',
            pdfPath: extra['pdfPath'] ?? '',
          );
        },
      ),
      GoRoute(
        path: AppRoutes.gameSetup,
        builder: (context, state) =>
            const _BackToHome(child: GameSetupScreen()),
      ),
      GoRoute(
        path: AppRoutes.gameSetupDetail,
        builder: (context, state) {
          final gameSetup = state.extra;
          if (gameSetup is! GameSetupStateEntity) {
            return _invalidExtraScreen(context);
          }
          return GameSetupDetailScreen(gameSetup: gameSetup);
        },
      ),
      GoRoute(
        path: AppRoutes.gameSetupPreparation,
        builder: (context, state) {
          final gameSetup = state.extra;
          if (gameSetup is! GameSetupStateEntity) {
            return _invalidExtraScreen(context);
          }
          return GameSetupPreparationScreen(gameSetup: gameSetup);
        },
      ),
      GoRoute(
        path: AppRoutes.scoreCalculator,
        builder: (context, state) =>
            const _BackToHome(child: ScoreCalculatorScreen()),
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
            return _invalidExtraScreen(context);
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
