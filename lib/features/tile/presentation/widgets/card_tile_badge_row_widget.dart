import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class CardTileBadgeRowWidget extends StatelessWidget {
  const CardTileBadgeRowWidget({
    required this.tileType,
    required this.playerColorInCircle,
    required this.badgeTypeInText,
    super.key,
    this.color,
  });

  final Color? color;
  final String tileType;
  final bool playerColorInCircle;
  final bool badgeTypeInText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 6, right: 6, top: 6),
      child: Wrap(
        spacing: 4,
        children: [
          if (badgeTypeInText)
            Badge(
              backgroundColor: AppColors.badgeBackground,
              label: Padding(
                padding: const EdgeInsets.only(left: 2, right: 2, bottom: 2),
                child: Text(tileType, style: AppTextStyles.tileType),
              ),
            ),
          if (color != null && playerColorInCircle)
            CircleAvatar(radius: 9, backgroundColor: color),
        ],
      ),
    );
  }
}
