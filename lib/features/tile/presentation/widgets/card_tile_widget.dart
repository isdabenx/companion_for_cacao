import 'package:companion_for_cacao/core/data/models/tile_model.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/features/tile/presentation/providers/tile_settings_notifier.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/card_tile_badge_row_widget.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/card_tile_boardgame_title_widget.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/card_tile_image_widget.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/card_tile_name_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CardTileWidget extends ConsumerWidget {
  const CardTileWidget({required this.tile, super.key});
  final TileModel tile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tileSettings = ref.watch(tileSettingsProvider.select((s) => s.value));

    if (tileSettings == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final tileColor = tile.color == null
        ? null
        : AppColors.findColorByName(tile.color.toString().split('.').last);

    final borderColor = (tileColor != null && tileSettings.playerColorInBorder)
        ? tileColor
        : AppColors.tileBorder;

    return Container(
      decoration: _cardTileDecoration(borderColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardTileImageWidget(
            tileType: tile.typeAsString,
            filenameImage: tile.filenameImage,
            badgeTypeInImage: tileSettings.badgeTypeInImage,
            quantity: tile.quantity,
            showQuantity: tileSettings.showQuantity,
          ),
          if (tileSettings.boardgameInTitle && tile.boardgame.value != null)
            CardTileBoardgameTitleWidget(
              title: tile.boardgame.value!.name,
              color: borderColor,
            ),
          if (tileSettings.badgeTypeInText || tileSettings.playerColorInCircle)
            CardTileBadgeRowWidget(
              tileType: tile.typeAsString,
              color: tileColor,
              playerColorInCircle: tileSettings.playerColorInCircle,
              badgeTypeInText: tileSettings.badgeTypeInText,
            ),
          CardTileNameWidget(name: tile.name),
        ],
      ),
    );
  }
}

Decoration _cardTileDecoration(Color borderColor) {
  return BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: AppColors.tileShadow.withValues(alpha: 0.4),
        blurRadius: 4,
        spreadRadius: 2,
        offset: const Offset(0, 2),
      ),
    ],
    color: AppColors.tileBackground,
    border: Border.all(color: borderColor, width: 2),
    borderRadius: const BorderRadius.only(
      bottomLeft: Radius.circular(8),
      bottomRight: Radius.circular(8),
    ),
  );
}
