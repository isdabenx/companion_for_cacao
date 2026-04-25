import 'package:flutter/material.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';

class SafeAssetImage extends StatelessWidget {
  final String assetPath;
  final BoxFit fit;
  final double? width;
  final double? height;
  final String? heroTag;

  const SafeAssetImage({
    super.key,
    required this.assetPath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final image = Image.asset(
      assetPath,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: AppColors.greenLight,
          width: width,
          height: height,
          child: Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              color: AppColors.brown.withValues(alpha: 0.5),
              size: 32,
            ),
          ),
        );
      },
    );

    if (heroTag != null) {
      return Hero(tag: heroTag!, child: image);
    }

    return image;
  }
}
