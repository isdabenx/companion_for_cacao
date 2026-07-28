import 'package:companion_for_cacao/config/constants/assets.dart';
import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/core/theme/app_markdown_style_sheet.dart';
import 'package:companion_for_cacao/core/theme/app_spacing.dart';
import 'package:companion_for_cacao/core/theme/app_text_styles.dart';
import 'package:companion_for_cacao/core/utils/string_extensions.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:companion_for_cacao/shared/utils/catalog_l10n.dart';
import 'package:companion_for_cacao/shared/widgets/container_full_style_widget.dart';
import 'package:companion_for_cacao/shared/widgets/custom_scaffold_widget.dart';
import 'package:companion_for_cacao/core/theme/app_shapes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TileDetailScreen extends ConsumerWidget {
  const TileDetailScreen({required this.tile, super.key});

  final TileEntity tile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLandscape =
        MediaQuery.orientationOf(context) == Orientation.landscape;

    final image = _buildTileImage();
    final content = _buildTileContent(context);

    return CustomScaffoldWidget(
      showBackButton: true,
      title: tile.type?.localizedName(AppLocalizations.of(context)) ?? '',
      body: ContainerFullStyleWidget(
        child: isLandscape
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 2, child: Center(child: image)),
                  AppSpacing.horizontalL,
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(child: content),
                  ),
                ],
              )
            : SingleChildScrollView(
                child: Column(children: [image, AppSpacing.verticalL, content]),
              ),
      ),
    );
  }

  Widget _buildTileImage() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: tile.color == null
              ? AppColors.tileBorder
              : AppColors.findColorByName(tile.color!.name),
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
    );
  }

  Widget _buildTileContent(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      children: [
        SelectableText(
          tile.localizedName(l10n),
          // Plain, not the decorative title: this is the tile's name — data,
          // not a brand moment — and names like "Mercat, preu de venda 3"
          // fray in the outlined display font, which is what the UX-3 pass
          // set out to stop. The app bar above already carries the same name.
          style: AppTextStyles.screenTitlePlain,
          textAlign: TextAlign.center,
        ),
        AppSpacing.verticalL,
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
                tile.boardgame.value!.localizedName(l10n),
                AppColors.greenDark,
              ),
            if (tile.module.value != null)
              _buildChip(
                context,
                Icons.view_module_outlined,
                tile.module.value!.localizedName(l10n),
                AppColors.greenDarker,
              ),
            if (tile.hutCost != null && tile.hutCost! > 0)
              _buildChip(
                context,
                Icons.monetization_on,
                l10n.costLabel(tile.hutCost!),
                AppColors.gold,
                textColor: AppColors.brown,
              ),
            if (tile.color != null)
              _buildChip(
                context,
                Icons.person_outline,
                tile.color!.localizedName(l10n).capitalized,
                AppColors.findColorByName(tile.color!.name),
                textColor:
                    tile.color == TileColor.white ||
                        tile.color == TileColor.yellow
                    ? AppColors.brown
                    : AppColors.white,
              ),
          ],
        ),
        AppSpacing.verticalXl,
        Divider(color: AppColors.brown.withValues(alpha: 0.5)),
        AppSpacing.verticalL,
        MarkdownBody(
          data: tile.localizedDescription(l10n),
          selectable: true,
          styleSheet: AppMarkdownStyleSheet.styleSheet,
        ),
        AppSpacing.verticalXl,
      ],
    );
  }

  Widget _buildChip(
    BuildContext context,
    IconData icon,
    String label,
    Color backgroundColor, {
    Color textColor = AppColors.white,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppShapes.radius(AppShapes.radiusL),
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
}
