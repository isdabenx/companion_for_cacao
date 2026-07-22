import 'package:flutter/widgets.dart';

/// Luminance grayscale filter. Used on the reference (white) component art of
/// the generalized "each player…" preparation steps so it reads as "any
/// colour", both on the thumbnail and in its zoom dialog.
const ColorFilter kGrayscaleFilter = ColorFilter.matrix(<double>[
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0, //
  0.2126, 0.7152, 0.0722, 0, 0, //
  0, 0, 0, 1, 0, //
]);
