import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/core/theme/app_breakpoints.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/features/game_setup/domain/entities/game_setup_state_entity.dart';
import 'package:companion_for_cacao/shared/widgets/container_full_style_widget.dart';
import 'package:flutter/material.dart';

class DetailedSummaryWidget extends StatelessWidget {
  const DetailedSummaryWidget({required this.gameSetup, super.key});

  final GameSetupStateEntity gameSetup;

  @override
  Widget build(BuildContext context) {
    return ContainerFullStyleWidget(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= AppBreakpoints.compact;
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: isWide ? 16 : 12),
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
        _sectionDivider(),
        _buildExpansionsSection(),
        _sectionDivider(),
        _buildModulesSection(),
        _sectionDivider(),
        _buildTilesSection(),
      ],
    );
  }

  Widget _sectionDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
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
  }

  // ===== SECTIONS =====

  Widget _buildPlayersSection() {
    return Builder(
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(context, Icons.people_outline, 'Players'),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: gameSetup.players.isEmpty
                  ? _emptyText(context, 'No players selected')
                  : _buildPlayersGrid(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPlayersGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate columns based on width (~180px per player)
        final columns = (constraints.maxWidth / 180).floor().clamp(1, 4);
        final rows = (gameSetup.players.length / columns).ceil();

        return Table(
          columnWidths: {
            for (int i = 0; i < columns; i++) i: const FlexColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.top,
          children: [
            for (int row = 0; row < rows; row++)
              TableRow(
                children: [
                  for (int col = 0; col < columns; col++)
                    col < (gameSetup.players.length - row * columns)
                        ? Padding(
                            padding: EdgeInsets.only(
                              right: col < columns - 1 ? 12 : 0,
                              bottom: row < rows - 1 ? 8 : 0,
                            ),
                            child: _PlayerRow(
                              color: AppColors.findColorByName(
                                gameSetup.players[row * columns + col].color,
                              ),
                              name: gameSetup.players[row * columns + col].name,
                              position: row * columns + col + 1,
                            ),
                          )
                        : const SizedBox.shrink(),
                ],
              ),
          ],
        );
      },
    );
  }

  Widget _buildExpansionsSection() {
    return Builder(
      builder: (context) {
        // Filter out base game (id=1) - only show actual expansions
        final expansions = gameSetup.expansions
            .where((e) => e.id != 1)
            .toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(context, Icons.extension_outlined, 'Expansions'),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: expansions.isEmpty
                  ? _emptyText(context, 'Base game only')
                  : Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: expansions
                          .map(
                            (e) => _SmallChip(
                              icon: Icons.add_circle_outline,
                              label: e.name,
                            ),
                          )
                          .toList(),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildModulesSection() {
    return Builder(
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader(context, Icons.widgets_outlined, 'Modules'),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: gameSetup.modules.isEmpty
                  ? _emptyText(context, 'No modules')
                  : Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: gameSetup.modules
                          .map(
                            (m) => _SmallChip(
                              icon: Icons.check_circle_outline,
                              label: m.name,
                            ),
                          )
                          .toList(),
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTilesSection() {
    return Builder(
      builder: (context) {
        // Separate worker tiles (colored) from jungle tiles
        final workerTiles = gameSetup.tiles
            .where((t) => t.color != null)
            .toList();
        final jungleTiles = gameSetup.tiles
            .where((t) => t.color == null)
            .toList();
        final totalTiles = gameSetup.tiles.fold(
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
            const SizedBox(height: 8),
            if (gameSetup.tiles.isEmpty)
              _emptyText(context, 'No tiles')
            else ...[
              // Workers section
              if (workerTiles.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Workers', style: AppTextStyles.sectionSublabel),
                      const SizedBox(height: 8),
                      _buildTileGrid(workerTiles, showColorCircle: false),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
              // Jungle section
              if (jungleTiles.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Jungle', style: AppTextStyles.sectionSublabel),
                      const SizedBox(height: 8),
                      _buildTileGrid(jungleTiles),
                    ],
                  ),
                ),
              ],
            ],
          ],
        );
      },
    );
  }

  Widget _buildTileGrid(List<TileModel> tiles, {bool showColorCircle = true}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate columns based on available width (min ~150px per column)
        final columns = (constraints.maxWidth / 150).floor().clamp(2, 4);
        final rows = (tiles.length / columns).ceil();

        return Table(
          columnWidths: {
            for (int i = 0; i < columns; i++) i: const FlexColumnWidth(),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.top,
          children: [
            for (int row = 0; row < rows; row++)
              TableRow(
                children: [
                  for (int col = 0; col < columns; col++)
                    col < (tiles.length - row * columns)
                        ? Padding(
                            padding: EdgeInsets.only(
                              right: col < columns - 1 ? 12 : 0,
                              bottom: row < rows - 1 ? 8 : 0,
                            ),
                            child: _TileChip(
                              name: tiles[row * columns + col].name,
                              quantity: tiles[row * columns + col].quantity,
                              imagePath:
                                  tiles[row * columns + col].filenameImage,
                              color: tiles[row * columns + col].color != null
                                  ? AppColors.findColorByName(
                                      tiles[row * columns + col].color!.name,
                                    )
                                  : null,
                              showColorCircle: showColorCircle,
                            ),
                          )
                        : const SizedBox.shrink(),
                ],
              ),
          ],
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
        const SizedBox(width: 8),
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
        _ColorCircle(color: color, size: 28, position: position),
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

class _ColorCircle extends StatelessWidget {
  const _ColorCircle({
    required this.color,
    this.size = 32,
    this.showInitial = true,
    this.position = 0,
  });

  final Color color;
  final double size;
  final bool showInitial;
  final int position;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: AppColors.brown, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.brown.withValues(alpha: 0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: showInitial
          ? Center(
              child: Text(
                position.toString(),
                style: TextStyle(
                  color: _getContrastColor(color),
                  fontWeight: FontWeight.bold,
                  fontSize: size * 0.45,
                ),
              ),
            )
          : null,
    );
  }

  Color _getContrastColor(Color color) {
    return color.computeLuminance() > 0.5 ? AppColors.brown : AppColors.white;
  }
}

class _SmallChip extends StatelessWidget {
  const _SmallChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.greenLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.greenNormal, width: 1),
      ),
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Small tile image
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppColors.brown.withValues(alpha: 0.3)),
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
          _ColorCircle(color: color!, size: 14, showInitial: false),
          const SizedBox(width: 4),
        ],
        // Name (flexible to shrink)
        Flexible(
          child: Text(
            name,
            style: AppTextStyles.tileNameSmall,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
        const SizedBox(width: 4),
        // Quantity badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('×$quantity', style: AppTextStyles.badge),
        ),
      ],
    );
  }
}
