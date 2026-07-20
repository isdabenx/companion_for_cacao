import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/score/domain/entities/score_result_entity.dart';
import 'package:companion_for_cacao/features/score/presentation/providers/score_notifier.dart';
import 'package:companion_for_cacao/shared/widgets/circle_badge.dart';
import 'package:companion_for_cacao/shared/widgets/container_full_style_widget.dart';
import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Final standings with the winner(s) highlighted and the gold breakdown
/// per category for every player.
class ScoreResultScreen extends ConsumerWidget {
  const ScoreResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(scoreResultProvider);

    return CustomScaffoldWidget(
      title: 'Final Score',
      showBackButton: true,
      body: ContainerFullStyleWidget(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _WinnerBanner(result: result),
              AppSpacing.verticalL,
              for (final score in result.standings) ...[
                _PlayerScoreCard(score: score),
                AppSpacing.verticalS,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _WinnerBanner extends StatelessWidget {
  const _WinnerBanner({required this.result});

  final ScoreResultEntity result;

  @override
  Widget build(BuildContext context) {
    final names = result.winners.map((s) => s.player.displayName).join(' & ');

    final subtitle = result.sharedWin
        ? 'Shared victory! Tied on gold and leftover cacao.'
        : result.tiebreakByCacaoApplied
        ? 'Tie on gold broken by leftover cacao fruits.'
        : null;

    return Container(
      padding: AppSpacing.allL,
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.25),
        border: Border.all(color: AppColors.gold, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(Icons.emoji_events, size: 48, color: AppColors.gold),
          AppSpacing.verticalS,
          Text(
            names,
            textAlign: TextAlign.center,
            style: AppTextStyles.titleTextStyle.copyWith(fontSize: 26),
          ),
          Text(
            result.sharedWin ? 'win the game!' : 'wins the game!',
            style: AppTextStyles.markdownBody,
          ),
          if (subtitle != null) ...[
            AppSpacing.verticalS,
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.instruction,
            ),
          ],
        ],
      ),
    );
  }
}

class _PlayerScoreCard extends StatelessWidget {
  const _PlayerScoreCard({required this.score});

  final PlayerScoreEntity score;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: score.isWinner
          ? AppColors.gold.withValues(alpha: 0.15)
          : AppColors.white.withValues(alpha: 0.6),
      child: Padding(
        padding: AppSpacing.allM,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  '#${score.rank}',
                  style: AppTextStyles.sectionTitlePlain.copyWith(
                    fontSize: 20,
                    color: score.isWinner
                        ? AppColors.greenDarker
                        : AppColors.brown,
                  ),
                ),
                AppSpacing.horizontalM,
                CircleBadge(
                  color: AppColors.findColorByName(score.player.color),
                  size: 32,
                ),
                AppSpacing.horizontalS,
                Expanded(
                  child: Text(
                    score.player.displayName,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.markdownBody.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${score.total}',
                  // Body font: the decorative font renders digits (0
                  // especially) as ornaments.
                  style: AppTextStyles.markdownBody.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                AppSpacing.horizontalS,
                const Icon(Icons.paid, color: AppColors.gold),
              ],
            ),
            const Divider(color: AppColors.greenNormal),
            for (final entry in score.breakdown.entries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.key.label,
                        style: AppTextStyles.tileNameSmall,
                      ),
                    ),
                    Text(
                      '${entry.value}',
                      style: AppTextStyles.tileNameSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: entry.value < 0
                            ? AppColors.red
                            : AppColors.brown,
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Leftover cacao (tiebreaker)',
                      style: AppTextStyles.sectionSublabel,
                    ),
                  ),
                  Text(
                    '${score.cacaoFruits}',
                    style: AppTextStyles.sectionSublabel,
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
