import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:flutter/material.dart';

class SelectableChip extends StatelessWidget {
  const SelectableChip({
    required this.child,
    this.isSelected = false,
    this.selectedColor,
    this.unselectedColor,
    this.selectedBorderColor,
    this.unselectedBorderColor,
    this.selectedBorderWidth = 2.5,
    this.unselectedBorderWidth = 1.5,
    this.borderRadius = 16.0,
    this.padding = AppSpacing.allM,
    this.onTap,
    this.showShadow = true,
    super.key,
  });

  final Widget child;
  final bool isSelected;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedBorderColor;
  final Color? unselectedBorderColor;
  final double selectedBorderWidth;
  final double unselectedBorderWidth;
  final double borderRadius;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final bool showShadow;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final effectiveSelectedColor =
        selectedColor ?? theme.colorScheme.primary.withValues(alpha: 0.15);
    final effectiveUnselectedColor =
        unselectedColor ?? theme.colorScheme.surfaceContainerHighest;

    final effectiveSelectedBorderColor =
        selectedBorderColor ?? theme.colorScheme.primary;
    final effectiveUnselectedBorderColor =
        unselectedBorderColor ?? theme.colorScheme.outlineVariant;

    // Compensate the thinner unselected border with padding so the chip's
    // outer size is identical in both states and layouts don't shift on
    // selection.
    final borderDelta = selectedBorderWidth - unselectedBorderWidth;
    final effectivePadding = !isSelected && borderDelta > 0
        ? padding.add(EdgeInsets.all(borderDelta))
        : padding;

    return Container(
      decoration: BoxDecoration(
        color: isSelected ? effectiveSelectedColor : effectiveUnselectedColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: isSelected
              ? effectiveSelectedBorderColor
              : effectiveUnselectedBorderColor,
          width: isSelected ? selectedBorderWidth : unselectedBorderWidth,
        ),
        boxShadow: isSelected && showShadow
            ? [
                BoxShadow(
                  color: theme.colorScheme.shadow.withValues(alpha: 0.15),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: Padding(padding: effectivePadding, child: child),
        ),
      ),
    );
  }
}
