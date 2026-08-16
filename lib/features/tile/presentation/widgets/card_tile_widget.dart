import 'package:companion_for_cacao/core/domain/entities/tile_entity.dart';
import 'package:companion_for_cacao/core/theme/app_colors.dart';
import 'package:companion_for_cacao/features/tile/presentation/providers/tile_settings_notifier.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/card_tile_badge_row_widget.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/card_tile_boardgame_title_widget.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/card_tile_image_widget.dart';
import 'package:companion_for_cacao/features/tile/presentation/widgets/card_tile_name_widget.dart';
import 'package:companion_for_cacao/l10n/generated/app_localizations.dart';
import 'package:companion_for_cacao/shared/utils/catalog_l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CardTileWidget extends ConsumerWidget {
  const CardTileWidget({required this.tile, super.key});
  final TileEntity tile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tileSettings = ref.watch(tileSettingsProvider.select((s) => s.value));
    final l10n = AppLocalizations.of(context);
    final localizedType = tile.type?.localizedName(l10n) ?? '';

    // A spinner here meant a grid of spinners, one per cell, each collapsing
    // its card to a dot. The card's shape does not depend on the settings —
    // only its optional extras do — so it shimmers as itself instead, and the
    // grid holds still while the settings arrive.
    if (tileSettings == null) {
      return Skeletonizer(
        child: Container(
          decoration: _cardTileDecoration(AppColors.tileBorder),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardTileImageWidget(
                tileType: localizedType,
                filenameImage: tile.filenameImage,
                badgeTypeInImage: false,
                quantity: tile.quantity,
                showQuantity: false,
              ),
              CardTileNameWidget(name: tile.localizedName(l10n)),
            ],
          ),
        ),
      );
    }

    final tileColor = tile.color == null
        ? null
        : AppColors.findColorByName(tile.color!.name);

    final borderColor = (tileColor != null && tileSettings.playerColorInBorder)
        ? tileColor
        : AppColors.tileBorder;

    return Container(
      decoration: _cardTileDecoration(borderColor),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardTileImageWidget(
            tileType: localizedType,
            filenameImage: tile.filenameImage,
            badgeTypeInImage: tileSettings.badgeTypeInImage,
            quantity: tile.quantity,
            showQuantity: tileSettings.showQuantity,
          ),
          if (tileSettings.boardgameInTitle && tile.boardgame.value != null)
            CardTileBoardgameTitleWidget(
              title: tile.boardgame.value!.localizedName(l10n),
              color: borderColor,
            ),
          if (tileSettings.badgeTypeInText || tileSettings.playerColorInCircle)
            CardTileBadgeRowWidget(
              tileType: localizedType,
              color: tileColor,
              playerColorInCircle: tileSettings.playerColorInCircle,
              badgeTypeInText: tileSettings.badgeTypeInText,
            ),
          CardTileNameWidget(name: tile.localizedName(l10n)),
        ],
      ),
    );
  }
}

Decoration _cardTileDecoration(Color borderColor) {
  return BoxDecoration(
    boxShadow: [
      BoxShadow(
        color: AppColors.tileShadow.withValues(alpha: 0.15),
        blurRadius: 8,
        spreadRadius: 1,
        offset: const Offset(0, 4),
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
