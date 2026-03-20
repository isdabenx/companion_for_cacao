import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/shared/widgets/circle_badge.dart';
import 'package:companion_for_cacao/shared/widgets/selectable_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerChipWidget extends ConsumerStatefulWidget {
  const PlayerChipWidget({
    required this.colorString,
    required this.isSelected,
    this.position,
    super.key,
  });

  final String colorString;
  final bool isSelected;
  final int? position;

  @override
  ConsumerState<PlayerChipWidget> createState() => _PlayerChipWidgetState();
}

class _PlayerChipWidgetState extends ConsumerState<PlayerChipWidget> {
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
    final notifier = ref.read(gameSetupProvider.notifier);

    if (widget.isSelected) {
      _savedName = _controller.text;
      notifier.removePlayer(widget.colorString);
      _controller.clear();
    } else {
      final nameToUse = _savedName.isNotEmpty ? _savedName : _controller.text;
      notifier.addPlayer(nameToUse, widget.colorString);
      _controller.text = nameToUse;
      _savedName = '';
      _focusNode.requestFocus();
    }
  }

  void _onNameChanged(String name) {
    final notifier = ref.read(gameSetupProvider.notifier);
    notifier.removePlayer(widget.colorString);
    notifier.addPlayer(name, widget.colorString);
  }

  @override
  Widget build(BuildContext context) {
    final player = ref.watch(
      gameSetupProvider.select(
        (s) => s.value?.players.firstWhere(
          (p) => p.color == widget.colorString,
          orElse: () => PlayerEntity(name: '', color: widget.colorString),
        ),
      ),
    );

    final playerName = player?.name ?? '';
    if (_controller.text != playerName) {
      _controller.text = playerName;
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
          // Color circle with number inside
          CircleBadge(
            color: color,
            size: circleSize,
            borderColor: widget.isSelected
                ? (isDarkColor ? Colors.white : AppColors.brown)
                : Theme.of(context).colorScheme.outline,
            borderWidth: widget.isSelected ? 3 : 2,
            text: widget.isSelected && widget.position != null
                ? '${widget.position}'
                : null,
            icon: !(widget.isSelected && widget.position != null)
                ? Icons.add
                : null,
            iconColor: Theme.of(context).colorScheme.onSurfaceVariant,
            iconSize: 20,
            textStyle: AppTextStyles.circlePosition.copyWith(
              color: isDarkColor ? Colors.white : AppColors.brown,
            ),
          ),
          const SizedBox(height: 8),
          // Name field or placeholder
          SizedBox(
            width: 80,
            child: widget.isSelected
                ? TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    onChanged: _onNameChanged,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.playerName.copyWith(
                      color: isDarkColor ? Colors.white : AppColors.brown,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 4,
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
                        color: (isDarkColor ? Colors.white : AppColors.brown)
                            .withValues(alpha: 0.5),
                      ),
                    ),
                  )
                : Text(
                    _capitalize(widget.colorString),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.colorName,
                  ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}
