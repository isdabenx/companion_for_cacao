import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/config/navigation/app_destinations.dart';
import 'package:companion_for_cacao/config/navigation/app_shell_scope.dart';
import 'package:companion_for_cacao/core/theme/app_breakpoints.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

/// How wide the body is allowed to grow.
enum ContentWidth {
  /// Capped and centred. The default: a row stretched across 900 dp puts its
  /// title against one edge and its chevron against the other, with dead space
  /// in between, which reads as a bug rather than as generosity.
  readable,

  /// Uncapped. For grids, where more width honestly means more columns.
  full,
}

/// The app shell: chrome, navigation and body placement for every screen.
///
/// Screens describe themselves — title, actions, whether they are a detail —
/// and never ask how big the window is. This widget owns that decision, so
/// adding a window class or moving navigation is a change in one file.
class CustomScaffoldWidget extends StatelessWidget {
  const CustomScaffoldWidget({
    required this.body,
    super.key,
    this.title,
    this.actions,
    this.showBackButton = false,
    this.appBarBottom,
    this.contentWidth = ContentWidth.readable,
  });

  final Widget body;

  /// Drawn whenever there is an app bar to draw it in.
  ///
  /// A destination with nothing else to offer gets no bar at all, and the
  /// title goes with it: the menu already names the section and marks it, and
  /// ~50 dp of band for a 12 dp word is the chrome saying it twice.
  final String? title;

  final List<Widget>? actions;
  final bool showBackButton;
  final PreferredSizeWidget? appBarBottom;
  final ContentWidth contentWidth;

  /// Max body width under [ContentWidth.readable]. Wide enough that a phone in
  /// landscape is never capped below its portrait width, narrow enough to kill
  /// the dead middle at 900 dp and up.
  static const double _readableMaxWidth = 680;

  /// A rail item with its label needs about this much height.
  static const double _railItemWithLabel = 72;
  static const double _railItemIconOnly = 56;

  /// Narrowest the rail may be once labels sit beside the icons.
  static const double _railExtendedWidth = 220;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final windowClass = AppBreakpoints.of(context);

    final destinations = windowClass.usesRail
        ? railDestinations()
        : barDestinations();

    // The branch you are in, straight from the shell. It stays put while you
    // go deeper into a section, so the menu stays on screen with the section
    // still marked instead of vanishing on every pushed screen.
    final shell = AppShellScope.maybeOf(context);
    final selected = shell?.currentIndex;

    // No shell means no router: a widget test pumping one screen. Nothing to
    // draw, and nothing to break.
    final showNavigation = selected != null && selected < destinations.length;
    final showRail = showNavigation && windowClass.usesRail;
    final showBar = showNavigation && !windowClass.usesRail;

    // The bar earns its band or it does not appear. What it is for is the
    // things navigation cannot express: the way back out of a detail, and
    // whatever this particular screen lets you do. A destination with neither
    // was spending ~50 dp to repeat the label already lit up in the menu.
    final hasActions = actions != null && actions!.isNotEmpty;
    final showAppBar = showBackButton || hasActions || appBarBottom != null;

