import 'dart:async';

import 'package:companion_for_cacao/config/routes/app_routes.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StartButtonWidget extends ConsumerWidget {
  const StartButtonWidget({super.key});

  void _onStartButtonPressed(BuildContext context, WidgetRef ref) {
    ref.read(gameSetupProvider.notifier).startGame();
    final gameSetupValue = ref.read(gameSetupProvider).value;
    if (gameSetupValue != null) {
      unawaited(context.push(AppRoutes.gameSetupDetail, extra: gameSetupValue));
    }
  }

  void _onResumeButtonPressed(BuildContext context, WidgetRef ref) {
    final gameSetupValue = ref.read(gameSetupProvider).value;
    if (gameSetupValue != null) {
      unawaited(context.push(AppRoutes.gameSetupDetail, extra: gameSetupValue));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    // Two selected players are enough — a name is optional. Unnamed players
    // fall back to their color (PlayerEntity.displayName), matching how the
    // score calculator lets you proceed without typing names.
    final playersReady = ref.watch(
      gameSetupProvider.select(
        (s) => (s.value?.players.where((p) => p.isSelected).length ?? 0) >= 2,
      ),
    );

    // A selected expansion with no module picked adds nothing to the game, so
    // it blocks the start and we say why right here (the card also flags it).
    final hasIncompleteExpansion = ref.watch(
      gameSetupProvider.select((s) => s.value?.hasIncompleteExpansion ?? false),
    );

    final isStarted = ref.watch(
      gameSetupProvider.select((s) => s.value?.isStarted ?? false),
    );

    final isStartButtonEnabled = playersReady && !hasIncompleteExpansion;

    // A disabled button always explains itself. Players come first (the more
    // fundamental blocker); once they're in place we surface the expansion
    // gap. The reason line stays visible even when its section (players grid
    // or the flagged expansion card) is scrolled out of view.
    final String? disabledReason = !playersReady
        ? l10n.playersNeededHint
        : hasIncompleteExpansion
        ? l10n.expansionNeedsModuleHint
        : null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.l,
        0,
        AppSpacing.l,
        AppSpacing.s,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (disabledReason != null) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 18,
                  color: AppColors.warning,
                ),
                const SizedBox(width: AppSpacing.xs),
                Flexible(
                  child: Text(
                    disabledReason,
                    style: AppTextStyles.sectionSublabel.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            AppSpacing.verticalS,
          ],
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: isStartButtonEnabled
                  ? () => isStarted
                        ? _onResumeButtonPressed(context, ref)
                        : _onStartButtonPressed(context, ref)
                  : null,
              child: Text(
                isStarted ? l10n.resumeGame : l10n.startGame,
                style: AppTextStyles.boardgameTitlePlain.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
