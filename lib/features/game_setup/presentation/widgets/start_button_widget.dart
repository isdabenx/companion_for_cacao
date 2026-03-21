import 'dart:async';

import 'package:companion_for_cacao/config/routes/app_routes.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
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

  void _onClearSetupPressed(BuildContext context, WidgetRef ref) {
    ref.read(gameSetupProvider.notifier).clearAll();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isStartButtonEnabled = ref.watch(
      gameSetupProvider.select(
        (s) =>
            (s.value?.players
                    .where((p) => p.isSelected && p.name.isNotEmpty)
                    .length ??
                0) >=
            2,
      ),
    );

    final isStarted = ref.watch(
      gameSetupProvider.select((s) => s.value?.isStarted ?? false),
    );

    final hasAnyInput = ref.watch(
      gameSetupProvider.select((s) {
        final state = s.value;
        if (state == null) return false;
        // Check if any player has a name
        final hasPlayers = state.players.any((p) => p.name.isNotEmpty);
        // Check if any expansions beyond the base game are selected
        final hasExpansions = state.expansions.length > 1;
        return hasPlayers || hasExpansions;
      }),
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: isStartButtonEnabled
                  ? () => isStarted
                        ? _onResumeButtonPressed(context, ref)
                        : _onStartButtonPressed(context, ref)
                  : null,
              child: Text(
                isStarted ? 'Resume Game' : 'Start Game',
                style: AppTextStyles.boardgameTitlePlain.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          if (hasAnyInput) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => _onClearSetupPressed(context, ref),
                icon: const Icon(Icons.clear_all, size: 20),
                label: Text(
                  'Clear Setup',
                  style: AppTextStyles.boardgameTitlePlain.copyWith(
                    color: AppColors.red,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.red),
                  foregroundColor: AppColors.red,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
