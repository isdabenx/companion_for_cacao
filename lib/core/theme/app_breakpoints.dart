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

  /// Height, not width — and the one place it is right to ask.
  ///
  /// Anything sized in fixed pixels along the vertical axis is a welcome in a
  /// tall window and a wall in a short one: a 132 dp logo is a quarter of a
  /// phone in portrait and over half of it turned sideways. Heroes, reference
  /// images and celebration banners all give ground here. This is not the
  /// orientation test in disguise — it asks about the axis that is actually
  /// scarce, and a tall-but-narrow window correctly answers "no".
  static bool isShortWindow(BuildContext context) =>
      MediaQuery.sizeOf(context).height < shortWindowMax;
}
