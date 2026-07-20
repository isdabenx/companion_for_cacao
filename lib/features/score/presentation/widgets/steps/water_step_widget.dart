import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/score/domain/services/score_calculator_service.dart';
import 'package:companion_for_cacao/features/score/presentation/providers/score_notifier.dart';
import 'package:companion_for_cacao/features/score/presentation/widgets/score_player_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Final water carrier position of each player on the village board track.
class WaterStepWidget extends ConsumerWidget {
  const WaterStepWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scoreProvider);
    final notifier = ref.read(scoreProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select the water field where each water carrier ended the game. '
          'Negative fields subtract gold.',
          style: AppTextStyles.instruction,
        ),
        AppSpacing.verticalM,
        for (final player in state.players)
          ScorePlayerRowWidget(
            player: player,
            below: Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (
                  var i = 0;
                  i < ScoreCalculatorService.waterTrackValues.length;
                  i++
                )
                  _WaterFieldChip(
                    value: ScoreCalculatorService.waterTrackValues[i],
                    isSelected:
                        state.inputOf(player.color).waterFieldIndex == i,
                    onTap: () => notifier.setWaterFieldIndex(player.color, i),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _WaterFieldChip extends StatelessWidget {
  const _WaterFieldChip({
    required this.value,
    required this.isSelected,
    required this.onTap,
  });

  final int value;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isNegative = value < 0;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        constraints: const BoxConstraints(minWidth: 40),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.greenDarker
              : AppColors.white.withValues(alpha: 0.6),
          border: Border.all(
            color: isNegative ? AppColors.red : AppColors.greenDarker,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          '$value',
          textAlign: TextAlign.center,
          style: AppTextStyles.badgeCount.copyWith(
            color: isSelected
                ? AppColors.white
                : (isNegative ? AppColors.red : AppColors.brown),
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
