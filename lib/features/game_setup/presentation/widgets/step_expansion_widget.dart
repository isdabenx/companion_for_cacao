import 'package:companion_for_cacao/shared/widgets/async_loading_widget.dart';
import 'package:companion_for_cacao/config/constants/game_constants.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/expansion_card_widget.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:companion_for_cacao/shared/providers/boardgame_notifier.dart';
import 'package:companion_for_cacao/shared/widgets/async_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Expansions as a vertical accordion: each expansion is a card that opens
/// on selection to reveal its cover and modules (see [ExpansionCardWidget]),
/// followed by the Big Game footer when both expansions are fully in play.
class StepExpansionWidget extends ConsumerWidget {
  const StepExpansionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final boardgamesAsync = ref.watch(boardgameProvider);

    return boardgamesAsync.when(
      data: (boardgames) {
        final expansions = boardgames
            .where((b) => b.id != GameConstants.baseGameId)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.m),
              child: Text(
                l10n.expansionSelectHint,
                style: AppTextStyles.instruction,
              ),
            ),
            for (final expansion in expansions)
              ExpansionCardWidget(
                key: ValueKey(expansion.id),
                expansion: expansion,
              ),
            const _BigGameFooter(),
          ],
        );
      },
      loading: () => const AsyncLoadingWidget(),
      error: (error, _) => AsyncErrorWidget(error: error),
    );
  }
}

class _BigGameFooter extends ConsumerWidget {
  const _BigGameFooter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canEnable = ref.watch(
      gameSetupProvider.select((s) => s.value?.canEnableBigGame ?? false),
    );
    if (!canEnable) return const SizedBox.shrink();

    final isBigGame = ref.watch(
      gameSetupProvider.select((s) => s.value?.isBigGame ?? false),
    );

    return Material(
      type: MaterialType.transparency,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(
          AppLocalizations.of(context).bigGame,
          style: AppTextStyles.bodyMedium,
        ),
        subtitle: Text(
          AppLocalizations.of(context).bigGameHint,
          style: AppTextStyles.sectionSublabel,
        ),
        trailing: Switch(
          value: isBigGame,
          activeTrackColor: AppColors.greenDark,
          inactiveTrackColor: AppColors.greenLight,
          onChanged: (value) =>
              ref.read(gameSetupProvider.notifier).setBigGame(value),
        ),
        onTap: () =>
            ref.read(gameSetupProvider.notifier).setBigGame(!isBigGame),
      ),
    );
  }
}
