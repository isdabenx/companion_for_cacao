import 'dart:async';

import 'package:companion_for_cacao/config/routes/app_routes.dart';
import 'package:companion_for_cacao/features/tile/presentation/providers/tile_notifier.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/card_tile_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

class TileListGrillWidget extends ConsumerStatefulWidget {
  const TileListGrillWidget({super.key});

  @override
  ConsumerState<TileListGrillWidget> createState() =>
      _TileListGrillWidgetState();
}

class _TileListGrillWidgetState extends ConsumerState<TileListGrillWidget> {
  @override
  Widget build(BuildContext context) {
    final tiles = ref.watch(tileProvider);

    return MasonryGridView.count(
      crossAxisCount: 3,
      crossAxisSpacing: 6,
      mainAxisSpacing: 6,
      itemCount: tiles.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          key: ValueKey(tiles[index].id),
          onTap: () {
            unawaited(context.push(AppRoutes.tileDetail, extra: tiles[index]));
          },
          child: CardTileWidget(tile: tiles[index]),
        );
      },
    );
  }
}
