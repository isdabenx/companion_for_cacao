import 'package:flutter/widgets.dart';
import 'package:smooth_corner/smooth_corner.dart';

/// Single source of truth for corner radii, squircle shapes and soft
/// shadows. Replaces the ~7 ad-hoc radius values scattered across the app
/// with one scale, and gives every surface the same continuous ("squircle")
/// corner and gentle depth — the 2025 soft-UI look, kept subtle so it stays
/// on-brand rather than flashy.
class AppShapes {
  const AppShapes._();

  // Corner radius scale.
  static const double radiusS = 8;
  static const double radiusM = 12;
  static const double radiusL = 16;
  static const double radiusXl = 20;
  static const double pill = 999;

  /// How rounded-square the corners are (0 = plain circle arc, 1 = full
  /// superellipse). 0.6 matches Figma/iOS "corner smoothing" comfortably.
  static const double smoothness = 0.6;

  static BorderRadius radius(double r) => BorderRadius.circular(r);

  static SmoothRectangleBorder shape(
    double r, {
    BorderSide side = BorderSide.none,
  }) => SmoothRectangleBorder(
    borderRadius: BorderRadius.circular(r),
    smoothness: smoothness,
    side: side,
  );

  /// Card/chip surfaces.
  static final SmoothRectangleBorder card = shape(radiusL);

  /// Full-width framed panels (`ContainerFullStyleWidget`).
  static final SmoothRectangleBorder panel = shape(radiusXl);

  // Soft, layered shadows — barely-there depth that supports hierarchy
  // without stealing attention.
  static const List<BoxShadow> soft = [
    BoxShadow(color: Color(0x16000000), blurRadius: 16, offset: Offset(0, 6)),
    BoxShadow(color: Color(0x0D000000), blurRadius: 3, offset: Offset(0, 1)),
  ];

  static const List<BoxShadow> softSm = [
    BoxShadow(color: Color(0x12000000), blurRadius: 10, offset: Offset(0, 3)),
  ];
}
