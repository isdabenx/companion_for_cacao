import 'dart:async';

import 'package:companion_for_cacao/config/routes/app_routes.dart';
import 'package:companion_for_cacao/features/tile/presentation/providers/tile_notifier.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/card_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

class TileListGrillWidget extends ConsumerStatefulWidget {
  const TileListGrillWidget({super.key});

  @override
  ConsumerState<TileListGrillWidget> createState() =>
      _TileListGrillWidgetState();
}

class _TileListGrillWidgetState extends ConsumerState<TileListGrillWidget>
    with TickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _initController(int itemCount) {
    if (_controller != null) return;
    final durationMs = (300 + (itemCount * 50)).clamp(0, 1500);
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: durationMs),
    )..forward();
  }

  @override
  Widget build(BuildContext context) {
    final tilesAsync = ref.watch(tileProvider);

    return tilesAsync.when(
      data: (tiles) {
        _initController(tiles.length);
        return LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = (constraints.maxWidth / 150).floor().clamp(
              2,
              6,
            );
            return MasonryGridView.count(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              itemCount: tiles.length,
              itemBuilder: (context, index) {
                final start = (index * 0.05).clamp(0.0, 0.7);
                final end = (start + 0.3).clamp(0.0, 1.0);
                final interval = Interval(start, end, curve: Curves.easeOut);

                final slideAnimation =
                    Tween<Offset>(
                      begin: const Offset(0, 0.3),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(parent: _controller!, curve: interval),
                    );

                final fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
                  CurvedAnimation(parent: _controller!, curve: interval),
                );

                return SlideTransition(
                  position: slideAnimation,
                  child: FadeTransition(
                    opacity: fadeAnimation,
                    child: GestureDetector(
                      key: ValueKey(tiles[index].id),
                      onTap: () {
                        unawaited(
                          context.push(
                            AppRoutes.tileDetail,
                            extra: tiles[index],
                          ),
                        );
                      },
                      child: CardTileWidget(tile: tiles[index]),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}
