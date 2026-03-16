import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ContainerFullStyleWidget extends StatelessWidget {
  const ContainerFullStyleWidget({required this.child, super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          constraints: BoxConstraints(minHeight: constraints.maxHeight - 16),
          decoration: BoxDecoration(
            color: AppColors.greenLight,
            border: Border.all(color: AppColors.greenDarker, width: 4),
            borderRadius: BorderRadius.circular(24),
          ),
          child: child,
        );
      },
    );
  }
}
