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
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              SelectableText(tile.name, style: AppTextStyles.titleTextStyle),
              const SizedBox(height: 8),
              MarkdownBody(
                data: tile.description,
                selectable: true,
                styleSheet: AppMarkdownStyleSheet.styleSheet,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
