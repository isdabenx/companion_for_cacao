import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/shared/widgets/player_name_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Game-setup player chip: binds [PlayerNameChipWidget] to the game setup
/// state, showing the turn position inside the color circle.
class PlayerChipWidget extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final playerName = ref.watch(
      gameSetupProvider.select(
        (s) => s.value?.players
            .where((p) => p.color == colorString)
            .map((p) => p.name)
            .firstOrNull,
      ),
    );
    final notifier = ref.read(gameSetupProvider.notifier);

    return PlayerNameChipWidget(
      colorString: colorString,
      isSelected: isSelected,
      name: playerName ?? '',
      position: position,
      onActivated: (name) => notifier.addPlayer(name, colorString),
      onDeactivated: () => notifier.removePlayer(colorString),
      // Update in place: remove+add would emit two states per keystroke and
      // the intermediate lower player count disables Big Game via
      // _resetBigGameIfInvalid.
      onNameChanged: (name) => notifier.updatePlayerName(colorString, name),
    );
  }
}
