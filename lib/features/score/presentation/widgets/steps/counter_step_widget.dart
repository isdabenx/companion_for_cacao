import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/score/domain/entities/player_score_input_entity.dart';
import 'package:companion_for_cacao/features/score/presentation/providers/score_notifier.dart';
import 'package:companion_for_cacao/features/score/presentation/widgets/count_stepper_widget.dart';
import 'package:companion_for_cacao/features/score/presentation/widgets/score_player_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A scoring step that is one number per player: an intro line, then a row
/// per player with a stepper.
///
/// Gold, sun tokens and leftover cacao were three files that differed only
/// in the intro, the field read and written, and the cap. The steps that are
/// *not* this shape — setup, temples, huts, gem mines, the water track —
/// keep their own widgets, because they are genuinely different.
class CounterStepWidget extends ConsumerWidget {
  const CounterStepWidget({
    required this.intro,
    required this.valueOf,
    required this.onChanged,
    this.max,
    super.key,
  });

  /// Already-localized instruction shown above the rows.
  final String intro;

  final int Function(PlayerScoreInputEntity input) valueOf;

  /// Takes (color, value) — [ScoreNotifier]'s setters match as tear-offs.
  final void Function(String color, int value) onChanged;

  /// Highest value the count can take, when the game caps it.
  final int? max;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scoreProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(intro, style: AppTextStyles.instruction),
        AppSpacing.verticalM,
        ScoreListCard(
          children: [
            for (final player in state.players)
              ScorePlayerRowWidget(
                player: player,
                trailing: CountStepperWidget(
                  value: valueOf(state.inputOf(player.color)),
                  max: max ?? CountStepperWidget.uncapped,
                  // A capped count is a handful of tokens, where the +/- is
                  // quicker than the keypad. An uncapped one (gold) can run
                  // into three figures, so it stays typable.
                  allowDirectEntry: max == null,
                  onChanged: (value) => onChanged(player.color, value),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
