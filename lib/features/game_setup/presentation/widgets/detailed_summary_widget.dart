import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/config/constants/game_constants.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/core/theme/app_breakpoints.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/features/tile/tile_public_api.dart';
import 'package:companion_for_cacao/shared/widgets/circle_badge.dart';
import 'package:companion_for_cacao/shared/widgets/container_full_style_widget.dart';
import 'package:companion_for_cacao/features/game_setup/presentation/widgets/responsive_grid_builder.dart';
import 'package:companion_for_cacao/shared/widgets/selectable_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailedSummaryWidget extends ConsumerStatefulWidget {
  const DetailedSummaryWidget({required this.gameSetup, super.key});

  final GameSetupStateEntity gameSetup;

  @override
  ConsumerState<DetailedSummaryWidget> createState() =>
      _DetailedSummaryWidgetState();
}

class _DetailedSummaryWidgetState extends ConsumerState<DetailedSummaryWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ContainerFullStyleWidget(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= AppBreakpoints.compact;
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              vertical: isWide ? AppSpacing.l : AppSpacing.m,
            ),
            child: _buildLayout(),
          );
        },
      ),
    );
  }

  Widget _buildLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPlayersSection(),
        _sectionDivider,
        _buildExpansionsSection(),
        _sectionDivider,
        _buildModulesSection(),
        if (widget.gameSetup.isBigGame) ...[
          _sectionDivider,
          _buildGameVariantSection(),
        ],
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          child: _isExpanded
              ? Column(children: [_sectionDivider, _buildTilesSection()])
              : const SizedBox.shrink(),
        ),
        AppSpacing.verticalS,
        Center(
          child: TextButton.icon(
            onPressed: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            icon: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
              color: AppColors.brown,
            ),
            label: Text(
              _isExpanded ? 'Hide Tiles' : 'Show All Tiles',
              style: AppTextStyles.boardgameTitlePlain.copyWith(
                color: AppColors.brown,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget get _sectionDivider => Container(
    height: 1,
    margin: const EdgeInsets.symmetric(vertical: AppSpacing.s),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          AppColors.greenNormal.withValues(alpha: 0),
          AppColors.greenNormal.withValues(alpha: 0.5),
          AppColors.greenNormal.withValues(alpha: 0),
        ],
      ),
    ),
  );

  // ===== SECTIONS =====

  Widget _buildPlayersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(context, Icons.people_outline, 'Players'),
        AppSpacing.verticalS,
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.s),
          child: widget.gameSetup.players.isEmpty
              ? _emptyText(context, 'No players selected')
              : _buildPlayersGrid(),
        ),
      ],
    );
  }

  Widget _buildPlayersGrid() {
    return ResponsiveGridBuilder(
      itemCount: widget.gameSetup.players.length,
      minItemWidth: 180.0,
      minColumns: 1,
      maxColumns: 4,
      horizontalSpacing: 12.0,
      verticalSpacing: 8.0,
      itemBuilder: (context, index) {
        final player = widget.gameSetup.players[index];
        return _PlayerRow(
          key: ValueKey('player_${player.color}'),
          color: AppColors.findColorByName(player.color),
          name: player.name,
          position: index + 1,
        );
      },
    );
  }

  Widget _buildExpansionsSection() {
    // Filter out base game (id=1) - only show actual expansions
    final expansions = widget.gameSetup.expansions
        .where((e) => e.id != GameConstants.baseGameId)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(context, Icons.extension_outlined, 'Expansions'),
        AppSpacing.verticalS,
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.s),
          child: expansions.isEmpty
              ? _emptyText(context, 'Base game only')
              : Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: expansions
                      .map(
                        (e) => _SmallChip(
                          key: ValueKey('expansion_${e.id}'),
                          icon: Icons.add_circle_outline,
                          label: e.name,
                        ),
                      )
                      .toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildModulesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(context, Icons.widgets_outlined, 'Modules'),
        AppSpacing.verticalS,
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.s),
          child: widget.gameSetup.modules.isEmpty
              ? _emptyText(context, 'No modules')
              : Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: widget.gameSetup.modules
                      .map(
                        (m) => _SmallChip(
                          key: ValueKey('module_${m.id}'),
                          icon: Icons.check_circle_outline,
                          label: m.name,
                        ),
                      )
                      .toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildGameVariantSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader(context, Icons.star_outline, 'Game Variant'),
        AppSpacing.verticalS,
        Padding(
          padding: const EdgeInsets.only(left: AppSpacing.s),
          child: _BigGameChip(),
        ),
      ],
    );
  }

  Widget _buildTilesSection() {
    // Separate worker tiles (colored) from jungle tiles
    final workerTiles = widget.gameSetup.tiles
        .where((t) => t.color != null)
        .toList();
    final hutTiles = widget.gameSetup.tiles
        .where((t) => t.color == null && t.type == TileType.hut)
        .toList();
    final jungleTiles = widget.gameSetup.tiles
        .where((t) => t.color == null && t.type != TileType.hut)
        .toList();
    final totalTiles = widget.gameSetup.tiles.fold(
      0,
      (sum, t) => sum + t.quantity,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _sectionHeader(
          context,
          Icons.grid_view_rounded,
          'Tiles',
          subtitle: '($totalTiles)',
        ),
        AppSpacing.verticalS,
        if (widget.gameSetup.tiles.isEmpty)
          _emptyText(context, 'No tiles')
        else ...[
          if (workerTiles.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.s),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Workers', style: AppTextStyles.sectionSublabel),
                  AppSpacing.verticalS,
                  _buildTileGrid(workerTiles, showColorCircle: false),
                  AppSpacing.verticalS,
                ],
              ),
            ),
          ],
          if (jungleTiles.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.s),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Jungle', style: AppTextStyles.sectionSublabel),
                  AppSpacing.verticalS,
                  _buildTileGrid(jungleTiles),
                  AppSpacing.verticalS,
                ],
              ),
            ),
          ],
          if (hutTiles.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.s),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Huts', style: AppTextStyles.sectionSublabel),
                  AppSpacing.verticalS,
                  _buildTileGrid(hutTiles),
                ],
              ),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildTileGrid(List<TileModel> tiles, {bool showColorCircle = true}) {
    final tileSettings = ref.watch(tileSettingsProvider.select((s) => s.value));
    final useCompact = tileSettings?.compactTileLayout ?? true;

    return ResponsiveGridBuilder(
      itemCount: tiles.length,
      minItemWidth: useCompact ? 120.0 : 150.0,
      minColumns: useCompact ? 3 : 2,
      maxColumns: 4,
      horizontalSpacing: 12.0,
      verticalSpacing: 8.0,
      itemBuilder: (context, index) {
        return _TileChip(
          name: tiles[index].name,
          quantity: tiles[index].quantity,
          imagePath: tiles[index].filenameImage,
          color: tiles[index].color != null
              ? AppColors.findColorByName(tiles[index].color!.name)
              : null,
          showColorCircle: showColorCircle,
        );
      },
    );
  }

  Widget _sectionHeader(
    BuildContext context,
    IconData icon,
    String title, {
    String? subtitle,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.greenDark),
        AppSpacing.horizontalS,
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        if (subtitle != null) ...[
          const SizedBox(width: 6),
          Text(subtitle, style: Theme.of(context).textTheme.labelSmall),
        ],
      ],
    );
  }

  Widget _emptyText(BuildContext context, String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppColors.brown.withValues(alpha: 0.5),
        fontStyle: FontStyle.italic,
      ),
    );
  }
}

