import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';

class CardTileImageWidget extends StatelessWidget {
  const CardTileImageWidget({
    required this.tileType,
    required this.filenameImage,
    required this.badgeTypeInImage,
    required this.quantity,
    required this.showQuantity,
    super.key,
  });

  final String tileType;
  final String filenameImage;
  final bool badgeTypeInImage;
  final int quantity;
  final bool showQuantity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Hero(
          tag: 'tile-image-$filenameImage',
          child: Image.asset(
            '${Assets.imagesTilePath}$filenameImage',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
        if (badgeTypeInImage)
          Positioned(
            top: 4,
            left: 4,
            child: Opacity(
              opacity: 0.75,
              child: Badge(
                backgroundColor: AppColors.badgeTransparentBackground,
                label: Padding(
                  padding: const EdgeInsets.all(1),
                  child: Text(
                    tileType,
                    style: AppTextStyles.tileBadgeTextStyle,
                  ),
                ),
              ),
            ),
          ),
        if (showQuantity)
          Positioned(
            bottom: 4,
            right: 4,
            child: Text(
              'x$quantity',
              style: AppTextStyles.tileQuantityTextStyle,
            ),
          ),
      ],
    );
  }
}
