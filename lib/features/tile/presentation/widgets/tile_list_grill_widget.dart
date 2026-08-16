import 'dart:async';

import 'package:companion_for_cacao/config/routes/app_routes.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_shapes.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/features/tile/presentation/providers/tile_notifier.dart';
import 'package:companion_for_cacao/features/tile/presentation/providers/tile_settings_notifier.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/card_tile_widget.dart';
import 'package:companion_for_cacao/shared/widgets/async_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';

class TileListGrillWidget extends ConsumerStatefulWidget {
  const TileListGrillWidget({
    super.key,
    this.customTiles,
    this.onSelect,
    this.selectedId,
  });

  final List<TileEntity>? customTiles;

  /// Given, a tap reports the tile instead of navigating — which is what a
  /// caller showing a detail pane wants, since there is nowhere to go.
  final void Function(TileEntity tile)? onSelect;

  /// Marked in the grid, so the pane's contents and the cell it came from
  /// stay visibly connected.
  final String? selectedId;

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
    if (widget.customTiles != null) {
      return _buildGrid(widget.customTiles!);
    }

    final tilesAsync = ref.watch(filteredTilesProvider);

    return tilesAsync.when(
      data: _buildGrid,
      loading: _buildLoadingSkeleton,
      error: (error, _) => AsyncErrorWidget(error: error),
    );
  }

  /// Shimmer skeleton in the shape of the grid while tiles load, instead of
  /// a bare spinner.
  Widget _buildLoadingSkeleton() {
    return Skeletonizer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = (constraints.maxWidth / 120.0).floor().clamp(
            2,
            8,
          );
          return AlignedGridView.count(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
            itemCount: crossAxisCount * 3,
            itemBuilder: (context, index) => const _TileSkeletonCard(),
          );
        },
      ),
    );
  }

  Widget _buildGrid(List<TileEntity> tiles) {
    _initController(tiles.length);
    final tileSettings = ref.watch(tileSettingsProvider.select((s) => s.value));

    return LayoutBuilder(
      builder: (context, constraints) {
        final useCompact = tileSettings?.compactTileLayout ?? true;
        final targetWidth = useCompact ? 120.0 : 150.0;
        final crossAxisCount = (constraints.maxWidth / targetWidth)
            .floor()
            .clamp(2, 8);

        return AlignedGridView.count(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
          itemCount: tiles.length,
          itemBuilder: (context, index) {
            final start = (index * 0.05).clamp(0.0, 0.7);
            final end = (start + 0.3).clamp(0.0, 1.0);
            final interval = Interval(start, end, curve: Curves.easeOut);

            final slideAnimation = Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: _controller!, curve: interval));

            final fadeAnimation = Tween<double>(
              begin: 0,
              end: 1,
            ).animate(CurvedAnimation(parent: _controller!, curve: interval));

            return SlideTransition(
              position: slideAnimation,
              child: FadeTransition(
                opacity: fadeAnimation,
                child: GestureDetector(
                  key: ValueKey(tiles[index].id),
                  // With a detail pane beside it the grid reports the choice
                  // and stays put; without one, tapping is a trip to the
                  // tile's own screen.
                  onTap: () {
                    final tile = tiles[index];
                    if (widget.onSelect != null) {
                      widget.onSelect!(tile);
                      return;
                    }
                    unawaited(context.push(AppRoutes.tileDetail, extra: tile));
                  },
                  child: _Selectable(
                    isSelected: tiles[index].id == widget.selectedId,
                    child: CardTileWidget(tile: tiles[index]),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

/// One placeholder card for the loading skeleton: a square image area over
/// a short name line, matching [CardTileWidget]'s silhouette.
class _TileSkeletonCard extends StatelessWidget {
  const _TileSkeletonCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppShapes.radiusS),
          bottomRight: Radius.circular(AppShapes.radiusS),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AspectRatio(
            aspectRatio: 1,
            child: ColoredBox(color: AppColors.greenNormal),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.s),
            child: Container(height: 12, color: AppColors.greenNormal),
          ),
        ],
      ),
    );
  }
}

/// A ring around the cell whose tile is showing in the detail pane.
///
/// Outside the card rather than over it: the tile art already carries a
/// coloured border of its own, and drawing on top of it would read as part of
/// the tile instead of as a state of the grid.
class _Selectable extends StatelessWidget {
  const _Selectable({required this.isSelected, required this.child});

  final bool isSelected;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.all(3),
      decoration: ShapeDecoration(
        shape: AppShapes.shape(AppShapes.radiusM).copyWith(
          side: BorderSide(
            color: isSelected ? AppColors.greenDarker : Colors.transparent,
            width: 3,
          ),
        ),
      ),
      child: child,
    );
  }
}
