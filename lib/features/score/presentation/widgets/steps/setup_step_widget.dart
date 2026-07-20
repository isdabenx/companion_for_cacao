import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/score/presentation/providers/score_notifier.dart';
import 'package:companion_for_cacao/shared/widgets/player_name_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// First step: who played and which score-relevant modules were in play.
/// Prefilled from the active game when there is one.
class SetupStepWidget extends ConsumerWidget {
  const SetupStepWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scoreProvider);
    final notifier = ref.read(scoreProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select the players of the finished game.',
          style: AppTextStyles.instruction,
        ),
        AppSpacing.verticalM,
        Wrap(
          spacing: AppSpacing.s,
          runSpacing: AppSpacing.s,
          children: [
            for (final color in AppColors.colors.keys)
              PlayerNameChipWidget(
                colorString: color,
                isSelected: state.players.any((p) => p.color == color),
                name:
                    state.players
                        .where((p) => p.color == color)
                        .map((p) => p.name)
                        .firstOrNull ??
                    '',
                onActivated: (name) => notifier.addPlayer(name, color),
                onDeactivated: () => notifier.removePlayer(color),
                onNameChanged: (name) => notifier.updatePlayerName(color, name),
              ),
          ],
        ),
        AppSpacing.verticalXl,
        Text(
          'Modules that change the final scoring:',
          style: AppTextStyles.instruction,
        ),
        AppSpacing.verticalS,
        // ListTiles paint ink on the nearest Material; without this the
        // decorated container behind them triggers a framework assertion.
        Material(
          type: MaterialType.transparency,
          child: Column(
            children: [
              SwitchListTile(
                value: state.hutModuleActive,
                onChanged: notifier.setHutModuleActive,
                activeThumbColor: AppColors.greenDarker,
                title: Text('Hut Module', style: AppTextStyles.markdownBody),
                subtitle: Text(
                  'Chocolatl: built huts refund their cost and give bonuses',
                  style: AppTextStyles.sectionSublabel,
                ),
                contentPadding: EdgeInsets.zero,
              ),
              SwitchListTile(
                value: state.gemMinesActive,
                onChanged: notifier.setGemMinesActive,
                activeThumbColor: AppColors.greenDarker,
                title: Text('The Gem Mines', style: AppTextStyles.markdownBody),
                subtitle: Text(
                  'Diamante: gem mines replace the temples',
                  style: AppTextStyles.sectionSublabel,
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
