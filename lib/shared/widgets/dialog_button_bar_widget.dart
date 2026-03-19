import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DialogButtonBarWidget extends StatelessWidget {
  const DialogButtonBarWidget({
    required this.onConfirm,
    required this.onCancel,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    super.key,
  });

  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final String confirmLabel;
  final String cancelLabel;

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
        const SizedBox(width: 8),
        FilledButton(onPressed: onConfirm, child: Text(confirmLabel)),
      ],
    );
  }
}
