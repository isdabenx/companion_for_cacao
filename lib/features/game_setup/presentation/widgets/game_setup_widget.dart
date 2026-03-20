import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_step_provider.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/start_button_widget.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/step_expansion_widget.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/step_module_widget.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/step_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameSetupWidget extends ConsumerWidget {
  const GameSetupWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = ref.watch(gameSetupStepProvider);
    final gameSetupAsync = ref.watch(gameSetupProvider);
    final screenHeight = MediaQuery.sizeOf(context).height;
    final selectedCount = gameSetupAsync.value?.players.length ?? 0;

    // Adaptive heights
    const double baseHeightAllExpansions = 180;
    const double baseHeightExpansion = 140;
    final heightAllExpansions = screenHeight > 400
        ? baseHeightAllExpansions
        : baseHeightAllExpansions * 0.75;
    final heightExpansion = screenHeight > 400
        ? baseHeightExpansion
        : baseHeightExpansion * 0.75;
    final widthExpansion = heightExpansion * 0.72;

    return gameSetupAsync.when(
      data: (_) => Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Stepper(
              stepIconMargin: EdgeInsets.zero,
              connectorColor: const WidgetStatePropertyAll(
                AppColors.greenDarker,
              ),
              currentStep: currentStep,
              onStepTapped: (step) {
                ref.read(gameSetupStepProvider.notifier).setStep(step);
              },
              controlsBuilder: (_, details) => const SizedBox.shrink(),
              steps: [
                Step(
                  title: Row(
                    children: [
                      Text('Players', style: AppTextStyles.sectionTitlePlain),
                      const SizedBox(width: 8),
                      // Player count badge
                      Container(
                        constraints: const BoxConstraints(minWidth: 52),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.greenDarker.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.people,
                              size: 14,
                              color: AppColors.greenDarker,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$selectedCount/4',
                              style: AppTextStyles.badgeCount,
                            ),
                          ],
                        ),
                      ),
                      if (selectedCount < 2) ...[
                        const SizedBox(width: 6),
                        Container(
                          constraints: const BoxConstraints(minWidth: 48),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Need ${2 - selectedCount}+',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.warningText,
                          ),
                        ),
                      ],
                    ],
                  ),
                  content: const StepPlayerWidget(),
                ),
                Step(
                  title: Text(
                    'Expansions (work in progress)',
                    style: AppTextStyles.sectionTitlePlain,
                  ),
                  content: StepExpansionWidget(
                    heightAllExpansions: heightAllExpansions,
                    heightExpansion: heightExpansion,
                    widthExpansion: widthExpansion,
                  ),
                ),
                Step(
                  title: Text(
                    'Modules (work in progress)',
                    style: AppTextStyles.sectionTitlePlain,
                  ),
                  content: const StepModuleWidget(),
                ),
              ],
            ),
          ),
          const StartButtonWidget(),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
