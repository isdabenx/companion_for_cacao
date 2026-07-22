import 'package:companion_for_cacao/config/routes/app_routes.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/detailed_summary_widget.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:companion_for_cacao/shared/widgets/action_card_widget.dart';
import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class GameSetupDetailScreen extends ConsumerWidget {
  const GameSetupDetailScreen({required this.gameSetup, super.key});

  final GameSetupStateEntity gameSetup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Prefer the live state: applying a worker selection during preparation
    // re-runs the pipeline, and the route extra is only a snapshot taken
    // when the game was started.
    final liveSetup = ref.watch(gameSetupProvider).value ?? gameSetup;

    return CustomScaffoldWidget(
      title: AppLocalizations.of(context).titleGameDashboard,
      showBackButton: true,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        children: [
          DetailedSummaryWidget(gameSetup: liveSetup),
          AppSpacing.verticalL,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
            child: ActionCardWidget(
              title: AppLocalizations.of(context).titlePreparation,
              icon: Icons.list_alt,
              onTap: () => context.push(
                AppRoutes.gameSetupPreparation,
                extra: liveSetup,
              ),
            ),
          ),
          AppSpacing.verticalM,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
            child: ActionCardWidget(
              title: AppLocalizations.of(context).tilesInPlay,
              icon: Icons.grid_view,
              onTap: () =>
                  context.push(AppRoutes.gameSetupTiles, extra: liveSetup),
            ),
          ),
          AppSpacing.verticalM,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
            child: ActionCardWidget(
              title: AppLocalizations.of(context).scoreCalculator,
              icon: Icons.calculate,
              // Prefilled from this game: starting a game resets any older
              // scoring session (see ScoreNotifier.build).
              onTap: () => context.push(AppRoutes.scoreCalculator),
            ),
          ),
          // Add more dashboard items here in the future
        ],
      ),
    );
  }
}