// ===== HELPER WIDGETS =====

class _PlayerRow extends StatelessWidget {
  const _PlayerRow({
    super.key,
    required this.color,
    required this.name,
    required this.position,
  });

  final Color color;
  final String name;
  final int position;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleBadge(
          color: color,
          size: 28,
          text: position.toString(),
          borderColor: AppColors.brown,
          borderWidth: 2,
          boxShadow: [
            BoxShadow(
              color: AppColors.brown.withValues(alpha: 0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        const SizedBox(width: 10),
        Text(
          name.isNotEmpty ? name : 'Player $position',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.brown,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _SmallChip extends StatelessWidget {
  const _SmallChip({required this.icon, required this.label, super.key});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SelectableChip(
      isSelected: false,
      unselectedColor: AppColors.greenLight,
      unselectedBorderColor: AppColors.greenNormal,
      unselectedBorderWidth: 1,
      borderRadius: 16,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      showShadow: false,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.greenDarker),
          const SizedBox(width: 5),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _TileChip extends StatelessWidget {
  const _TileChip({
    required this.name,
    required this.quantity,
    required this.imagePath,
    this.color,
    this.showColorCircle = true,
  });

  final String name;
  final int quantity;
  final String imagePath;
  final Color? color;
  final bool showColorCircle;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 130;
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Small tile image
            Container(
              width: isCompact ? 28 : 32,
              height: isCompact ? 28 : 32,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: AppColors.brown.withValues(alpha: 0.3),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Image.asset(
                  '${Assets.imagesTilePath}$imagePath',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: AppColors.greenLight,
                      child: Icon(
                        Icons.image_outlined,
                        size: 16,
                        color: AppColors.brown.withValues(alpha: 0.5),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 6),
            // Color circle if applicable and enabled
            if (showColorCircle && color != null) ...[
              CircleBadge(
                color: color!,
                size: isCompact ? 12 : 14,
                borderColor: AppColors.brown,
                borderWidth: 2,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.brown.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              const SizedBox(width: AppSpacing.xs),
            ],
            // Name (flexible to shrink)
            Flexible(
              child: Text(
                name,
                style: isCompact
                    ? AppTextStyles.tileNameSmall.copyWith(fontSize: 11)
                    : AppTextStyles.tileNameSmall,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            // Quantity badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '×$quantity',
                style: isCompact
                    ? AppTextStyles.badge.copyWith(fontSize: 10)
                    : AppTextStyles.badge,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BigGameChip extends StatelessWidget {
  const _BigGameChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.gold, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star, size: 16, color: AppColors.gold),
          const SizedBox(width: 6),
          Text(
            'Big Game',
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.brown,
            ),
          ),
        ],
      ),
    );
  }
}
