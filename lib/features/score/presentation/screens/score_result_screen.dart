import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_breakpoints.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/score/domain/entities/score_result_entity.dart';
import 'package:companion_for_cacao/features/score/presentation/providers/score_notifier.dart';
import 'package:companion_for_cacao/features/score/presentation/utils/score_l10n.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:companion_for_cacao/shared/utils/player_display_l10n.dart';
import 'package:companion_for_cacao/shared/widgets/circle_badge.dart';
import 'package:companion_for_cacao/shared/widgets/container_full_style_widget.dart';
import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:companion_for_cacao/core/theme/app_shapes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Final standings with the winner(s) highlighted and the gold breakdown
/// per category for every player.
class ScoreResultScreen extends ConsumerWidget {
  const ScoreResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(scoreResultProvider);

    final banner = _WinnerBanner(result: result)
        .animate()
        .fadeIn(duration: 300.ms)
        .scaleXY(begin: 0.96, curve: Curves.easeOutBack);

    final standings = <Widget>[
      for (var i = 0; i < result.standings.length; i++) ...[
        _PlayerScoreCard(score: result.standings[i])
            .animate()
            .fadeIn(duration: 260.ms, delay: (120 + 80 * i).ms)
            .slideY(
              begin: 0.1,
              end: 0,
              duration: 260.ms,
              delay: (120 + 80 * i).ms,
              curve: Curves.easeOutCubic,
            ),
        AppSpacing.verticalS,
      ],
    ];

    return CustomScaffoldWidget(
      title: AppLocalizations.of(context).finalScoreTitle,
      showBackButton: true,
      // Uncapped: wide enough, the announcement and the numbers sit side by
      // side rather than one pushing the other off screen.
      contentWidth: ContentWidth.full,
      body: ContainerFullStyleWidget(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Stacked, the banner is the announcement *and* the wall between
            // you and the scores: it filled a landscape window on its own and
            // every breakdown started below the fold. Beside them it stays a
            // celebration and costs nobody their numbers.
            if (constraints.maxWidth < AppBreakpoints.mediumMin) {
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [banner, AppSpacing.verticalL, ...standings],
                ),
              );
            }

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: SingleChildScrollView(child: banner)),
                AppSpacing.horizontalL,
                Expanded(flex: 3, child: ListView(children: standings)),
              ],
            );
          },
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
    final l10n = AppLocalizations.of(context);
    final names = result.winners
        .map((s) => s.player.localizedDisplayName(l10n))
        .join(' & ');

    final subtitle = result.sharedWin
        ? l10n.sharedVictorySubtitle
        : result.tiebreakByCacaoApplied
        ? l10n.tiebreakSubtitle
        : null;

    return Container(
      padding: AppSpacing.allL,
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.25),
        border: Border.all(color: AppColors.gold, width: 2),
        borderRadius: AppShapes.radius(AppShapes.radiusL),
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
            result.sharedWin ? l10n.winsTheGameShared : l10n.winsTheGameSingle,
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
      // Winner cards wear a warm gold tint; the rest stay crisp white so
      // they read cleanly on the cream panel instead of muddy tan.
      color: score.isWinner
          ? AppColors.gold.withValues(alpha: 0.18)
          : AppColors.surfaceCard,
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
                    score.player.localizedDisplayName(
                      AppLocalizations.of(context),
                    ),
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
                        entry.key.localizedName(AppLocalizations.of(context)),
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
                      AppLocalizations.of(context).leftoverCacaoTiebreaker,
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
