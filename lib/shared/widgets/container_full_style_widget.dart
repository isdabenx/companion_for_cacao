import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ContainerFullStyleWidget extends StatelessWidget {
  const ContainerFullStyleWidget({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.greenLight,
        border: Border.all(color: AppColors.greenDarker, width: 4),
        borderRadius: BorderRadius.circular(24),
      ),
      child: child,
    );
  }
}
