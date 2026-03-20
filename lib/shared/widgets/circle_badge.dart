import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CircleBadge extends StatelessWidget {
  const CircleBadge({
    required this.color,
    this.size = 32,
    this.text,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.borderColor,
    this.borderWidth = 2.0,
    this.boxShadow,
    this.textStyle,
    super.key,
  });

  final Color color;
  final double size;
  final String? text;
  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;
  final Color? borderColor;
  final double borderWidth;
  final List<BoxShadow>? boxShadow;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = borderColor ?? AppColors.brown;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: effectiveBorderColor, width: borderWidth),
        boxShadow: boxShadow,
      ),
      child: Center(
        child: text != null
            ? Text(
                text!,
                style:
                    textStyle ??
                    Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: _getContrastColor(color),
                      fontWeight: FontWeight.bold,
                      fontSize: size * 0.45,
                    ),
              )
            : icon != null
            ? Icon(
                icon,
                color: iconColor ?? _getContrastColor(color),
                size: iconSize ?? size * 0.5,
              )
            : null,
      ),
    );
  }

  Color _getContrastColor(Color color) {
    return color.computeLuminance() > 0.5 ? AppColors.brown : Colors.white;
  }
}
