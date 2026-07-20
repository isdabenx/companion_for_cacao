import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

/// Fullscreen zoom dialog for a preparation step image, shared by every
/// card/row that shows a step thumbnail.
void showPreparationImageDialog(
  BuildContext context, {
  required String imagePath,
  required String heroTag,
}) {
  showDialog<void>(
    context: context,
    barrierColor: AppColors.black.withValues(alpha: 0.7),
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: AppSpacing.allXl,
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Hero(
                tag: heroTag,
                child: InteractiveViewer(
                  maxScale: 4.0,
                  minScale: 0.5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.black.withValues(alpha: 0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    padding: AppSpacing.allL,
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Padding(
                          padding: EdgeInsets.all(40.0),
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: AppColors.brown,
                            size: 100,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -16,
                right: -16,
                child: Material(
                  color: AppColors.cream,
                  shape: const CircleBorder(),
                  elevation: 4,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: AppColors.brown),
                    onPressed: () => Navigator.of(context).pop(),
                    tooltip: AppLocalizations.of(context).closeAction,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
