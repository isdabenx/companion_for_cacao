import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/score/presentation/providers/score_notifier.dart';
import 'package:companion_for_cacao/features/score/presentation/widgets/count_stepper_widget.dart';
import 'package:companion_for_cacao/features/score/presentation/widgets/score_player_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Leftover cacao fruits (0-5). Worth no gold, but they break ties and feed
/// the Trader hut bonus.
class CacaoStepWidget extends ConsumerWidget {
  const CacaoStepWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scoreProvider);
    final notifier = ref.read(scoreProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Leftover cacao fruits give no gold, but they decide ties: with '
          'equal gold, the player with most cacao left wins.',
          style: AppTextStyles.instruction,
        ),
        AppSpacing.verticalM,
        for (final player in state.players)
          ScorePlayerRowWidget(
            player: player,
            trailing: CountStepperWidget(
              value: state.inputOf(player.color).cacaoFruits,
              max: 5,
              allowDirectEntry: false,
              onChanged: (value) =>
                  notifier.setCacaoFruits(player.color, value),
            ),
          ),
      ],
    );
  }
}
