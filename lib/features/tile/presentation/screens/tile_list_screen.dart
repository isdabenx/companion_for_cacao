import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/core/theme/app_breakpoints.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/features/tile/domain/entities/tile_filter_scope.dart';
import 'package:companion_for_cacao/features/tile/presentation/screens/tile_detail_screen.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/filter_icon_widget.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/settings_icon_widget.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/tile_list_grill_widget.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:companion_for_cacao/shared/utils/catalog_l10n.dart';
import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/filter_active_chip.dart';
import 'package:flutter/material.dart';

/// The tile catalogue, with the chosen tile beside it when there is room.
///
/// Narrow, tapping a tile is a trip to its own screen and back. Wide, it opens
/// a pane instead and the grid keeps its place — which is the difference
/// between glancing at one tile and comparing several, and comparing is what
/// people actually come here to do.
class TileListScreen extends StatefulWidget {
  const TileListScreen({super.key});

  @override
  State<TileListScreen> createState() => _TileListScreenState();
}

class _TileListScreenState extends State<TileListScreen> {
  TileEntity? _selected;

  /// The pane taking the whole width, for reading a long description or
  /// looking closely at the art without losing the selection.
  bool _detailExpanded = false;

  /// Below this the grid and a readable pane cannot both fit, so the detail
  /// goes back to being its own screen.
  static const double _twoPaneFrom = AppBreakpoints.mediumMin;

  void _select(TileEntity tile) => setState(() {
    // Choosing the tile already open closes the pane, so the same tap both
    // opens and dismisses.
    _selected = tile.id == _selected?.id ? null : tile;
    _detailExpanded = false;
  });

  void _close() => setState(() {
    _selected = null;
    _detailExpanded = false;
  });

  @override
  Widget build(BuildContext context) {
    return CustomScaffoldWidget(
      // A grid earns real columns from extra width, so it is not capped.
      contentWidth: ContentWidth.full,
      title: AppLocalizations.of(context).menuTiles,
      actions: const [
        FilterIconWidget(scope: TileFilterScope.catalog),
        SettingsIconWidget(),
      ],
      body: LayoutBuilder(
        builder: (context, constraints) {
          final twoPane = constraints.maxWidth >= _twoPaneFrom;
          final selected = _selected;

          // A pane cannot survive the window narrowing: the selection is kept,
          // but with nowhere to show it the grid goes back to navigating.
          final grid = TileListGrillWidget(
            onSelect: twoPane ? _select : null,
            selectedId: twoPane ? selected?.id : null,
          );

          if (!twoPane || selected == null) {
            return _CatalogueColumn(child: grid);
          }

          return Row(
            children: [
              if (!_detailExpanded)
                Expanded(flex: 3, child: _CatalogueColumn(child: grid)),
              Expanded(
                flex: _detailExpanded ? 1 : 2,
                child: _DetailPane(
                  tile: selected,
                  isExpanded: _detailExpanded,
                  onToggleExpanded: () =>
                      setState(() => _detailExpanded = !_detailExpanded),
                  onClose: _close,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CatalogueColumn extends StatelessWidget {
  const _CatalogueColumn({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const FilterActiveChip(scope: TileFilterScope.catalog),
        Expanded(
          child: Padding(padding: AppSpacing.allS, child: child),
        ),
      ],
    );
  }
}

/// The chosen tile, beside the grid.
///
/// Two controls, because there are two things you might want: out of the pane
/// entirely, or the pane on its own for a closer look. Neither is the system
/// back — nothing was pushed, so there is nothing to go back from.
class _DetailPane extends StatelessWidget {
  const _DetailPane({
    required this.tile,
    required this.isExpanded,
    required this.onToggleExpanded,
    required this.onClose,
  });

  final TileEntity tile;
  final bool isExpanded;
  final VoidCallback onToggleExpanded;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: AppSpacing.s,
            right: AppSpacing.xs,
            top: AppSpacing.xs,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  tile.type?.localizedName(l10n) ?? '',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              IconButton(
                tooltip: isExpanded
                    ? l10n.tilePaneCollapse
                    : l10n.tilePaneExpand,
                onPressed: onToggleExpanded,
                icon: Icon(
                  isExpanded ? Icons.close_fullscreen : Icons.open_in_full,
                  color: AppColors.brown,
                  size: 20,
                ),
              ),
              IconButton(
                tooltip: l10n.tilePaneClose,
                onPressed: onClose,
                icon: const Icon(Icons.close, color: AppColors.brown, size: 20),
              ),
            ],
          ),
        ),
        Expanded(
          // Keyed on the tile so switching selection rebuilds the pane rather
          // than mutating it in place, which keeps the hero art and the scroll
          // position from bleeding between two different tiles.
          child: TileDetailView(key: ValueKey(tile.id), tile: tile),
        ),
      ],
    );
  }
}
