import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/features/score/presentation/providers/score_notifier.dart';
import 'package:companion_for_cacao/features/score/presentation/widgets/count_stepper_widget.dart';
import 'package:companion_for_cacao/features/score/presentation/widgets/score_player_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Gold coins each player collected during the game.
class GoldStepWidget extends ConsumerWidget {
  const GoldStepWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scoreProvider);
    final notifier = ref.read(scoreProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Count the gold coins each player has. Tap the number for direct '
          'entry.',
          style: AppTextStyles.instruction,
        ),
        AppSpacing.verticalM,
        for (final player in state.players)
          ScorePlayerRowWidget(
            player: player,
            trailing: CountStepperWidget(
              value: state.inputOf(player.color).accumulatedGold,
              onChanged: (value) =>
                  notifier.setAccumulatedGold(player.color, value),
            ),
          ),
      ],
    );
  }
}