    return Scaffold(
      appBar: showAppBar
          ? AppBar(
              toolbarHeight: _toolbarHeight(context),
              bottom: appBarBottom,
              actions: actions,
              // Uppercased: the app-bar title is chrome, so it reads as a
              // label rather than competing with the content headings below.
              //
              // Drawn whenever the bar is: the redundancy with the menu is a
              // reason to drop the *band*, not to leave an existing band empty
              // with one icon adrift in the corner.
              title: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text((title ?? '').toUpperCase()),
              ),
              centerTitle: true,
              leading: _leading(),
            )
          : null,
      // Consume the horizontal display cutout once, here, for everything.
      //
      // Left to itself the rail absorbs it: in landscape with the camera on
      // the leading edge it grew from 79 dp to 135 dp, icons shoved off to
      // one side behind a dead green band. Taking the inset at the body means
      // the rail is its true width whichever way the phone is turned, and the
      // content pane cannot slide under the camera in the other rotation
      // either. Top and bottom are left to the Scaffold, which already
      // handles the status bar and the gesture bar.
      body: _Background(
        child: SafeArea(
          // With no bar there is nothing between the content and the status
          // bar, so the body takes that inset itself. The leafy ground still
          // reaches under it, which is what keeps the top edge from looking
          // like a cut rather than a margin.
          top: !showAppBar,
          bottom: false,
          child: Row(
            children: [
              if (showRail)
                _Rail(
                  destinations: destinations,
                  selectedIndex: selected,
                  extended: windowClass.usesExtendedRail,
                  l10n: l10n,
                ),
              Expanded(child: _constrainedBody()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: showBar
          ? NavigationBar(
              selectedIndex: selected,
              onDestinationSelected: (i) => _goToBranch(context, i),
              destinations: [
                for (final d in destinations)
                  NavigationDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: d.label(l10n),
                  ),
              ],
            )
          : null,
    );
  }

  /// The back arrow, or nothing.
  ///
  /// The brand mark used to sit here when there was no arrow. It was not
  /// tappable, which made it a button-shaped thing that did nothing in the
  /// one slot where everything else is a control — and it told you the name
  /// of the app you were already using. The mark lives in About now, next to
  /// the product name, where it says something.
  Widget? _leading() => showBackButton ? null : const SizedBox.shrink();

  /// Height is the scarce axis in a short window, so the bar gives some back —
  /// but never below 48, which is the smallest a back arrow may be and still
  /// be comfortably hittable. The old 44 was under that line.
  double _toolbarHeight(BuildContext context) =>
      AppBreakpoints.isShortWindow(context) ? 48 : 56;

  Widget _constrainedBody() {
    if (contentWidth == ContentWidth.full) return body;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _readableMaxWidth),
        child: body,
      ),
    );
  }

  static void _goToBranch(BuildContext context, int index) =>
      AppShellScope.maybeOf(context)?.onSelect(index);
}

class _Rail extends StatelessWidget {
  const _Rail({
    required this.destinations,
    required this.selectedIndex,
    required this.extended,
    required this.l10n,
  });

  final List<AppDestination> destinations;
  final int selectedIndex;
  final bool extended;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Five labelled items need ~360 dp; a phone in landscape has ~355 left
        // under the app bar. When they do not fit, keep the label on the
        // selected item rather than dropping all of them: knowing *where you
        // are* matters more than naming the four places you are not, and the
        // rest keep their labels as tooltips.
        final needed =
            destinations.length * CustomScaffoldWidget._railItemWithLabel;
        final fitsLabels = constraints.maxHeight >= needed;

        return NavigationRail(
          selectedIndex: selectedIndex,
          extended: extended,
          labelType: extended
              ? null
              : (fitsLabels
                    ? NavigationRailLabelType.all
                    : NavigationRailLabelType.selected),
          backgroundColor: AppColors.menuBackground,
          minWidth: CustomScaffoldWidget._railItemIconOnly,
          // A floor, not a ceiling: the rail still grows to fit its widest
          // child. Keeping it narrow is therefore the leading widget's job,
          // which is why the wordmark below is bounded — unbounded it asked
          // for 320 dp, a quarter of a tablet spent on chrome.
          minExtendedWidth: CustomScaffoldWidget._railExtendedWidth,
          onDestinationSelected: (i) =>
              CustomScaffoldWidget._goToBranch(context, i),
          destinations: [
            for (final d in destinations)
              NavigationRailDestination(
                icon: Icon(d.icon),
                selectedIcon: Icon(d.selectedIcon),
                label: Text(d.label(l10n)),
              ),
          ],
        );
      },
    );
  }
}

/// The leafy ground, behind the rail as well as the content.
///
/// It reaches under the display cutout on purpose: the strip the camera
/// reserves belongs to no component, and showing the page ground there is
/// what makes the rail read as its true width instead of as a wide band with
/// its icons shoved to one side.
class _Background extends StatelessWidget {
  const _Background({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage(Assets.background),
          fit: BoxFit.cover,
          // Warm cream wash over the leaf texture: the jungle stays a
          // whisper, and content sits on a calm ground instead of a
          // second green competing with the chrome and the cards.
          colorFilter: ColorFilter.mode(
            AppColors.cream.withValues(alpha: 0.9),
            BlendMode.srcOver,
          ),
        ),
      ),
      child: child,
    );
  }
}
