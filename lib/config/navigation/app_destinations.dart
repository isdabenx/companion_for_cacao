import 'package:companion_for_cacao/config/routes/app_routes.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

/// The top-level places the app can be.
///
/// A screen states which one it is; it is never inferred from the current
/// route. Sniffing the router would tie the shell to routing just to draw
/// chrome, and a screen that cannot render without a live router stops being
/// testable on its own.
enum AppDestinationId { home, game, tiles, rules, scores }

/// How prominently a destination is offered.
enum DestinationTier {
  /// Always offered, in every window class.
  primary,

  /// Offered on the rail, where there is vertical room to spare. A secondary
  /// destination must **always** be reachable another way too — from content,
  /// from Home — so a compact window never loses access to it. The rail
  /// accelerates; it does not hide.
  secondary,
}

/// One place the app can navigate to. The single source of truth behind the
/// bottom bar, the collapsed rail and the extended rail: the three are the
/// same list drawn three ways, so a destination is declared exactly once.
@immutable
class AppDestination {
  const AppDestination({
    required this.id,
    required this.route,
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.tier = DestinationTier.primary,
  });

  final AppDestinationId id;
  final String route;
  final IconData icon;
  final IconData selectedIcon;

  /// Resolved late so the list can be `const` and still localize.
  final String Function(AppLocalizations) label;

  final DestinationTier tier;
}

/// Every destination, in presentation order.
///
/// Labels stay short on purpose: at compact width four items share the screen,
/// so a long label truncates. Translations must pick short forms too.
const List<AppDestination> appDestinations = [
  AppDestination(
    id: AppDestinationId.home,
    route: AppRoutes.home,
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
    label: _home,
  ),
  AppDestination(
    id: AppDestinationId.game,
    route: AppRoutes.gameSetup,
    icon: Icons.group_outlined,
    selectedIcon: Icons.group,
    label: _game,
  ),
  AppDestination(
    id: AppDestinationId.tiles,
    route: AppRoutes.tiles,
    icon: Icons.widgets_outlined,
    selectedIcon: Icons.widgets,
    label: _tiles,
  ),
  AppDestination(
    id: AppDestinationId.rules,
    route: AppRoutes.rules,
    icon: Icons.library_books_outlined,
    selectedIcon: Icons.library_books,
    label: _rules,
  ),
  // Secondary: the rail shows it because it has the room. In a compact window
  // the Home card is the way in, which is why that card has to stay.
  AppDestination(
    id: AppDestinationId.scores,
    route: AppRoutes.scoreCalculator,
    icon: Icons.calculate_outlined,
    selectedIcon: Icons.calculate,
    label: _scores,
    tier: DestinationTier.secondary,
  ),
];

String _home(AppLocalizations l) => l.menuHome;
String _game(AppLocalizations l) => l.menuGame;
String _tiles(AppLocalizations l) => l.menuTiles;
String _rules(AppLocalizations l) => l.menuRules;
String _scores(AppLocalizations l) => l.menuScores;

/// Most a bottom bar may hold before the targets get too tight to hit.
const int maxBarDestinations = 5;

/// The destinations a bottom bar offers.
///
/// All of them while they fit — which they do today, and which matters: a
/// destination missing from the bar in a compact window has no chrome at all
/// pointing at it, so landing on one leaves no visible way out. The tiers only
/// start filtering once the list outgrows the bar, and on that day the
/// secondary ones will need a reachable path from content before they can be
/// dropped from here.
List<AppDestination> barDestinations() =>
    appDestinations.length <= maxBarDestinations
    ? appDestinations
    : appDestinations
          .where((d) => d.tier == DestinationTier.primary)
          .toList(growable: false);

/// The destinations a rail offers. It has the vertical room for all of them.
List<AppDestination> railDestinations() => appDestinations;
