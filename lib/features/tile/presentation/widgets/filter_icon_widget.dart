import 'package:companion_for_cacao/features/tile/presentation/widgets/tile_filter_bottom_sheet_widget.dart';
import 'package:flutter/material.dart';

class FilterIconWidget extends StatelessWidget {
  const FilterIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.filter_list),
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          showDragHandle: true,
          builder: (context) {
            return const TileFilterBottomSheetWidget();
          },
        );
      },
    );
  }
}
