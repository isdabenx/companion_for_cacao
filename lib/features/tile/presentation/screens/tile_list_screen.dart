import 'package:companion_for_cacao/features/tile/presentation/widgets/filter_icon_widget.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/settings_icon_widget.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/tile_list_grill_widget.dart';
import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:companion_for_cacao/shared/widgets/filter_active_chip.dart';
import 'package:flutter/material.dart';

class TileListScreen extends StatelessWidget {
  const TileListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      title: 'Tiles',
      actions: const [FilterIconWidget(), SettingsIconWidget()],
      body: Column(
        children: const [
          FilterActiveChip(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(8),
              child: TileListGrillWidget(),
            ),
          ),
        ],
      ),
    );
  }
}
