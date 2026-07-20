import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/core/utils/app_logger.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class AsyncErrorWidget extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;

  const AsyncErrorWidget({super.key, required this.error, this.onRetry});

  @override
  Widget build(BuildContext context) {
    // Log the technical detail; the user sees a friendly message
    AppLogger.warning('AsyncErrorWidget shown', error);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: AppColors.brown, size: 48),
          SizedBox(height: AppSpacing.m),
          Text(
            AppLocalizations.of(context).errorGenericRetry,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.brown),
          ),
          if (onRetry != null) ...[
            SizedBox(height: AppSpacing.m),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenDark,
              ),
              child: Text(AppLocalizations.of(context).retryAction),
            ),
          ],
        ],
      ),
    );
  }
}
