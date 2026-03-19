import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/player_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reorderable_grid/reorderable_grid.dart';

class PlayersGridWidget extends ConsumerWidget {
  const PlayersGridWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameSetupAsync = ref.watch(gameSetupProvider);
    final colorOrder =
        gameSetupAsync.value?.colorOrder ?? AppColors.colors.keys.toList();
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
          'Tap a color to add a player',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.brown.withValues(alpha: 0.7),
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 12),

        // All colors - reorderable
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 400 ? 4 : 2;

            return ReorderableGridView.count(
              crossAxisCount: crossAxisCount,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.0,
              onReorder: (oldIndex, newIndex) {
                ref
                    .read(gameSetupProvider.notifier)
                    .reorderColorOrder(oldIndex, newIndex);
              },
              proxyDecorator: (child, index, animation) {
                // Return a simple colored box during drag to avoid layer conflicts
                final color = AppColors.findColorByName(colorOrder[index]);
                return Container(
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: color, width: 2),
                  ),
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
