import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/providers/game_setup_notifier.dart';
import 'package:companion_for_cacao/features/tile/tile_public_api.dart';
import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameSetupTilesScreen extends ConsumerWidget {
  const GameSetupTilesScreen({required this.gameSetup, super.key});

  final GameSetupStateEntity gameSetup;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Prefer the live state: applying a worker selection during preparation
    // re-runs the pipeline, and the route extra is only a snapshot taken
    // when the game was started.
    final liveSetup = ref.watch(gameSetupProvider).value ?? gameSetup;
    final filter = ref.watch(tileFilterProvider);
    final filteredTiles = liveSetup.tiles
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
              padding: AppSpacing.allS,
              child: TileListGrillWidget(customTiles: filteredTiles),
            ),
          ),
        ],
      ),
    );
  }
}
