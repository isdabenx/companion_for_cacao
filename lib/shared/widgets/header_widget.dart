import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_shapes.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Small section heading: a gold accent bar next to bold body-font text.
/// Uses the gold purposefully as an accent instead of as a text outline.
class HeaderWidget extends StatelessWidget {
  const HeaderWidget({required this.text, super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.gold,
              borderRadius: AppShapes.radius(AppShapes.radiusS),
            ),
          ),
          AppSpacing.horizontalS,
          Flexible(child: Text(text, style: AppTextStyles.markdownH2)),
        ],
      ),
    );
  }
}
