import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/detailed_preparation_widget.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/detailed_summary_widget.dart';
import 'package:companion_for_cacao/features/tile/presentation/providers/tile_filter_notifier.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/filter_icon_widget.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/settings_icon_widget.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/tile_list_grill_widget.dart';
import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameSetupDetailScreen extends StatefulWidget {
  const GameSetupDetailScreen({required this.gameSetup, super.key});

  final GameSetupStateEntity gameSetup;

  @override
  State<GameSetupDetailScreen> createState() => _GameSetupDetailScreenState();
}

class _GameSetupDetailScreenState extends State<GameSetupDetailScreen>
    with SingleTickerProviderStateMixin {
  static final _tabs = ['Summary', 'Preparation', 'Tiles'];
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showActions = _tabController.index == 2;

    return CustomScaffoldWidget(
      actions: showActions
          ? const [FilterIconWidget(), SettingsIconWidget()]
          : null,
      title: 'Game Setup',
      showBackButton: true,
      appBarBottom: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.greenDarker,
        tabs: _tabs
            .map(
              (label) => Tab(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.boardgameTitlePlain.copyWith(
                    fontSize: 16,
                    shadows: [],
                  ),
                ),
              ),
            )
            .toList(),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          DetailedSummaryWidget(gameSetup: widget.gameSetup),
          DetailedPreparationWidget(preparation: widget.gameSetup.preparation),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Consumer(
              builder: (context, ref, _) {
                final filter = ref.watch(tileFilterProvider);
                final filteredTiles = widget.gameSetup.tiles
                    .where((t) => filter.matches(t))
                    .toList();

                return TileListGrillWidget(customTiles: filteredTiles);
              },
            ),
          ),
        ],
      ),
    );
  }
}
