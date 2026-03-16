import 'dart:async';

import 'package:companion_for_cacao/config/routes/app_routes.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/tile/presentation/providers/tile_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StartButtonWidget extends ConsumerWidget {
  const StartButtonWidget({super.key});

  void _onStartButtonPressed(BuildContext context, WidgetRef ref) {
    ref.read(gameSetupProvider.notifier).startGame();
    final gameSetupState = ref.read(gameSetupProvider);
    ref.read(tileNotifierProvider.notifier).setTiles(gameSetupState.tiles);
    unawaited(context.push(AppRoutes.gameSetupDetail, extra: gameSetupState));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameSetupState = ref.watch(gameSetupProvider);
    final isStartButtonEnabled =
        gameSetupState.players
            .where((p) => p.isSelected && p.name.isNotEmpty)
            .length >=
        2;

    return ElevatedButton(
      onPressed: isStartButtonEnabled
          ? () => _onStartButtonPressed(context, ref)
          : null,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            child: Text(
              'Start Game',
              style: AppTextStyles.boardgameTitleTextStyle,
            ),
          ),
        ],
      ),
    );
  }
}
