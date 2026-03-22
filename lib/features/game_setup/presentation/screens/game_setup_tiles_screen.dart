import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/tile/presentation/providers/tile_filter_notifier.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/filter_icon_widget.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/settings_icon_widget.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/tile_list_grill_widget.dart';
import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:companion_for_cacao/shared/widgets/filter_active_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameSetupTilesScreen extends ConsumerWidget {
  const GameSetupTilesScreen({required this.gameSetup, super.key});

  final GameSetupStateEntity gameSetup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(tileFilterProvider);
    final filteredTiles = gameSetup.tiles
        .where((t) => filter.matches(t))
        .toList();

    return CustomScaffoldWidget(
      title: 'Tiles in Play',
      showBackButton: true,
      actions: const [FilterIconWidget(), SettingsIconWidget()],
      body: Column(
        children: [
          const FilterActiveChip(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TileListGrillWidget(customTiles: filteredTiles),
            ),
          ),
        ],
      ),
    );
  }
}
