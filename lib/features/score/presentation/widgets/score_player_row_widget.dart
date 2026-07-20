import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/player_entity.dart';
import 'package:companion_for_cacao/shared/widgets/circle_badge.dart';
import 'package:flutter/material.dart';

/// A labeled row for one player in a score step: color badge + name on the
/// left, an input control ([trailing]) on the right, or full-width content
/// ([below]) underneath.
class ScorePlayerRowWidget extends StatelessWidget {
  const ScorePlayerRowWidget({
    required this.player,
    this.trailing,
    this.below,
    super.key,
  });

  final PlayerEntity player;
  final Widget? trailing;
  final Widget? below;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleBadge(
                color: AppColors.findColorByName(player.color),
                size: 28,
              ),
              AppSpacing.horizontalS,
              Expanded(
                child: Text(
                  player.displayName,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.markdownBody.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
          if (below != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: below,
            ),
        ],
      ),
    );
  }
}
