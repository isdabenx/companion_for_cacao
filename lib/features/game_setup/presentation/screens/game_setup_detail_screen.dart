import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/detailed_preparation_widget.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/detailed_summary_widget.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/settings_icon_widget.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/tile_list_grill_widget.dart';
import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:flutter/material.dart';

class GameSetupDetailScreen extends StatelessWidget {
  const GameSetupDetailScreen({required this.gameSetup, super.key});

  final GameSetupStateEntity gameSetup;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: CustomScaffoldWidget(
        actions: const [SettingsIconWidget()],
        title: 'Game Setup',
        showBackButton: true,
        appBarBottom: TabBar(
          indicatorColor: AppColors.greenDarker,
          tabs: [
            Tab(
              child: Text(
                'Summary',
                textAlign: TextAlign.center,
                style: AppTextStyles.boardgameTitle.copyWith(fontSize: 16),
              ),
            ),
            Tab(
              child: Text(
                'Preparation',
                textAlign: TextAlign.center,
                style: AppTextStyles.boardgameTitle.copyWith(fontSize: 16),
              ),
            ),
            Tab(
              child: Text(
                'Tiles',
                textAlign: TextAlign.center,
                style: AppTextStyles.boardgameTitle.copyWith(fontSize: 16),
              ),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            DetailedSummaryWidget(gameSetup: gameSetup),
            DetailedPreparationWidget(preparation: gameSetup.preparation),
            const Padding(
              padding: EdgeInsets.all(8),
              child: TileListGrillWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
