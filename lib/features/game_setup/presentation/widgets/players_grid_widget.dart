import 'package:companion_for_cacao/config/constants/game_constants.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/player_chip_widget.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:companion_for_cacao/shared/widgets/selectable_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reorderable_grid/reorderable_grid.dart';

class PlayersGridWidget extends ConsumerWidget {
  const PlayersGridWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameSetupAsync = ref.watch(gameSetupProvider);
    final colorOrder =
        gameSetupAsync.value?.colorOrder ?? GameConstants.playerColorOrder;
    final selectedColors =
        gameSetupAsync.value?.players
            .where((p) => p.isSelected)
            .map((p) => p.color)
            .toSet() ??
        {};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Instruction text
        Text(
          AppLocalizations.of(context).tapColorHint,
          style: AppTextStyles.instruction,
        ),
        AppSpacing.verticalM,

        // All colors - reorderable. Two per row with a compact height that
        // hugs the content (matching the score-calculator player picker),
        // instead of tall square cells with wasted green space.
        LayoutBuilder(
          builder: (context, constraints) {
            final isLandscape =
                MediaQuery.sizeOf(context).width >
                MediaQuery.sizeOf(context).height;

            return ReorderableGridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppSpacing.s,
              crossAxisSpacing: AppSpacing.s,
              // Wide and short: the chip is now one row (disc + name), so a
              // tall cell would just re-introduce the dead space. The ratio
              // still has to clear the 40px colour disc plus the chip's
              // padding and border, or the disc (and the turn number inside
              // it) gets clipped.
              childAspectRatio: isLandscape ? 4.0 : 2.2,
              onReorder: (oldIndex, newIndex) {
                ref
                    .read(gameSetupProvider.notifier)
                    .reorderColorOrder(oldIndex, newIndex);
              },
              proxyDecorator: (child, index, animation) {
                // Return a simple colored box during drag to avoid layer conflicts
                final color = AppColors.findColorByName(colorOrder[index]);
                return SelectableChip(
                  isSelected: true,
                  selectedColor: color.withValues(alpha: 0.3),
                  selectedBorderColor: color,
                  selectedBorderWidth: 2,
                  borderRadius: 16,
                  showShadow: false,
                  child: const SizedBox.shrink(),
                );
              },
              children: [
                for (int i = 0; i < colorOrder.length; i++)
                  PlayerChipWidget(
                    key: ValueKey(colorOrder[i]),
                    colorString: colorOrder[i],
                    isSelected: selectedColors.contains(colorOrder[i]),
                    position: selectedColors.contains(colorOrder[i])
                        ? colorOrder
                                  .sublist(0, i)
                                  .where((c) => selectedColors.contains(c))
                                  .length +
                              1
                        : null,
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
