import 'package:companion_for_cacao/config/routes/app_routes.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/score/domain/entities/score_state_entity.dart';
import 'package:companion_for_cacao/features/score/presentation/providers/score_notifier.dart';
import 'package:companion_for_cacao/features/score/presentation/widgets/steps/cacao_step_widget.dart';
import 'package:companion_for_cacao/features/score/presentation/widgets/steps/gems_step_widget.dart';
import 'package:companion_for_cacao/features/score/presentation/widgets/steps/gold_step_widget.dart';
import 'package:companion_for_cacao/features/score/presentation/widgets/steps/huts_step_widget.dart';
import 'package:companion_for_cacao/features/score/presentation/widgets/steps/setup_step_widget.dart';
import 'package:companion_for_cacao/features/score/presentation/widgets/steps/sun_step_widget.dart';
import 'package:companion_for_cacao/features/score/presentation/widgets/steps/temples_step_widget.dart';
import 'package:companion_for_cacao/features/score/presentation/utils/score_step_assets.dart';
import 'package:companion_for_cacao/features/score/presentation/widgets/steps/water_step_widget.dart';
import 'package:companion_for_cacao/shared/widgets/container_full_style_widget.dart';
import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:companion_for_cacao/shared/widgets/dialog_button_bar_widget.dart';
import 'package:companion_for_cacao/shared/widgets/safe_asset_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Step-by-step final score calculator. Steps adapt to the modules in play
/// and are prefilled from the active game when there is one.
class ScoreCalculatorScreen extends ConsumerWidget {
  const ScoreCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scoreProvider);
    final notifier = ref.read(scoreProvider.notifier);

    return CustomScaffoldWidget(
      title: 'Score Calculator',
      actions: [
        Tooltip(
          message: 'Start over',
          child: IconButton(
            onPressed: () => _confirmReset(context, notifier),
            icon: const Icon(Icons.refresh),
          ),
        ),
      ],
      body: ContainerFullStyleWidget(
        child: Column(
          children: [
            _StepHeader(state: state),
            AppSpacing.verticalS,
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _StepReferenceImage(step: state.currentStep),
                    _StepContent(step: state.currentStep),
                  ],
                ),
              ),
            ),
            AppSpacing.verticalS,
            _NavigationBar(state: state),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmReset(
    BuildContext context,
    ScoreNotifier notifier,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Start over?'),
        content: const Text(
          'This discards all entered scores and reloads players and modules '
          'from the current game setup.',
        ),
        actions: [
          DialogButtonBarWidget(
            onCancel: () => Navigator.of(dialogContext).pop(false),
            onConfirm: () => Navigator.of(dialogContext).pop(true),
            confirmLabel: 'Start over',
          ),
        ],
      ),
    );
    if (confirmed ?? false) notifier.reset();
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.state});

  final ScoreStateEntity state;

  @override
  Widget build(BuildContext context) {
    final steps = state.steps;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              state.currentStep.label,
              style: AppTextStyles.sectionTitlePlain.copyWith(fontSize: 18),
            ),
            Text(
              '${state.currentStepIndex + 1} / ${steps.length}',
              style: AppTextStyles.badgeCount,
            ),
          ],
        ),
        AppSpacing.verticalS,
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (state.currentStepIndex + 1) / steps.length,
            minHeight: 6,
            backgroundColor: AppColors.greenNormal,
            color: AppColors.greenDarker,
          ),
        ),
      ],
    );
  }
}

/// Picture of the physical component to count in the current step, when
/// one helps (village board for the water track, temple tile, etc.).
class _StepReferenceImage extends StatelessWidget {
  const _StepReferenceImage({required this.step});

  final ScoreStep step;

  @override
  Widget build(BuildContext context) {
    final asset = scoreStepReferenceImage(step);
    if (asset == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SafeAssetImage(
            assetPath: asset,
            height: 120,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class _StepContent extends StatelessWidget {
  const _StepContent({required this.step});

  final ScoreStep step;

  @override
  Widget build(BuildContext context) {
    return switch (step) {
      ScoreStep.setup => const SetupStepWidget(),
      ScoreStep.accumulatedGold => const GoldStepWidget(),
      ScoreStep.waterTrack => const WaterStepWidget(),
      ScoreStep.temples => const TemplesStepWidget(),
      ScoreStep.sunTokens => const SunStepWidget(),
      ScoreStep.cacaoFruits => const CacaoStepWidget(),
      ScoreStep.huts => const HutsStepWidget(),
      ScoreStep.gemMines => const GemsStepWidget(),
    };
  }
}

class _NavigationBar extends ConsumerWidget {
  const _NavigationBar({required this.state});

  final ScoreStateEntity state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(scoreProvider.notifier);
    final needsPlayers = !state.canCalculate;

    return Row(
      children: [
        if (state.currentStepIndex > 0)
          OutlinedButton.icon(
            onPressed: notifier.previousStep,
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back'),
          ),
        const Spacer(),
        if (needsPlayers)
          Text('Select at least 2 players', style: AppTextStyles.warningText)
        else if (state.isLastStep)
          FilledButton.icon(
            onPressed: () => context.push(AppRoutes.scoreResult),
            icon: const Icon(Icons.emoji_events),
            label: const Text('Results'),
          )
        else
          FilledButton.icon(
            onPressed: notifier.nextStep,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Next'),
          ),
      ],
    );
  }
}
