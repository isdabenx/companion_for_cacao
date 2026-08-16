import 'package:companion_for_cacao/config/navigation/app_shell_scope.dart';
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

/// The shell every destination lives inside.
///
/// It owns the two things that have to survive moving between sections: the
/// branch navigators, which remember each section's stack and scroll, and the
/// back behaviour, which is the same three-step answer everywhere and so is
/// written once here rather than wrapped around each route.
///
/// Back, in order: pop inside the current section if it has anywhere to go;
/// otherwise return to Home, because leaving the app from a section would take
/// a game in memory with it; and on Home, ask first when there is a game to
/// lose.
class _AppShell extends ConsumerWidget {
  const _AppShell({required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const int _homeBranch = 0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameInProgress = ref.watch(
      gameSetupProvider.select((s) => s.value?.isStarted ?? false),
    );
    final onHome = navigationShell.currentIndex == _homeBranch;

    return AppShellScope(
      currentIndex: navigationShell.currentIndex,
      // Tapping the section you are already in returns it to its starting
      // point, which is the familiar way out of somewhere deep.
      onSelect: (index) => navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      ),
      child: PopScope(
        // Leaving outright is only ever right from Home with nothing at stake.
        // Everything else has somewhere to go first.
        canPop: onHome && !gameInProgress,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop || !context.mounted) return;
          if (!onHome) {
            navigationShell.goBranch(_homeBranch);
            return;
          }
          await _confirmExitWithGame(context);
        },
        child: navigationShell,
      ),
    );
  }
}

/// Asks before the back gesture closes the app on top of a game.
///
/// A set-up game is 45 minutes of table work held in memory: the activity
/// finishing destroys it, with no warning and nothing on disk to recover from.
/// Pressing HOME keeps everything; only back is destructive, which is exactly
/// the confusion worth interrupting.
Future<void> _confirmExitWithGame(BuildContext context) async {
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
}

/// The last segment of a nested path, which is what `GoRoute` wants for a
/// child. Derived from the full constant so the two can never drift: the
/// constants stay the single place a path is written down.
String _relative(String path, {String under = ''}) {
  final prefix = under.isEmpty
      ? '${path.substring(0, path.lastIndexOf('/'))}/'
      : '$under/';
  assert(path.startsWith(prefix), '$path is not under $prefix');
  return path.substring(prefix.length);
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
      // One branch per destination, in the same order as `appDestinations`,
      // because the shell talks to them by index. Each branch keeps its own
      // navigator, so a section remembers its stack and its scroll while you
      // are away in another one, and a screen pushed inside a section keeps
      // the menu on screen with that section still marked.
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            _AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.gameSetup,
                builder: (context, state) => const GameSetupScreen(),
                routes: [
                  GoRoute(
                    path: _relative(AppRoutes.gameSetupDetail),
                    builder: (context, state) {
                      final gameSetup = state.extra;
                      if (gameSetup is! GameSetupStateEntity) {
                        return _invalidExtraScreen(context);
                      }
                      return GameSetupDetailScreen(gameSetup: gameSetup);
                    },
                    routes: [
                      GoRoute(
                        path: _relative(
                          AppRoutes.gameSetupPreparation,
                          under: AppRoutes.gameSetupDetail,
                        ),
                        builder: (context, state) {
                          final gameSetup = state.extra;
                          if (gameSetup is! GameSetupStateEntity) {
                            return _invalidExtraScreen(context);
                          }
                          return GameSetupPreparationScreen(
                            gameSetup: gameSetup,
                          );
                        },
                      ),
                      GoRoute(
                        path: _relative(
                          AppRoutes.gameSetupTiles,
                          under: AppRoutes.gameSetupDetail,
                        ),
                        builder: (context, state) {
                          final gameSetup = state.extra;
                          if (gameSetup is! GameSetupStateEntity) {
                            return _invalidExtraScreen(context);
                          }
                          return GameSetupTilesScreen(gameSetup: gameSetup);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.tiles,
                builder: (context, state) => const TileListScreen(),
                routes: [
                  GoRoute(
                    path: _relative(AppRoutes.tileDetail),
                    builder: (context, state) {
                      final tile = state.extra;
                      if (tile is! TileEntity) {
                        return _invalidExtraScreen(context);
                      }
                      return TileDetailScreen(tile: tile);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.rules,
                builder: (context, state) => const RuleScreen(),
                routes: [
                  GoRoute(
                    path: _relative(AppRoutes.rulePdf),
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
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.scoreCalculator,
                builder: (context, state) => const ScoreCalculatorScreen(),
                routes: [
                  GoRoute(
                    path: _relative(AppRoutes.scoreResult),
                    builder: (context, state) => const ScoreResultScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
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
