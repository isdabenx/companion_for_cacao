import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_shapes.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// The app mark — a "C" in the decorative face on a green squircle.
///
/// This is where the brand lives in chrome now that there is no drawer to
/// open. The rail keeps it on screen permanently, which is more presence than
/// a drawer logo ever had, and the app bar shows it on top-level screens where
/// no back arrow needs the slot.
///
/// It stays legible small because [AppTextStyles.brandMark] drops the gold
/// outline; do not put the outlined title style in here.
class BrandMarkWidget extends StatelessWidget {
  const BrandMarkWidget({this.size = 32, super.key});

  /// Edge of the squircle. Verified legible down to 21.
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: AppColors.greenDarker,
          shape: AppShapes.shape(size * 0.28),
        ),
        // The mark is decoration; the screen title already announces where
        // you are, so a screen reader should skip the lone letter.
        child: ExcludeSemantics(
          child: Center(
            child: Text(
              'C',
              style: AppTextStyles.brandMark.copyWith(fontSize: size * 0.5),
            ),
          ),
        ),
      ),
    );
  }
}
