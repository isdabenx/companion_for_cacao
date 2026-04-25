import 'package:flutter/material.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';

class AsyncErrorWidget extends StatelessWidget {
  final Object error;
  final VoidCallback? onRetry;

  const AsyncErrorWidget({super.key, required this.error, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: AppColors.brown, size: 48),
          SizedBox(height: AppSpacing.m),
          Text(
            error.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.brown),
          ),
          if (onRetry != null) ...[
            SizedBox(height: AppSpacing.m),
            ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.greenDark,
              ),
              child: const Text('Retry'),
            ),
          ],
        ],
      ),
    );
  }
}
