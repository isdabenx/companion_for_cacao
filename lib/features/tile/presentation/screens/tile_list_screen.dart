import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/features/tile/domain/entities/tile_filter_scope.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/filter_icon_widget.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/settings_icon_widget.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/tile_list_grill_widget.dart';
import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/filter_active_chip.dart';
import 'package:flutter/material.dart';

class TileListScreen extends StatelessWidget {
  const TileListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: 'Tiles',
      actions: const [
        FilterIconWidget(scope: TileFilterScope.catalog),
        SettingsIconWidget(),
      ],
      body: Column(
        children: const [
          FilterActiveChip(scope: TileFilterScope.catalog),
          Expanded(
            child: Padding(
              padding: AppSpacing.allS,
              child: TileListGrillWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
