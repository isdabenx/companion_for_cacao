import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerChipWidget extends ConsumerStatefulWidget {
  const PlayerChipWidget({
    required this.colorString,
    required this.isSelected,
    super.key,
  });

  final String colorString;
  final bool isSelected;

  @override
  ConsumerState<PlayerChipWidget> createState() => _PlayerChipWidgetState();
}

class _PlayerChipWidgetState extends ConsumerState<PlayerChipWidget>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  String _savedName = ''; // Persist name when deselecting

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    if (widget.isSelected) {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(PlayerChipWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isSelected && !oldWidget.isSelected) {
      _animationController.forward();
      _focusNode.requestFocus();
    } else if (!widget.isSelected && oldWidget.isSelected) {
      _animationController.reverse();
    }
  }

  void _onTap() {
    final notifier = ref.read(gameSetupProvider.notifier);

    if (widget.isSelected) {
      // Save name before removing
      _savedName = _controller.text;
      notifier.removePlayer(widget.colorString);
      _controller.clear();
    } else {
      // Use saved name or controller text
      final nameToUse = _savedName.isNotEmpty ? _savedName : _controller.text;
      notifier.addPlayer(nameToUse, widget.colorString);
      _controller.text = nameToUse;
      _savedName = ''; // Clear saved name after use
      _animationController.forward();
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

    // Sync controller
    if (_controller.text != playerName) {
      _controller.text = playerName;
    }

    final color = AppColors.findColorByName(widget.colorString);
    final isDarkColor =
        widget.colorString == 'purple' || widget.colorString == 'black';

    return ScaleTransition(
      scale: _scaleAnimation,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
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
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
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
                  // Color circle
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: widget.isSelected ? 48 : 40,
                    height: widget.isSelected ? 48 : 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                      border: Border.all(
                        color: widget.isSelected
                            ? (isDarkColor ? Colors.white : AppColors.brown)
                            : Colors.grey.shade400,
                        width: widget.isSelected ? 3 : 2,
                      ),
                      boxShadow: widget.isSelected
                          ? [
                              BoxShadow(
                                color: color.withValues(alpha: 0.5),
                                blurRadius: 6,
                                spreadRadius: 1,
                              ),
                            ]
                          : [],
                    ),
                    child: !widget.isSelected
                        ? Icon(Icons.add, color: Colors.grey.shade600, size: 20)
                        : null,
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
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isDarkColor
                                  ? Colors.white
                                  : AppColors.brown,
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
                              hintStyle: TextStyle(
                                fontSize: 11,
                                color:
                                    (isDarkColor
                                            ? Colors.white
                                            : AppColors.brown)
                                        .withValues(alpha: 0.5),
                              ),
                            ),
                          )
                        : Text(
                            _capitalize(widget.colorString),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}
