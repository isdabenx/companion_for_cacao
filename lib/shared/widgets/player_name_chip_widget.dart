import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/core/utils/string_extensions.dart';
import 'package:companion_for_cacao/shared/widgets/circle_badge.dart';
import 'package:companion_for_cacao/shared/widgets/selectable_chip.dart';
import 'package:flutter/material.dart';

/// A tappable player-color chip with an inline name field.
///
/// Owns the interaction behavior shared by every player picker (game setup,
/// score calculator): tapping toggles selection, activating focuses the name
/// field right away, and the last typed name is remembered so deselecting by
/// mistake doesn't lose it. State management stays with the caller via the
/// callbacks — this widget is purely presentational.
class PlayerNameChipWidget extends StatefulWidget {
  const PlayerNameChipWidget({
    required this.colorString,
    required this.isSelected,
    required this.name,
    required this.onActivated,
    required this.onDeactivated,
    required this.onNameChanged,
    this.position,
    super.key,
  });

  final String colorString;
  final bool isSelected;

  /// Current player name from the caller's state ('' when unnamed).
  final String name;

  /// Called with the name to use when the chip is selected.
  final ValueChanged<String> onActivated;

  final VoidCallback onDeactivated;
  final ValueChanged<String> onNameChanged;

  /// Optional 1-based turn position shown inside the color circle when
  /// selected; a check mark is shown instead when null.
  final int? position;

  @override
  State<PlayerNameChipWidget> createState() => _PlayerNameChipWidgetState();
}

class _PlayerNameChipWidgetState extends State<PlayerNameChipWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _savedName = '';

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTap() {
    if (widget.isSelected) {
      _savedName = _controller.text;
      widget.onDeactivated();
      _controller.clear();
    } else {
      final nameToUse = _savedName.isNotEmpty ? _savedName : _controller.text;
      widget.onActivated(nameToUse);
      _controller.text = nameToUse;
      _savedName = '';
      // Jump straight into the name field so typing can start immediately.
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.text != widget.name) {
      _controller.text = widget.name;
    }

    final color = AppColors.findColorByName(widget.colorString);
    final isDarkColor =
        widget.colorString == 'purple' || widget.colorString == 'black';
    const circleSize = 40.0;

    return SelectableChip(
      isSelected: widget.isSelected,
      selectedColor: color.withValues(alpha: 0.15),
      unselectedColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      selectedBorderColor: color,
      unselectedBorderColor: Theme.of(context).colorScheme.outlineVariant,
      onTap: _onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleBadge(
            color: color,
            size: circleSize,
            borderColor: widget.isSelected
                ? (isDarkColor ? AppColors.white : AppColors.brown)
                : Theme.of(context).colorScheme.outline,
            borderWidth: widget.isSelected ? 3 : 2,
            text: widget.isSelected && widget.position != null
                ? '${widget.position}'
                : null,
            icon: widget.isSelected
                ? (widget.position == null ? Icons.check : null)
                : Icons.add,
            iconColor: widget.isSelected
                ? (isDarkColor ? AppColors.white : AppColors.brown)
                : Theme.of(context).colorScheme.onSurfaceVariant,
            iconSize: 20,
            textStyle: AppTextStyles.circlePosition.copyWith(
              color: isDarkColor ? AppColors.white : AppColors.brown,
            ),
          ),
          AppSpacing.verticalS,
          // Name field or placeholder
          SizedBox(
            width: 80,
            child: widget.isSelected
                ? TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    onChanged: widget.onNameChanged,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.playerName.copyWith(
                      color: isDarkColor ? AppColors.white : AppColors.brown,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xs,
                        vertical: 6,
                      ),
                      filled: true,
                      fillColor: color.withValues(alpha: 0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Name',
                      hintStyle: AppTextStyles.hintText.copyWith(
                        color: (isDarkColor ? AppColors.white : AppColors.brown)
                            .withValues(alpha: 0.5),
                      ),
                    ),
                  )
                : Text(
                    widget.colorString.capitalized,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.colorName,
                  ),
          ),
        ],
      ),
    );
  }
}
