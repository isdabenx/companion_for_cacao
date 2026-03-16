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
    final gameSetupState = ref.watch(gameSetupProvider);
    final gameSetupNotifier = ref.read(gameSetupProvider.notifier);

    final player = gameSetupState.players.firstWhere(
      (p) => p.color == widget.colorString,
      orElse: () => PlayerEntity(name: '', color: widget.colorString),
    );

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
          child: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.findColorByName(widget.colorString),
              border: Border.all(
                color: player.isSelected
                    ? AppColors.brown
                    : AppColors.greenNormal,
                width: 2,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Visibility(
            visible: player.isSelected,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: TextField(
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
            ),
          ),
        ),
      ],
    );
  }
}
