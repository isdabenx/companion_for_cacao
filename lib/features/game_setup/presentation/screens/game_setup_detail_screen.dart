import 'package:companion_for_cacao/config/routes/app_routes.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/detailed_summary_widget.dart';
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
      title: 'Game Dashboard',
      showBackButton: true,
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        children: [
          DetailedSummaryWidget(gameSetup: liveSetup),
          AppSpacing.verticalXl,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
            child: _DashboardCard(
              title: 'Preparation',
              icon: Icons.list_alt,
              onTap: () => context.push(
                AppRoutes.gameSetupPreparation,
                extra: liveSetup,
              ),
            ),
          ),
          AppSpacing.verticalL,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
            child: _DashboardCard(
              title: 'Tiles in Play',
              icon: Icons.grid_view,
              onTap: () =>
                  context.push(AppRoutes.gameSetupTiles, extra: liveSetup),
            ),
          ),
          AppSpacing.verticalL,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
            child: _DashboardCard(
              title: 'Score Calculator',
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

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.xl,
            horizontal: AppSpacing.xl,
          ),
          child: Row(
            children: [
              Icon(icon, size: 32, color: AppColors.greenDarker),
              AppSpacing.horizontalXl,
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyles.boardgameTitlePlain.copyWith(
                    fontSize: 20,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.brown),
            ],
          ),
        ),
      ),
    );
  }
}
