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
    final gameSetupValue = ref.read(gameSetupProvider).value;
    if (gameSetupValue != null) {
      ref.read(tileProvider.notifier).setTiles(gameSetupValue.tiles);
      unawaited(context.push(AppRoutes.gameSetupDetail, extra: gameSetupValue));
    }
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

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: isStartButtonEnabled
              ? () => _onStartButtonPressed(context, ref)
              : null,
          child: Text(
            'Start Game',
            style: AppTextStyles.boardgameTitle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
