import 'package:companion_for_cacao/config/routes/app_routes.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/detailed_summary_widget.dart';
import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GameSetupDetailScreen extends StatelessWidget {
  const GameSetupDetailScreen({required this.gameSetup, super.key});

  final GameSetupStateEntity gameSetup;

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: 'Game Dashboard',
      showBackButton: true,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DetailedSummaryWidget(gameSetup: gameSetup),
          const SizedBox(height: 24),
          _DashboardCard(
            title: 'Preparation',
            icon: Icons.list_alt,
            onTap: () =>
                context.push(AppRoutes.gameSetupPreparation, extra: gameSetup),
          ),
          const SizedBox(height: 16),
          _DashboardCard(
            title: 'Tiles in Play',
            icon: Icons.grid_view,
            onTap: () =>
                context.push(AppRoutes.gameSetupTiles, extra: gameSetup),
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
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Row(
            children: [
              Icon(icon, size: 32, color: AppColors.greenDarker),
              const SizedBox(width: 20),
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
