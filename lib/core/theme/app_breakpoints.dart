import 'package:flutter/widgets.dart';

/// Material 3 window size classes.
///
/// Layout branches on window **width** and nothing else. Never on orientation
/// and never on device type: a landscape phone, a portrait tablet and a
/// resized desktop window can all hand the app the same width, and that width
/// is the only thing that says what fits. `width > height` in particular is a
/// trap — it reports "landscape" for a 923 dp phone and a 1600 dp desktop
/// alike, which want completely different layouts.
enum WindowClass {
  /// Phone in portrait. Navigation sits in a bottom bar.
  compact,

  /// Tablet in portrait, small windows. Collapsed rail, one pane.
  medium,

  /// Phone in landscape, most tablets. Collapsed rail, room for two panes.
  expanded,

  /// Tablet in landscape, desktop. Extended rail with labels.
  large;

  /// Navigation lives on the side rather than the bottom.
  bool get usesRail => this != WindowClass.compact;

  /// The rail has room for icon + label side by side.
  bool get usesExtendedRail => this == WindowClass.large;

  /// There is width for a list and a detail pane at once.
  bool get fitsTwoPanes => index >= WindowClass.expanded.index;
}

class AppBreakpoints {
  const AppBreakpoints._();

  /// Lower bound of each class, in logical pixels.
  static const double mediumMin = 600;
  static const double expandedMin = 840;
  static const double largeMin = 1200;

  static WindowClass classify(double width) {
    if (width >= largeMin) return WindowClass.large;
    if (width >= expandedMin) return WindowClass.expanded;
    if (width >= mediumMin) return WindowClass.medium;
    return WindowClass.compact;
  }

  /// The class of the whole app window. For a decision about the space one
  /// subtree was actually given — which can be a single pane, not the window
  /// — measure with `LayoutBuilder` and call [classify] on the constraints.
  static WindowClass of(BuildContext context) =>
      classify(MediaQuery.sizeOf(context).width);

  /// Below this the window has no height to spare.
  static const double shortWindowMax = 500;

  /// Height, not width — for the few things that cannot be told by a
  /// constraint.
  ///
  /// Prefer measuring the space a widget was actually handed, with
  /// `LayoutBuilder`. This query was tried for the Home hero and the score
  /// reference image and read **stale across a rotation**: both stayed at
  /// their portrait size in landscape, the second one clipping the counters
  /// underneath it. Both now size from their constraints instead.
  ///
  /// What is left is the app bar, whose height has to be declared before any
  /// layout happens and so has nothing to measure. If a constraint is within
  /// reach, use the constraint.
  static bool isShortWindow(BuildContext context) =>
      MediaQuery.sizeOf(context).height < shortWindowMax;
}
