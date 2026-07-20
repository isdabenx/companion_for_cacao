import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DialogButtonBarWidget extends StatelessWidget {
  const DialogButtonBarWidget({
    required this.onConfirm,
    required this.onCancel,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.isDestructive = false,
    super.key,
  });

  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final String confirmLabel;
  final String cancelLabel;

  /// Paints the confirm button red for irreversible actions (delete, reset).
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    // Windows expects confirmation on the left (RTL reverses the Row)
    final textDirection = defaultTargetPlatform == TargetPlatform.windows
        ? TextDirection.rtl
        : TextDirection.ltr;

    return Row(
      textDirection: textDirection,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(onPressed: onCancel, child: Text(cancelLabel)),
        AppSpacing.horizontalS,
        FilledButton(
          onPressed: onConfirm,
          style: isDestructive
              ? FilledButton.styleFrom(backgroundColor: AppColors.red)
              : null,
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
