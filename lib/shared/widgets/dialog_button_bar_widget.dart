import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DialogButtonBarWidget extends StatelessWidget {
  const DialogButtonBarWidget({
    required this.onConfirm,
    required this.onCancel,
    this.confirmLabel,
    this.cancelLabel,
    this.isDestructive = false,
    super.key,
  });

  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  /// Defaults to the localized "OK" / "Cancel". They used to default to
  /// hardcoded English, which four of the five dialogs in the app relied on
  /// by not passing a cancel label at all.
  final String? confirmLabel;
  final String? cancelLabel;

  /// Paints the confirm button red for irreversible actions (delete, reset).
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Windows expects confirmation on the left (RTL reverses the Row)
    final textDirection = defaultTargetPlatform == TargetPlatform.windows
        ? TextDirection.rtl
        : TextDirection.ltr;

    return Row(
      textDirection: textDirection,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Flexible, not fixed: a confirm label that spells out what it does
        // ("Reset the game scoring") is longer than a dialog is wide, and
        // an unconstrained Row runs it off the edge instead of wrapping.
        Flexible(
          child: TextButton(
            onPressed: onCancel,
            child: Text(cancelLabel ?? l10n.cancelAction),
          ),
        ),
        AppSpacing.horizontalS,
        Flexible(
          child: FilledButton(
            onPressed: onConfirm,
            style: isDestructive
                ? FilledButton.styleFrom(backgroundColor: AppColors.red)
                : null,
            child: Text(
              confirmLabel ?? l10n.okAction,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
