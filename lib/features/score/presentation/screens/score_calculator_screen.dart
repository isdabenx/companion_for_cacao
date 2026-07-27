import 'package:companion_for_cacao/config/routes/app_routes.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_shapes.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/score/domain/entities/score_state_entity.dart';
import 'package:companion_for_cacao/features/score/presentation/providers/score_notifier.dart';
import 'package:companion_for_cacao/features/score/presentation/widgets/steps/counter_step_widget.dart';
import 'package:companion_for_cacao/features/score/presentation/widgets/steps/gems_step_widget.dart';
import 'package:companion_for_cacao/features/score/presentation/widgets/steps/huts_step_widget.dart';
import 'package:companion_for_cacao/features/score/presentation/widgets/steps/setup_step_widget.dart';
import 'package:companion_for_cacao/features/score/presentation/widgets/steps/temples_step_widget.dart';
import 'package:companion_for_cacao/features/score/presentation/utils/score_l10n.dart';
import 'package:companion_for_cacao/features/score/presentation/utils/score_step_assets.dart';
import 'package:companion_for_cacao/features/score/presentation/widgets/steps/water_step_widget.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:companion_for_cacao/shared/widgets/container_full_style_widget.dart';
import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:companion_for_cacao/shared/utils/player_display_l10n.dart';
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
    final gameActive = ref.watch(
      gameSetupProvider.select((s) => s.value?.isStarted ?? false),
    );
    final l10n = AppLocalizations.of(context);

    // Reached by push from the game dashboard, or as a root destination from
    // Home, which replaces the stack. The two are different tools: from the
    // board this is *the game's* scoreboard, from Home it is a calculator
    // that happens to know about the game. It decides both the leading
    // button and what "start over" is allowed to mean.
    final fromGameBoard = context.canPop();

    return CustomScaffoldWidget(
      title: l10n.scoreCalculator,
      showBackButton: fromGameBoard,
      actions: [
        Tooltip(
          message: l10n.startOverAction,
          child: IconButton(
            onPressed: () => _confirmReset(
              context,
              notifier,
              gameActive: gameActive,
              fromGameBoard: fromGameBoard,
            ),
            icon: const Icon(Icons.refresh),
          ),
        ),
      ],
      body: ContainerFullStyleWidget(
        child: Column(
          children: [
            if (gameActive) ...[
              _ContextBanner(state: state, notifier: notifier),
              AppSpacing.verticalS,
            ],
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
    ScoreNotifier notifier, {
    required bool gameActive,
    required bool fromGameBoard,
  }) async {
    final l10n = AppLocalizations.of(context);

    // Opened from the game board: this screen is that game's scoreboard, so
    // the only thing "start over" can mean is scoring it again. Emptying the
    // calculator would detach it from the game the player navigated in from
    // — that belongs to the calculator reached from Home.
    if (gameActive && fromGameBoard) {
      final confirmed = await _confirm(
        context,
        body: l10n.startOverBody,
        confirmLabel: l10n.scoreResetGameOption,
      );
      if (confirmed) notifier.resetToGame();
      return;
    }

    // No game running: nothing to reload from, so reset just empties.
    if (!gameActive) {
      final confirmed = await _confirm(
        context,
        body: l10n.scoreClearBlankBody,
        confirmLabel: l10n.startOverAction,
      );
      if (confirmed) notifier.clearToBlank();
      return;
    }

    // Opened from Home with a game running: the standalone calculator, so
    // both readings are on the table — rescore the game, or take it away
    // for a separate calculation.
    final choice = await showDialog<_ResetChoice>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.startOverTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.scoreResetChooseBody, style: AppTextStyles.markdownBody),
            AppSpacing.verticalM,
            FilledButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(_ResetChoice.game),
              child: Text(l10n.scoreResetGameOption),
            ),
            AppSpacing.verticalS,
            OutlinedButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(_ResetChoice.blank),
              child: Text(l10n.scoreClearBlankOption),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(l10n.cancelAction),
          ),
        ],
      ),
    );
    switch (choice) {
      case _ResetChoice.game:
        notifier.resetToGame();
      case _ResetChoice.blank:
        notifier.clearToBlank();
      case null:
        break;
    }
  }

  /// A yes/no confirmation under the "start over" title, shared by the two
  /// single-action shapes of the reset.
  Future<bool> _confirm(
    BuildContext context, {
    required String body,
    required String confirmLabel,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(dialogContext).startOverTitle),
        content: Text(body),
        actions: [
          DialogButtonBarWidget(
            onCancel: () => Navigator.of(dialogContext).pop(false),
            onConfirm: () => Navigator.of(dialogContext).pop(true),
            confirmLabel: confirmLabel,
          ),
        ],
      ),
    );
    return confirmed ?? false;
  }
}

