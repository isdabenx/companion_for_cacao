import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/shared/widgets/dialog_button_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Direct numeric entry dialog. Owns its text controller so it is disposed
/// with the dialog's own lifecycle — disposing it right after showDialog
/// returns races the exit animation and the IME while the TextField is
/// still attached ("used after dispose" errors on Enter).
class _ValueEntryDialog extends StatefulWidget {
  const _ValueEntryDialog({required this.initialValue});

  final int initialValue;

  @override
  State<_ValueEntryDialog> createState() => _ValueEntryDialogState();
}

class _ValueEntryDialogState extends State<_ValueEntryDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: '${widget.initialValue}',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() => Navigator.of(context).pop(int.tryParse(_controller.text));

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter value'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onSubmitted: (_) => _submit(),
      ),
      actions: [
        DialogButtonBarWidget(
          onCancel: () => Navigator.of(context).pop(),
          onConfirm: _submit,
          confirmLabel: 'OK',
        ),
      ],
    );
  }
}

/// A -/+ stepper for score inputs. Tapping the value opens a dialog for
/// direct numeric entry (useful for large gold amounts).
class CountStepperWidget extends StatelessWidget {
  const CountStepperWidget({
    required this.value,
    required this.onChanged,
    this.min = 0,
    this.max = 999,
    this.allowDirectEntry = true,
    super.key,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int max;
  final bool allowDirectEntry;

  Future<void> _editValue(BuildContext context) async {
    final entered = await showDialog<int>(
      context: context,
      builder: (_) => _ValueEntryDialog(initialValue: value),
    );
    if (entered != null) onChanged(entered.clamp(min, max));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          onPressed: value > min ? () => onChanged(value - 1) : null,
          icon: const Icon(Icons.remove_circle_outline),
          color: AppColors.greenDarker,
          visualDensity: VisualDensity.compact,
        ),
        InkWell(
          onTap: allowDirectEntry ? () => _editValue(context) : null,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            constraints: const BoxConstraints(minWidth: 44),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.7),
              border: Border.all(color: AppColors.greenDarker),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              // Body font: the decorative header font renders digits as
              // ornaments (its zero looks like a beetle).
              style: AppTextStyles.markdownBody.copyWith(
                color: AppColors.brown,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: value < max ? () => onChanged(value + 1) : null,
          icon: const Icon(Icons.add_circle_outline),
          color: AppColors.greenDarker,
          visualDensity: VisualDensity.compact,
        ),
      ],
    );
  }
}
