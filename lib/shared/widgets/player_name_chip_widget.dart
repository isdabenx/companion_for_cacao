import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/core/utils/string_extensions.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:companion_for_cacao/shared/utils/player_display_l10n.dart';
import 'package:companion_for_cacao/shared/widgets/circle_badge.dart';
import 'package:companion_for_cacao/shared/widgets/selectable_chip.dart';
import 'package:companion_for_cacao/core/theme/app_shapes.dart';
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
    // Derive the glyph colour from the disc's luminance instead of listing
    // "dark" colours by name: red is dark enough to need a light glyph, and
    // the hardcoded list left its turn number in brown on red.
    final onColor = color.computeLuminance() > 0.5
        ? AppColors.brown
        : AppColors.white;
    const circleSize = 40.0;

    return SelectableChip(
      isSelected: widget.isSelected,
      selectedColor: color.withValues(alpha: 0.15),
      // White (the shared card surface) rather than the pale green fill: a
      // stack of large green blocks read as empty space and buried the
      // colour discs, which are the actual content here.
      unselectedColor: AppColors.surfaceCard,
      selectedBorderColor: color,
      unselectedBorderColor: Theme.of(context).colorScheme.outlineVariant,
      onTap: _onTap,
      // Disc beside the name instead of stacked above it: the cell hugs one
      // line of content, so four colours fit without dominating the screen.
      child: Row(
        children: [
          CircleBadge(
            color: color,
            size: circleSize,
            // A neutral hairline when idle (a grey theme outline muddied the
            // coloured discs), the contrast glyph colour once picked.
            borderColor: widget.isSelected
                ? onColor
                : AppColors.brown.withValues(alpha: 0.3),
            borderWidth: widget.isSelected ? 3 : 2,
            text: widget.isSelected && widget.position != null
                ? '${widget.position}'
                : null,
            icon: widget.isSelected
                ? (widget.position == null ? Icons.check : null)
                : Icons.add,
            // The disc is filled with the player colour in BOTH states, so the
            // glyph always follows the disc's luminance. The theme's grey left
            // the "+" nearly invisible on the dark purple and red discs.
            iconColor: onColor,
            iconSize: 20,
            textStyle: AppTextStyles.circlePosition.copyWith(color: onColor),
          ),
          AppSpacing.horizontalM,
          // Name field or colour label. Fixed height so the chip is exactly
          // the same size selected or not — no growth (score picker) and no
          // overflow (game-setup grid) when a color is picked.
          Expanded(
            child: SizedBox(
              height: 38,
              child: widget.isSelected
                  ? TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      onChanged: widget.onNameChanged,
                      style: AppTextStyles.playerName.copyWith(
                        color: AppColors.brown,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.s,
                          vertical: 6,
                        ),
                        filled: true,
                        fillColor: color.withValues(alpha: 0.18),
                        border: OutlineInputBorder(
                          borderRadius: AppShapes.radius(AppShapes.radiusS),
                          borderSide: BorderSide.none,
                        ),
                        hintText: AppLocalizations.of(context).playerNameHint,
                        hintStyle: AppTextStyles.hintText.copyWith(
                          color: AppColors.brown.withValues(alpha: 0.45),
                        ),
                      ),
                    )
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        localizedColorName(
                          AppLocalizations.of(context),
                          widget.colorString,
                        ).capitalized,
                        style: AppTextStyles.colorName,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
