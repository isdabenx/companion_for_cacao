import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayerRowWidget extends ConsumerStatefulWidget {
  const PlayerRowWidget({required this.colorString, super.key});

  final String colorString;

  @override
  ConsumerState<PlayerRowWidget> createState() => _PlayerRowWidgetState();
}

class _PlayerRowWidgetState extends ConsumerState<PlayerRowWidget> {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final player =
        ref.watch(
          gameSetupProvider.select(
            (s) => s.value?.players.firstWhere(
              (p) => p.color == widget.colorString,
              orElse: () => PlayerEntity(name: '', color: widget.colorString),
            ),
          ),
        ) ??
        PlayerEntity(name: '', color: widget.colorString);
    final gameSetupNotifier = ref.read(gameSetupProvider.notifier);

    // Sync controller with state when they differ (e.g. navigating back)
    if (player.isSelected && controller.text != player.name) {
      controller.text = player.name;
    }

    void onTogglePlayer() {
      final newSelected = !player.isSelected;
      gameSetupNotifier.updatePlayerSelection(
        widget.colorString,
        isSelected: newSelected,
      );
      if (newSelected) {
        gameSetupNotifier.addPlayer(controller.text, widget.colorString);
        focusNode.requestFocus();
      } else {
        gameSetupNotifier.removePlayer(widget.colorString);
      }
    }

    void onPlayerNameChanged(String name) {
      if (player.isSelected) {
        gameSetupNotifier
          ..removePlayer(widget.colorString)
          ..addPlayer(name, widget.colorString);
      }
    }

    void clearTextField() {
      controller.clear();
      onPlayerNameChanged('');
      focusNode.requestFocus();
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: onTogglePlayer,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: player.isSelected ? 36 : 30,
            height: player.isSelected ? 36 : 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.findColorByName(widget.colorString),
              border: Border.all(
                color: player.isSelected
                    ? AppColors.brown
                    : AppColors.greenNormal,
                width: player.isSelected ? 3 : 2,
              ),
              boxShadow: player.isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.brown.withValues(alpha: 0.4),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: AnimatedOpacity(
            opacity: player.isSelected ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: player.isSelected
                  ? TextField(
                      decoration: InputDecoration(
                        labelText: 'Player Name',
                        suffixIcon: controller.text.isNotEmpty
                            ? IconButton(
                                onPressed: clearTextField,
                                icon: const Icon(Icons.clear),
                              )
                            : null,
                      ),
                      controller: controller,
                      onChanged: onPlayerNameChanged,
                      focusNode: focusNode,
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ],
    );
  }
}
