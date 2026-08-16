import 'package:flutter/widgets.dart';

/// What the chrome needs to know about the branch it is drawing for.
///
/// Each destination is a branch with its own navigator, which is what keeps
/// the bar and the rail on screen inside a section and what lets a section
/// remember where you were in it. Drawing that takes exactly two facts —
/// which branch is current, and how to switch — so this carries those and not
/// the navigator itself. The scaffold ends up with no dependency on routing at
/// all, which is also what makes a screen still testable on its own: with no
/// shell above it, [maybeOf] answers `null` and the chrome sits out.
@immutable
class AppShellScope extends InheritedWidget {
  const AppShellScope({
    required this.currentIndex,
    required this.onSelect,
    required super.child,
    super.key,
  });

  final int currentIndex;

  /// Called with the destination index. Selecting the current one is a request
  /// to return that section to its starting point.
  final void Function(int index) onSelect;

  static AppShellScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppShellScope>();

  @override
  bool updateShouldNotify(AppShellScope oldWidget) =>
      oldWidget.currentIndex != currentIndex || oldWidget.onSelect != onSelect;
}
