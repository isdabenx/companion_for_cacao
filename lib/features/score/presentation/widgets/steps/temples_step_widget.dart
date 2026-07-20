import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/score/domain/services/score_calculator_service.dart';
import 'package:companion_for_cacao/features/score/presentation/providers/score_notifier.dart';
import 'package:companion_for_cacao/features/score/presentation/widgets/count_stepper_widget.dart';
import 'package:companion_for_cacao/features/score/presentation/widgets/score_player_row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// One card per temple on the board: adjacent workers per player, with a
/// live preview of the 6/3 gold distribution (official tie rules applied).
class TemplesStepWidget extends ConsumerWidget {
  const TemplesStepWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scoreProvider);
    final notifier = ref.read(scoreProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add one entry per temple and count the workers adjacent to it. '
          'Gold is awarded automatically: 6 for first place, 3 for second, '
          'ties split rounded down.',
          style: AppTextStyles.instruction,
        ),
        AppSpacing.verticalM,
        for (var i = 0; i < state.temples.length; i++)
          _TempleCard(index: i, templeId: state.temples[i].id),
        AppSpacing.verticalS,
        Center(
          child: OutlinedButton.icon(
            onPressed: notifier.addTemple,
            icon: const Icon(Icons.add),
            label: const Text('Add temple'),
          ),
        ),
      ],
    );
  }
}

class _TempleCard extends ConsumerWidget {
  const _TempleCard({required this.index, required this.templeId});

  final int index;
  final int templeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scoreProvider);
    final notifier = ref.read(scoreProvider.notifier);
    final temple = state.temples.firstWhere((t) => t.id == templeId);
    final gold = const ScoreCalculatorService().scoreTemple(temple);

    return Card(
      color: AppColors.white.withValues(alpha: 0.6),
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Padding(
        padding: AppSpacing.allM,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.temple_hindu, color: AppColors.greenDarker),
                AppSpacing.horizontalS,
                Expanded(
                  child: Text(
                    'Temple ${index + 1}',
                    style: AppTextStyles.sectionTitlePlain,
                  ),
                ),
                IconButton(
                  onPressed: () => notifier.removeTemple(templeId),
                  icon: const Icon(Icons.delete_outline, color: AppColors.red),
                  tooltip: 'Remove temple',
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
            for (final player in state.players)
              ScorePlayerRowWidget(
                player: player,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if ((gold[player.color] ?? 0) > 0) ...[
                      Text(
                        '+${gold[player.color]}',
                        style: AppTextStyles.badgeCount.copyWith(
                          color: AppColors.greenDarker,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      AppSpacing.horizontalS,
                    ],
                    CountStepperWidget(
                      value: temple.workersOf(player.color),
                      max: 20,
                      allowDirectEntry: false,
                      onChanged: (value) => notifier.setTempleWorkers(
                        templeId,
                        player.color,
                        value,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
