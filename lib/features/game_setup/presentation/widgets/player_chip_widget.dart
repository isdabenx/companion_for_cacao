import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
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

    return Container(
      decoration: BoxDecoration(
        color: widget.isSelected
            ? color.withValues(alpha: 0.15)
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.isSelected ? color : Colors.grey.shade300,
          width: widget.isSelected ? 2.5 : 1.5,
        ),
        boxShadow: widget.isSelected
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
                ),
              ]
            : [],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Color circle with number inside
                Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    border: Border.all(
                      color: widget.isSelected
                          ? (isDarkColor ? Colors.white : AppColors.brown)
                          : Colors.grey.shade400,
                      width: widget.isSelected ? 3 : 2,
                    ),
                  ),
                  child: Center(
                    child: widget.isSelected && widget.position != null
                        ? Text(
                            '${widget.position}',
                            style: AppTextStyles.circlePosition.copyWith(
                              color: isDarkColor
                                  ? Colors.white
                                  : AppColors.brown,
                            ),
                          )
                        : Icon(
                            Icons.add,
                            color: Colors.grey.shade600,
                            size: 20,
                          ),
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
                              color:
                                  (isDarkColor ? Colors.white : AppColors.brown)
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
          ),
        ),
      ),
    );
  }

  String _capitalize(String s) =>
      s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
}
