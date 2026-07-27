import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_shapes.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

/// The signature full-width framed panel. Sits on the calmed background as a
/// warm [AppColors.surface] card with a soft shadow and continuous
/// (squircle) corners — replacing the old hard 4px green border, which read
/// heavy stacked over the leafy backdrop.
class ContainerFullStyleWidget extends StatelessWidget {
  const ContainerFullStyleWidget({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.m,
      ),
      decoration: ShapeDecoration(
        color: AppColors.surface,
        shape: AppShapes.panel,
        shadows: AppShapes.soft,
      ),
      child: child,
    );
  }
}
