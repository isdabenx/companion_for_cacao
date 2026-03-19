import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/player_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlayersGridWidget extends ConsumerWidget {
  const PlayersGridWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameSetupAsync = ref.watch(gameSetupProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Instruction text
        Text(
          'Tap a color to add a player',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.brown.withValues(alpha: 0.7),
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 12),

        // Grid of player chips
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.0,
          children: [
            for (final color in AppColors.colors.keys)
              PlayerChipWidget(
                colorString: color,
                isSelected:
                    (gameSetupAsync.value?.players.any(
                      (p) => p.color == color,
                    ) ??
                    false),
              ),
          ],
        ),
      ],
    );
  }
}
