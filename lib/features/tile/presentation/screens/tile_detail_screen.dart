import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_markdown_style_sheet.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/shared/widgets/container_full_style_widget.dart';
import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TileDetailScreen extends ConsumerWidget {
  const TileDetailScreen({required this.tile, super.key});

  final TileModel tile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScaffoldWidget(
      showBackButton: true,
      title: tile.typeAsString,
      body: ContainerFullStyleWidget(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: tile.color == null
                        ? AppColors.tileBorder
                        : AppColors.findColorByName(
                            tile.color.toString().split('.').last,
                          ),
                    width: 4,
                  ),
                ),
                child: Hero(
                  tag: 'tile-image-${tile.filenameImage}',
                  child: Material(
                    color: Colors.transparent,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Image.asset(
                        '${Assets.imagesTilePath}${tile.filenameImage}',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.greenLight,
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                color: AppColors.brown.withValues(alpha: 0.5),
                                size: 64,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SelectableText(
                tile.name,
                style: AppTextStyles.titleTextStyle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Metadata Section
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildChip(
                    context,
                    Icons.layers_outlined,
                    'x${tile.quantity}',
                    AppColors.brown,
                  ),
                  if (tile.boardgame.value != null)
                    _buildChip(
                      context,
                      Icons.extension_outlined,
                      tile.boardgame.value!.name,
                      AppColors.greenDark,
                    ),
                  if (tile.module.value != null)
                    _buildChip(
                      context,
                      Icons.view_module_outlined,
                      tile.module.value!.name,
                      AppColors.greenDarker,
                    ),
                  if (tile.hutCost != null && tile.hutCost! > 0)
                    _buildChip(
                      context,
                      Icons.monetization_on,
                      'Cost: ${tile.hutCost}',
                      AppColors.gold,
                      textColor: AppColors.brown,
                    ),
                  if (tile.color != null)
                    _buildChip(
                      context,
                      Icons.person_outline,
                      _getColorName(tile.color!),
                      AppColors.findColorByName(
                        tile.color.toString().split('.').last,
                      ),
                      textColor:
                          tile.color == TileColor.white ||
                              tile.color == TileColor.yellow
                          ? AppColors.brown
                          : Colors.white,
                    ),
                ],
              ),

              const SizedBox(height: 24),
              Divider(color: AppColors.brown.withValues(alpha: 0.5)),
              const SizedBox(height: 16),

              MarkdownBody(
                data: tile.description,
                selectable: true,
                styleSheet: AppMarkdownStyleSheet.styleSheet,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(
    BuildContext context,
    IconData icon,
    String label,
    Color backgroundColor, {
    Color textColor = Colors.white,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: backgroundColor == Colors.transparent
              ? AppColors.brown
              : backgroundColor,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getColorName(TileColor color) {
    switch (color) {
      case TileColor.red:
        return 'Vermell';
      case TileColor.purple:
        return 'Lila';
      case TileColor.white:
        return 'Blanc';
      case TileColor.yellow:
        return 'Groc';
    }
  }
}
