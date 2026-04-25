import 'package:flutter/material.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';

class AsyncLoadingWidget extends StatelessWidget {
  final double size;

  const AsyncLoadingWidget({super.key, this.size = 24.0});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.brown),
        ),
      ),
    );
  }
}