enum _ResetChoice { game, blank }

/// Tells the player which session they are looking at while a game is
/// running: the game's scoring, or a separate scratch calculation they can
/// return from with one tap.
class _ContextBanner extends StatelessWidget {
  const _ContextBanner({required this.state, required this.notifier});

  final ScoreStateEntity state;
  final ScoreNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final onGame = state.prefilledFromGame;

    final label = onGame ? l10n.scoreContextGame : l10n.scoreContextDetached;
    final detail = onGame
        ? state.players.map((p) => p.localizedDisplayName(l10n)).join(', ')
        : null;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      decoration: BoxDecoration(
        color: AppColors.greenDarker.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppShapes.radiusM),
      ),
      child: Row(
        children: [
          Icon(
            onGame ? Icons.sports_esports_outlined : Icons.calculate_outlined,
            size: 18,
            color: AppColors.greenDarker,
          ),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.sectionSublabel.copyWith(
                    color: AppColors.greenDarker,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (detail != null && detail.isNotEmpty)
                  Text(detail, style: AppTextStyles.sectionSublabel),
              ],
            ),
          ),
          if (!onGame)
            TextButton(
              onPressed: notifier.resetToGame,
              child: Text(l10n.scoreBackToGameAction),
            ),
        ],
      ),
    );
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
              state.currentStep.localizedName(AppLocalizations.of(context)),
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

class _StepContent extends ConsumerWidget {
  const _StepContent({required this.step});

  final ScoreStep step;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(scoreProvider.notifier);

    return switch (step) {
      ScoreStep.setup => const SetupStepWidget(),
      // The three one-number-per-player steps share a widget, so their whole
      // configuration is visible here rather than in three near-identical
      // files. Caps come from the village board: 3 sun-worshiping places and
      // 5 cacao storage spaces. Gold is uncapped.
      ScoreStep.accumulatedGold => CounterStepWidget(
        intro: l10n.scoreGoldIntro,
        valueOf: (input) => input.accumulatedGold,
        onChanged: notifier.setAccumulatedGold,
      ),
      ScoreStep.sunTokens => CounterStepWidget(
        intro: l10n.scoreSunIntro,
        valueOf: (input) => input.sunTokens,
        onChanged: notifier.setSunTokens,
        max: 3,
      ),
      ScoreStep.cacaoFruits => CounterStepWidget(
        intro: l10n.scoreCacaoIntro,
        valueOf: (input) => input.cacaoFruits,
        onChanged: notifier.setCacaoFruits,
        max: 5,
      ),
      ScoreStep.waterTrack => const WaterStepWidget(),
      ScoreStep.temples => const TemplesStepWidget(),
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
    final l10n = AppLocalizations.of(context);

    return Row(
      children: [
        if (state.currentStepIndex > 0)
          OutlinedButton.icon(
            onPressed: notifier.previousStep,
            icon: const Icon(Icons.arrow_back),
            label: Text(l10n.backAction),
          ),
        const Spacer(),
        if (needsPlayers)
          Text(l10n.needTwoPlayers, style: AppTextStyles.warningText)
        else if (state.isLastStep)
          FilledButton.icon(
            onPressed: () => context.push(AppRoutes.scoreResult),
            icon: const Icon(Icons.emoji_events),
            label: Text(l10n.resultsAction),
          )
        else
          FilledButton.icon(
            onPressed: notifier.nextStep,
            icon: const Icon(Icons.arrow_forward),
            label: Text(l10n.nextAction),
          ),
      ],
    );
  }
}
