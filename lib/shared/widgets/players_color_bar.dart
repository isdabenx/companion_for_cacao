import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// A thin segmented strip of the active players' colours — a supplementary
/// "who does this" cue for all-players preparation steps. It always pairs
/// with the step's text ("each player…"), so colour is never the only
/// signal (WCAG 1.4.1). A hairline outline keeps the whole strip (and a
/// white segment) legible on light surfaces.
class PlayersColorBar extends StatelessWidget {
  const PlayersColorBar({required this.colors, this.height = 4, super.key});

  final List<String> colors;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (colors.isEmpty) return const SizedBox.shrink();
    return Container(
      height: height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(height),
        border: Border.all(
          color: AppColors.brown.withValues(alpha: 0.45),
          width: 0.75,
        ),
      ),
      child: Row(
        // Stretch so each border-less segment fills the bar height —
        // otherwise a childless DecoratedBox collapses to zero height.
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final color in colors)
            Expanded(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.findColorByName(color),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
